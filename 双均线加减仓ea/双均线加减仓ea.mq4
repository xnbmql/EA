//+------------------------------------------------------------------+
//|                                                     双均线加减仓ea.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
//ZZ
extern double Depth    =12500;
extern int    Smooth   =2194;
extern int    ForkBars  =4700;
//---- buffers
double zz[], ha[], la[], hs[], ls[], hx[], lx[];
double tmp_ha[], tmp_la[];
//---- parameters
double hi, li, hm, lm;
int    f=0, f1, f0, ai, bi, aibar, bibar;
int    wait=0;

// Stochastic Cross Alert
//---- input parameters
extern int KPeriod=9;
extern int DPeriod=4;
extern int Slowing=4;
extern int MA_Method=0; // SMA 0, EMA 1, SMMA 2, LWMA 3
extern int PriceField=0; // Low/High 0, Close/Close 1
extern int OverBoughtLevel  =96;
extern int OverSoldLevel    =14;
extern bool show_KD_cross=false;
extern bool show_K_OBOScross=true;
extern bool show_D_OBOScross=false;
double CrossUp[];
double CrossDown[];
int flagval1=0;
int flagval2=0;

input int Magic = 899491;// 开仓magic码
input double Lots = 0.1; //开仓手数
input string comment = "双指标加减仓"; //开仓备注
input int Slippage = 30; // 滑点

double addLots; //加仓单的手数
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
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
 
  }
//+------------------------------------------------------------------+

//getAddOrderVolume() 获当前加仓单的手数
double getAddOrderVolume()
  {
   if(sazzCrossColor())
     {
      if(scArrowColor())
        {
         addLots = 1.5*Lots;
        }
      else
        {
         addLots = 0.5*Lots;
        }
      if(!sazzCrossColor())
        {
         if(!scArrowColor())
           {
            addLots = 1.5*Lots;
           }
         else
           {
            addLots = 0.5*Lots;
           }
        }
     }
   return addLots;
  }
//获取sazzCrossColor() 返回StreamAmpZZ叉的颜色
int sazzCrossColor()
  {
   double cum, sum;
   int bars =Bars - IndicatorCounted(), i, j;
   if(bars > 1)
      bars=ForkBars; //镥疱痂耦怅?镱 怦屐 駈tBars 镳?赅驿铎 眍忸?徉疱
//----
   for(i=bars-1; i>=0; i--)
     {
      if(i>=ForkBars)
        {
         hi=High[i];
         li=Low[i];
        }
      if(Low [i] > hi)
        {
         hi=Low [i];
         if(hi>=li+Depth)
            li=hi - Depth;
        }
      if(High[i] < li)
        {
         li=High[i];
         if(li<=hi-Depth)
            hi=li + Depth;
        }
      //----
      if(High[i] > hi && Low[i] < li)
         if(High[i]-hi > li-Low[i])
            f1=1;
         else
            f1=2;
      else
         f1=0;
      //----
      if(f==0)
        {
         if(High[i] > hi)
           {
            hm=High[i];
            ai=i;
            f=1;
           }
         if(Low [i] < li)
           {
            lm=Low [i];
            bi=i;
            f=2;
           }
        }
      //----
      if(f1!=2)
        {
         if(f==2 && High[i] > hi)
           {
            hm=High[i];
            f=1;
            f0=0;
            if(ai!=bi)
               for(j=ai; j>=bi; j--)
                  zz[j]=High[ai]*(j - bi)/(ai - bi) + Low[bi]*(j - ai)/(bi - ai);
            ai=i;
           }
         if(f==1 && High[i] > hm)
           {
            hm=High[i];
            ai=i;
            f0=0;
           }
        }
      //----
      if(f1!=1)
        {
         if(f==1 && Low[i] < li)
           {
            lm=Low[i];
            f=2;
            f0=0;
            if(ai!=bi)
               for(j=bi; j>=ai; j--)
                  zz[j]=High[ai]*(j - bi)/(ai - bi) + Low[bi]*(j - ai)/(bi - ai);
            bi=i;
           }
         if(f==2 && Low[i] < lm)
           {
            lm=Low[i];
            bi=i;
            f0=0;
           }
        }
      //----
      if(f0==0 && i==0)
        {
         aibar=Bars - ai;
         bibar=Bars - bi;
         f0=1;
        }
      if(f0==1)
        {
         ai=Bars - aibar;
         bi=Bars - bibar;
        }
      //----
      if(i==0)
        {
         if(ai > bi)
            for(j=ai; j>=bi; j--)
               zz[j]=High[ai]*(j - bi)/(ai - bi) + Low[bi]*(j - ai)/(bi - ai);
         if(ai < bi)
            for(j=bi; j>=ai; j--)
               zz[j]=High[ai]*(j - bi)/(ai - bi) + Low[bi]*(j - ai)/(bi - ai);
         //----
         if(f ==1 && ai!=0)
            for(j=ai; j>=0; j--)
               zz[j]=Close[0]*(j - ai)/(0 - ai) + High[ai]*(j - 0)/(ai - 0);
         if(f ==2 && bi!=0)
            for(j=bi; j>=0; j--)
               zz[j]=Close[0]*(j - bi)/(0 - bi) + Low [bi]*(j - 0)/(bi - 0);
         if(bi==0 && ai!=0)
            for(j=ai; j>=0; j--)
               zz[j]=Low  [0]*(j - ai)/(0 - ai) + High[ai]*(j - 0)/(ai - 0);
         if(ai==0 && bi!=0)
            for(j=bi; j>=0; j--)
               zz[j]=High [0]*(j - bi)/(0 - bi) + Low [bi]*(j - 0)/(bi - 0);
        }
      //----
      tmp_ha[i]=hi;
      tmp_la[i]=li;
      //雁豚骅忄龛?(玎戾潆屙桢)
      if(i<=ForkBars-Smooth && Smooth > 1)
        {
         for(j=i, cum=0, sum=0; j<i+Smooth; j++)
           {
            cum+=tmp_ha[j];
            sum+=tmp_la[j];
           }
         ha[i]=cum/Smooth;
         la[i]=sum/Smooth;
        }
      else
        {
         ha[i]=tmp_ha[i];
         la[i]=tmp_la[i];
        }
     }
//---- 佯邃? 戾驿?zz ?ha/la
   for(i=bars-1; i>=0; i--)
     {
      hs[i]=(zz[i] + ha[i])/2;
      ls[i]=(zz[i] + la[i])/2;
     }
//---- 蓐耱疱祗禧
   if(bars>=Bars)
      bars=ForkBars - 1;
   for(i=bars; i>0; i--)
     {
      hx[i]=EMPTY_VALUE;
      lx[i]=EMPTY_VALUE;
     }
   if(hx[i])
     {
      return true;
     }
   if(lx[i])
     {
      return false;
     }
   return 0;
  }

