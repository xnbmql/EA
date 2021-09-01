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
input int HedgePoint = 100; // 对冲单开单亏损点数
input int takeProfitPoint = 300; // 止盈
input int addOrderTimeSpace = 5;// 加仓单开仓间隔时间 分钟
input int addOrderPointSpace = 100;// 加仓单开仓亏损间隔点数
input int addOrderLotsMul = 2; // 加仓单手数的倍数
input int addOrderLimit = 10; // 加仓单数限制

input int allProfitPoint = 20000; // 整体止盈线

input int riskMoney = 1500; // 风控金额

input bool riskCloseAll = true; // 风控平仓 (优先)
input bool riskLockAll = false; // 风控锁单



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

   if(!(riskLockAll|| riskCloseAll)){
    return(INIT_FAILED);
   }
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
    delete om;
  }

enum ENUM_ORDER_STATE{
  EMPTY = 0,
  FISRT = 1,
  HEDGE = 2,
  ADD = 3
};
ENUM_ORDER_STATE order_status = EMPTY;

int FisrtOrderDirect = 0;
int FisrtTicket = 0;
double lastProfit = 0.0;
int lastSeconds = 0;

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
    // 首单
    if(order_status==EMPTY){
      if(GetPriceMaPosition() == PRICE_ABOVE){
      FisrtTicket = om.BuyWithStAndTp(InitLots,0,takeProfitPoint);
        if(FisrtTicket==0)
          {
            Alert("开启首单多单错误：",GetLastError());
            return;
          }
        order_status = FISRT;
        FisrtOrderDirect = OP_BUY;
      }

      if(GetPriceMaPosition() == PRICE_BELOW){
      FisrtTicket = om.SellWithStAndTp(InitLots,0,takeProfitPoint);
        if(FisrtTicket == 0)
          {
            Alert("开启首单空单错误：",GetLastError());
            return;
          }
        order_status = FISRT;
        FisrtOrderDirect = OP_SELL;
      }
    }

    // 对冲单
    if(order_status == FISRT){
      if(om.FloatProfit() <= - HedgePoint * MarketInfo(Symbol(),MODE_POINT)){
        if(om.BuyWithTicket(InitLots)==0){
            Alert("开启首单空单错误：",GetLastError());
            return;
        }
        if(om.SellWithTicket(InitLots)==0){
            Alert("开启首单空单错误：",GetLastError());
            return;
        }
        order_status = HEDGE;
        CancelFirstOrderProfit()
        lastProfit = om.FloatProfit();
        lastSeconds = TimeSeconds(TimeCurrent());
      }
    }

    if(order_status == HEDGE || order_status == ADD){
      if(TimeSeconds(TimeCurrent()) - lastSeconds > 60 *addOrderTimeSpace){
        if((om.FloatProfit() - lastProfit)/MarketInfo(Symbol(),MODE_POINT) < -addOrderPointSpace){
          switch(FisrtOrderDirect){
            case OP_SELL:
              if(om.SellWithTicket()==0){
                Alert("加仓失败:", GetLastError());
              }
              break;
            case OP_BUY:
              if(om.BuyWithTicket()==0){
                Alert("加仓失败:", GetLastError());
              }
            default:
              printf("加仓遇到未知类型：%d \n",FisrtOrderDirect);
          }
          lastProfit = om.FloatProfit();
          lastSeconds = TimeSeconds(TimeCurrent());
        }
      }
    }

    if(om.FloatProfit() < -riskMoney){
        if(riskCloseAll){
          if(!om.CloseAllOrders()){
            Alert("risk CloseAll error:",GetLastError());
            return;
          }
        }else{
          if(!om.LockOrders()){
            Alert("risk lock error:",GetLastError());
            return;
          }
        }
    }



  }
//+------------------------------------------------------------------+

bool CancelFirstOrderProfit(){
return false;
}

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


