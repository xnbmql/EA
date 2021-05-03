//+------------------------------------------------------------------+
//|                                                       混沌ea附件.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <Mylib\Trade\Ordermanager.mqh>

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input string comment = "混沌ea附件"; //开仓备注
input int Magic = 199005; // 开仓magic码
input int Slippage = 30; // 滑点
input double lots = 0.01; //开单手数
input double OpenBuyLine = 100.0; //开多单的数值线
input double OpenSellLine = 100.0; //开空单的数值线

int bars = 0;

OrderManager np(comment,Magic,Slippage);

//+------------------------------------------------------------------+
//|                                                                  |
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

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(!IsTradeAllowed())
     {
      Alert("自动交易设置存在异常,   请检查!  ");
      return;
     }
   if(Bars ==0)
     {
      return;
     }

   if(bars != Bars)
     {
      RealPriceWithOpenBuyOrSellLine();
      bars = Bars;
     }
  }
//+------------------------------------------------------------------+
//开多空单的数值线与收盘价格线的关系
void RealPriceWithOpenBuyOrSellLine()
  {

   if(OpenBuyLine < Close[1])
     {
      np.Buy(lots,clrRed);
     }
   if(OpenSellLine > Close[1])
     {
      np.Sell(lots,clrLime);
     }
  }

////开空单的数值线与收盘价格线的关系
//void RealPriceWithOpenSellLine(){
//   if(OpenSellLine > Close[1])
//     {
//      np.Sell(lots,clrLime);
//     }
//}

