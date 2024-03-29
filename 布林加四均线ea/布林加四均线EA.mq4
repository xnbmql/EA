//+------------------------------------------------------------------+
//|                                                     布林加四均线EA.mq4 |
//|                                                        992249804 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "992249804"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Mylib\Panels\DisablePanel.mqh>

#property indicator_level1  0
#property indicator_levelcolor clrSilver

input int ma1_Period = 20; //均线1周期
input int ma2_Period = 40; //均线2周期
input int ma3_Period = 80; //均线3周期
input int ma4_Period = 160; //均线4周期
input int bb_Period = 20; //布林周期

input ENUM_MA_METHOD ma1_Mathod = MODE_SMA; //ma1均线类型
input ENUM_MA_METHOD ma2_Mathod = MODE_SMA; //ma2均线类型
input ENUM_MA_METHOD ma3_Mathod = MODE_SMA; //ma3均线类型
input ENUM_MA_METHOD ma4_Mathod = MODE_SMA; //ma4均线类型
input ENUM_MA_METHOD bb_Mathod = MODE_SMA; //布林均线类型
input double Deviations = 2.0;//与布林主线的偏差


input ENUM_APPLIED_PRICE ma1_Price = PRICE_CLOSE; //均线1应用价格
input ENUM_APPLIED_PRICE ma2_Price = PRICE_CLOSE; //均线2应用价格
input ENUM_APPLIED_PRICE ma3_Price = PRICE_CLOSE; //均线3应用价格
input ENUM_APPLIED_PRICE ma4_Price = PRICE_CLOSE; //均线4应用价格
input ENUM_APPLIED_PRICE bb_Price = PRICE_CLOSE; //布林应用价格

extern int md1=12;
extern int md2=26;
extern int md3=9;

//---- indicator buffers
input double 手数 = 0.01;
input string 开仓备注 = "yuwenshuo";
input int 开仓magic码 = 199003;
input int Slippage = 30; //滑点

//input int 点差距离 = 300;
//input int 单数 = 4;
//input int 亏损单平仓点 = 0;

int orderTicket = 0;

enum Swich
  {
   nothon = 0, twoUpfour = 1, twoDownfour = 2
  };

enum priceStatus
  {
   priceWear = 1, priceUnder = 2, priceZeroPoint = 0
  };

// 当前是否有做多订单开启，开单时置为true，平仓的时候置为false
bool isBuyOrderOpening = false;

// 20是否穿过40线，当isOrderOpening为true的时候作判断。买入的时候判断下穿，卖出的时候判断上穿。平仓的时候置为false
bool isTwentyOverFourty = false;
int lastOpenOrderBar = 0;
// 布林顶和布林底处于平仓条件，当isOrderOpeing和isTwentyOverFourty为true的时候开始判断，买入的时候价格要与布林上轨相交
//卖出的时候价格要与布林下轨相交。平仓后置为false
//bool isBBCrossPrice = false;

