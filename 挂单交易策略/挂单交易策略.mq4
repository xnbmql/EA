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

int BuyLimitCount = 0;
int SellLimitCount = 0;
int SellStopCount = 0;
int BuyStopCount = 0;

OrderManager *OP;


int CBars = Bars;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   OP =new OrderManager(comment,Magic,Slippage);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   delete OP;
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
//Print("多单挂单数： ",getHandBuyOrderCount()," 空单挂单数：",getHangSellOrderCount());
   Print(IsColseZero());
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
         CBars = Bars;
        }
      else
        {
         return false;
         CBars = Bars;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//买单限价挂单
int GetBuyLimitCount()
  {
   double price = MarketInfo(Symbol(),MODE_BID);
//sl=price-(int)ObjectGetString(0,"TEXT2",OBJPROP_TEXT,0)*
//   MarketInfo(Symbol(),MODE_POINT)*10;
//tp=price+(int)ObjectGetString(0,"TEXT3",OBJPROP_TEXT,0)*
//   MarketInfo(Symbol(),MODE_POINT)*10;
   int check=OrderSend(Symbol(),OP_BUYLIMIT,Lots,price,Slippage,0,0,"BUYLIMIT",Magic,0,clrBlue);
   return check;
  }

//卖单限价挂单
int GetSellLimitCount()
  {
   double price = MarketInfo(Symbol(),MODE_BID);
   int check=OrderSend(Symbol(),OP_SELLLIMIT,Lots,price,Slippage,0,0,"SELLLIMIT",Magic,0,clrRed);
   return check;
  }

//买单止损挂单
int GetBuyStopCount()
  {
   double price = MarketInfo(Symbol(),MODE_BID);
   int check=OrderSend(Symbol(),OP_BUYSTOP,Lots,price,Slippage,0,0,"BUYSTOP",Magic,0,clrBlue);
   return check;
  }

//卖单止损挂单
int GetSellStopCount()
  {
   double price = MarketInfo(Symbol(),MODE_BID);
   int check=OrderSend(Symbol(),OP_SELLSTOP,Lots,price,Slippage,0,0,"SELLSTOP",Magic,0,clrRed);
   return check;
  }
//+------------------------------------------------------------------+
