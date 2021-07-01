// vim:filetype=cpp
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
#include <Mylib\Trade\trade.mqh>


input double Lots = 0.1; //单量
input string comment = "遇见"; //备注
input int magic = 431655; //开仓magic码
input int Slippage = 30; //滑点
input int ma_shift = 2; //均线平移
//input int ProfitPoint = 100; //移动止盈点数
//input int StopPoint = 100; //移动止损点数

input int FirstProfitPoint = 100; //第一止盈位
input int SecondProfitPoint = 300; //第二止盈位
input int ThirdProfitPoint = 500; //第三止盈位
input int FourthProfitPoint = 800; //第四止盈位
input int FifthProfitPoint = 1000; //第五止盈位
input int SixthProfitPoint = 200; //第六止盈位

input double FirstProfitPercent = 0.1; //第一止盈位利润
input double SecondProfitPercent = 0.2; //第二止盈位利润
input double ThirdProfitPercent = 0.4; //第三止盈位利润
input double FourthProfitPercent = 0.5; //第四止盈位利润
input double FifthProfitPercent = 0.6; //第五止盈位利润
input double SixthProfitPercent = 0.7; //第六止盈位利润

input int ma1_Period = 120; //均线1周期
input ENUM_MA_METHOD  ma1_Method = MODE_SMA; // ma1均线应用模式
input ENUM_APPLIED_PRICE  ma1_Price = PRICE_CLOSE; //ma1价格模式
input int ma2_Period = 50; //均线2周期
input ENUM_MA_METHOD  ma2_Method = MODE_SMA; // ma2均线应用模式
input ENUM_APPLIED_PRICE  ma2_Price = PRICE_CLOSE; //ma2价格模式
input int ma3_Period = 60; //均线3周期
input ENUM_MA_METHOD  ma3_Method = MODE_SMA; // ma3均线应用模式
input ENUM_APPLIED_PRICE  ma3_Price = PRICE_CLOSE; //ma3价格模式
input ENUM_TIMEFRAMES ma_Period = PERIOD_M5; // 均线时间轴 默认为五分钟

enum LossPoint
  {
   开启 = 1, 关闭 = 2
  };

input LossPoint 是否开启止盈 = 开启;

int OrderCount = 0;

int currentBars = 0;
int currentOrder = 0;

OrderManager *bp;
OrderManager *sp;

OrderInfo *oi;

enum ENUM_UFHOHMA_POSITION
  {
    ENUM_UFHOHMA_POSITION_UP = 0,
    ENUM_UFHOHMA_POSITION_MID = 1,
    ENUM_UFHOHMA_POSITION_DOWN = 2
  };
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
   delete oi;
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
   Print(IsOrderCountGreaterThanZero());
//开仓
//Print("IsUpFourHourAndOneHourMa: ",IsUpFourHourAndOneHourMa(0));
   bp.Update();
   sp.Update();
   if(bp.GetHandBuyCount() < 1 && !IsOrderCountGreaterThanZero() && IsUpFourHourAndOneHourMa(0) == ENUM_UFHOHMA_POSITION_UP && IsPriceUpMa(0) == PRICE_UP_50_60_MA)
     {
      Print("多单开仓 ",!IsOrderCountGreaterThanZero()," ",IsUpFourHourAndOneHourMa(0)== ENUM_UFHOHMA_POSITION_UP ," ",IsPriceUpMa(0));
      int ticket = bp.BuyWithTicket(Lots,clrRed);
      //currentBars = Bars;
      if(oi!=NULL)
        {
         delete oi;
        }
      oi = new OrderInfo(ticket);
     }

   if(sp.GetHandSellCount() < 1 && !IsOrderCountGreaterThanZero() && IsUpFourHourAndOneHourMa(0) == ENUM_UFHOHMA_POSITION_DOWN && IsPriceDownMa(0) == PRICE_DOWN_50_60_MA)
     {
      Print("空单开仓 "," ",!IsOrderCountGreaterThanZero()," ",IsUpFourHourAndOneHourMa(0) == ENUM_UFHOHMA_POSITION_DOWN," ",IsPriceDownMa(0));
      int ticket = sp.SellWithTicket(Lots,clrRed);
      //currentBars = Bars;
      if(oi!=NULL)
        {
         delete oi;
        }
      oi = new OrderInfo(ticket);
     }
//平仓
   //if(是否开启止盈 == 开启 && IsOrderCountGreaterThanZero())
   //  {
   //   if(!resetStopLoss())
   //     {
   //      Alert("reset last error",GetLastError());
   //     }       
   //  }
//   if(IsOrderCountGreaterThanZero() && IsDownOneHourMa(0))
//     {
//      Print("平仓 ",IsOrderCountGreaterThanZero()," ",IsDownOneHourMa(0));
//      oi.Close(Slippage,clrAliceBlue);
//
//      delete oi;
//      //IsOrderCountGreaterThanZero()<=0;
//     }
   if(IsDownOneHourMa(0) == PRICEWITH_120_MA_UP)
     {
      sp.CloseAllOrders(clrYellow);
     }
   if(IsDownOneHourMa(0) == PRICEWITH_120_MA_DOWN)
     {
      bp.CloseAllOrders(clrYellow);
     }

  }

