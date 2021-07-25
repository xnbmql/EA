// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                   亨利投资ea.mq4 |
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

input int MA_Period = 20; // 均线周期
input ENUM_MA_METHOD MA_Method = MODE_SMA; // 均线类型
input ENUM_APPLIED_PRICE MA_Price = PRICE_CLOSE; // 均线价格类型


Ordermanager *om;

int OnInit()
  {
   om = new OrderManager(comment,Magic,Slippage);
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
   om.Update();
   ENUM_POSITION breakPosition = PriceMaPosition(0);
   // ------------------------------------------------------------------------------------------
   // 平仓逻辑
   if(breakPosition == ENUM_POSITION_UP || breakPosition == ENUM_POSITION_DOWN)
   {
     if(om.GetNetProfit() > ProfitMoney){
        if(!om.CloseAllOrders()){
          Alert("平所有错误：", GetLastError());
        }
     }else{
       if(!om.CloseProfitOrders()){
        Alert("平盈利错误：", GetLastError());
       }
     }
   }


   // ------------------------------------------------------------------------------------------
   // 开仓逻辑
   if( breakPosition == ENUM_POSITION_UP && PriceBreakPosition() == ENUM_POSITION_UP)
     {
      double buylots = Lots*(upBreakTimes);
   // ------------------------------------------------------------------------------------------
   // 加仓逻辑
      if(om.GetHandSellCount()>0)
        {
          buylots = 0.02;
        }
      if(om.GetHandSellCount()>0&&om.GetHandBuyCount() > 0)
        {
          buylots = 0.03;
        }
   // ------------------------------------------------------------------------------------------
      int ticket = om.BuyWithTicket(buylots);
      if(ticket <= 0)
        {
          Alert("开多单错误，错误代码：", GetLastError());
        }
     }

   if(breakPosition == ENUM_POSITION_DOWN && PriceBreakPosition() == ENUM_POSITION_DOWN)
     {
      double sellLots = Lots*(downBreakTimes);

   // ------------------------------------------------------------------------------------------
   // 加仓逻辑
      if(om.GetHandBuyCount()>0)
        {
          sellLots = 0.02;
        }
      if(om.GetHandSellCount()>0&&om.GetHandBuyCount() > 0)
        {
          sellLots  = 0.03;
        }
   // ------------------------------------------------------------------------------------------
      int ticket = om.SellWithTicket(sellLots);
      if(ticket <= 0)
        {
          Alert("开空单错误，错误代码：", GetLastError());
        }
     }


  }
//+------------------------------------------------------------------+

enum ENUM_POSITION {
  ENUM_POSITION_UP = 0,
  ENUM_POSITION_DOWN = 1,
  ENUM_POSITION_MID = 2
};

ENUM_POSITION PriceMaPosition(int shift)
  {
    double price = Close[shift];
    double ma = iMA(Symbol(),0,MA_Period,0,MA_Method,MA_Price,shift);
    if(price > ma){
      return ENUM_POSITION_UP;
    }
    if(price < ma){
      return ENUM_POSITION_DOWN;
    }
    return ENUM_POSITION_MID;
  }


double UpBreakPriceLimit = 0;
double DownBreakPriceLimit = 0;
int upBreakTimes = 0;
int downBreakTimes = 0;

void resetBreakArgs()
  {
    UpBreakPriceLimit = 0;
    DownBreakPriceLimit = 0;
    upBreakTimes = 0;
    downBreakTimes = 0;
  }

ENUM_POSITION PriceBreakPosition(){
  if(UpBreakPriceLimit == 0)
    {
      UpBreakPriceLimit = Close[1];
    }

  if(DownBreakPriceLimit == 0)
    {
      DownBreakPriceLimit = Close[1];
    }

  if(Close[0]+BreakPoint*Point > UpBreakPriceLimit)
    {
      upBreakTimes +=1;
      UpBreakPriceLimit = Close[0]+BreakPoint;
      return ENUM_POSITION_UP;
    }

  if(Close[0]-BreakPoint*Point < DownBreakPriceLimit)
    {
      downBreakTimes +=1;
      DownBreakPriceLimit = Close[0]-BreakPoint;
      return ENUM_POSITION_DOWN;
    }

  return ENUM_POSITION_MID;

}
