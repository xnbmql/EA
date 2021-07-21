// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                       55均线ea.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "992249804"
#property version   "1.00"
#property strict

#include <Mylib\Trade\Ordermanager.mqh>
#include <Mylib\Trade\trade.mqh>

input double Lots = 0.1; // 交易手数
//input double MaxStop = 100; // 单日最大亏损 $
//input int TrackStopLoss = 600; // 跟踪止损
//input int MaxProfits = 800; // 单日盈利
input int Slippage = 30; // 滑点

input int MaPriod = 55; // 均线周期
input ENUM_MA_METHOD MaType = MODE_EMA; // 均线模式
input ENUM_APPLIED_PRICE MaPrice = PRICE_CLOSE; // 均线应用价格
input ENUM_TIMEFRAMES MaPeriod = PERIOD_M15; // 指标时间轴

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderManager om("55均线ea",521000,Lots);
double openPrice = 0.0;
OrderManager OP("55均线ea",521000,Slippage);
//int MaxOrdersCount = 0; // 单日最大单量
double openBid = 0.0;
int bars;
int pairOpenBars = 0;
int currentDay = 0;
//bool IsOpenCurrentDay = true; // 当天是否还要开仓（默认开）
int direct = 0;
OrderInfo *oi;
int openBars = 0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
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
//Print(om.SoildProfit());
   if(!IsTradeAllowed())
     {
      Alert("自动交易设置存在异常,   请检查!  ");
      return;
     }
   if(Bars == 0)
     {
      return;
     }

// 开仓
//   if(openBid>0)
//     {
//
//      Print("update:",openBid);
//      OP.Update();
//      oi.Update();
//      if(oi.GetState() == CLOSED)
//        {
//         openBid = 0;
//        }
//     }



   if(openBid ==0&&openBars!=Bars)
     {
      if(OpenOrder()){
        
         Print("开单成功",openBid);
         openBid = Bid;
         
         openBars= Bars;
        }
     }
//if(OP.SoildProfit())
//  {
//   return;
//  }

   if(openBid >0)
     {
      if(direct==OP_BUY&&PriceWithMa()==PriceDownMa)
        {
         OP.CloseAllOrders();
         openBid = 0;
         delete(oi);
        }
      else
         if(direct==OP_SELL&&PriceWithMa()==PriceUpMa)
           {
            OP.CloseAllOrders();
            openBid = 0;
            delete(oi);
           }
     }


//   if(PriceWithMa()==PriceUpMa)
//     {
//      OP.Buy(Lots,clrRed);
//     }
//
//   if(PriceWithMa()==PriceDownMa)
//     {
//      OP.Sell(Lots,clrLime);
//     }


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
   double ma = iMA(Symbol(),0,MaPriod,0,MaType,MaPrice,0);
   double price = MarketInfo(Symbol(),MODE_BID);
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
//|  开单函数                                                        |
//+------------------------------------------------------------------+
bool OpenOrder()
  {
// todo: 这里才是跟踪止损的地方
   int ticket;
   if(PriceWithMa() == PriceUpMa)
     {
      direct = OP_BUY;
      //做多
      ticket = OP.Buy(Lots,clrRed);
     }

   if(PriceWithMa() == PriceDownMa)
     {
      direct = OP_SELL;
      //做空
      ticket = OP.Sell(Lots,clrLime);
     }
   if(ticket > 0)
     {
      oi = new OrderInfo(ticket);
      return true;
     }
   else
     {
      Alert("open order occurr error, code is : ",GetLastError());
     }
   return false;
  }

//单日最大亏损（总亏损是否达到100$）

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//bool MaxStopDay(double MaxStop)
//  {
//
//   OP.Update();
//   if(OP.SoildProfit() < -100)
//     {
//      IsTradeAllowed()==false;
//     }
//   return false;
//  }
//+------------------------------------------------------------------+
// 开单价和实时价是否达到200点
//bool IsEnoughPoint()
//  {
//   if(openBid >= Bid+200*Point || openBid <= Bid-200*Point)
//     {
//      return true;
//     }
//   return false;
//  }
//+------------------------------------------------------------------+