//检测订单数量是否大于0
bool IsOrderCountGreaterThanZero()
  {
   //Print("---------------------");
   int i;
//double price;
   Print("OrdersTotal: ", OrdersTotal());
   for(i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
        // Print("++++++++++++++++++");
         if(MarketInfo(OrderSymbol(),MODE_TRADEALLOWED)!=1)
           {
            continue;
           }
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && (OrderType()==OP_BUY || OrderType()==OP_SELL))
           {
            //Print("==========================");
            //price=MarketInfo(OrderSymbol(),MODE_BID);
            //return false;
            return true;
           }
        }
     }
   //Print("判断订单数量<=0 ");
   return false;
  }

//+------------------------------------------------------------------+
//实时价格是否在4小时120日均线与1小时120日均线之上
ENUM_UFHOHMA_POSITION IsUpFourHourAndOneHourMa(int shift)
  {
   double ma1_1 = iMA(Symbol(),PERIOD_H4,ma1_Period,ma_shift,ma1_Method,ma1_Price,shift);
   double ma1_2 = iMA(Symbol(),PERIOD_H1,ma1_Period,ma_shift,ma1_Method,ma1_Price,shift);
   double price = MarketInfo(Symbol(),MODE_BID);
   if(price > ma1_1 && price > ma1_2)
     {
      return ENUM_UFHOHMA_POSITION_UP;
     }

   if(price < ma1_1 && price < ma1_2)
     {
      return ENUM_UFHOHMA_POSITION_DOWN;
     }
   return ENUM_UFHOHMA_POSITION_MID;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//判断实时价格是否在1小时120日均线之下
enum PRICEWITH_120_MA
  {
   PRICEWITH_120_MA_UP = 1, PRICEWITH_120_MA_DOWN = 2, PRICEWITH_120_MA_MID = 0
  };
PRICEWITH_120_MA IsDownOneHourMa(int shift)
  {
   double ma1 = iMA(Symbol(),PERIOD_H1,ma1_Period,ma_shift,ma1_Method,ma1_Price,shift);
   double price = MarketInfo(Symbol(),MODE_BID);
   if(price < ma1)
     {
      return PRICEWITH_120_MA_DOWN;
     }
   if(price > ma1)
     {
      return PRICEWITH_120_MA_UP;
     }
     return PRICEWITH_120_MA_MID;
  }
//+------------------------------------------------------------------+
//实时价格是否上穿50日均线和60日均线
enum ISPRICE_UP_50_60_MA
  {
   PRICE_UP_50_60_MA = 1, PRICE_DOWN_50_60_MA = 2, PRICE_MID_50_60_MA = 0
  };

ISPRICE_UP_50_60_MA IsPriceUpMa(int shift)
  {
   double ma2 = iMA(Symbol(),ma_Period,ma2_Period,ma_shift,ma2_Method,ma2_Price,shift);
   double ma3 = iMA(Symbol(),ma_Period,ma3_Period,ma_shift,ma3_Method,ma3_Price,shift);
   double price = MarketInfo(Symbol(),MODE_BID);
   if(price > ma2 && price > ma3)
     {
      return PRICE_UP_50_60_MA;
     }
   return PRICE_MID_50_60_MA;
  }

//实时价格是否下穿50日均线和60日均线
ISPRICE_UP_50_60_MA IsPriceDownMa(int shift)
  {
   double ma2 = iMA(Symbol(),ma_Period,ma2_Period,ma_shift,ma2_Method,ma2_Price,shift);
   double ma3 = iMA(Symbol(),ma_Period,ma3_Period,ma_shift,ma3_Method,ma3_Price,shift);
   double price = MarketInfo(Symbol(),MODE_BID);
   if(price < ma2 && price < ma3)
     {
      return PRICE_DOWN_50_60_MA;
     }
   return PRICE_MID_50_60_MA;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool resetStopLoss()
  {
   Print("重置止损位");
   if(IsOrderCountGreaterThanZero())
     {
      oi.Update();
     }
   int profitPoint = int(oi.GetNetProfit()/Point);
   if(profitPoint < FirstProfitPoint)
     {
      return true;
     }
   if(profitPoint > SixthProfitPoint)
     {
      return oi.ModifyStopLoss(getStopLossPriceByPoint(profitPoint,SixthProfitPercent),true);
     }
   if(profitPoint > FifthProfitPoint)
     {
      return oi.ModifyStopLoss(getStopLossPriceByPoint(profitPoint,FifthProfitPercent),true);
     }
   if(profitPoint > FourthProfitPoint)
     {
      return oi.ModifyStopLoss(getStopLossPriceByPoint(profitPoint,FourthProfitPercent),true);
     }
   if(profitPoint > ThirdProfitPoint)
     {
      return oi.ModifyStopLoss(getStopLossPriceByPoint(profitPoint,ThirdProfitPercent),true);
     }
   if(profitPoint > SecondProfitPoint)
     {
      return oi.ModifyStopLoss(getStopLossPriceByPoint(profitPoint,SecondProfitPercent),true);
     }
   if(profitPoint > FirstProfitPoint)
     {
      return oi.ModifyStopLoss(getStopLossPriceByPoint(profitPoint,FirstProfitPercent),true);
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getStopLossPriceByPoint(int profitPoint, double rate)
  {
   Print("获取止损价格转化的点数");
   double openPrice = oi.GetOpenPrice();
   switch(oi.GetType())
     {
      case OP_BUY:
         return openPrice + profitPoint * rate;
      case OP_SELL:
         return openPrice - profitPoint*rate;
      default:
         return 0;
     }
  }

//+------------------------------------------------------------------+
