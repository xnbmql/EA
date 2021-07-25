//+------------------------------------------------------------------+
//|                                                       亨利投资ea.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|  https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482 |
//+------------------------------------------------------------------+
#property copyright "https://item.taobao.com/item.htm?spm=a230r.1.14.6.5b876b15pPfxRb&id=651269419591&ns=1&abbucket=12#detail"
#property link      "19956480259"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Mylib\Trade\Ordermanager.mqh>


input int Magic = 311622; //开仓magic码
input string comment = "亨利投资"; //开仓备注
input int Slippage = 10; //滑点
input double Lots = 0.01; // 手数
input int BreakPoint = 50; // K线突破的点数
input double ProfitMoney = 20; // 盈利金额
input int TrailingStop = 200; // 移动止损



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
  }
//+------------------------------------------------------------------+
