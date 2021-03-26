// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                    MACD加均线EA.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


#include <Mylib\Trade\trade.mqh>
// input bool message = true; //是否显示信息框
input double Lots = 0.1; //单量
input string comment = ""; //备注
input int magic = 15430; //开仓magic码
input int Slippage = 30; //滑点
// input string comm1X="----------------------------";
// input string comm2X="----------------------------";
// enum AlertLocation
//   {
//    实时出现信号判断=0,收盘出现信号判断=1
//   };
// input bool macdSwitch = false; //macd开关
// input AlertLocation maLocation = 收盘出现信号判断; //均线报警信号位置
input int md1=12; //macd1周期
input int md2=26; //macd2周期
input int md3=9; //macd3周期
input int ma1_Period = 5; //均线1周期
input int ma1_shift=0; // 均线1平移
input ENUM_MA_METHOD  ma1_Method = MODE_SMA; // ma1均线应用模式
input ENUM_APPLIED_PRICE  ma1_Price = PRICE_CLOSE; //ma1价格模式
input int ma2_Period = 20; //均线2周期
input int ma2_shift=0; // 均线2平移
input ENUM_MA_METHOD  ma2_Method = MODE_SMA; // ma2均线应用模式
input ENUM_APPLIED_PRICE  ma2_Price = PRICE_CLOSE; //ma2价格模式
input int ma3_Period = 40; //均线3周期
input int ma3_shift=0; // 均线3平移
input ENUM_MA_METHOD  ma3_Method = MODE_SMA; // ma3均线应用模式
input ENUM_APPLIED_PRICE  ma3_Price = PRICE_CLOSE; //ma3价格模式
input ENUM_TIMEFRAMES ma_Period = PERIOD_CURRENT; // 均线时间轴
input bool autoTraceStop = true; // 跟踪止损
input double buyProfit = 50; // 多单止盈
input double buyStop = 50; //多单止损
input double sellProfit = 50; //空单止盈
input double sellStop = 200; //空单止损

OrderInfo *currentOrder;
double realTimeStopTakeProfit=0.0;
double realTimeStopLoss=0.0;
double OpenBid=0.0;
bool isSellOrder =false;

// bool isChange = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(currentOrder==NULL)
     {
      Print("BID:"+Bid+" MA2: ",iMA(Symbol(),0,ma2_Period,0,ma2_Method,ma2_Price,shift), " PriceCloseMa2: ", PriceCloseMa2());
      // 开仓逻辑
      if(!PriceCloseMa2())
        {
         return;
        }
      Print("MACDStatus: ",MACDStatus()," SEND_MA_POSITION: ",GetSendMAPosition());
      if(MACDStatus()==RED && GetSendMAPosition()==SEND_MA_UP)
        {
         Buy();
         return;
        }

      if(MACDStatus()==GREEN &&GetSendMAPosition()==SEND_MA_DOWN)
        {
         Sell();
         return;
        }
     }
   else
     {
       resetStop();
       if(needClose() || touchStopLine())
       {
         bool ok = currentOrder.Close(Slippage);
         if (!ok){
           int lastErrorCode = GetLastError();
           Alert("Close order failed code: ", lastErrorCode);
         }
         delete(currentOrder);
         currentOrder = NULL;
         realTimeStopLoss = 0.0;
         realTimeStopTakeProfit = 0.0;
         isSellOrder = false;
         OpenBid = 0;
       }
     }
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

  }
//+------------------------------------------------------------------+

