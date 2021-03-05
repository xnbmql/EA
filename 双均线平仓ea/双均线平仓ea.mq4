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
#include <Mylib\Panels\DisPlayAndDisablePanel.mqh>

input int MA1_Period = 20; //快均线周期
input int MA2_Period = 40; //慢均线周期
input ENUM_MA_METHOD MA_Method = MODE_SMA; //均线模式
input ENUM_APPLIED_PRICE MA_price = PRICE_CLOSE; //均线应用价格

CommPanel Dp;
//input double OpenLots = 0.1; // 开仓手数
//input int OpenMagic = 199003; //开仓magic
//input string OpenComment = "双均线平仓"; //开仓备注信息
input int Slippage = 30; // 滑点
// 两条均线的位置
enum EUNM_TWO_MA_POSITION
  {
   DownToUp = 1, UpToDown = 2, NotChange = 0
  };

enum ENUM_POSITION
  {
   UP = 0,
   DOWN=1,
   COINCIDE = 2 // 重叠
  };



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   recentBar = Bars;
   // Dp.Destroy();
   if(!Dp.Create(0,"控制面板",0,0,0,200,200,"平仓单盈利情况"))
     {
      Dp.Destroy();
      return -3;
     }

   if(!Dp.Run())
     {
      return -2;
     }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
Dp.Destroy();
  }

int recentBar = 0;
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

   if(recentBar != Bars && !Dp.GetDisableStatus())
     {
      EUNM_TWO_MA_POSITION p = GetMaPosition();
      if(p == DownToUp)
        {
         Print("Close Sells");
         CloseSingleDirect(OP_SELL);
        }
      if(p == UpToDown)
        {
         Print("Close buys");
         CloseSingleDirect(OP_BUY);
        }
      recentBar = Bars;
     }
    Dp.SetProfit(totalProfit);
  }
//+------------------------------------------------------------------+

double totalProfit = 0.0;
void CloseSingleDirect(int op)
  {
   OrderInfo ois[];
   GetOpenningOrderInfo(ois,Symbol(),op);
   //GetOpenningOrderInfo(&ois,Symbol(),OP_BUY);
   //GetOpenningOrderInfo(*ois,Symbol(),OP_BUY);
   for(int i=ArraySize(ois)-1; i>=0; i--)
     {
      if(!ois[i].Close(Slippage))
        {
         Alert(StringFormat("tikect:%d close error,code:%d",ois[i].ticket,GetLastError()));
         return;
        }else{
          ois[i].Update();
          totalProfit+= ois[i].profit;
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EUNM_TWO_MA_POSITION GetMaPosition()
  {
   double MA1_2 = iMA(Symbol(), PERIOD_CURRENT, MA1_Period, 0, MA_Method, MA_price, 2);
   double MA2_2 = iMA(Symbol(), PERIOD_CURRENT, MA2_Period, 0, MA_Method, MA_price, 2);

   double MA1_1 = iMA(Symbol(), PERIOD_CURRENT, MA1_Period, 0, MA_Method, MA_price, 1);
   double MA2_1 = iMA(Symbol(), PERIOD_CURRENT, MA2_Period, 0, MA_Method, MA_price, 1);

   if(MA1_2 < MA2_2 && MA1_1 > MA2_1)
     {
      return DownToUp;
      //return(OP_BUY);

     }
   if(MA1_2 > MA2_2 && MA1_1 < MA2_1)
     {
      return UpToDown;
      //return(OP_SELL);
     }
   return NotChange;
  }
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   Dp.ChartEvent(id,lparam,dparam,sparam);
  }
