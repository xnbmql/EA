// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                               双均线加减仓ea.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Mylib\Panels\ManagerPanel.mqh>
#include <Mylib\Trade\Ordermanager.mqh>


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

input int Magic = 899491;// 开仓magic码
input double Lots = 0.1; //开仓手数
input string comment = "双指标加减仓"; //开仓备注
input int Slippage = 30; // 滑点

int signalsDist = 24;

input double Depth = 12500;
input int MaxBars = 4700;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderManager fp(comment,Magic,Slippage);
OrderManager ap(comment,Magic,Slippage);


int AddOrderCount = 0; // 加仓次数
double AddOrderVolume = 0.0; // 加仓手数
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---


//
//   if(!op.Create(0,"一键平仓",0))
//     {
//      Print("init failed");
//     }
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
   fp.Update();
   ap.Update();
   if(!IsTradeAllowed())
     {
      Alert("自动交易设置存在异常,   请检查!  ");
      return;
     }
   if(Bars ==0)
     {
      return;
     }
//ZZ_COLOR zc = GetZZCOLOR(Depth*Point,MaxBars);
   

  }
//+------------------------------------------------------------------+

//开单的方向 多单0 空单1 无方向2
enum OrderDirect
  {
   OBuy = 0,
   OSell = 1,
   ONothing = 2
  };

// 新首单方向，如果不需要开返回Nothing
OrderDirect NewOpenFirstOrderDirect()
  {
   if(GetSignalsColor(1)==S_COLOR_RED && GetZZCOLOR(Depth*Point,1)==ZZ_GREEN_CROSS)
     {
      return OBuy;
     }
   if(GetSignalsColor(1)==S_COLOR_BULE && GetZZCOLOR(Depth*Point,1)==ZZ_RED_CROSS)
     {
      return OSell;
     }
   return ONothing;
  }

//获取存在的首单方向，不存在返回Nothing
OrderDirect GetExistFirstOrderDirect()
  {

   if(fp.GetHandBuyCount()>=1)
     {
      return OBuy;
     }
   if(fp.GetHandSellCount()>=1)
     {
      return OSell;
     }
   return ONothing;
  }



// 加仓方向，不需要加仓 返回noting
OrderDirect GetAddOrderDirect()
  {
   if(GetExistFirstOrderDirect()==OBuy)
     {
      if(GetSignalsColor(0)==S_COLOR_BULE)
        {
         return OBuy;
        }
     }
   if(GetExistFirstOrderDirect()==OSell)
     {
      if(GetSignalsColor(0)==S_COLOR_RED)
        {
         return OSell;
        }
     }
   return ONothing;
  }

//开仓(首单 + 加仓单)
//bool OpenOrder(){
//   if(NewOpenFirstOrderDirect())
//     {
//      fp.Buy(Lots,clrRed);
//     }
//     return false;
//}

// 剩余加仓单次数
int GetRestAddOrderCount()
  {
   if(fp.FloatProfit()>0)
     {

      return 3- ap.GetHandSellCount()-ap.GetHandBuyCount();
     }
   if(fp.FloatProfit()<=0)
     {
      return 1- ap.GetHandSellCount()-ap.GetHandBuyCount();
     }
   return 0;
  }

//加仓单手数
double GetAddOrderVolume()
  {
   if(fp.FloatProfit()>0)
     {
      return 2.0*Lots;
     }
   if(fp.FloatProfit()<=0)
     {
      return 0.5*Lots;
     }
   return 0;
  }

// 是否需要平加仓单
bool NeedCloseAddOrder()
  {
   if(GetAddOrderDirect()==OBuy && GetSignalsColor(0)==S_COLOR_RED)
     {
      return true;
     }
   if(GetAddOrderDirect()==OSell && GetSignalsColor(0)==S_COLOR_BULE)
     {
      return true;
     }
   return false;
  }

//是否需要平首单
bool NeedCloseFirstOrder()
  {
   if(GetAddOrderDirect()==OBuy && GetZZCOLOR(Depth*Point,0)==ZZ_GREEN_CROSS)
     {
      return true;
     }
   if(GetAddOrderDirect()==OSell && GetZZCOLOR(Depth*Point,0)==ZZ_RED_CROSS)
     {
      return true;
     }
   return false;
  }



enum SIGNALS_COLOR
  {
   S_COLOR_NONE=0,S_COLOR_RED = 1,S_COLOR_BULE=2
  };
