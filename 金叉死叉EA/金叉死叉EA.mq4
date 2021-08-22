//+------------------------------------------------------------------+
//|                                                   MyEA金叉死叉开单.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Mylib\Trade\Ordermanager.mqh>


//外部变量
//均线的参数设置
input int MA1_Period = 15; //均线一周期
input int MA2_Period = 30; //均线二周期
input ENUM_TIMEFRAMES MA1_Time = PERIOD_CURRENT; //均线一时间周期
input ENUM_TIMEFRAMES MA2_Time = PERIOD_CURRENT; //均线二时间周期
input ENUM_MA_METHOD MA_Method = MODE_SMA; //均线模式
input ENUM_APPLIED_PRICE MA_price = PRICE_CLOSE; //均线应用价格

//交易的参数设置
input double OpenLots = 0.1; // 开仓手数
input int OpenMagic = 788733; //开仓magic
input string OpenComment = "金死叉"; //开仓备注信息
input int Slippage = 10; // 滑点


OrderManager mp(OpenComment,OpenMagic,Slippage);

enum IsOpen
  {
   开启 = 0, 关闭 = 1
  };
input IsOpen 是否开启金叉 = 开启;
input IsOpen 是否开启死叉 = 开启;


int buyorder = 0;
int sellorder = 0;
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
//平仓
   if(buyorder>0 && OpenTypes()==DEATH_CROSS)
     {
      if(!mp.CloseAllBuyOrders())
        {
         Print("close buy error: ",GetLastError());
        }
      buyorder--;
     }
   if(sellorder>0 && OpenTypes()==GOLDEN_CROSS)
     {
      if(!mp.CloseAllSellOrders())
        {
         Print("close sell error: ",GetLastError());
        }
      sellorder--;
     }

//开仓
   if(是否开启金叉==开启 && OpenTypes()==GOLDEN_CROSS && buyorder==0)
     {
      if(!mp.Buy(OpenLots,clrRed))
        {
         Print("open buy error: ",GetLastError());
        }
      buyorder++;
     }
   if(是否开启死叉==开启 && OpenTypes()==DEATH_CROSS && sellorder==0)
     {
      if(!mp.Sell(OpenLots,clrLime))
        {
         Print("open sell error: ",GetLastError());
        }
      sellorder++;
     }

  }
//+------------------------------------------------------------------+

enum CROSSTYPE
  {
   GOLDEN_CROSS = 0, DEATH_CROSS = 1, NO_CROSS = 2
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CROSSTYPE OpenTypes()
  {
   double MA1_2 = iMA(Symbol(),MA1_Time, MA1_Period,0, MA_Method, MA_price, 2);
   double MA2_2 = iMA(Symbol(),MA2_Time, MA2_Period, 0, MA_Method, MA_price, 2);

   double MA1_1 = iMA(Symbol(),MA1_Time, MA1_Period, 0, MA_Method, MA_price, 1);
   double MA2_1 = iMA(Symbol(),MA2_Time, MA2_Period, 0, MA_Method, MA_price, 1);

   if(MA1_2 < MA2_2 && MA1_1 > MA2_1)
     {
      return GOLDEN_CROSS;
     }
   if(MA1_2 > MA2_2 && MA1_1 < MA2_1)
     {
      return DEATH_CROSS;
     }
   return NO_CROSS;
  }
//+------------------------------------------------------------------+
