//+------------------------------------------------------------------+
//|                                                   单向macd均线ea.mq4 |
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

input double Lots = 0.1; //单量
input string comment = "盼哥"; //备注
input int magic = 15430; //开仓magic码
input int Slippage = 30; //滑点

input int md1=12; //macd1周期
input int md2=26; //macd2周期
input int md3=9; //macd3周期
input int ma1_Period = 5; //均线1周期
input ENUM_MA_METHOD  ma1_Method = MODE_SMA; // ma1均线应用模式
input ENUM_APPLIED_PRICE  ma1_Price = PRICE_CLOSE; //ma1价格模式
input int ma2_Period = 20; //均线2周期
input ENUM_MA_METHOD  ma2_Method = MODE_SMA; // ma2均线应用模式
input ENUM_APPLIED_PRICE  ma2_Price = PRICE_CLOSE; //ma2价格模式
input int ma3_Period = 40; //均线3周期
input ENUM_MA_METHOD  ma3_Method = MODE_SMA; // ma3均线应用模式
input ENUM_APPLIED_PRICE  ma3_Price = PRICE_CLOSE; //ma3价格模式
input ENUM_TIMEFRAMES ma_Period = PERIOD_CURRENT; // 均线时间轴

double UpBuffer[];
double DownBuffer[];
double ZeroBuffer[];
double SigMABuffer[];

double Ma1Buffer[];
double Ma2Buffer[];
double Ma3Buffer[];

//做单方向
enum 做单方向
  {
   做多=1,做空=2,全做=3
  };
input 做单方向 做单方向选择=全做;


OrderManager mp(comment,magic,Slippage);

int CBars;
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
//---
   if(!IsTradeAllowed())
     {
      Alert("自动交易设置存在异常,   请检查!  ");
      return;
     }
// 开仓部分
   mp.Update();
   if(GetSendMAPosition()==MACDUP_MAUP && CBars!=Bars && mp.GetHandBuyCount()<1)
     {
      mp.Buy(Lots,clrRed);
      CBars = Bars;
     }
   if(GetSendMAPosition()==MACDDOWN_MADOWN && CBars!=Bars && mp.GetHandSellCount()<1)
     {
      mp.Sell(Lots,clrLime);
      CBars = Bars;
     }
     
//平仓部分
   if(GetCloseMAPosition()==MA_DOWN || GetCloseMAPosition()==MA_UP)
     {
      mp.CloseAllOrders();
     }
  }
//+------------------------------------------------------------------+
enum ENUM_MACD_COLOR
  {
   GRAY = 0,
   RED = 1,
   GREEN = 2
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_MACD_COLOR MACDStatus(int shift=0)
  {
   double myMACDmain,myMACDsignal;

   myMACDmain=iMACD(NULL,0,md1,md2,md3,PRICE_CLOSE,MODE_MAIN,shift);
   myMACDsignal=iMACD(NULL,0,md1,md2,md3,PRICE_CLOSE,MODE_SIGNAL,shift);
   if((myMACDmain > 0)&&(myMACDmain > myMACDsignal))
     {
      return RED; // 红
     }
   else
     {
      if((myMACDmain < 0)&&(myMACDmain < myMACDsignal))
        {
         return GREEN; // 绿
        }
      else
        {
         return GRAY; // 灰
        }
     }
  }

//开仓时
//均线和macd的上穿下穿状态 1.MACD 向上过0轴 7均线上穿20和40  2.MACD 向下过0轴 7均线下穿20和40
enum MA_MACD_STATUS
  {
   MACDUP_MAUP = 1, MACDDOWN_MADOWN = 2, OTHER_MA_MACD_STSTUS = 0
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MA_MACD_STATUS GetSendMAPosition(int shift=0)
  {

   double ma1 = iMA(Symbol(),0,ma1_Period,0,ma1_Method,ma1_Price,shift);
   double ma2 = iMA(Symbol(),0,ma2_Period,0,ma2_Method,ma2_Price,shift);
   double ma3 = iMA(Symbol(),0,ma3_Period,0,ma3_Method,ma3_Price,shift);
   if(ma1>ma2 && ma2>ma3 && MACDStatus()==RED)
     {
      return MACDUP_MAUP;
     }
   if(ma1<ma2 && ma2<ma3 && MACDStatus()==GREEN)
     {
      return MACDDOWN_MADOWN;
     }
   return OTHER_MA_MACD_STSTUS;
  }
//+------------------------------------------------------------------+

//平仓时
//1.做多时， 7下穿40 平仓  2. 做空时 ， 7上穿40 平仓
enum MA_STATUS
  {
   MA_DOWN = 1, MA_UP = 2, OTHER_MASTAUTS = 0
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MA_STATUS GetCloseMAPosition(int shift=0)
  {

   double ma1 = iMA(Symbol(),0,ma1_Period,0,ma1_Method,ma1_Price,shift);
   double ma2 = iMA(Symbol(),0,ma2_Period,0,ma2_Method,ma2_Price,shift);
   double ma3 = iMA(Symbol(),0,ma3_Period,0,ma3_Method,ma3_Price,shift);
   if(ma1<ma3 && GetSendMAPosition()==MACDUP_MAUP)
     {
      return MA_DOWN;
     }
   if(ma1>ma3 && GetSendMAPosition()==MACDDOWN_MADOWN)
     {
      return MA_UP;
     }
   return OTHER_MASTAUTS;
  }
//+------------------------------------------------------------------+
