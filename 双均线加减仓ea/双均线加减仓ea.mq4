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
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

input int Magic = 899491;// 开仓magic码
input double Lots = 0.1; //开仓手数
input string comment = "双指标加减仓"; //开仓备注
input int Slippage = 30; // 滑点

int signalsDist = 24;
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
