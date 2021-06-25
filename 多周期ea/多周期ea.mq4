//+------------------------------------------------------------------+
//|                                                        多周期ea.mq4 |
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

#include <Mylib\Trade\Ordermanager.mqh>

input double Lots = 0.1; //单量
input string comment = "遇见"; //备注
input int magic = 431655; //开仓magic码
input int Slippage = 30; //滑点
input int ma_shift = 2; //均线平移
input int ProfitPoint = 100; //移动止盈点数
input int StopPoint = 100; //移动止损点数

input int ma1_Period = 120; //均线1周期
input ENUM_MA_METHOD  ma1_Method = MODE_SMA; // ma1均线应用模式
input ENUM_APPLIED_PRICE  ma1_Price = PRICE_CLOSE; //ma1价格模式
input int ma2_Period = 50; //均线2周期
input ENUM_MA_METHOD  ma2_Method = MODE_SMA; // ma2均线应用模式
input ENUM_APPLIED_PRICE  ma2_Price = PRICE_CLOSE; //ma2价格模式
input int ma3_Period = 60; //均线3周期
input ENUM_MA_METHOD  ma3_Method = MODE_SMA; // ma3均线应用模式
input ENUM_APPLIED_PRICE  ma3_Price = PRICE_CLOSE; //ma3价格模式
input ENUM_TIMEFRAMES ma_Period = PERIOD_CURRENT; // 均线时间轴

int OrderCount = 0;
//int currentBars = 0;

OrderManager *bp;
OrderManager *sp;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   bp = new OrderManager(comment,magic,Slippage);
   sp = new OrderManager(comment,magic,Slippage);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   delete bp;
   delete sp;
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
     if(OrderCount<=1 && IsUpFourHourAndOneHourMa(0) && IsPriceUpMa(0))
       {
        bp.Buy(Lots,clrRed);
        OrderCount++;
       }
     if(OrderCount<=1 && IsUpFourHourAndOneHourMa(0) && IsPriceDownMa(0))
       {
        sp.Sell(Lots,clrRed);
        OrderCount++;
       }
  }
//+------------------------------------------------------------------+
//实时价格是否在4小时120日均线与1小时120日均线之上
bool IsUpFourHourAndOneHourMa(int shift)
  {
   double ma1_1 = iMA(Symbol(),PERIOD_H4,ma1_Period,ma_shift,ma1_Method,ma1_Price,shift);
   double ma1_2 = iMA(Symbol(),PERIOD_H1,ma1_Period,ma_shift,ma1_Method,ma1_Price,shift);
   double price = MarketInfo(Symbol(),MODE_BID);
   if(price > ma1_1 && price > ma1_2)
     {
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//实时价格是否上穿50日均线和60日均线
bool IsPriceUpMa(int shift){
   double ma2 = iMA(Symbol(),PERIOD_M5,ma2_Period,ma_shift,ma2_Method,ma2_Price,shift);
   double ma3 = iMA(Symbol(),PERIOD_M5,ma3_Period,ma_shift,ma3_Method,ma3_Price,shift);
   double price = MarketInfo(Symbol(),MODE_BID);
   if(price > ma2 && price > ma3)
     {
        return true;      
     }
     return false;
}

//实时价格是否下穿50日均线和60日均线
bool IsPriceDownMa(int shift){
   double ma2 = iMA(Symbol(),PERIOD_M5,ma2_Period,ma_shift,ma2_Method,ma2_Price,shift);
   double ma3 = iMA(Symbol(),PERIOD_M5,ma3_Period,ma_shift,ma3_Method,ma3_Price,shift);
   double price = MarketInfo(Symbol(),MODE_BID);
   if(price < ma2 && price < ma3)
     {
        return true;      
     }
     return false;
}  