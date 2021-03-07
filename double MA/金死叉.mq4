//+------------------------------------------------------------------+
//|                                                          金死叉.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//外部变量
//均线的参数设置
input int MA1_Period = 15;
input int MA2_Period = 60;
input ENUM_MA_METHOD MA_Method = MODE_SMA;
input ENUM_APPLIED_PRICE MA_Price = PRICE_CLOSE;

//交易的参数设置
input double OpenLots = 0.01;
input int OpenMagic = 123456;
input string OpenComment = "金死叉";

//清仓线设置
input double ProfitClose = 1000;
input double StopClose = -1000;

//全局变量
int B_Orders, S_Orders;
double B_Lots, S_Lots;
double B_Profits, S_Profits;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
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
   if(IsTradeAllowed())
     {
      Alert("自动交易存在异常，请检查!");
      return;
     }

   CountOrders();

   double TotalProfits = B_Profits + S_Profits;

   if(TotalProfits > ProfitClose || TotalProfits < StopClose)
     {
      CloseOrders();
     }

   int tempType = OpenTypes();

   switch(tempType)
     {
      case OP_BUY :
         if(S_Orders > 0)
           {
            CloseOrders(OP_SELL);
           }
         if(B_Orders == 0)
           {
            OpenOrders(OP_BUY);
           }
         break;
      case OP_SELL :
         if(B_Orders > 0)
           {
            CloseOrders(OP_BUY);
           }
         if(S_Orders == 0)
           {
            OpenOrders(OP_SELL);
           }
         break;
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CountOrders()
  {
   B_Orders = 0;
   B_Lots = 0.0;
   B_Profits = 0.0;

   S_Orders = 0;
   S_Lots = 0.0;
   S_Profits = 0.0;

   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == OpenMagic && OrderComment() == OpenComment)
           {
            if(OrderType() == OP_BUY)
              {
               B_Orders++;
               B_Lots += OrderLots();
               B_Profits += OrderProfit() + OrderCommission() + OrderSwap();
              }

            if(OrderType() == OP_SELL)
              {
               S_Orders++;
               S_Lots += OrderLots();
               S_Profits += OrderProfit() + OrderSwap() + OrderCommission();
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OpenTypes()
  {
   double MA1_2 = iMA(Symbol(),0,MA1_Period,0,MA_Method,MA_Price,2);
   double MA2_2 = iMA(Symbol(),0,MA2_Period,0,MA_Method,MA_Price,2);

   double MA1_1 = iMA(Symbol(),0,MA1_Period,0,MA_Method,MA_Price,1);
   double MA2_1 = iMA(Symbol(),0,MA2_Period,0,MA_Method,MA_Price,1);

   if(MA1_2 < MA2_2 && MA1_1 > MA2_1)
     {
      return OP_BUY;
     }
   if(MA1_2 > MA2_2 && MA1_1 < MA2_1)
     {
      return OP_SELL;
     }
   return -1;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenOrders(int OpenType)
  {
   double OpenPrice = 0.0;

   switch(OpenType)
     {
      case OP_BUY :
         OpenPrice = Ask;
         break;
      case OP_SELL :
         OpenPrice = Bid;
         break;
     }

   int Ticket = OrderSend(Symbol(),OpenType,OpenLots,OpenPrice,30,0,0,OpenComment,OpenMagic,0,clrRed);

   if(Ticket < 0)
     {
      Alert("开单错误，错误代码是：", GetLastError());
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseOrders(int CloseType = -1)
  {
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == OpenMagic && OrderComment() == OpenComment)
           {
            if(OrderType() == CloseType || CloseType == -1)
              {
               bool tempClose = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),30,clrLime);

               if(!tempClose)
                 {
                  Print("平仓错误，错误代码是：",GetLastError());
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