//+------------------------------------------------------------------+
//|获取scArrowColor() 返回 Stochastic Cross Alert 的箭头颜色                                                               |
//+------------------------------------------------------------------+
int scArrowColor()
  {
   int limit, i, counter;
   double tmp=0;
   double fastMAnow, slowMAnow, fastMAprevious, slowMAprevious;
   double Range, AvgRange;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)
      return(-1);
   if(counted_bars > 0)
      counted_bars--;
   limit = Bars - counted_bars;
   if(counted_bars==0)
      limit-=1+9;

   for(i=1; i<=limit; i++)
     {
      counter=i;
      Range=0;
      AvgRange=0;
      for(counter=i ; counter<=i+9; counter++)
        {
         //       AvgRange=AvgRange+MathAbs(iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, PriceField, MODE_MAIN, i)-iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, PriceField, MODE_MAIN, i+1));
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
        }
      Range=AvgRange/10;
      fastMAnow=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, PriceField, MODE_MAIN, i);
      fastMAprevious=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, PriceField, MODE_MAIN, i+1);
      slowMAnow=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, PriceField, MODE_SIGNAL, i);
      slowMAprevious=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, PriceField, MODE_SIGNAL, i+1);
      CrossUp[i]=EMPTY_VALUE;
      CrossDown[i]=EMPTY_VALUE;
      if
      (((show_KD_cross)&&(fastMAnow > slowMAnow) && (fastMAprevious < slowMAprevious))||
       ((show_K_OBOScross)&&(fastMAnow > OverSoldLevel) && (fastMAprevious < OverSoldLevel))||
       ((show_D_OBOScross)&&(slowMAnow > OverSoldLevel) && (slowMAprevious < OverSoldLevel)))
        {
         if(i==1 && flagval1==0)
           {
            flagval1=1;
            flagval2=0;
           }
         CrossUp[i]=Low[i] - Range*0.5;
         //         CrossUp[i] = AvgRange;
         CrossDown[i]=EMPTY_VALUE;
        }
      else
         if
         (((show_KD_cross)&&(fastMAnow < slowMAnow) && (fastMAprevious > slowMAprevious))||
          ((show_K_OBOScross)&&(fastMAnow < OverBoughtLevel) && (fastMAprevious > OverBoughtLevel))||
          ((show_D_OBOScross)&&(slowMAnow < OverBoughtLevel) && (slowMAprevious > OverBoughtLevel)))
           {
            if(i==1 && flagval2==0)
              {
               flagval2=1;
               flagval1=0;
              }
            CrossDown[i]=High[i] + Range*0.5;
            //        CrossDown[i] = AvgRange;
            CrossUp[i]=EMPTY_VALUE;
           }
     }
   if(CrossUp[i])
     {
      return true;
     }
   if(CrossDown[i])
     {
      return false;
     }
   return 0;
  }
//+------------------------------------------------------------------+