// 当前是否有做空订单开启，开单时置为true，平仓时置为false
bool isSellOrderOpening = false;
DisablePanel Dp;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool needCloseBuyOrder()
  {
   if(!isTwentyOverFourty && !TwentyFourtyStatus(0))
     {
      return false;
     }
   isTwentyOverFourty = true;

   if(upAnddown(0) == priceWear)
     {
      return true;
     }

   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool needCloseSellOrder()
  {

   if(!isTwentyOverFourty && TwentyFourtyStatus(0))
     {
      return false;
     }
   isTwentyOverFourty = true;

   if(upAnddown(0) == priceUnder)
     {
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Dp.Destroy();
   if(!Dp.Create(0,"MACD禁用面板",0,0,0,200,100))
     {
      return -1;
     }

   if(!Dp.Run())
     {
      return -2;
     }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Dp.Destroy();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
//if(Dp.GetDisableStatus())
//  {
//   Print("被禁用了");
//   return;
//  }
   if(orderTicket!=0)
     {
      if((isBuyOrderOpening && needCloseBuyOrder()) ||(isSellOrderOpening && needCloseSellOrder()))
        {
         int operation = OP_BUY;
         if(isSellOrderOpening)
           {
            operation = OP_SELL;
           }
         if(!CloseOrder(operation))
           {

            return;
           }
         orderTicket = 0;
         isSellOrderOpening = false;
         isBuyOrderOpening = false;
         isTwentyOverFourty = false;
         return;
        }
      return;
     }
   if(Bars >0 && Bars==lastOpenOrderBar)
     {
      return;
     }
   Swich fourMaStatus = GetFourMaStatus(0);
//Print("当前状态：", fourMaStatus);

   if(fourMaStatus  == twoUpfour && upAnddown(0) == priceUnder)
     {
      if(!macd() && !Dp.GetDisableStatus())
        {
         Print("-----1");
         return;
        }
      Print("-----2");

      Buy();
      Print(" 价格  ", Ask," marketInfo价格 ", MarketInfo(Symbol(),MODE_ASK)," SybolInfo价格 ",SymbolInfoDouble(Symbol(),SYMBOL_ASK),"  布林底  ",iBands(Symbol(),0,bb_Period,Deviations,0,bb_Price,MODE_LOWER,0)," position ",upAnddown(0));
      lastOpenOrderBar = Bars;
      isBuyOrderOpening = true;
      return;
     }

   if(fourMaStatus  == twoDownfour && upAnddown(0) == priceWear)
     {
      if(macd() && !Dp.GetDisableStatus())
        {
         Print("-----3");
         return;
        }
      Print("-----4");
      Sell();
      Print(" 价格  ", Ask," marketInfo价格 ", MarketInfo(Symbol(),MODE_ASK)," SybolInfo价格 ",SymbolInfoDouble(Symbol(),SYMBOL_ASK),"  布林顶  ",iBands(Symbol(),0,bb_Period,Deviations,0,bb_Price,MODE_UPPER,0)," position ",upAnddown(0));
      lastOpenOrderBar = Bars;
      isSellOrderOpening = true;
      return;
     }
//
   return;
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
   Dp.ChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Swich GetFourMaStatus(int shift)
  {
   double ma1 = iMA(Symbol(),0,ma1_Period,0,ma1_Mathod,ma1_Price,shift);
   double ma2 = iMA(Symbol(),0,ma2_Period,0,ma2_Mathod,ma2_Price,shift);
   double ma3 = iMA(Symbol(),0,ma3_Period,0,ma3_Mathod,ma3_Price,shift);
   double ma4 = iMA(Symbol(),0,ma4_Period,0,ma4_Mathod,ma4_Price,shift);

   Swich s = nothon;
   if(ma1 > ma2 && ma2 > ma3 && ma3 > ma4)
     {
      s = twoUpfour;
     }
   else
      if(ma4 > ma3 && ma3 > ma2 && ma2 > ma1)
        {
         s = twoDownfour;
        }

   return s;
  }
// 获取20均线和40均线的位置状态, 上穿为true，下穿为flase且包含零界点
bool TwentyFourtyStatus(int shift)
  {
   double ma1 = iMA(Symbol(),0,ma1_Period,0,ma1_Mathod,ma1_Price,shift);
   double ma2 = iMA(Symbol(),0,ma2_Period,0,ma2_Mathod,ma2_Price,shift);
   if(ma1 > ma2)
     {
      return true;
     }
   else
     {
      return false;
     }

  }
// 获取价格上升或下降到达布林20顶和底的两个状态
priceStatus upAnddown(int shift)
  {

   double bbUpprice = iBands(Symbol(),0,bb_Period,Deviations,0,bb_Price,MODE_UPPER,shift);
   double bbDownprice = iBands(Symbol(),0,bb_Period,Deviations,0,bb_Price,MODE_LOWER,shift);
   double realTimePrice = SymbolInfoDouble(Symbol(),SYMBOL_ASK);
//double Ma20 = iMA(Symbol(),0,ma1_Period,0,ma1_Mathod,ma1_Price,shift);
//double Ma40 = iMA(Symbol(),0,ma2_Period,0,ma2_Mathod,ma2_Price,shift);

   priceStatus p = priceZeroPoint;

   if(realTimePrice > bbUpprice)
     {
      p = priceWear;
     }
   else
      if(realTimePrice < bbDownprice)
        {
         p = priceUnder;
        }
   return p;
  }

//做多
bool Buy()
  {
   RefreshRates();
   orderTicket = OrderSend(Symbol(),OP_BUY,手数,Ask,Slippage,0,0,开仓备注,开仓magic码,0,clrRed);
   if(orderTicket < 0)
     {
      Print("开单错误，错误代码是:  ", GetLastError());
      return false;
     }
   return true;
  }

//做空
bool Sell()
  {
   RefreshRates();

   orderTicket  = OrderSend(Symbol(),OP_SELL,手数,Bid,Slippage,0,0,开仓备注,开仓magic码,0,clrGreen);
   if(orderTicket  < 0)
     {
      Print("开单错误，错误代码是:  ", GetLastError());
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CloseOrder(int operation)
  {
   if(orderTicket != 0)
     {
      RefreshRates();

      double price;
      switch(operation)
        {
         case OP_SELL :
            price = Bid;
            break;
         case OP_BUY :
            price = Ask;
            break;
         default:
            Print("Unsupport operation: ", operation);
            return false;
        }

      Print("关闭订单：",price," op ",operation);
      bool check =  OrderClose(orderTicket, 手数, price, Slippage, Red);
      if(check)
        {
         orderTicket = 0;
         return true;
        }
      Print("关闭订单错误，错误代码是:  ", GetLastError());
      return false;
     }
   return true;
  }
//
////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//void CloseSellOrder()
//  {
//   int i;
//   for(i = 0; i <= OrdersTotal() - 1; i++)
//     {
//      if(OrderSelect(i, SELECT_BY_POS))
//        {
//         if(OrderSymbol() == Symbol() && OrderType() == OP_SELL)
//           {
//            int check = OrderClose(OrderTicket(), 手数, Bid, Slippage);
//           }
//        }
//     }
//  }
////+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool macd()
  {
   double myMACDmain,myMACDsignal;

   myMACDmain=iMACD(NULL,0,md1,md2,md3,PRICE_CLOSE,MODE_MAIN,0);
   myMACDsignal=iMACD(NULL,0,md1,md2,md3,PRICE_CLOSE,MODE_SIGNAL,0);



   if(myMACDmain > 0)
     {
      return true;
     }
   else
     {
      if(myMACDmain < 0)
        {
         return false;
        }

     }
   return false;
  }


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