// 判断需要平常吗
bool needClose(int shift=0)
  {
   double ma1 = iMA(Symbol(),0,ma1_Period,0,ma1_Method,ma1_Price,shift);
   double ma3 = iMA(Symbol(),0,ma3_Period,0,ma3_Method,ma3_Price,shift);
   if(isSellOrder)
     {
      if(ma1>ma3)
        {
         return true;
        }
     }
   if(!isSellOrder)
     {
      if(ma1<ma3)
        {
         return true;
        }
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool touchStopLine()
  {
    if(!isSellOrder){
      if(Bid >= realTimeStopTakeProfit || Bid <= realTimeStopLoss)
        {
         return true;
        }
    }else{
      if(Bid <= realTimeStopTakeProfit || Bid >= realTimeStopLoss)
        {
          return true;
        }
    }
    return false;
  }

//跟踪止损
void resetStop()
{
  if(!autoTraceStop)
    {
      return;
    }

  if(!isSellOrder)
    {
     if(Bid - buyStop*Point > realTimeStopLoss)
       {
         realTimeStopLoss = Bid - buyStop*Point;
       }
    }
  else
    {
      if(Bid + sellStop*Point < realTimeStopLoss)
        {
          realTimeStopLoss = Bid + sellStop*Point;
        }
    }
}

enum ENUM_MACD_COLOR
  {
   GRAY = 0,
   RED = 1,
   GREEN = 2
  };
// MACD状态  注意这里获取的是实时的转态
ENUM_MACD_COLOR MACDStatus(int shift=0)
  {
   double myMACDmain,myMACDsignal;
   myMACDmain=iMACD(NULL,0,md1,md2,md3,PRICE_CLOSE,MODE_MAIN,shift);
   myMACDsignal=iMACD(NULL,0,md1,md2,md3,PRICE_CLOSE,MODE_SIGNAL,shift);
   if((myMACDmain > 0)&&(myMACDmain > myMACDsignal))
     {
      return RED; // 红
     }
   else
     {
      if((myMACDmain < 0)&&(myMACDmain < myMACDsignal))
        {
         return GREEN;//绿
        }
      else
        {
         return GRAY; //灰
        }
     }
  }

enum ENUM_SEND_MA_POSITION
  {
   SEND_MA_MID = 0,
   SEND_MA_UP = 1,
   SEND_MA_DOWN = 2
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_SEND_MA_POSITION GetSendMAPosition(int shift=0)
  {
   double m1 = iMA(Symbol(),0,ma1_Period,0,ma1_Method,ma1_Price,shift);
   double m2 = iMA(Symbol(),0,ma2_Period,0,ma2_Method,ma2_Price,shift);
   double m3 = iMA(Symbol(),0,ma3_Period,0,ma3_Method,ma3_Price,shift);
   if(m1>m2&& m1>m3)
     {
      return SEND_MA_UP;
     }
   if(m1<m2&&m1<m3)
     {
      return SEND_MA_DOWN;
     }
   return SEND_MA_MID;
  }

enum ENUM_CLOSE_MA_POSITION
  {
   CLOSE_MA_UP = 0,
   CLOSE_MA_DOWN = 1
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_CLOSE_MA_POSITION GetCloseMaPosition(int shift=0)
  {
   double m1 = iMA(Symbol(),0,ma1_Period,0,ma1_Method,ma1_Price,shift);
   double m3 = iMA(Symbol(),0,ma3_Period,0,ma3_Method,ma3_Price,shift);
   if(m1>=m3)
     {
      return CLOSE_MA_UP;
     }
   return CLOSE_MA_DOWN;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Buy()
  {
   RefreshRates();
   int orderTicket = OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,comment,magic,0,clrRed);
   if(orderTicket < 0)
     {
      Alert("开单错误，错误代码是:  ", GetLastError());
      // ExpertRemove();
      return false;
     }
   currentOrder = new OrderInfo(orderTicket);
   OpenBid = Bid;
   realTimeStopLoss = OpenBid - buyStop*Point;
   realTimeStopTakeProfit = OpenBid + buyProfit*Point;
   isSellOrder = false;
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Sell()
  {
   RefreshRates();
   int orderTicket = OrderSend(Symbol(),OP_BUY,Lots,Bid,Slippage,0,0,comment,magic,0,clrGreen);
   if(orderTicket < 0)
     {
      Alert("开单错误，错误代码是:  ", GetLastError());
      // ExpertRemove();
      return false;
     }
   currentOrder = new OrderInfo(orderTicket);
   OpenBid = Bid;
   realTimeStopLoss = OpenBid + sellProfit*Point;
   realTimeStopTakeProfit = OpenBid  - sellStop*Point;
   isSellOrder = true;
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool PriceCloseMa2(int shift=0)
  {

   double m2 = iMA(Symbol(),0,ma2_Period,0,ma2_Method,ma2_Price,shift);
   double dp = (Bid - m2)/Point;
   if(dp >= -10 && dp <=10)
     {
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
