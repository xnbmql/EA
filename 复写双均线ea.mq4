//+------------------------------------------------------------------+
//|                                                      复写双均线ea.mq4 |
//|                                                        992249804 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "992249804"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#property indicator_buffers 2
#property indicator_color1 clrLime
#property indicator_color2 clrRed
#property indicator_width1 1
#property indicator_width2 1

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

input int ma1Period = 20;
input int ma2Period = 40;

input ENUM_APPLIED_PRICE ma1Price = PRICE_CLOSE;
input ENUM_APPLIED_PRICE ma2Price = PRICE_CLOSE;

double ma1Buffer[];
double ma2Buffer[];

input double lots = 0.01;
input int Slippage = 30;
input int Magic = 992249;
input string comment = "双均线";

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
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int maStatus()
  {

   double ma1_1 = iMA(Symbol(),0,ma1Period,0,MODE_SMA,ma1Price,1);
   double ma2_1 = iMA(Symbol(),0,ma2Period,0,MODE_SMA,ma2Price,1);

   double ma1_2 = iMA(Symbol(),0,ma1Period,0,MODE_SMA,ma1Price,2);
   double ma2_2 = iMA(Symbol(),0,ma2Period,0,MODE_SMA,ma2Price,2);

   if(ma1_1 > ma2_1 && ma1_2 < ma2_2)
     {
      return OP_BUY;
     }
   else
      if(ma1_1 < ma2_1 && ma1_2 > ma2_2)
        {
         return OP_SELL;
        }
   return -1;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenOrders(int OpenType)
  {

   double OpenPrice = 0.0;
   switch(OpenType)
     {
      case OP_BUY :
         OpenPrice = Ask;
         break;

      case OP_SELL :
         OpenPrice = Bid;
         break;
     }

   int ticket = OrderSend(Symbol(),OpenType,lots,OpenPrice,Slippage,0,0,comment,Magic,0,clrLime);

   if(ticket < 0)
     {
      Print("开单错误，错误代码：",GetLastError());
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseOrders()
  {
   
  }
//+------------------------------------------------------------------+
