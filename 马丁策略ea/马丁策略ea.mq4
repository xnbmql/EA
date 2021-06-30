// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                       马丁策略ea.mq4 |
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


input double Lots = 0.1; //手数
input string comment = "在路上"; //备注
input int magic = 714751; //开仓magic码
input int Slippage = 30; //滑点
input double AddLots = 0.1; //加仓手数
input int AddDistance = 100; // 加仓距离点数
input double LockLots = 0.1; //锁仓手数
input double LossMoney = 100; //亏损到预设金额锁仓

input int ProfitPoint = 100; // 盈利平仓点数
input int LockProfitPoint = 100; //锁仓单止盈点数
input int LockStopPoint = 100; //锁仓单止损点数


OrderManager *bp; //正常单
OrderManager *sp; //正常单
OrderManager *ap; //加仓单
OrderManager *lp; //锁仓单

enum 开单方向
  {
   多单方向 = 0, 空单方向 = 1
  };
input 开单方向 做单方向 = 多单方向;

int currentBars = 0;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   bp = new OrderManager(comment,magic,Slippage);
   sp = new OrderManager(comment,magic,Slippage);
   ap = new OrderManager(comment,magic,Slippage);
   lp = new OrderManager(comment,magic,Slippage);
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
   delete ap;
   delete lp;
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
   bp.Update();
   sp.Update();
   if(bp.GetHandBuyCount() + sp.GetHandSellCount() < 1) // todo: 如果是维护一组的话，这里会反复开单
     {
      // todo: 这里判断下开单是否异常
      if(!bp.Buy(Lots,clrRed))
        {
         Alert("对冲多单开单异常: ",GetLastError());
        }
      if(!sp.Sell(Lots,clrLime))
        {
         Alert("对冲空单开单异常: ",GetLastError());
        }
     }

// fake code
   ap.Update();
   if(LossReachMoney())
     {
      if(OrderLossDirection() == BuyDirection && ap.GetHandBuyCount() < 1)
        {
         // buy 方向上加仓逻辑
         if(!ap.Buy(AddLots,clrYellow))
           {
            Alert("加仓多单开单错误: ",GetLastError());
           }
        }
      if(OrderLossDirection() == SellDirection && ap.GetHandSellCount() < 1)
        {
         // Sell 方向上加仓逻辑
         if(!ap.Sell(AddLots,clrYellow))
           {
            Alert("加仓空单开单错误: ",GetLastError());
           }
        }
     }
//锁仓单
   
   
  }
//+------------------------------------------------------------------+

//单子的方向
enum ORDERDIRECTION
  {
   BuyDirection = 1, SellDirection = 2, NoDirection = 0
  };

//判断哪个方向的单子亏损了
ORDERDIRECTION OrderLossDirection()
  {
   if(bp.FloatProfit() < sp.FloatProfit())
     {
      return BuyDirection;
     }
   if(bp.FloatProfit() > sp.FloatProfit())
     {
      return SellDirection;
     }

   return NoDirection;

  }


//是否亏损到一定金额
bool LossReachMoney()
  {
   if(bp.FloatProfit()<-LossMoney || sp.FloatProfit() < -LossMoney)
     {
      return true;
     }
   return false;
  }



//+------------------------------------------------------------------+
