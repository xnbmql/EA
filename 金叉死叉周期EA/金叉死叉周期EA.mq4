//+------------------------------------------------------------------+
//|                                                   MyEA金叉死叉开单.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482"
#property version   "1.00"
#property strict

#include <Mylib\Trade\Ordermanager.mqh>


//外部变量
//均线的参数设置
input int MA1_Period = 15; //均线一周期
input int MA2_Period = 30; //均线二周期
input ENUM_TIMEFRAMES MA1_Time = PERIOD_CURRENT; //均线一时间周期
input ENUM_TIMEFRAMES MA2_Time = PERIOD_CURRENT; //均线二时间周期
input ENUM_MA_METHOD MA_Method = MODE_SMA; //均线模式
input ENUM_APPLIED_PRICE MA_price = PRICE_CLOSE; //均线应用价格

input int DMA1_Period = 60; //大均线一周期
input int DMA2_Period = 120; //大均线二周期
input ENUM_TIMEFRAMES DMA1_Time = PERIOD_H1; //大均线一时间周期
input ENUM_TIMEFRAMES DMA2_Time = PERIOD_H1; //大均线二时间周期
input ENUM_MA_METHOD DMA_Method = MODE_SMA; //大均线模式
input ENUM_APPLIED_PRICE DMA_price = PRICE_CLOSE; //大均线应用价格

//交易的参数设置
input double OpenLots = 0.1; // 开仓手数
input int OpenMagic = 788733; //开仓magic
input string OpenComment = "金死叉"; //开仓备注信息
input int Slippage = 10; // 滑点
input double ProfitMoney = 100; // 盈利金额

//加仓手数 1-1-2-3-5-8-13-21-34
input double AddLots1 = 1; //加仓手数1
input double AddLots2 = 1; //加仓手数2
input double AddLots3 = 2; //加仓手数3
input double AddLots4 = 3; //加仓手数4
input double AddLots5 = 5; //加仓手数5
input double AddLots6 = 8; //加仓手数6
input double AddLots7 = 13; //加仓手数7
input double AddLots8 = 21; //加仓手数8
input double AddLots9 = 34; //加仓手数9
input double AddLots10 = 55; //加仓手数10


OrderManager mp(OpenComment,OpenMagic,Slippage);

enum IsOpen
  {
   开启 = 0, 关闭 = 1
  };
input IsOpen 是否开启金叉 = 开启;
input IsOpen 是否开启死叉 = 开启;

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
   if(!IsTradeAllowed())
     {
      Alert("自动交易设置存在异常,   请检查!  ");
      return;
     }
//平仓
   if(orderCount()>0 && OpenTypes()==DEATH_CROSS && mp.FloatProfit()>ProfitMoney)
     {
      for(int i=OrdersTotal(); i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY)
              {
               CloseAllOrder();
              }
           }
        }
     }
   if(orderCount()>0 && OpenTypes()==GOLDEN_CROSS && mp.FloatProfit()>ProfitMoney)
     {
      for(int i=OrdersTotal(); i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_SELL)
              {
               CloseAllOrder();
              }
           }
        }
     }

//开仓
   
   if(是否开启金叉==开启 && BOpenTypes()==BDEATH_CROSS && OpenTypes()==GOLDEN_CROSS && orderCount()<1)
     {
      if(!mp.Buy(OpenLots,clrRed))
        {
         Print("open buy error: ",GetLastError());
        }
     }
   if(是否开启死叉==开启 && BOpenTypes()==BGOLDEN_CROSS && OpenTypes()==DEATH_CROSS && orderCount()<1)
     {
      if(!mp.Sell(OpenLots,clrLime))
        {
         Print("open sell error: ",GetLastError());
        }
     }
//加仓

  }
//+------------------------------------------------------------------+

enum CROSSTYPE
  {
   GOLDEN_CROSS = 0, DEATH_CROSS = 1, NO_CROSS = 2
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//小周期
CROSSTYPE OpenTypes()
  {
   double MA1_2 = iMA(Symbol(),MA1_Time, MA1_Period,0, MA_Method, MA_price, 2);
   double MA2_2 = iMA(Symbol(),MA2_Time, MA2_Period, 0, MA_Method, MA_price, 2);

   double MA1_1 = iMA(Symbol(),MA1_Time, MA1_Period, 0, MA_Method, MA_price, 1);
   double MA2_1 = iMA(Symbol(),MA2_Time, MA2_Period, 0, MA_Method, MA_price, 1);

   if(MA1_2 < MA2_2 && MA1_1 > MA2_1)
     {
      return GOLDEN_CROSS;
     }
   if(MA1_2 > MA2_2 && MA1_1 < MA2_1)
     {
      return DEATH_CROSS;
     }
   return NO_CROSS;
  }
  
//大周期
enum BIGCROSSTYPE
  {
   BGOLDEN_CROSS = 0, BDEATH_CROSS = 1, BNO_CROSS = 2
  };
  
BIGCROSSTYPE BOpenTypes()
  {
   double MA1_2 = iMA(Symbol(),DMA1_Time, DMA1_Period,0, DMA_Method, DMA_price, 2);
   double MA2_2 = iMA(Symbol(),DMA2_Time, DMA2_Period, 0, DMA_Method, DMA_price, 2);

   double MA1_1 = iMA(Symbol(),DMA1_Time, DMA1_Period, 0, DMA_Method, DMA_price, 1);
   double MA2_1 = iMA(Symbol(),DMA2_Time, DMA2_Period, 0, DMA_Method, DMA_price, 1);

   if(MA1_2 < MA2_2 && MA1_1 > MA2_1)
     {
      return BGOLDEN_CROSS;
     }
   if(MA1_2 > MA2_2 && MA1_1 < MA2_1)
     {
      return BDEATH_CROSS;
     }
   return BNO_CROSS;
  }
//+------------------------------------------------------------------+
int orderCount()
  {
   int oc = 0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
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
void CloseAllOrder()
  {
   int i;
   double price=0.0;
   double lot=0.0;

   int err=0;
   int huadian=10;
   for(i=OrdersTotal()-1; i>=0; i--)
     {

      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(MarketInfo(OrderSymbol(),MODE_TRADEALLOWED)!=1)
           {
            continue;
           }
         if(OrderSymbol()==Symbol() && (OrderType()==OP_SELL ||OrderType()==OP_BUY))
           {
            lot=OrderLots();
            price=MarketInfo(Symbol(),MODE_ASK);
            if(!OrderClose(OrderTicket(),lot,price,huadian))
              {
               Alert("平仓错误：",GetLastError());
              }

           }
        }
     }
  }
//+------------------------------------------------------------------+
