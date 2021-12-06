//+------------------------------------------------------------------+
//|                                                        双重金死叉.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|  https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
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
input string OpenComment = "双重金死叉"; //开仓备注信息
input int Slippage = 10; // 滑点
input double ProfitMoney = 100; // 盈利金额

//加仓手数 1-1-2-3-5-8-13-21-34
input double AddLots1 = 0.1;//加仓手数1
input double AddLots2 = 0.1; //加仓手数2
input double AddLots3 = 0.1; //加仓手数3
input double AddLots4 = 0.1; //加仓手数4
input double AddLots5 = 0.1; //加仓手数5
input double AddLots6 = 0.1; //加仓手数6
input double AddLots7 = 0.1; //加仓手数7
input double AddLots8 = 0.1; //加仓手数8
input double AddLots9 = 0.1; //加仓手数9
input double AddLots10 = 0.1; //加仓手数10
input double AddLots11 = 0.1; //加仓手数11
input double AddLots12 = 0.1; //加仓手数12
input double AddLots13 = 0.1; //加仓手数13
input double AddLots14 = 0.1; //加仓手数14
input double AddLots15 = 0.1; //加仓手数15
input double AddLots16 = 0.1; //加仓手数16
input double AddLots17 = 0.1; //加仓手数17
input double AddLots18 = 0.1; //加仓手数18
input double AddLots19 = 0.1; //加仓手数19
input double AddLots20 = 0.1; //加仓手数20



OrderManager mp(OpenComment,OpenMagic,Slippage);

enum IsOpen
  {
   开启 = 0, 关闭 = 1
  };
input IsOpen 是否开启金叉 = 开启;
input IsOpen 是否开启死叉 = 开启;
double AddLots[21]= {};// 分清楚 全局变量 和局部变量，这个你要用在其他方法中的，所以放全局

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
   AddLots[11] = AddLots11;
   AddLots[12] = AddLots12;
   AddLots[13] = AddLots13;
   AddLots[14] = AddLots14;
   AddLots[15] = AddLots15;
   AddLots[16] = AddLots16;
   AddLots[17] = AddLots17;
   AddLots[18] = AddLots18;
   AddLots[19] = AddLots19;
   AddLots[20] = AddLots20;
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
  

enum FIRSTCROSS
  {
   FGOLDEN_CROSS = 0, FDEATH_CORSS = 1, FNO_CROSS = 2
  };
FIRSTCROSS precross = FNO_CROSS;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
FIRSTCROSS FOpenTypes()
  {
   double FMA1 = iMA(Symbol(),MA1_Time, MA1_Period,0, MA_Method, MA_price, 0);
   double FMA2 = iMA(Symbol(),MA2_Time, MA2_Period,0, MA_Method, MA_price, 0);

   if(FMA1 > FMA2)
     {
      return FGOLDEN_CROSS;
     }
   if(FMA1 < FMA2)
     {
      return FDEATH_CORSS;
     }
   return FNO_CROSS;
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
   if(FOpenTypes()!=precross){
      Print("FOpenTypes:",FOpenTypes(), "  precross:",precross," BOpenTypes()：",BOpenTypes(), " bars:",bars," Bars:",Bars," mp.GetHandBuyCount(): ",mp.GetHandBuyCount()," mp.GetHandSellCount(): ",mp.GetHandSellCount()," OrderAddCount",OrderAddCount);
      precross = FOpenTypes();
   }

//大周期下小周期金死叉交替循环来开平仓。当大周期改变时也需要平仓，也就是大小周期不处于同一状态也需要平仓
   mp.Update();
   if((mp.GetHandBuyCount()>0 && (FOpenTypes()==FDEATH_CORSS || BOpenTypes()== BDEATH_CROSS)) && bars != Bars)
     {
      Print("mp.GetHandBuyCount(): ",mp.GetHandBuyCount()," FOpenTypes(): ",FOpenTypes()," BOpenTypes(): ",BOpenTypes());
      bool needRest = false;
      if(mp.FloatProfit() > 0)
        {
         needRest = true;
         //OrderAddCount=0;
        }
      if(!mp.CloseAllBuyOrders())
        {
         Print("close sell",GetLastError());
        }
      else
        {
         if(needRest)
           {
            OrderAddCount = 0;
           }
        }

     }
//
   if((mp.GetHandSellCount()>0 && (FOpenTypes()==FGOLDEN_CROSS || BOpenTypes()== BGOLDEN_CROSS)) && bars != Bars)
     {
     double DMA1 = iMA(Symbol(),DMA1_Time,DMA1_Period,0,DMA_Method,DMA_price,0);
   double DMA2 = iMA(Symbol(),DMA2_Time,DMA2_Period,0,DMA_Method,DMA_price,0);
   Print(DMA1," ttttc ",DMA2);
      Print("mp.GetHandSellCount(): ",mp.GetHandSellCount()," FOpenTypes(): ",FOpenTypes()," BOpenTypes(): ",BOpenTypes());
      bool needRest = false;
      if(mp.FloatProfit() > 0)
        {
         needRest = true;
         //OrderAddCount=0;
        }
      if(!mp.CloseAllSellOrders())
        {
         Print("close sell",GetLastError());
        }
      else
        {
         if(needRest)
           {
            OrderAddCount = 0;
           }
        }

     }
   mp.Update();

//第一次的时候大小周期处于同一状态下 就要开仓


   if(OrderAddCount<=20 && bars != Bars)
     {
      if(是否开启金叉==开启 && BOpenTypes()==BGOLDEN_CROSS && FOpenTypes() == FGOLDEN_CROSS && mp.GetHandBuyCount()<1)
        {
        Print("aaaaa mp.GetHandBuyCount(): ",mp.GetHandBuyCount()," FOpenTypes(): ",FOpenTypes()," BOpenTypes(): ",BOpenTypes());
         if(!mp.Buy(AddLots[OrderAddCount],clrRed))
           {
            Print("open buy error: ",GetLastError());
           }
         OrderAddCount++;
         bars = Bars;
        }
      if(是否开启死叉==开启 && BOpenTypes()==BDEATH_CROSS && FOpenTypes() == FDEATH_CORSS && mp.GetHandSellCount()<1)
        {
          double DMA1 = iMA(Symbol(),DMA1_Time,DMA1_Period,0,DMA_Method,DMA_price,0);
   double DMA2 = iMA(Symbol(),DMA2_Time,DMA2_Period,0,DMA_Method,DMA_price,0);
   Print(DMA1," ttttc ",DMA2);
           Print("aaaa mp.GetHandSellCount(): ",mp.GetHandSellCount()," FOpenTypes(): ",FOpenTypes()," BOpenTypes(): ",BOpenTypes());
         if(!mp.Sell(AddLots[OrderAddCount],clrLime))
           {
            Print("open sell error: ",GetLastError());
           }
         bars = Bars;
         OrderAddCount++;
        }
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

//这里用来实现第一次加载时 大小周期处于同一状态下的开仓


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
