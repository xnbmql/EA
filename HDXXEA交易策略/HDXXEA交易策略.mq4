//+------------------------------------------------------------------+
//|                                                   HDXXEA交易策略.mq4 |
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
#include <Mylib\Trade\OrderManager.mqh>

input double Lots = 0.01; //开仓手数
input string comment = "zhongtianren"; // 开仓备注
input int magic = 199005; // 开仓magic码
input int Slippage = 30; // 滑点
input int BarsDiff = 5; // 相差柱数

int currentBars = 0;
//double min = 0;
//double max = 0;
//int interval = BarsDiff;
int cnt=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderManager mp(comment,magic,Slippage);
OrderManager sp(comment,magic,Slippage);

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
      Alert("自动交易设置存在异常,   请检查!  ");
      return;
     }
   if(Bars ==0)
     {
      return;
     }
   if(IsHavePendOrder() && IsCloseBarsLessThan() && currentBars != Bars)
     {
      if(!sp.Sell(Lots,clrLime))
        {
         Alert("open sell order error code: ",GetLastError());
        }
      currentBars = Bars;
     }
   if(IsHavePendOrder() && IsCloseBarsGreaterThan() && currentBars != Bars)
     {
      if(!mp.Buy(Lots,clrRed))
        {
         Alert("open buy order error code: ",GetLastError());
        }
      currentBars = Bars;
     }
  }
//+------------------------------------------------------------------+

//K线价格的最后一根柱的收盘价是否小于前5根柱K线的收盘价
bool IsCloseBarsLessThan()
  {
   double min = 0;
   for(int i = 2; i<=BarsDiff+1; i++)
     {
      if(i==2)
        {
         min = Close[i];
         continue;
        }
      if(min>Close[i])
        {
         min = Close[i];
        }
     }
   return Close[1] < min;
  }

//K线价格的最后一根柱的收盘价是否大于前5根柱K线的收盘价
bool IsCloseBarsGreaterThan()
  {
   double max = 0;
   for(int i = 2; i<=BarsDiff+1; i++)
     {
      if(i==2)
        {
         max = Close[i];
         continue;
        }
      if(max<Close[i])
        {
         max = Close[i];
        }
     }
   return Close[1]>max;
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsHavePendOrder()
  {
   for(cnt=OrdersTotal(); cnt>=0; cnt--)
     {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
        {
         if(OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT || OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP)
           {
            return false;
           }
        }
     }
   return true;
  }
//+------------------------------------------------------------------+
