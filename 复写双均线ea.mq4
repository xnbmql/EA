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
input ENUM_MA_METHOD maMethon = MODE_SMA;

double ma1Buffer[];
double ma2Buffer[];

input double lots = 0.01;
input int Slippage = 20;
input int Magic = 992249;
input string comment = "双均线";
input int ProfitClose = 50;
//input int StopClose = 100;

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
   if(!IsTradeAllowed())
     {
      Alert("自动交易存在异常，  请检查  ");
      return;
     }

   if(maStatus() == OP_BUY)
     {
      OpenOrders(OP_BUY);
     }
   else
      if(maStatus() == OP_SELL)
        {
         OpenOrders(OP_SELL);
        }

   double TotalProfits = 0.0;
   if(TotalProfits > ProfitClose*Point)
     {
      CloseOrders();
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int maStatus()
  {

   double ma1_1 = iMA(Symbol(),0,ma1Period,0,maMethon,ma1Price,1);
   double ma2_1 = iMA(Symbol(),0,ma2Period,0,maMethon,ma2Price,1);

   double ma1_2 = iMA(Symbol(),0,ma1Period,0,maMethon,ma1Price,2);
   double ma2_2 = iMA(Symbol(),0,ma2Period,0,maMethon,ma2Price,2);

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
void CloseOrders(int CloseType = -1)
  {
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() && OrderComment() == comment && OrderMagicNumber() == Magic)
           {
            if(OrderType() == CloseType || CloseType == -1)
              {
               bool tempClose = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrRed);

               if(!tempClose)
                 {
                  Print("平仓错误，错误代码是: ",GetLastError());
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
