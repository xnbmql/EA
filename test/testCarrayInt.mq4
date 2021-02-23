//+------------------------------------------------------------------+
//|                                                testCarrayInt.mq4 |
//|                                                        992249804 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "992249804"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <Arrays\ArrayInt.mqh>
#include <Arrays\List.mqh>
#include <Mylib\Trade\trade.mqh>

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
  CList c;
  OrderInfo *o1 = new OrderInfo(1314124);
  //Free(ol);
  c.Add(o1);
   OrderInfo *o2 = new OrderInfo(2222);
  //Free(ol);
  c.Add(o2);
  Print(c.Total());//---
  c.MoveToIndex(0);
  //c.GetNextNode();//---
  
  OrderInfo *oo =(OrderInfo *)c.GetNextNode();
  
  Print(oo.ticket);
//---
   return(INIT_FAILED);
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
