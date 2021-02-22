//+------------------------------------------------------------------+
//|                                                     testEdit.mq4 |
//|                                                        992249804 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "992249804"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Mylib\Panels\DisplayPanel.mqh>
DisplayPanel Dp;//---
//#include <Mylib\Panels\DisablePanel.mqh>
//DisablePanel Dp;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
//---
   Print(222);
   if(!Dp.Create(0,"盈亏面板",0,0,0,200,100))
     {
      Print("error ", GetLastError());
      return -3;
     }

   if(!Dp.Run())
     {
      return -2;
     }
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
   Dp.Destroy();
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
   Dp.ChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
