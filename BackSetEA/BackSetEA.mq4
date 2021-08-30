// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                      双均线平仓ea.mq4 |
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
#include <Mylib\Trade\trade.mqh>
#include <Mylib\Trade\Ordermanager.mqh>


input int MA1_Period = 20; //快均线周期

input ENUM_MA_METHOD MA_Method = MODE_SMA; //均线模式
input ENUM_APPLIED_PRICE MA_PRICE = PRICE_CLOSE; //均线应用价格

input int OpenMagic = 210803; // 魔术码
input int Slippage = 30; // 滑点
input int InitLots = 0.01; // 初始手数
string comment ="绵羊EA";

enum ENUM_PRICE_MA_POSITION
  {
    PRICE_CROSS=0, PRICE_ABOVE = 1, PRICE_BELOW = 2
  };

OrderManager *om;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(Slippage <= (int)MarketInfo(Symbol(),MODE_SPREAD)){
    Alert("滑点设定的太小");
    return(INIT_FAILED);
   }
   om = new OrderManager(comment,OpenMagic,Slippage);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
    delete om;
  }

enum EUNM_ORDER_STATE{
  EMPTY = 0,

};

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
    // 首单
    if(om.GetHandCount() == 0){
      if(GetPriceMaPosition() == PRICE_ABOVE){
        if(om.BuyWithTicket(InitLots)==0)
          {
            Alert("开启首单多单错误：",GetLastError());
          }
      }

      if(GetPriceMaPosition() == PRICE_ABOVE){
        if(om.BuyWithTicket(InitLots)==0)
          {
            Alert("开启首单空单错误：",GetLastError());
          }
      }
    }


    // 对仓单
    if(om.GetHandCount() == 1)
    {

    }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
  }

ENUM_PRICE_MA_POSITION GetPriceMaPosition(){
   double ma_val = iMA(Symbol(), PERIOD_CURRENT, MA1_Period, 0, MA_Method, MA_PRICE, 0);
   if(Bid>ma_val){
      return PRICE_ABOVE;
   }
   if(Bid<ma_val){
     return PRICE_BELOW;
   }
   return PRICE_CROSS;
}


