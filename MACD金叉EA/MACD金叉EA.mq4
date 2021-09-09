//+------------------------------------------------------------------+
//|                                                     MACD金叉EA.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|  https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482"
#property version   "1.00"
#property strict
#include <Mylib\Trade\Ordermanager.mqh>

input int md1=12;
input int md2=26;
input int md3=9;
input ENUM_TIMEFRAMES MA_TimeFrame = PERIOD_M1; // macd时间周期

input int OpenMagic = 745666; //开仓magic码
input string OpenComment = "MACD金叉"; //开仓备注
input double OpenLots = 0.01; // 开仓手数
input int Slippage = 30; // 滑点
input int StopLoss = 2000; // 止损点数

OrderManager mp(Symbol(),OpenComment,OpenMagic,Slippage);

double MacdBuffer[];
double SigMABuffer[];

int bars;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
enum GOLE_DEATH_SWITCH
        {
         打开 = 0, 关闭 = 1
        };
input GOLE_DEATH_SWITCH 是否开启金叉 = 打开;
input GOLE_DEATH_SWITCH 是否开启死叉 = 打开;
int OnInit()
  {
   datetime NY=D'2021.09.13 08:43:00'; //到期时间
   datetime d1 = TimeLocal();
   if(d1>NY)
     {
      Alert("测试版到期：",GetLastError());
      Sleep(3000);
      ExpertRemove();
     }
   return(0);
  }
//+------------------------------------------------------------------+
//| The angle for EMA                                                |
//+------------------------------------------------------------------+
void OnTick()
  {

//   double myMACDmain=0,myMACDsignal=0,MACDmain_15=0;
//   int limit = GetLimit();
//   int i;
//
//   for(i=0; i<limit; i++)
//     {
//      myMACDmain=iMACD(Symbol(),MA_TimeFrame,md1,md2,md3,PRICE_CLOSE,MODE_MAIN,i);
//      myMACDsignal=iMACD(Symbol(),MA_TimeFrame,md1,md2,md3,PRICE_CLOSE,MODE_SIGNAL,i);
//      
//      MACDmain_15=iMACD(Symbol(),PERIOD_M15,md1,md2,md3,PRICE_CLOSE,MODE_MAIN,i);   
//     }
//平仓
     if((OrderType()==OP_BUY && CloseMACD()==K_1_BIGGER))
       {
       printf("CloseMACD: ",CloseMACD());
        mp.CloseAllOrders(clrYellowGreen);
        bars=Bars;
       }
     if((OrderType()==OP_SELL && CloseMACD()==K_2_BIGGER))
       {
        mp.CloseAllOrders(clrYellowGreen);
        bars=Bars;
       }
 
 
//开仓    
     if(是否开启金叉 == 打开 && orderCount()<1 && MACD_Status()==GOLD_CROSS && bars!=Bars)
       {
        mp.BuyWithStAndTp(OpenLots,StopLoss);
       }
     if(是否开启死叉 == 打开 && orderCount()<1 && MACD_Status()==DEATH_CROSS && bars!=Bars)
       {
        mp.SellWithStAndTp(OpenLots,StopLoss);
       }
  }

// 交叉状态  0表示金叉 1表示死叉 2表示其他情况
enum CROSS_STATUS
  {
   GOLD_CROSS = 0, DEATH_CROSS = 1, NO_CROSS = 2
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//开仓时的状态
CROSS_STATUS MACD_Status()
  {

   double F1_1 = iMACD(Symbol(),MA_TimeFrame,md1,md2,md3,PRICE_CLOSE,MODE_MAIN,1);
   double F1_2 = iMACD(Symbol(),MA_TimeFrame,md1,md2,md3,PRICE_CLOSE,MODE_MAIN,2);
   double F2_1 = iMACD(Symbol(),MA_TimeFrame,md1,md2,md3,PRICE_CLOSE,MODE_MAIN,1);
   double F2_2 = iMACD(Symbol(),MA_TimeFrame,md1,md2,md3,PRICE_CLOSE,MODE_MAIN,2);

   if(F1_1>=0 && F1_2<0)
     {
      return GOLD_CROSS;
     }
   if(F1_1<0 && F1_2>0)
     {
      return DEATH_CROSS;
     }
   return NO_CROSS;
  }
//+------------------------------------------------------------------+

enum COMPARE_K
  {
   K_1_BIGGER = 0, K_2_BIGGER = 1, OTHERS = 2
  };
//平仓时的条件 15分钟macd前一柱低于前前一柱金叉平仓  15分钟macd前一柱高于前前一柱死叉平仓

COMPARE_K CloseMACD()
{
   double MACD_Period_15_1 = iMACD(Symbol(),PERIOD_M15,md1,md2,md3,PRICE_CLOSE,MODE_MAIN,0);
   double MACD_Period_15_2 = iMACD(Symbol(),PERIOD_M15,md1,md2,md3,PRICE_CLOSE,MODE_MAIN,1);
   
   if(MACD_Period_15_1>MACD_Period_15_2)
     {
      return K_2_BIGGER;
     }
   if(MACD_Period_15_1<MACD_Period_15_2)
     {
      return K_1_BIGGER;
     }
     return OTHERS;
}

int GetLimit()
  {
   int count_Bars = IndicatorCounted(),limit;
   if(count_Bars < 0)
     {
      return(-1);
     }
   if(count_Bars > 0)
     {
      count_Bars--;
     }
   limit = Bars - count_Bars;
   return limit;
  }
  
//每次只开一单
int orderCount()
  {
   int oc = 0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber() == OpenMagic)
        {
         if(OrderType()==OP_BUY || OrderType()==OP_SELL)
           {
            oc++;
           }
        }
     }
   return oc;
  }