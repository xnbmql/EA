// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                       混沌交易ea.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "992249804"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input int jaw_period = 13; // 下颌周期
input int jaw_shift = 8; // 下颌平移
input int teeth_period = 8; // 牙齿周期
input int teeth_shift = 5; // 牙齿位移
input int lips_period = 5;  // 嘴唇周期
input int lips_shift = 3; // 嘴唇位移
input ENUM_MA_METHOD ma_method = MODE_SMMA; // 均线类型
input ENUM_APPLIED_PRICE  applied_price = PRICE_MEDIAN; // 平均价格类型
#include <Mylib\Trade\trade.mqh>
#include <Mylib\Trade\OrderManager.mqh>
#include <Arrays\List.mqh>


input double 手数 = 0.01;
input string 开仓备注 = "zhongtianren";
input int 开仓magic码 = 199005;
input int Slippage = 30; //滑点
input bool DisableEAStatus = true; //默认禁用
input double 点差距离 = 300;
input int pairOrderLimit = 4; // 对冲单最大组数
OrderManager *nm; // 普通订单管理者
OrderManager *pm; // 对冲单管理者
int pairOrderCount = 0; // 对冲单计数器

double currentPairHighestPrice = 0.0; //当前对冲单最高价
double currentPairLowestPrice = 0.0; //当前对冲单最低价


enum ENUM_GAT_POSITION
  {
   CROSS_JAW = 0,
   CROSS_TEETH = 1,
   CROSS_LIPS= 2,
   OVER_JAW = 3,
   OVER_TEETH = 4,
   OVER_LIPS = 5,
   BELOW_JAW = 6,
   BELOW_TEETH = 7,
   BELOW_LIPS = 8,
   UNKNOW_GAT_POSITION = 9
  };
int currentBars = 0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   nm = new OrderManager(开仓备注,开仓magic码,Slippage);
   pm = new OrderManager(开仓备注,开仓magic码,Slippage);
   return(INIT_SUCCEEDED);
  }



//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   delete nm;
   delete pm;
  }
int OpenBar = 0;
int CloseBar =0;
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
   if(currentBars != Bars)
     {
      // 当前状态与前一柱鳄鱼唇线的关系 以及是否满足点差要求 满足开对冲 并将对冲组数加1
      ENUM_POSITION lp = GetPoisitionWithLipsPosition(1);
      if(lp==CROSS && pointDiffEnough())
        {
         pairOrderCount++;
         setHighestAndLowestPrice();
         if(pairOrderCount==4) // 对冲组数满足4组 将盈利单平仓
           {
            if(!pm.ClosePorfitOrders())
              {
               Alert("close pair order error code: ",GetLastError());
              }
            if(!nm.ClosePorfitOrders())
              {
               Alert("close nomral order error code: ",GetLastError());
              }
           }
         if(!pm.Buy(手数)||!pm.Sell(手数))
           {
            Alert("open pair order error code: ",GetLastError());
           }
         currentBars = Bars;
        }
      // 当前柱子完全在唇线上或唇线下 开多单空单
      if(lp == OVER)
        {
         if(!nm.Buy(手数))
           {
            Alert("open buy order error code: ",GetLastError());
            currentBars = Bars;
           }
        }
      if(lp == BELOW)
        {
         if(!nm.Sell(手数))
           {
            Alert("open sell order error code: ",GetLastError());
            currentBars = Bars;
           }
        }
     }


  }
// 判断点差距离是否满足要求
bool pointDiffEnough()
  {
   double maxPd = pointDiff(currentPairHighestPrice,Bid);
   double minPd = pointDiff(currentPairLowestPrice,Bid);

   if(minPd >= 点差距离||maxPd <= -点差距离)
     {
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int pointDiff(double price1,double price2)
  {
   double spread = (price1 - price2)/Point;
   return (int)spread;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//对冲单初次和每到第四次的时候 要将价格置为当前实时价
void setHighestAndLowestPrice()
  {
   if(pairOrderCount==4||pairOrderCount==0)
     {
      currentPairHighestPrice = Bid;
      currentPairLowestPrice = Bid;
      return;
     }
   if(Bid > currentPairHighestPrice)
     {
      currentPairHighestPrice = Bid;
     }
   if(Bid < currentPairLowestPrice)
     {
      currentPairLowestPrice = Bid;
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
enum ENUM_POSITION
  {
   OVER =0,
   CROSS = 1,
   BELOW = 2
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
// 获取柱子的状态  是否位于唇线上或者唇线下
ENUM_POSITION GetPoisition(double areaStart, double areaEnd, double val)
  {
   double high = areaStart>areaEnd?areaStart:areaEnd;
   double low = areaStart>areaEnd?areaEnd:areaStart;
   if(val > high)
     {
      return OVER;
     }
   else
      if(val < low)
        {
         return BELOW;
        }

   return CROSS;

  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
// 获取当前位置和鳄鱼唇线的位置
ENUM_POSITION GetPoisitionWithLipsPosition(int shift)
  {
   double lips = iAlligator(Symbol(), PERIOD_CURRENT, jaw_period, jaw_shift, teeth_period, teeth_shift, lips_period, lips_shift, ma_method, applied_price, MODE_GATORLIPS, shift);
   return GetPoisition(Close[shift],Open[shift],lips);
  }

//+------------------------------------------------------------------+
