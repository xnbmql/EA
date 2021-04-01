//+------------------------------------------------------------------+
//|                                                  testpenning.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

int openBars = 0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
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
   if(Bars == 0)
     {
      return;
     }
   if(Bars != openBars)
     {
      Buy();
      openBars = Bars;
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
bool Buy()
  {
//   RefreshRates();
//   double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
//   Print("Minimum Stop Level=",minstoplevel," points");
//   double OpenBid = Bid;
//   double realTimeStopLoss = OpenBid - 3000*Point;
//   double realTimeStopTakeProfit = OpenBid + 6000*Point;
//   int orderTicket = OrderSend(Symbol(),OP_BUY,0.01,Ask,10,NormalizeDouble(realTimeStopLoss,Digits),NormalizeDouble(realTimeStopTakeProfit,Digits),"test",1111,0,clrRed);
//   if(orderTicket < 0)
//     {
//      Alert("开单错误，错误代码是:  ", GetLastError());
//      // ExpertRemove();
//      return false;
//     }
//
//   return true;

   double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   double freezelevel=MarketInfo(Symbol(),MODE_FREEZELEVEL);

   Print("Minimum Stop Level=",minstoplevel," points");
   Print("freezelevel=",freezelevel," points");
   double price=Ask;
//--- calculated SL and TP prices must be normalized
   double stoploss=NormalizeDouble(Bid-minstoplevel*Point,Digits);
   double takeprofit=NormalizeDouble(Bid+minstoplevel*Point,Digits);
//--- place market order to buy 1 lot
   int ticket=OrderSend(Symbol(),OP_BUY,1,price,3,stoploss,takeprofit,"My order",16384,0,clrGreen);
   if(ticket<0)
     {
      Print("OrderSend failed with error #",GetLastError());
     }
   else
      Print("OrderSend placed successfully");
   return true;
  }
//+------------------------------------------------------------------+
