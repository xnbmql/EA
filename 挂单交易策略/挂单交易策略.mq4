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
input int OrderLimit = 5; // 挂单数
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
        }
      OpenBuyOrder();
      OpenSellOrder();
      CBars=Bars;
     }
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
////+------------------------------------------------------------------+
////买单限价挂单
//int GetBuyLimit()
//  {
//   double price = MarketInfo(Symbol(),MODE_ASK)-distance*Point;
////sl=price-(int)ObjectGetString(0,"TEXT2",OBJPROP_TEXT,0)*
////   MarketInfo(Symbol(),MODE_POINT)*10;
////tp=price+(int)ObjectGetString(0,"TEXT3",OBJPROP_TEXT,0)*
////   MarketInfo(Symbol(),MODE_POINT)*10;
//   int check=OrderSend(Symbol(),OP_BUYLIMIT,Lots,price,Slippage,0,0,"BUYLIMIT",Magic,0,clrBlue);
//   return check;
//  }
//
////卖单限价挂单
//int GetSellLimit()
//  {
//   double price = MarketInfo(Symbol(),MODE_BID)+distance*Point;
//   int check=OrderSend(Symbol(),OP_SELLLIMIT,Lots,price,Slippage,0,0,"SELLLIMIT",Magic,0,clrRed);
//   return check;
//  }
//
////买单止损挂单
//int GetBuyStop()
//  {
//   double price = MarketInfo(Symbol(),MODE_ASK)-distance*Point;
//   int check=OrderSend(Symbol(),OP_BUYSTOP,Lots,price,Slippage,0,0,"BUYSTOP",Magic,0,clrBlue);
//   return check;
//  }
//
////卖单止损挂单
//int GetSellStop()
//  {
//   double price = MarketInfo(Symbol(),MODE_BID)+distance*Point;
//   int check=OrderSend(Symbol(),OP_SELLSTOP,Lots,price,Slippage,0,0,"SELLSTOP",Magic,0,clrRed);
//   return check;
//  }
////多空单
//int GetBuyOrSellOrder(){
//   double price1 = MarketInfo(Symbol(),MODE_ASK);
//   double price2 = MarketInfo(Symbol(),MODE_BID);
//   int check1 = OrderSend(Symbol(),OP_BUY,Lots,price1,Slippage,0,0,comment,Magic,0,clrAqua);
//   int check2 = OrderSend(Symbol(),OP_SELL,Lots,price2,Slippage,0,0,comment,Magic,0,clrCyan);
//   return check1;
//   return check2;
//}

//所有类型的单子
//void Order_Type(){
//   GetBuyLimit();
//   GetBuyStop();
//   GetSellLimit();
//   GetSellStop();
//   GetBuyOrSellOrder();
//}
//+------------------------------------------------------------------+

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


//+------------------------------------------------------------------+
//|                                                                  |
////+------------------------------------------------------------------+
//void OpenOrder()
//  {
//// 单数为0 新开盘价 开单
//   if(CBars!=Bars)
//     {
//      HighPrice = 0.0;
//      LowPrice = 0.0;
//      int needOpenCount = OrderLimit - GetBuyOrderCount();
//      for(int i=0; i<needOpenCount; i++)
//        {
//         double buyStopPrice = Ask+(i+1)*distance*Point;
//         double sellStopPrice = Bid-(i+1)*distance*Point;
//         HighPrice = buyStopPrice;
//         LowPrice = sellStopPrice;
//         int ticket1 = OrderSend(Symbol(),OP_BUYSTOP,Lots,HighPrice,Slippage,0,0,comment,Magic,0,clrLime);
//         int ticket2 = OrderSend(Symbol(),OP_SELLSTOP,Lots,LowPrice,Slippage,0,0,comment,Magic,0,clrRed);
//         if(ticket1 < 0)
//           {
//            Alert("开单错误:    错误代码:   ", GetLastError());
//           }
//         if(ticket2 < 0)
//           {
//            Alert("开单错误:    错误代码:   ", GetLastError());
//           }
//        }
//     }
//   CBars = Bars;
//  }
//+------------------------------------------------------------------+
