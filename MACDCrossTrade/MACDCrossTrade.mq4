// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                               MACDCrossTrade.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|  https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482"
#property version   "1.00"
#property strict

#include <Mylib\Trade\Ordermanager.mqh>

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

//+------------------------------------------------------------------+
//| expert initialization function|
//+------------------------------------------------------------------+
int OnInit()
  {
   return(INIT_SUCCEEDED);

  }


void OnDeinit(const int reason)
  {
  }


void OnTick()
  {
  }
