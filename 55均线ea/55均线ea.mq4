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
#include <Mylib\Trade\trade.mqh>

input double Lots = 0.1; // 交易手数
//input int MaxOrdersCount = 3; // 单日最大单量
input double MaxStop = 100; // 单日最大亏损 $
input int TrackStopLoss = 600; // 跟踪止损
input int Slippage = 30; // 滑点

input int MaPriod = 55; // 均线周期
input ENUM_MA_METHOD MaType = MODE_EMA; // 均线模式
input ENUM_APPLIED_PRICE MaPrice = PRICE_CLOSE; // 均线应用价格
input ENUM_TIMEFRAMES MaPeriod = PERIOD_M15; // 指标时间轴

input datetime firstStart = D'06:00:00';//第一次开始时间
input datetime firstEnd = D'12:20:00';//第一次结束时间
input datetime secondStart = D'20:00:00';//第二次开始时间
input datetime secondEnd = D'24:00:00';//第二次结束时间
input datetime closeAllOrdersTimePoint = D'2:00:00';
OrderManager om("55均线ea",521000,Lots);
double openPrice = 0.0;
OrderManager OP("55均线ea",521000,Slippage);
int MaxOrdersCount = 0; // 单日最大单量
double openBid = 0.0;
int pairOpenBars = 0;
int currentDay = 0;
bool IsOpenCurrentDay = true; // 当天是否还要开仓（默认开）
int direct = 0;
OrderInfo *oi;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   datetime t = TimeLocal();
   MqlDateTime mqldate;
   TimeToStruct(t,mqldate);
   // MqlDateTime closeAllOrdersTimePointS;
   //
   // TimeToStruct(closeAllOrdersTimePoint,closeAllOrdersTimePointS);
   closeAllOrdersTimePoint = StringToTime(StringFormat("%4d.%02d.%02d %02d:%02d",mqldate.year,mqldate.mon,mqldate.day+1,2,0));
   currentDay = getDay();
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

   if(openBid>0)
     {

      Print("update:",openBid);
      OP.Update();
      oi.Update();
      if(oi.GetState() == CLOSED)
        {
         openBid = 0;
        }
     }

   if(openBid ==0 && IsOpenCurrentDay)
     {
      Print("MaxOrdersCount: ",MaxOrdersCount);
      if(OpenOrderTime())
        {
         Print("OpenOrderTime: ",OpenOrderTime()," openBid: ",openBid);
         if(OpenOrder())
           {
            Print("开单成功");
            openBid = Bid;
            MaxOrdersCount++;
           }
        }
     }
   if(OP.SoildProfit()>800*Point || MaxOrdersCount>3||OP.SoildProfit() < -100)
     {
      IsOpenCurrentDay==false;
      return;
     }
// 当日不再开仓
//OP.Update();
//if(OP.SoildProfit()>800*Point || MaxOrdersCount>3||OP.SoildProfit() < -100)
//  {
//   IsOpenCurrentDay==false;
//  }

// 平仓
//Print("NeedCloseOrder:",NeedCloseOrder()," direct: ",direct," PriceWithMa: ",PriceWithMa(), " IsEnoughPoint: ",IsEnoughPoint());
   if(openBid >0&&(NeedCloseOrder() || (direct==OP_BUY&&PriceWithMa()==PriceDownMa)|| (direct==OP_SELL&&PriceWithMa()==PriceUpMa)|| IsEnoughPoint()))
     {
      OP.CloseAllOrders();
      openBid = 0;
      delete(oi);
     }

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
// todo: 这个 Varieties这么用吗,不是说可以去了吗,再这么用不是傻逼吗
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
      ticket = OP.BuyWithStAndTp(Lots,TrackStopLoss);
     }

   if(PriceWithMa() == PriceDownMa)
     {
      direct = OP_SELL;
      //做空
      ticket = OP.SellWithStAndTp(Lots,TrackStopLoss);
     }
   if(ticket > 0)
     {
      oi = new OrderInfo(ticket,true,TrackStopLoss);
      return true;
     }
   else
     {
      Alert("open order occurr error, code is : ",GetLastError());
     }
   return false;
  }
//+------------------------------------------------------------------+
// 做单时间段模块
bool OpenOrderTime()
  {
   datetime time = TimeLocal();
   // string time1 = TimeToString(TimeLocal());
   // datetime time = StringToTime(time1);

//Print("time------------",time);
   Print("firstStart: " ,firstStart," firstEnd: ",firstEnd," secondStart: ",secondStart," secondEnd: ",secondEnd," time: ",time," timecurrent: ",TimeCurrent());
   if((time>=firstStart && time<=firstEnd) || (time>=secondStart && time <= secondEnd))
     {
      // todo: 这里要return false 啊,光alert还是return  true
      //Alert("当前非做单时间段",GetLastError());
      return true;
     }
   else
     {
      Comment("\n\n\n当前非做单时间段",GetLastError());
      return false;
     }
//else
//   if(!(time>=secondStart && time <= secondEnd))
//     {
//      // todo: 这边也一样
//      Alert("当前非做单时间段",GetLastError());
//      return false;
//     }
   return false;
  }
//+------------------------------------------------------------------+
// 平当天所有单时间
bool NeedCloseOrder()
  {
   datetime time = TimeLocal();
   if(time>=closeAllOrdersTimePoint)
     {
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getDay()
  {
   datetime locDateTime = TimeLocal();
   MqlDateTime ld;
   TimeToStruct(locDateTime,ld);
   return ld.day;
  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//单日最大亏损（总亏损是否达到100$）

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MaxStopDay(double MaxStop)
  {

   OP.Update();
   if(OP.SoildProfit() < -100)
     {
      IsTradeAllowed()==false;
     }
   return false;
  }
//+------------------------------------------------------------------+
// 开单价和实时价是否达到200点
bool IsEnoughPoint()
  {
   if(openBid >= Bid+200*Point || openBid <= Bid-200*Point)
     {
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
