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


int OrderCount = 0;


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
//---这里有挂单就不开对冲
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
        {
         if(OrderType()==OP_BUYSTOP || OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT)
           {
            return;
           }
        }
     }
   if(OrderCount < 1)
     {
      int ticket_b = OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,comment,Magic,0,clrRed);
      int ticket_s = OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,comment,Magic,0,clrLime);
      if(ticket_b < 0)
        {
         Alert("多单开单错误:    错误代码:   ", GetLastError());
        }
      if(ticket_s < 0)
        {
         Alert("多单开单错误:    错误代码:   ", GetLastError());
        }
      OrderCount = 1;
     }

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
        {
         if(OrderType()==OP_BUY && Close[1] > OrderOpenPrice() + distance)
           {           
            int ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,comment,Magic,0,clrRed);
            if(ticket < 0)
              {
               Alert("多单开单错误:    错误代码:   ", GetLastError());
              }
           }
        }
     }

   for(int i=OrdersTotal()-1; i>=0; i--)
     {    
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
        {
         if(OrderType()==OP_SELL && Close[1] < OrderOpenPrice() - distance)
           {
            int ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,comment,Magic,0,clrRed);
            if(ticket < 0)
              {
               Alert("多单开单错误:    错误代码:   ", GetLastError());
              }
           }
        }
     }



  }
//+------------------------------------------------------------------+
