//+------------------------------------------------------------------+
//|                                                 infinite多空EA.mq4 |
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
input int Magic = 2021722; //开仓magic码
input string comment = "yongjie"; //开仓备注
input int Slippage = 10; //滑点
input double Lots = 0.01; // 手数
input int ProfitPoints = 500; // 止盈点数

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

double maxBuyBid = 0.0;
double maxSellAsk = 0.0;

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
// 先开一组对冲单
   if(OrderCountBuy() < 1 || OrderCountSell() < 1)
     {
     
      int ticket_b = OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,Bid+ProfitPoints*Point,comment,Magic,0,clrRed);
      int ticket_s = OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,Ask-ProfitPoints*Point,comment,Magic,0,clrLime);
      if(ticket_b <= 0)
        {
         Alert("多单开单错误:    错误代码:   ", GetLastError());
        }
      if(ticket_s <= 0)
        {
         Alert("多单开单错误:    错误代码:   ", GetLastError());
        }
      //maxBuyBid = Bid;
      //maxSellAsk = Ask;
     }
     
// 平了任意多单或空单，继续开多空
   
   
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderCountBuy()
  {
   int oc = 0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber() == Magic)
        {
         if(OrderType()==OP_BUY)
           {
            oc++;
           }
        }
     }
   return oc;
  }
//+------------------------------------------------------------------+
int OrderCountSell()
  {
   int oc = 0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber() == Magic)
        {
         if(OrderType()==OP_SELL)
           {
            oc++;
           }
        }
     }
   return oc;
  }