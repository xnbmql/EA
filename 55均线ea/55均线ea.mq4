// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                       55均线ea.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Mylib\Trade\Ordermanager.mqh>

input string Varieties = "XTIUSD"; // 交易品种
input double Lots = 0.1; // 交易手数
input int MaxOrders = 3; // 单日最大单量
input double MaxStop = 100; // 单日最大亏损 $
input int TrackStopLoss = 600; // 跟踪止损
//input datetime CloseTime = TimeLocal(); //当日所有仓位清仓时间
input int MaPriod = 55; // 均线周期
input ENUM_MA_METHOD MaType = MODE_EMA; // 均线模式
input ENUM_APPLIED_PRICE MaPrice = PRICE_CLOSE; // 均线应用价格
input ENUM_TIMEFRAMES MaPeriod = PERIOD_M15; // 指标时间轴

datetime fisrtStart = D'16:00:00';
datetime fisrtEnd = D'17:20:00';
datetime secondStart = D'21:00:00';
datetime secondEnd = D'24:00:00';
Ordermanager om("55均线ea",199255,Lots);
double openPrice = 0.0;
double
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
delete(om);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
    // 每次都要reset一下这个固定值，不然一个ea运行多天时间判断会出错
   fisrtStart = D'16:00:00';
   fisrtEnd = D'17:20:00';
   secondStart = D'21:00:00';
   secondEnd = D'24:00:00';


  }
//+------------------------------------------------------------------+

// 均线和实时价的关系 1 实时价在均线上 2 实时价在均线下 0 实时价等于均线
enum MA_REAL_PEICE
  {
   PriceUpMa = 1, PriceDownMa = 2, PriceEqualMa = 0
  };
//+------------------------------------------------------------------+
//|  实时价和均线的关系                                              |
//+------------------------------------------------------------------+
MA_REAL_PEICE PriceWithMa()
  {

   double ma = iMA(Varieties,0,MaPriod,0,MaType,MaPrice,0);
   double price = MarketInfo(Varieties,MODE_BID);
   if(price < ma)
     {
      return PriceDownMa;
     }
   else
      if(price > ma)
        {
         return PriceUpMa;
        }
      else
        {
         return PriceEqualMa;
        }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|  开单函数                                                        |
//+------------------------------------------------------------------+
void OpenOrder()
  {
   if(PriceWithMa() == PriceUpMa)
     {
      //做多
      //if(MaxOrders>3)
      //  {
      //   return;
      //  }
      OP.Buy(Lots,clrRed);
     }
   if(PriceWithMa() == PriceDownMa)
     {
      //做空
      OP.Sell(Lots,clrLime);
     }
  }
//+------------------------------------------------------------------+