// 获取Signals的颜色
SIGNALS_COLOR GetSignalsColor(int shift)
  {
   if(iHighest(NULL,0,MODE_HIGH,signalsDist,0) == shift)
     {
      return S_COLOR_RED;
     }
   if(iLowest(NULL,0,MODE_LOW,signalsDist,0) == shift)
     {
      return S_COLOR_BULE;
     }
   return S_COLOR_NONE;
  }


//获取ZZ的颜色
enum ZZ_COLOR
  {
   ZZ_NO_CROSS=0,
   ZZ_RED_CROSS=1,
   ZZ_GREEN_CROSS=2
  };


enum HighOrLowState
  {
   Other = 0,
   HighHighLow = 1,
   HighLowLow = 2,
  };
enum NewHighOrLow
  {
   NotHighOrLow = 0,
   NewHigh = 1,
   NewLow = 2
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ZZ_COLOR GetZZCOLOR(double innerDepth,int maxBars)
  {
   double zz[],  hs[], ls[], hx[], lx[];

   ArrayResize(zz, maxBars);

   ArrayResize(hs, maxBars);
   ArrayResize(ls, maxBars);

   innerDepth*=Point;
   int f0=0;
   int i,j;
   double relativeHighValue = 0;// hi
   double relativeLowValue = 0;// li
   double realHighValue = 0; // hm
   double realLowValue = 0; // lm
   int realHighIndex = 0; // ai
   int realLowIndex = 0; // bi

   int realHighIndexBar = 0; // aibar
   int realLowIndexBar = 0; // bibar

   HighOrLowState highLowState = Other;
   NewHighOrLow isNewHeighestOrLowest=NotHighOrLow; // 上一次出现的是新高还是新低



   int bars = Bars;
   if(bars > maxBars)
     {
      maxBars = bars;
     }

   for(i=bars-1; i>=0; i--)
     {
      if(i>=maxBars)
        {
         // 设定初始的最高价最低价
         relativeHighValue=High[i];
         relativeLowValue=Low[i];
        }

      // 柱子 完全上升到 之前 hi 之上
      if(Low[i] > relativeHighValue)
        {
         relativeHighValue=Low[i]; // high 给重置为 low[i]
         // 如果 历史最高价 > 历史最低价加上 Depth
         if(relativeHighValue>=relativeLowValue+innerDepth)
            relativeLowValue=relativeHighValue - innerDepth; // 历史最低价置为 hi - Depth ， 也就是最低价和最高价差不能高过 Depth
        }

      if(High[i] < relativeLowValue)
        {
         relativeLowValue=High[i];
         if(relativeLowValue<=relativeHighValue-innerDepth)
            relativeHighValue=relativeLowValue + innerDepth;
        }

      // 如果 当前柱 最高价 高于 relativeHighValue （突破最高价）  最低价 低于 relativeLowValue 突破最低价 是一种包含的姿态
      if(High[i] > relativeHighValue && Low[i] < relativeLowValue) // 这个条件满足就代表即出现新高又出现新低
         if(High[i]-relativeHighValue > relativeLowValue-Low[i]) //
            highLowState=HighHighLow;
         else
            highLowState=HighLowLow; // 如果包含偏下
      else
         highLowState=Other; // 其他情况 不包含姿态

      if(isNewHeighestOrLowest==NotHighOrLow) // 如果第一运行循环，上一次新高新低还未定义, 初始化定义一下
        {
         if(High[i] >relativeHighValue)
           {
            realHighValue=High[i]; // 最高价
            realHighIndex =i; // 最高价柱数
            isNewHeighestOrLowest=NewHigh; //  f代表出现新高
           }

         if(Low[i] < relativeLowValue)
           {
            realLowValue=Low[i]; // 最低价
            realLowIndex=i; // 最低价柱数
            isNewHeighestOrLowest=NewLow;// f代表出现新低
           }
        }
      //----
      if(highLowState!=HighLowLow) // 不是向下包含
        {
         if(isNewHeighestOrLowest==NewLow && High[i] > relativeHighValue) // 上一柱出现新低 且当前柱出现新高
           {
            realHighValue=High[i]; // 最高值
            isNewHeighestOrLowest=NewHigh;  // 出现新高
            f0=0; // 循环的当前柱是否出现新低或者新高
            if(realHighIndex!=realLowIndex)  // 如果上一次新低 和这次新高不是一柱
               for(j=realHighIndex; j>=realLowIndex; j--)
                  zz[j]=High[realHighIndex]*(j - realLowIndex)/(realHighIndex - realLowIndex) + Low[realLowIndex]*(j - realHighIndex)/(realLowIndex - realHighIndex); // j-realLowIndex 是这个区间的第几柱
            realHighIndex=i; // 新高柱数重置
           }
         // 如果上一次是新高，这次出现更高值，重置新高的几个状态
         if(isNewHeighestOrLowest==NewHigh && High[i] > realHighValue)
           {
            realHighValue=High[i];  // 新高重置
            realHighIndex=i; // 新高柱数重置
            f0=0;
           }
        }
      //----
      if(highLowState!=HighHighLow) // 不是 向上偏包含
        {
         if(isNewHeighestOrLowest==NewHigh && Low[i] < relativeLowValue) // 上一次出现新低 当前新高
           {
            realLowValue=Low[i]; // 最低
            isNewHeighestOrLowest=NewLow;
            f0=0;
            if(realHighIndex!=realLowIndex)
               for(j=realLowIndex; j>=realHighIndex; j--)
                  zz[j]=High[realHighIndex]*(j - realLowIndex)/(realHighIndex - realLowIndex) + Low[realLowIndex]*(j - realHighIndex)/(realLowIndex - realHighIndex);
            realLowIndex=i;
           }
         if(isNewHeighestOrLowest==NewLow && Low[i] < realLowValue)
           {
            realLowValue=Low[i];
            realLowIndex=i;
            f0=0;
           }
        }

      if(f0==0 && i==0)  // 出现新高新低  并且是实时柱
        {
         realHighIndexBar=Bars - realHighIndex; // 最高柱数到 实时柱的距离
         realLowIndexBar=Bars - realLowIndex; // 最低柱数到 实时柱的距离
         f0=1;   // 重置为1
        }
      if(f0==1) // 如果没有出现新高 新低
        {
         realHighIndex=Bars - realHighIndexBar; // 重新计算 新高新低的位置
         realLowIndex=Bars - realLowIndexBar;
        }
      //----
      if(i==0) // 实时柱
        {
         // 画 zz 进行中的线路
         if(realHighIndex > realLowIndex)
            for(j=realHighIndex; j>=realLowIndex; j--)
               zz[j]=High[realHighIndex]*(j - realLowIndex)/(realHighIndex - realLowIndex) + Low[realLowIndex]*(j - realHighIndex)/(realLowIndex - realHighIndex);

         if(realHighIndex < realLowIndex)
            for(j=realLowIndex; j>=realHighIndex; j--)
               zz[j]=High[realHighIndex]*(j - realLowIndex)/(realHighIndex - realLowIndex) + Low[realLowIndex]*(j - realHighIndex)/(realLowIndex - realHighIndex);

         // 如果出现新高
         if(isNewHeighestOrLowest ==NewHigh && realHighIndex!=0)
            for(j=realHighIndex; j>=0; j--)
               zz[j]=Close[0]*(j - realHighIndex)/(0 - realHighIndex) + High[realHighIndex]*(j - 0)/(realHighIndex - 0);
         // 出现新低
         if(isNewHeighestOrLowest ==NewLow && realLowIndex!=0)
            for(j=realLowIndex; j>=0; j--)
               zz[j]=Close[0]*(j - realLowIndex)/(0 - realLowIndex) + Low[realLowIndex]*(j - 0)/(realLowIndex - 0);
         // 新低在当前柱
         if(realLowIndex==0 && realHighIndex!=0)
            for(j=realHighIndex; j>=0; j--)
               zz[j]=Low[0]*(j - realHighIndex)/(0 - realHighIndex) + High[realHighIndex]*(j - 0)/(realHighIndex - 0);
         // 新高在当前柱
         if(realHighIndex==0 && realLowIndex!=0)
            for(j=realLowIndex; j>=0; j--)
               zz[j]=High[0]*(j - realLowIndex)/(0 - realLowIndex) + Low[realLowIndex]*(j - 0)/(realLowIndex - 0);
        }
     }

   if(bars>=Bars)
      bars=maxBars - 1;

   for(i=1; i>0; i--)
     {
      //----
      if(zz[i-1] < zz[i] && zz[i] > zz[i+1])
        {
         if(i==1)
           {
            return ZZ_RED_CROSS;
           }
        }
      if(zz[i-1] > zz[i] && zz[i] < zz[i+1])
        {
         if(i==1)
           {
            return ZZ_GREEN_CROSS;
           }
        }
     }

   return ZZ_NO_CROSS;
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

  }
//+------------------------------------------------------------------+
