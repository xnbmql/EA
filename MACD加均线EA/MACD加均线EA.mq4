//+------------------------------------------------------------------+
//|                                                    MACD加均线EA.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#property  indicator_buffers 4
#property  indicator_color1   Red
#property  indicator_color2   Lime
#property  indicator_color3   Aqua
#property  indicator_color4   Magenta

#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 1
#property indicator_width4 1

#property indicator_level1  0
#property indicator_levelcolor Silver

//---- indicator parameters
input bool message = true; //是否显示信息框
input double Lots = 0.1; //单量
input string comment = ""; //备注
input int magic = 15430; //开仓magic码
input string comm1X="----------------------------";
input string comm2X="----------------------------";
enum AlertLocation
  {
   实时出现信号判断=0,收盘出现信号判断=1
  };
input bool macdSwitch = false; //macd开关
input AlertLocation maLocation = 收盘出现信号判断; //均线报警信号位置
input int md1=12; //macd1周期
input int md2=26; //macd2周期
input int md3=9; //macd3周期
input int ma1_Period = 5; //均线1周期
input int ma1_shift=0; // 均线1平移
input ENUM_MA_METHOD  ma1_Method = MODE_SMA; // ma1均线应用模式
input ENUM_APPLIED_PRICE  ma1_Price = PRICE_CLOSE; //ma1价格模式
input int ma2_Period = 20; //均线2周期
input int ma2_shift=0; // 均线2平移
input ENUM_MA_METHOD  ma2_Method = MODE_SMA; // ma2均线应用模式
input ENUM_APPLIED_PRICE  ma2_Price = PRICE_CLOSE; //ma2价格模式
input int ma3_Period = 40; //均线3周期
input int ma3_shift=0; // 均线3平移
input ENUM_MA_METHOD  ma3_Method = MODE_SMA; // ma3均线应用模式
input ENUM_APPLIED_PRICE  ma3_Price = PRICE_CLOSE; //ma3价格模式
input ENUM_TIMEFRAMES ma_Period = PERIOD_CURRENT; // 均线时间轴

input double buyProfit = 50; // 多单止盈
input double buyStop = 50; //多单止损
input double sellProfit = 50; //空单止盈
input double sellStop = 200; //空单止损

//---- indicator buffers
double UpBuffer[];
double DownBuffer[];
double ZeroBuffer[];
double SigMABuffer[];



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
  IndicatorBuffers(4);
  SetIndexStyle(0,DRAW_HISTOGRAM);
  SetIndexStyle(1,DRAW_HISTOGRAM);
  SetIndexStyle(2,DRAW_HISTOGRAM);
  SetIndexStyle(3,DRAW_LINE);
  
  SetIndexBuffer(0,UpBuffer);
  SetIndexBuffer(1,DownBuffer);
  SetIndexBuffer(2,ZeroBuffer);
  SetIndexBuffer(3,SigMABuffer);
  
  SetIndexDrawBegin(0,0);
  
  IndicatorShortName("MACD ("+md1+", "+md2+", "+md3+") ");
  
  IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+2);
  
  SetIndexLabel(0,"UpBuffer");
  SetIndexLabel(1,"DownBuffer");
  SetIndexLabel(2,"ZeroBuffer");
  SetIndexLabel(3,"SigMABuffer");
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
   double myMACDmain,myMACDsignal;
   int limit, i;
   
   int countedBars = IndicatorCounted();
//---- check for possible errors
   if(countedBars<0) 
      return;
//---- last counted bar will be recounted
   if(countedBars>0) countedBars--;
   limit = Bars-countedBars;
    
//---- main loop
   for(i=0; i<limit; i++)
   {
      myMACDmain=iMACD(NULL,0,md1,md2,md3,PRICE_CLOSE,MODE_MAIN,i);
      myMACDsignal=iMACD(NULL,0,md1,md2,md3,PRICE_CLOSE,MODE_SIGNAL,i);
      
      SigMABuffer[i]=myMACDsignal;
      
      if((myMACDmain > 0)&&(myMACDmain > myMACDsignal))
         {
          UpBuffer[i] = myMACDmain;
         }
      else 
         {
          if ((myMACDmain < 0)&&(myMACDmain < myMACDsignal))
             {
              DownBuffer[i] = myMACDmain;
             }
          else
             {
              ZeroBuffer[i] = myMACDmain;
             }
         }
   }
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
