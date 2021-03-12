//+------------------------------------------------------------------+
//|                                                    testPanel.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <Mylib\Panels\DisPlayAndDisablePanel2.mqh>

CommPanel Dp;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  bool DisableEAStatus = true;
//---
// Dp.Destroy();
   if(!Dp.Create(0,"盈亏面板",0,0,0,200,200,"浮动盈亏",DisableEAStatus))
     {
      Dp.Destroy();
      return -3;
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
   Dp.GetDownLimit();
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
