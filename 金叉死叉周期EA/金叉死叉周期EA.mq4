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
input double AddLots1 = 0.1; //加仓手数1
input double AddLots2 = 0.1; //加仓手数2
input double AddLots3 = 0.2; //加仓手数3
input double AddLots4 = 0.3; //加仓手数4
input double AddLots5 = 0.5; //加仓手数5
input double AddLots6 = 0.8; //加仓手数6
input double AddLots7 = 1.3; //加仓手数7
input double AddLots8 = 2.1; //加仓手数8
input double AddLots9 = 3.4; //加仓手数9
input double AddLots10 = 5.5; //加仓手数10

OrderManager mp(OpenComment,OpenMagic,Slippage);

enum IsOpen
  {
   开启 = 0, 关闭 = 1
  };
input IsOpen 是否开启金叉 = 开启;
input IsOpen 是否开启死叉 = 开启;
double AddLots[11]= {};// 分清楚 全局变量 和局部变量，这个你要用在其他方法中的，所以放全局

int OrderAddCount=0; // 加仓单数量(手数)

int bars=0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   AddLots[0] = OpenLots;
   AddLots[1] = AddLots1;
   AddLots[2] = AddLots2;
   AddLots[3] = AddLots3;
   AddLots[4] = AddLots4;
   AddLots[5] = AddLots5;
   AddLots[6] = AddLots6;
   AddLots[7] = AddLots7;
   AddLots[8] = AddLots8;
   AddLots[9] = AddLots9;
   AddLots[10] = AddLots10;
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
//Print("BOpenType: ",BOpenTypes());
//---
   if(!IsTradeAllowed())
     {
      Alert("自动交易设置存在异常,   请检查!  ");
      return;
     }
//平仓
   Print("orderCount():",orderCount()," OpenTypes():", DEATH_CROSS," bars:",bars, " Bars:",Bars);
   if((orderCount()>0 && OpenTypes()==DEATH_CROSS) && bars != Bars)
     {
      for(int i=OrdersTotal(); i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
           {
            Print("OrderType:", OrderType());
            if(OrderType()==OP_BUY || OrderType()==OP_SELL)
              {
               if(mp.FloatProfit()>0)
                 {
                  OrderAddCount=0;
                 }
               CloseAllOrder();
              }
           }
        }
     }
   if((orderCount()>0 && OpenTypes()==GOLDEN_CROSS) && bars != Bars)
     {
      for(int i=OrdersTotal(); i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL)
              {
               if(mp.FloatProfit()>0)
                 {
                  OrderAddCount=0;
                 }
               CloseAllOrder();
              }
           }
        }
     }
//如果盈利金额大于设置金额 全部平仓 加仓手数重置(加仓单数量重置)
   //if(mp.FloatProfit()>ProfitMoney)
   //  {
   //   CloseAllOrder();
   //   OrderAddCount=0;
   //  }

//开仓
//加仓,最多加十次，每次的手数都需要自己设置

   mp.Update();
   if(OrderAddCount<=10)
     {
      //if(BOpenTypes()==BDEATH_CROSS)
      //  {
      if(是否开启金叉==开启 && BOpenTypes()==BDEATH_CROSS && OpenTypes()==GOLDEN_CROSS && orderCount()<1)
        {
         if(!mp.Buy(AddLots[OrderAddCount],clrRed))
           {
            Print("open buy error: ",GetLastError());
           }
         OrderAddCount++;
         bars = Bars;
        }

      //}

      //if(BOpenTypes()==BGOLDEN_CROSS)
      //  {
      if(是否开启死叉==开启 && BOpenTypes()==BGOLDEN_CROSS && OpenTypes()==DEATH_CROSS && orderCount()<1)
        {
         if(!mp.Sell(AddLots[OrderAddCount],clrLime))
           {
            Print("open sell error: ",GetLastError());
           }
         bars = Bars;
         OrderAddCount++;
        }
      //}
     }

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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BIGCROSSTYPE BOpenTypes()
  {
   double DMA1 = iMA(Symbol(),DMA1_Time,DMA1_Period,0,DMA_Method,DMA_price,0);
   double DMA2 = iMA(Symbol(),DMA2_Time,DMA2_Period,0,DMA_Method,DMA_price,0);

   if(DMA1>DMA2)
     {
      return BGOLDEN_CROSS;
     }
   if(DMA1<DMA2)
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
         //Print("Trade is allowed for the symbol=",MarketInfo(Symbol(),MODE_TRADEALLOWED));
         // if(MarketInfo(Symbol(),MODE_TRADEALLOWED)!=1)
         //   {
         //    Alert("not allowed");
         //    continue;
         //   }
         if(OrderSymbol()==Symbol() && (OrderType()==OP_SELL ||OrderType()==OP_BUY))
           {
            lot=OrderLots();
            price=MarketInfo(Symbol(),MODE_ASK);
            if(!OrderClose(OrderTicket(),lot,price,huadian))
              {
               Print("平仓错误");
               Alert("平仓错误：",GetLastError());
              }

           }
        }
     }
  }

//+------------------------------------------------------------------+
