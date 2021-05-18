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

#include <Mylib\Panels\sub\ValueBox.mqh>
#include <Mylib\Panels\ManagerPanel.mqh>

ValueBox op;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

input int Magic = 899491;// 开仓magic码
input double Lots = 0.1; //开仓手数
input string comment = "双指标加减仓"; //开仓备注
input int Slippage = 30; // 滑点

int signalsDist = 24;

extern double Depth    =12500;
extern int    Smooth   =1;
extern int    maxBars  =4700;
double zz[], ha[], la[], hs[], ls[], hx[], lx[];
double tmp_ha[], tmp_la[];
//---- parameters
double hi, li, hm, lm;
double relativeHighValue = 0;// hi
double relativeLowValue = 0;// li
double realHighValue = 0; // hm
double realLowValue = 0; // lm

enum NewHighOrLow {
   NotHighOrLow = 0,
   NewHigh = 1,
   NewLow = 2
};

enum HighOrLowState {
  Other = 0,
  HighHighLow = 1,
  HighLowLow = 2,
};

enum CrossColor
  {
   RedCrross = 1, GreenCross = 2, OtherColor = 0
  };

HighOrLowState highLowState = Other;
NewHighOrLow isNewHeighestOrLowest=NotHighOrLow; // 上一次出现的是新高还是新低

// int f1;
int f0, ai, bi, aibar, bibar;
int realHighIndex = 0; // ai
int realLowIndex = 0; // bi

int realHighIndexBar = 0; // aibar
int realLowIndexBar = 0; // bibar

int    wait=0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

   Depth*=Point;  // 将depth 转换为价格
   ArrayResize(tmp_ha, maxBars);
   ArrayResize(tmp_la, maxBars);
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
   op.Destroy();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  }
//+------------------------------------------------------------------+

enum SIGNALS_COLOR {
  S_COLOR_NONE=0,S_COLOR_RED = 1,S_COLOR_BULE=2
};
// 获取Signals的颜色
SIGNALS_COLOR GetSignalsColor(int shift){
      if (iHighest(NULL,0,MODE_HIGH,signalsDist,0) == shift){
        return S_COLOR_RED;
      }
      if (iLowest(NULL,0,MODE_LOW,signalsDist,0) == shift){
        return S_COLOR_BULE;
      }
      return S_COLOR_NONE;
}

