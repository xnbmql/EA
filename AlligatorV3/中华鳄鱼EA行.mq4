//+------------------------------------------------------------------+
//|                                                      中华鳄鱼EA行.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

// 1 代表在上下限之间 2 代表上穿 3 代表下穿
enum PriceWithLineRelation
  {
   PriceMiddlelLine = 1, PriceUpLineLimit = 2, PriceDownLineFloor = 3
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
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int PriceWithLineFuntion(double LineLimit, double LineFloor)
  {
   double RealTimePrice = MarketInfo(Symbol(),MODE_ASK);
//double point = MarketInfo(Symbol(), MODE_POINT);

   if(RealTimePrice < LineLimit && RealTimePrice > LineFloor)
     {
      return PriceMiddlelLine;
     }
   if(RealTimePrice >= LineLimit)
     {
      return PriceUpLineLimit;
     }
   if(RealTimePrice <= LineFloor)
     {
      return PriceDownLineFloor;
     }

   return -1;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PriceAndLineRelationAlert()
  {
   double a = 0.0, b = 0.0;
   double PriceMiddlelLine = PriceWithLineFuntion(a,b);
   if(PriceWithLineFuntion(a,b) > PriceMiddlelLine)
     {
      Alert("实时价格高于预估多单平仓价");
     }
     else
     {
      Alert("实时价格低于预估平仓价");
     }
  }
//+------------------------------------------------------------------+
