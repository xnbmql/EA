// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                        鳄鱼种田人.mq4 |
//|                                                        992249804 |
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
#include <Mylib\Panels\DisPlayAndDisablePanel.mqh>
#include <Arrays\List.mqh>

CommPanel Dp;


input double 手数 = 0.01;
input string 开仓备注 = "zhongtianren";
input int 开仓magic码 = 199004;
input int Slippage = 30; //滑点
//input int stopProfilePoint = 300000;// 止盈点数
//input int stopLossPoint = -300000;// 止损点数
//OrderInfo historyOiss[];//---

CList BuyOpenOrders;
CList SellOpenOrders;
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
   if(!Dp.Create(0,"盈亏面板",0,0,0,200,200))
     {
      return -3;
     }

   if(!Dp.Run())
     {
      return -2;
     }
   return(INIT_SUCCEEDED);
  }

double historyProfit = 0.0;
bool CloseAll()
  {
   CloseAllBuy();
   CloseAllSell();
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CloseAllBuy()
  {
   if(BuyOpenOrders.Total()> 0)
     {
      for(int i =0; i< BuyOpenOrders.Total(); i--)
        {
         OrderInfo *oo = (OrderInfo *)BuyOpenOrders.GetNodeAtIndex(0);
         if(!oo.Close(Slippage))
           {
            Alert("关闭订单错误，错误代码是:  ", GetLastError());
            ExpertRemove();
            return false;
           }
         historyProfit+=oo.profit;
         delete(oo);
        }
     }
   BuyOpenOrders.Clear();
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CloseAllSell()
  {
   if(SellOpenOrders.Total()> 0)
     {
      for(int i =0; i< SellOpenOrders.Total(); i--)
        {
         OrderInfo *oo = (OrderInfo *)SellOpenOrders.GetNodeAtIndex(0);
         if(!oo.Close(Slippage))
           {
            Alert("关闭订单错误，错误代码是:  ", GetLastError());
            ExpertRemove();
            return false;
           }
         historyProfit+=oo.profit;
         delete(oo);
        }
     }
   SellOpenOrders.Clear();
   return true;
  }
//做多
bool Buy()
  {
   RefreshRates();
   int orderTicket = OrderSend(Symbol(),OP_BUY,手数,Ask,Slippage,0,0,开仓备注,开仓magic码,0,clrRed);
   if(orderTicket < 0)
     {
      Alert("开单错误，错误代码是:  ", GetLastError());
      ExpertRemove();
      return false;
     }
   OrderInfo *oo = new OrderInfo(orderTicket);
   BuyOpenOrders.Add(oo);
   return true;
  }

//做空
bool Sell()
  {
   RefreshRates();

   int orderTicket  = OrderSend(Symbol(),OP_SELL,手数,Bid,Slippage,0,0,开仓备注,开仓magic码,0,clrGreen);
   if(orderTicket  < 0)
     {
      Alert("开单错误，错误代码是:  ", GetLastError());
      ExpertRemove();
      return false;
     }
   OrderInfo *oo = new OrderInfo(orderTicket);
   BuyOpenOrders.Add(oo);
   return true;
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Dp.Destroy();
  }
int OpenBar = 0;
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
// 趋势开单
   if(currentBars != Bars)
     {
      ENUM_GAT_POSITION gp = GetGatPoisition(1);
      if(gp == OVER_LIPS)
        {
         Sell();
        }
      else
         if(gp == BELOW_LIPS)
           {
            Buy();
           }
      currentBars = Bars;
      //buyBar = Bars;
      return;
     }
// 对冲开单
   ENUM_GAT_POSITION gtp = GetGatPoisition(0);
   if(OpenBar != Bars && gtp != OVER_LIPS && gtp != BELOW_LIPS)
     {
      Sell();
      Buy();
      OpenBar = Bars;
      currentBars = Bars;
      return;
     }
// 和下颌线相交全部平仓
   if(!Dp.GetDisableStatus())
     {
      ENUM_POSITION gp = GetPoisition(High[0],Low[0],iAlligator(Symbol(), PERIOD_CURRENT, jaw_period, jaw_shift, teeth_period, teeth_shift, lips_period, lips_shift, ma_method, applied_price, MODE_GATORJAW, 0));
      ENUM_POSITION lp = GetPoisition(High[0],Low[0],iAlligator(Symbol(), PERIOD_CURRENT, jaw_period, jaw_shift, teeth_period, teeth_shift, lips_period, lips_shift, ma_method, applied_price, MODE_GATORLIPS, 0));
      ENUM_POSITION tp = GetPoisition(High[0],Low[0],iAlligator(Symbol(), PERIOD_CURRENT, jaw_period, jaw_shift, teeth_period, teeth_shift, lips_period, lips_shift, ma_method, applied_price, MODE_GATORTEETH, 0));
      if(gp == CROSS)
        {
         CloseAll();
        }
      else
      
         if(lp == CROSS)
           {
           // Close[0] >  iAlligator(Symbol(), PERIOD_CURRENT, jaw_period, jaw_shift, teeth_period, teeth_shift, lips_period, lips_shift, ma_method, applied_price, MODE_GATORTEETH, 0)
            if(tp == OVER)
              {
               CloseAllBuy();
              }
            if(tp == BELOW)
              {
               CloseAllSell();
              }
           }
     }

   Dp.SetProfit(historyProfit+FloatProfit());

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double FloatProfit()
  {
   double floatProfit = 0.0;
   if(SellOpenOrders.Total()> 0)
     {
      for(int i =0; i< SellOpenOrders.Total(); i--)
        {
         OrderInfo *oo = (OrderInfo *)SellOpenOrders.GetNodeAtIndex(0);
         oo.Update();
         floatProfit+=oo.profit;
        }
     }

   if(BuyOpenOrders.Total()> 0)
     {
      for(int i =0; i< BuyOpenOrders.Total(); i--)
        {
         OrderInfo *oo = (OrderInfo *)BuyOpenOrders.GetNodeAtIndex(0);
         oo.Update();
         floatProfit+=oo.profit;
        }
     }


   return floatProfit;
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
   Dp.ChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_GAT_POSITION GetGatPoisition(int shift)
  {
   double high = iHigh(NULL,0, shift);
   double low = iLow(NULL, 0,shift);
   double jaw = iAlligator(Symbol(), PERIOD_CURRENT, jaw_period, jaw_shift, teeth_period, teeth_shift, lips_period, lips_shift, ma_method, applied_price, MODE_GATORJAW, shift);
   double teeth = iAlligator(Symbol(), PERIOD_CURRENT, jaw_period, jaw_shift, teeth_period, teeth_shift, lips_period, lips_shift, ma_method, applied_price, MODE_GATORTEETH, shift);
   double lips = iAlligator(Symbol(), PERIOD_CURRENT, jaw_period, jaw_shift, teeth_period, teeth_shift, lips_period, lips_shift, ma_method, applied_price, MODE_GATORLIPS, shift);
   ENUM_POSITION jp = GetPoisition(high, low, jaw);
   ENUM_POSITION tp = GetPoisition(high, low, teeth);
   ENUM_POSITION lp = GetPoisition(high, low, lips);
   int s = jp+tp+lp;
   if(s == 0)
     {
      return OVER_LIPS;
     }
   if(s == 6)
     {
      return BELOW_LIPS;
     }
   if(jp == CROSS)
     {
      return CROSS_JAW;
     }
   return UNKNOW_GAT_POSITION;
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
