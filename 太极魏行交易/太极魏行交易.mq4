// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                       太极魏行交易.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|  https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input int Magic = 202100; //开仓magic码
input string comment = "太极魏行交易"; //开仓备注
input int distance = 100; //等距离点差距离
input int Slippage = 10; //滑点
input double Lots = 0.01; // 手数


// int OrderCount = 0;


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
//---这里有挂单就不开对冲
   if(penningOrderCount() > 0){
      Print("有挂单不交易");
      return;
   }
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
      // OrderCount = 1;
     }

   // for(int i=OrdersTotal()-1; i>=0; i--)
   //   {
   //    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
   //      {
   //       if(OrderType()==OP_BUY && Close[1] > OrderOpenPrice() + distance)
   //         {
   //          int ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,comment,Magic,0,clrRed);
   //          if(ticket < 0)
   //            {
   //             Alert("多单开单错误:    错误代码:   ", GetLastError());
   //            }
   //         }
   //      }
   //   }

   // 开空单逻辑
   Print("Bid:",Close[0], "ask:",maxSellAsk+sellLoop*distance*Point,"sellloop:",sellLoop);
   if(Close[0] > maxSellAsk+sellLoop*distance*Point){
      // maxSellAsk = Ask;
      int ticket = OrderSend(Symbol(),OP_SELL,Lots*(sellLoop*2+1),Bid,Slippage,0,0,comment,Magic,0,clrRed);
      if(ticket <= 0)
        {
         Alert("多单开单错误:    错误代码:   ", GetLastError());
        }
      sellLoop++;
   }

   // 开空单逻辑
   Print("c Bid:",Close[0] +(maxSellAsk-maxBuyBid) , "ask:", maxBuyBid-buyLoop*distance*Point,"buyLoop:",buyLoop);

   if(Close[0] +(maxSellAsk-maxBuyBid) < maxBuyBid-buyLoop*distance*Point){
      // maxBuyBid = Bid;
      int ticket = OrderSend(Symbol(),OP_BUY,Lots*(buyLoop*2+1),Ask,Slippage,0,0,comment,Magic,0,clrRed);
      if(ticket <= 0)
        {
         Alert("多单开单错误:    错误代码:   ", GetLastError());
        }
      buyLoop++;
   }

   // for(int i=OrdersTotal()-1; i>=0; i--)
   //   {
   //    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
   //      {
   //       if(OrderType()==OP_SELL && Close[1] < OrderOpenPrice() - distance)
   //         {
   //          int ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,comment,Magic,0,clrRed);
   //          if(ticket < 0)
   //            {
   //             Alert("多单开单错误:    错误代码:   ", GetLastError());
   //            }
   //         }
   //      }
   //   }



  }
//+------------------------------------------------------------------+

int orderCount(){
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

int penningOrderCount(){
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
