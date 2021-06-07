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
input int distance = 100; //等距离点差距离
input int Slippage = 10; //滑点
input int OrderLimit = 25; // 挂单数
input double Lots = 0.01; // 手数

int BuyLimitCount = 0;
int SellLimitCount = 0;
int SellStopCount = 0;
int BuyStopCount = 0;
double HighPrice = 0.0; // 高点
double LowPrice = 0.0; // 低点

int CBars = Bars;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  
   if(!IsTradeAllowed())
     {
      Alert("自动交易设置存在异常,   请检查!  ");
      return;
     }
   if(Bars == 0)
     {
      return;
     }
   if(Bars!=CBars)
     {
      if(GetBuyOrderCount()+GetSellOrderCount()==0)
        {
         HighPrice = Ask;
         LowPrice = Bid;
         OpenBuyOrder();
         OpenSellOrder();
        }
      //OpenBuyOrder();
      //OpenSellOrder();
      CBars=Bars;
     }
   //if(Bars!=CBars&&GetBuyOrderCount()+GetSellOrderCount()==0)
   //  {
   //   HighPrice = Ask;
   //   LowPrice = Bid;
   //   OpenBuyOrder();
   //   OpenSellOrder();
   //  }
   //if(GetBuyOrderCount()<OrderLimit)
   //  {
   //   OpenBuyOrder();
   //  }
   //if(GetSellOrderCount()<OrderLimit)
   //  {
   //   OpenSellOrder();
   //  }

   
  }
//+------------------------------------------------------------------+
//获取多单挂单数
int GetBuyOrderCount()
  {
   int c=0;
   if(BuyLimitCount+BuyStopCount<=OrderLimit)
     {
      for(int i=OrdersTotal()-1; i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUYSTOP || OrderType()==OP_BUYLIMIT)
              {
               c++;
              }
           }
        }
     }
   return c;
  }
//+------------------------------------------------------------------+

//获取空单挂单数
int GetSellOrderCount()
  {
   int c=0;
   if(SellStopCount+SellLimitCount<=OrderLimit)
     {
      for(int i=OrdersTotal()-1; i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_SELLLIMIT || OrderType()==OP_SELLSTOP)
              {
               c++;
              }
           }
        }
     }
   return c;
  }
//+------------------------------------------------------------------+
//到新的收盘价 挂单数目+开仓单数 是否为0
bool IsColseZero()
  {
   if(CBars != Bars)
     {
      if(GetBuyOrderCount()+GetSellOrderCount() !=0)
        {
         return true;
         //CBars = Bars;
        }
      else
        {
         return false;
         //CBars = Bars;
        }
     }
   return false;
  }

//第一次开单需要的价格和高点低点
void OpenSellOrder()
  {
   int needOpenCount = OrderLimit - GetSellOrderCount();
   for(int i=0; i<needOpenCount; i++)
     {
      LowPrice = LowPrice-distance*Point;
      int ticket = OrderSend(Symbol(),OP_SELLSTOP,Lots,LowPrice,Slippage,0,0,comment,Magic,0,clrRed);
      if(ticket < 0)
        {
         Alert("空单开单错误:    错误代码:   ", GetLastError());
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenBuyOrder()
  {

   int needOpenCount = OrderLimit - GetBuyOrderCount();
   for(int i=0; i<needOpenCount; i++)
     {
      HighPrice = HighPrice + distance*Point;
      int ticket = OrderSend(Symbol(),OP_BUYSTOP,Lots,HighPrice,Slippage,0,0,comment,Magic,0,clrLime);
      if(ticket < 0)
        {
         Alert("多单开单错误:    错误代码:   ", GetLastError());
        }
     }

  }
