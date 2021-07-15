// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                     手动多空加仓ea.mq4 |
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

// 亏损用负值  清仓以后会自动重新下单
// 每一层的盈利，亏损都是累加的  比如达到第二层 那这时候的总盈利是第一层的总盈利加第二层的总盈利 亏损也是一样的


input string comment = "手动多空加仓ea"; // 开仓备注
input int Magic = 525788;  // 开仓魔术码
input double Lots = 0.1; // 开仓手数
input int Slippage = 30; // 滑点
enum OrderDirection
  {
   多单 = 0, 空单 = 1
  };
input OrderDirection 货币一做单方向 = 多单;

input OrderDirection 货币二做单方向 = 空单;

input string Currency_1 = "BTCUSDm"; //货币对1
input string Currency_2 = "XAUUSDm"; //货币对2

input double FirstLoss = -10; // 第一层总亏损
input double FirstAddLots = 0.1; // 第一层加仓手数
input double FirstProfit = 20; // 第一层总获利

input double SecondLoss = -20; // 第二层总亏损
input double SecondAddLots = 0.1; // 第二层加仓手数
input double SecondProfit = 30; // 第二层总获利

input double ThirdLoss = -30; // 第三层总亏损
input double ThirdAddLots = 0.1; // 第三层加仓手数
input double ThirdProfit = 40; // 第三层总获利

input double FourthLoss = -40; // 第四层总亏损
input double FourthAddLots = 0.1; // 第四层加仓手数
input double FourthProfit = 50; // 第四层总获利

input double FifthLoss = -50; // 第五层总亏损
input double FifthAddLots = 0.1; // 第五层加仓手数
input double FifthProfit = 60; // 第五层总获利

input double SixthLoss = -60; // 第六层总亏损
input double SixthAddLots = 0.1; // 第六层加仓手数
input double SixthProfit = 70; // 第六层总获利

input double SeventhLoss = -70; // 第七层总亏损
input double SeventhAddLots = 0.1; // 第七层加仓手数
input double SeventhProfit = 80; // 第七层总获利

input double EighthLoss = -80; // 第八层总亏损
input double EighthAddLots = 0.1; // 第八层加仓手数
input double EighthProfit = 100; // 第八层总获利

double lossLevels[8];
double lotsLevels[8];
double profitLevels[8];

OrderManager *om1;
OrderManager *om2;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
// data check
   if(Currency_1 == "" || MarketInfo(Currency_1,MODE_BID)==0)
     {
      Alert("货币对1 填写错误或没有开市");
      return INIT_FAILED;
     }
   if(Currency_2 == "" || MarketInfo(Currency_2,MODE_BID)==0)
     {
      Alert("货币对2 填写错误或没有开市");
      return INIT_FAILED;
     }
   lossLevels[0] = FirstLoss;
   lossLevels[1] = SecondLoss;
   lossLevels[2] = ThirdLoss;
   lossLevels[3] = FourthLoss;
   lossLevels[4] = FifthLoss;
   lossLevels[5] = SixthLoss;
   lossLevels[6] = SeventhLoss;
   lossLevels[7] = EighthLoss;


   for(int i = 0; i < ArraySize(lossLevels)-1; i++)
     {
      if(lossLevels[i]<=lossLevels[i+1])
        {
         Alert("亏损加仓参数，第", i+1, "和", i+2,"层非递减关系");
         return INIT_FAILED;
        }
     }
   lotsLevels[0] = FirstAddLots;
   lotsLevels[1] = SecondAddLots;
   lotsLevels[2] = ThirdAddLots;
   lotsLevels[3] = FourthAddLots;
   lotsLevels[4] = FifthAddLots;
   lotsLevels[5] = SixthAddLots;
   lotsLevels[6] = SeventhAddLots;
   lotsLevels[7] = EighthAddLots;
//lotsLevels = {FirstAddLots,SecondAddLots,ThirdAddLots,FourthAddLots,FifthAddLots,SixthAddLots,SeventhAddLots,EighthAddLots};

   profitLevels[0] = FirstProfit;
   profitLevels[1] = SecondProfit;
   profitLevels[2] = ThirdProfit;
   profitLevels[3] = FourthProfit;
   profitLevels[4] = FifthProfit;
   profitLevels[5] = SixthProfit;
   profitLevels[6] = SeventhProfit;
   profitLevels[7] = EighthProfit;
//profitLevels = {FirstProfit, SecondProfit, ThirdProfit,FourthProfit,FifthProfit, SixthProfit,SeventhProfit, EighthProfit};

   for(int i = 0; i < ArraySize(profitLevels)-1; i++)
     {
      if(profitLevels[i]>=profitLevels[i+1])
        {
         Alert("盈利平仓参数，第", i+1, "和", i+2, "层非递增关系");
         return INIT_FAILED;
        }
     }

   om1 = new OrderManager(Currency_1,comment,Magic,Slippage);
   om2 = new OrderManager(Currency_2,comment,Magic,Slippage);
   OpenOrders(Lots);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   delete(om1);
   delete(om2);
  }
int currentLossLevel = -1;
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   om1.Update();
   om2.Update();
   double p = om1.FloatProfit()+om2.FloatProfit();
   Comment("当前盈利：", p);
   if(p < 0)
     {
      for(int i=0; i<ArraySize(lossLevels) ; i++)
        {
         if(currentLossLevel >= i)
           {
            continue;
           }
         if(p < lossLevels[i])
           {
            OpenOrders(lotsLevels[i]);
            currentLossLevel = i;
            break;
           }
        }
     }
   else
     {
      for(int i=0; i<ArraySize(profitLevels) ; i++)
        {
         if(p > profitLevels[i])
           {
            if(!om1.CloseAllOrders())
              {
               Alert("货币1平仓错误，错误代码：",GetLastError());
              }
            if(!om2.CloseAllOrders())
              {
               Alert("货币2平仓错误，错误代码：",GetLastError());
              }
            resetStatus();
            break;
           }
        }
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void resetStatus()
  {
   currentLossLevel = -1;
   OpenOrders(Lots);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenOrders(double lots)
  {
   if(货币一做单方向 == 多单)
     {
      if(!om1.Buy(lots))
        {
         Alert("货币1开多单失败，错误原因：", GetLastError());
        }
     }
   else
     {
      if(!om1.Sell(lots))
        {
         Alert("货币1开空单失败，错误原因：", GetLastError());
        }
     }
   if(货币二做单方向 == 多单)
     {
      if(!om2.Buy(lots))
        {
         Alert("货币2开多单失败，错误原因：", GetLastError());
        }
     }
   else
     {
      if(!om2.Sell(lots))
        {
         Alert("货币2开空单失败，错误原因：", GetLastError());
        }
     }
  }






//+------------------------------------------------------------------+
