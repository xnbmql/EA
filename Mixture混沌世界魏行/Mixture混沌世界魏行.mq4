// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                       Mixture混沌世界魏行.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|  https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482"
#property version   "1.00"
#property strict
#include <Mylib\Trade\Ordermanager.mqh>


//那就是把混沌ea附件放在 混沌世界魏行里面
//有一个挂单 混沌世界魏行不开仓，混沌ea附件开仓
//超过一个了  都不开仓
//没有挂单  两个都正常开仓
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input int Magic = 202100; //开仓magic码
input string comment = "Mixture混沌世界魏行"; //开仓备注
input int distance = 100; //等距离点差距离
input int Slippage = 10; //滑点
input double Lots = 0.01; // 手数
input double OpenBuyLine = 100.0; //开多单的数值线
input double OpenSellLine = 100.0; //开空单的数值线

int bars = 0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderManager np(comment,199005,Slippage);
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
double maxBuyBid = 0.0;
double maxSellAsk = 0.0;
int sellLoop = 0;
int buyLoop = 0;
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
   if(Bars ==0)
     {
      return;
     }
   if(bars != Bars && penningOrderCount() < 1)
     {
      RealPriceWithOpenBuyOrSellLine();
      bars = Bars;
     }
//---这里有挂单就不开对冲
   //if(penningOrderCount() > 0)
   //  {
   //   Print("有挂单不交易");
   //   return;
   //  }
   if(orderCount() < 1)
     {
      int ticket_b = OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,comment,Magic,0,clrRed);
      int ticket_s = OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,comment,Magic,0,clrLime);
      if(ticket_b <= 0)
        {
         Alert("多单开单错误:    错误代码:   ", GetLastError());
        }
      if(ticket_s <= 0)
        {
         Alert("多单开单错误:    错误代码:   ", GetLastError());
        }
      maxBuyBid = Bid;
      maxSellAsk = Ask;
      sellLoop = 1;
      buyLoop = 1;
     }

// 开空单逻辑
   Print("Bid:",Close[0], "ask:",maxSellAsk+sellLoop*distance*Point,"sellloop:",sellLoop);
   if(Close[0] > maxSellAsk+sellLoop*distance*Point)
     {
      // maxSellAsk = Ask;
      int ticket = OrderSend(Symbol(),OP_SELL,Lots*(sellLoop*2+1),Bid,Slippage,0,0,comment,Magic,0,clrLime);
      if(ticket <= 0)
        {
         Alert("多单开单错误:    错误代码:   ", GetLastError());
        }
      sellLoop++;
     }

// 开多单逻辑
   Print("c Bid:",Close[0] +(maxSellAsk-maxBuyBid), "ask:", maxBuyBid-buyLoop*distance*Point,"buyLoop:",buyLoop);

   if(Close[0] +(maxSellAsk-maxBuyBid) < maxBuyBid-buyLoop*distance*Point)
     {
      // maxBuyBid = Bid;
      int ticket = OrderSend(Symbol(),OP_BUY,Lots*(buyLoop*2+1),Ask,Slippage,0,0,comment,Magic,0,clrRed);
      if(ticket <= 0)
        {
         Alert("多单开单错误:    错误代码:   ", GetLastError());
        }
      buyLoop++;
     }

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int orderCount()
  {
   int oc = 0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber() == Magic)
        {
         if(OrderType()==OP_BUY || OrderType()==OP_SELL)
           {
            oc++;
           }
        }
     }
   return oc;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int penningOrderCount()
  {
   int pc = 0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
        {
         if(OrderType()==OP_BUYSTOP || OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT)
           {
            pc++;
           }
        }
     }
   return pc;
  }


//开多空单的数值线与收盘价格线的关系
void RealPriceWithOpenBuyOrSellLine()
  {

   if(OpenBuyLine < Close[1])
     {
      np.Buy(Lots,clrRed);
     }
   if(OpenSellLine > Close[1])
     {
      np.Sell(Lots,clrLime);
     }
  }
//+------------------------------------------------------------------+
