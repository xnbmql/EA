//+------------------------------------------------------------------+
//|                                                       挂单交易策略.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <Mylib\Trade\Ordermanager.mqh>

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input int Magic = 202100; //开仓magic码
input string comment = "挂单交易策略"; //开仓备注
input int distance = 10; //等距离点差距离
input int Slippage = 10; //滑点
input int OrderLimit = 5; // 挂单数
input double Lots = 0.01; // 手数

int HandBuyOrderCount = 0;
int HangSellOrderCount = 0;
int HandingSellOrderCount = 0;
int HandingBuyOrderCount = 0;

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
   Print("多单挂单数： ",getHandBuyOrderCount()," 空单挂单数：",getHangSellOrderCount());
  }
//+------------------------------------------------------------------+
//获取多单挂单数
int getHandBuyOrderCount()
  {
   if(HandBuyOrderCount<=OrderLimit)
     {
      for(int i=OrdersTotal()-1; i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUYSTOP || OrderType()==OP_BUYLIMIT)
              {
               return HandBuyOrderCount=i;
              }
           }      
        }
     }
   return HandBuyOrderCount;
  }
//+------------------------------------------------------------------+

//获取空单挂单数
int getHangSellOrderCount()
  {
   if(HangSellOrderCount<=OrderLimit)
     {
      for(int i=OrdersTotal()-1; i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_SELLLIMIT || OrderType()==OP_SELLSTOP)
              {
               return HangSellOrderCount=i;
              }
           }
        }
     }
   return HangSellOrderCount;
  }
//+------------------------------------------------------------------+
//到新的收盘价 挂单数目+开仓单数 是否为0