//zz指标
int zzIndication(){
   int bars =Bars;
   int i, j;
   if(bars > 1)
      bars=maxBars;
//----
   for(i=bars-1; i>=0; i--)
     {
      if(i>=maxBars)
        {
        // 设定初始的最高价最低价
         relativeHighValue=iHigh(Symbol(),0,i);
         relativeLowValue=iLow(Symbol(),0,i);
        }
       // 柱子 完全上升到 之前 hi 之上
      if(iLow(Symbol(),0,i) > relativeHighValue)
        {
         relativeHighValue=iLow(Symbol(),0,i); // high 给重置为 low[i]
         // 如果 历史最高价 > 历史最低价加上 Depth
         if(relativeHighValue>=relativeLowValue+Depth)
            relativeLowValue=relativeHighValue - Depth; // 历史最低价置为 hi - Depth ， 也就是最低价和最高价差不能高过 Depth
        }
      if(iHigh(Symbol(),0,i) < relativeLowValue)
        {
         relativeLowValue=iHigh(Symbol(),0,i);
         if(relativeLowValue<=relativeHighValue-Depth)
            relativeHighValue=relativeLowValue + Depth;
        }
      // 如果 当前柱 最高价 高于 relativeHighValue （突破最高价）  最低价 低于 relativeLowValue 突破最低价 是一种包含的姿态
      if(iHigh(Symbol(),0,i) > relativeHighValue && iLow(Symbol(),0,i) < relativeLowValue) // 这个条件满足就代表即出现新高又出现新低
         if(iHigh(Symbol(),0,i)-relativeHighValue > relativeLowValue-iLow(Symbol(),0,i)) //
            highLowState=HighHighLow;
         else
            highLowState=HighLowLow; // 如果包含偏下
      else
         highLowState=Other; // 其他情况 不包含姿态

      if(isNewHeighestOrLowest==NotHighOrLow) // 如果第一运行循环，上一次新高新低还未定义, 初始化定义一下
      {
         if(iHigh(Symbol(),0,i) >relativeHighValue)
           {
            realHighValue=iHigh(Symbol(),0,i); // 最高价
            realHighIndex =i; // 最高价柱数
            isNewHeighestOrLowest=NewHigh; //  f代表出现新高
           }

         if(iLow(Symbol(),0,i) < relativeLowValue)
           {
            realLowValue=iLow(Symbol(),0,i); // 最低价
            realLowIndex=i; // 最低价柱数
            isNewHeighestOrLowest=NewLow;// f代表出现新低
           }
        }
      //----
      if(highLowState!=HighLowLow) // 不是向下包含
        {
         if(isNewHeighestOrLowest==NewLow && iHigh(Symbol(),0,i) > relativeHighValue) // 上一柱出现新低 且当前柱出现新高
           {
            realHighValue=iHigh(Symbol(),0,i); // 最高值
            isNewHeighestOrLowest=NewHigh;  // 出现新高
            f0=0; // 循环的当前柱是否出现新低或者新高
            if(realHighIndex!=realLowIndex)  // 如果上一次新低 和这次新高不是一柱
              for(j=realHighIndex; j>=realLowIndex; j--)
                  zz[j]=High[realHighIndex]*(j - realLowIndex)/(realHighIndex - realLowIndex) + Low[realLowIndex]*(j - realHighIndex)/(realLowIndex - realHighIndex); // j-realLowIndex 是这个区间的第几柱
            realHighIndex=i; // 新高柱数重置
           }
           // 如果上一次是新高，这次出现更高值，重置新高的几个状态
         if(isNewHeighestOrLowest==NewHigh && iHigh(Symbol(),0,i) > realHighValue)
           {
            realHighValue=iHigh(Symbol(),0,i);  // 新高重置
            realHighIndex=i; // 新高柱数重置
            f0=0;
           }
        }
      //----
      if(highLowState!=HighHighLow) // 不是 向上偏包含
        {
         if(isNewHeighestOrLowest==NewHigh && iLow(Symbol(),0,i) < relativeLowValue) // 上一次出现新低 当前新高
           {
            realLowValue=iLow(Symbol(),0,i); // 最低
            isNewHeighestOrLowest=NewLow;
            f0=0;
            if(realHighIndex!=realLowIndex)
               for(j=realLowIndex; j>=realHighIndex; j--)
                  zz[j]=High[realHighIndex]*(j - realLowIndex)/(realHighIndex - realLowIndex) + Low[realLowIndex]*(j - realHighIndex)/(realLowIndex - realHighIndex);
            realLowIndex=i;
           }
         if(isNewHeighestOrLowest==NewLow && iLow(Symbol(),0,i) < realLowValue)
           {
            realLowValue=iLow(Symbol(),0,i);
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
   for(i=bars-1; i>=0; i--)
     {
      hs[i]=(zz[i] + ha[i])/2;
      ls[i]=(zz[i] + la[i])/2;
     }
   if(bars>=Bars)
      bars=maxBars - 1;
   for(i=bars; i>0; i--)
     {
      hx[i]=EMPTY_VALUE;
      lx[i]=EMPTY_VALUE;
      //----
      if(zz[i-1] < zz[i] && zz[i] > zz[i+1])
        {
          // 只看最近三柱的情况
          // return redCross;
         hx[i]=zz[i];
         return RedCrross;
        }
      if(zz[i-1] > zz[i] && zz[i] < zz[i+1])
        {
         lx[i]=zz[i];
         return GreenCross;
        }
     }
   // end
   return OtherColor;
}

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   op.OnEvent(id,lparam,dparam,sparam);
  }