//+------------------------------------------------------------------+
//|                                                     种田人阴阳线ea.mq4 |
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

input double Lots = 0.01; // 开仓手数
input int Magic = 923185; //开仓magic码
input string comment= "阴线阳线ea"; // 开仓备注
input int Slippage = 30; //滑点


input int OrderNumbers = 180; // 总订单数

// 阴柱阳柱
enum Kzhu
  {
   yinzhu = 1, yangzhu = 2, another = 0
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

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

int currentBars = 0;
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(Bars != currentBars && Bars > currentBars)
     {
      // 开单
      OpenOrder(OpenTypes());
      // 重置currentBars为当前的柱数
      currentBars = Bars;
     }
//---
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

//开仓条件 阴线收盘价开空单、阳线收盘价开多单
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//判断前一柱的状态
int kState(int i)
  {
// 这个把0替换为i，PERIOD_H1替换成当前时间周期就能获取指定柱子的信息了
//Print("Current bar for USDCHF H1: ",iTime("USDCHF",PERIOD_H1,0),", ",  iOpen("USDCHF",PERIOD_H1,0),", ",
//                               iHigh("USDCHF",PERIOD_H1,0),", ",  iLow("USDCHF",PERIOD_H1,0),", ",
//                             iClose("USDCHF",PERIOD_H1,0),", ", iVolume("USDCHF",PERIOD_H1,0));
// 这个 PRICECLOSE 只能在指标里面用
   if(iClose(Symbol(),PERIOD_CURRENT,i) > iOpen(Symbol(),PERIOD_CURRENT,i))
     {
      return 1;
     }

   else
      if(iClose(Symbol(),PERIOD_CURRENT,i) < iOpen(Symbol(),PERIOD_CURRENT,i))
        {
         return 2;
        }
      else
        {
         return 0;
        }
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//判断开单的方向
int OpenTypes()
  {
   int ks = kState(1);
   if(ks == yangzhu)
     {
      return OP_BUY;
     }
   else
     {
      return OP_SELL;
     }
  }





//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//开单
void OpenOrder(int OpenType)
  {

   double OpenPrice = 0.00;

   switch(OpenType)
     {
      case OP_BUY :

         OpenPrice = Ask;
         break;
      case OP_SELL :

         OpenPrice = Bid;
         break;
     }
// 你放在这里干嘛。这个函数返回的是什么？
// 你返回的是数字啊
   int Ticket = OrderSend(Symbol(),OpenType,Lots, OpenPrice, 30, 0, 0, comment,Magic, 0, clrRed);

   if(Ticket < 0)
     {
      Alert("开单错误，错误代码是：", GetLastError());
     }
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
