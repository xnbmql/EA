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
  OrderInfo *o1 = new OrderInfo(111);
  //Free(ol);
  c.Add(o1);
   OrderInfo *o2 = new OrderInfo(2222);
  //Free(ol);
  c.Add(o2);
     OrderInfo *o3 = new OrderInfo(333);
  //Free(ol);
  c.Add(o3);
  
for(int i=0;i<c.Total();i++){
 OrderInfo *oo = (OrderInfo *)c.GetNodeAtIndex(i);
   Print(oo.ticket);
}
c.Clear();
Print(c.Total(),"-----");

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
