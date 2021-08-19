//+------------------------------------------------------------------+
//|                                                       止盈止损EA.mq4 |
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

////input int Magic = 011963; //开仓magic码
//input string comment = "止盈止损"; //开仓备注
//input int Slippage = 10; //滑点
//input double Lots = 0.01; // 手数

enum IsOpen
  {
   开启 = 0, 关闭 = 1
  };
input IsOpen 是否开启止盈 = 开启;
input IsOpen 是否开启止损 = 开启;

input double TakeProfit = 0.1; //止盈占比
input double StopLoss = 0.1; //止损占比



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
//Print("已用预付款",AccountMargin());
//Print("账户盈利",AccountProfit());
   double Margin = AccountMargin();
   double Profit = AccountProfit();

   if((是否开启止盈==开启) && (Profit > Margin*TakeProfit))
     {
      ordercl();
     }

   if((是否开启止损==开启) && Profit < -Margin*StopLoss)
     {
      ordercl();
     }
   Print("Profit: ",Profit," Margin*StopLoss",-Margin*StopLoss," Margin: ",Margin);

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ordercl()
  {
   int i;
   double price;
   double lot;
   int huadian=10;
   for(i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(MarketInfo(OrderSymbol(),MODE_TRADEALLOWED)!=1)
           {
            continue;
           }
         if(OrderType()==OP_SELL)
           {
            lot=OrderLots();
            price=MarketInfo(Symbol(),MODE_ASK);

            if(!OrderClose(OrderTicket(),lot,price,huadian))
              {
               Alert("平仓错误：",GetLastError());
              }
           }
         if(OrderType()==OP_BUY)
           {
            lot=OrderLots();
            price=MarketInfo(Symbol(),MODE_BID);
            if(!OrderClose(OrderTicket(),lot,price,huadian))
              {
               Alert("平仓错误: ",GetLastError());
              }
           }

        }

     }

  }
//+------------------------------------------------------------------+
