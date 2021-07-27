// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                   亨利投资ea.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|  https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482 |
//+------------------------------------------------------------------+
#property copyright "https://item.taobao.com/item.htm?spm=a230r.1.14.6.5b876b15pPfxRb&id=651269419591&ns=1&abbucket=12#detail"
#property link      "19956480259"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Mylib\Trade\Ordermanager.mqh>
#include <Mylib\Trade\trade.mqh>
#include <arrays\list.mqh>


input int Magic = 311622; //开仓magic码
input string comment = "亨利投资"; //开仓备注
input int Slippage = 10; //滑点
input double Lots = 0.01; // 手数

input int BreakPoint = 50; // K线突破的点数
input double ProfitMoney = 20; // 盈利金额
input int TrailingStop = 150; // 移动止损
input int TrailingLimit = 200; // 开启止损点
input int OneWay = 2; //单向单子倍数
input int TwoWay = 3; //双向单子倍数

enum ENUM_OPEN_DIRECTION
  {
   全部=0, 空单 = 1, 多单 = 2
  };
input ENUM_OPEN_DIRECTION od = 全部; // 开单方向

input int MA_Period = 20; // 均线周期
input ENUM_MA_METHOD MA_Method = MODE_SMA; // 均线类型
input ENUM_APPLIED_PRICE MA_Price = PRICE_CLOSE; // 均线价格类型
input ENUM_TIMEFRAMES MA_Time = PERIOD_CURRENT; // 均线时间周期

enum ENUM_SWITCH
  {
   开启 = 0, 关闭 = 1
  };
input ENUM_SWITCH 趋势线开关 = 开启;

input ENUM_SWITCH 达到金额平仓开关 = 开启;

OrderManager *om;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   om = new OrderManager(comment,Magic,Slippage);

   ObjectDelete(0, "lable");
   ObjectDelete(0, "button1");
   ObjectDelete(0, "button2");
   ObjectDelete(0, "button3");

   Lable("lable", 180, 80, clrDarkViolet, clrNavy, CORNER_RIGHT_UPPER, 190, 50,false);
   Button("button1", 70, 30, clrNONE, clrWhite, clrRed, 10, CORNER_RIGHT_UPPER, 175, 60, "开多");
   Button("button2", 70, 30, clrNONE, clrWhite, clrGreen, 10, CORNER_RIGHT_UPPER, 95, 60, "开空");
   Button("button3", 150, 30, clrNONE, clrWhite, clrRed, 10, CORNER_RIGHT_UPPER, 175, 100, "全部平仓");
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectsDeleteAll();
   delete om;
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
   ENUM_POSITION breakPosition = PriceMaPosition(0);
// ------------------------------------------------------------------------------------------

   om.Update();
// 设置止盈止损
   setStopLoss();
// 平仓逻辑
   if(达到金额平仓开关==开启 && (breakPosition == ENUM_POSITION_UP || breakPosition == ENUM_POSITION_DOWN))
     {
      if(om.FloatProfit() > ProfitMoney)
        {
         if(!om.CloseAllOrders())
           {
            Alert("平所有错误：", GetLastError());
           }
        }
      else
        {
         if(!om.CloseProfitOrders())
           {
            Alert("平盈利错误：", GetLastError());
           }
        }
     }


   om.Update();
   if(om.GetHandSellCount()+om.GetHandBuyCount() == 0)
     {
      resetBreakArgs();
     }
// ------------------------------------------------------------------------------------------
// 开仓逻辑
   if(od!=空单 && breakPosition == ENUM_POSITION_UP && ((趋势线开关 == 开启 &&PriceBreakPosition() == ENUM_POSITION_UP) || 趋势线开关 != 开启))
     {
      double buylots = Lots*(upBreakTimes);
      // ------------------------------------------------------------------------------------------
      // 加仓逻辑
      if(om.GetHandSellCount()>0)
        {
         buylots = Lots*OneWay;
        }
      if(om.GetHandSellCount()>0&&om.GetHandBuyCount() > 0)
        {
         buylots = Lots*TwoWay;
        }
      // ------------------------------------------------------------------------------------------
      int ticket = om.BuyWithTicket(buylots);
      if(ticket <= 0)
        {
         Alert("开多单错误，错误代码：", GetLastError());
        }
     }

   if(od != 多单 && breakPosition == ENUM_POSITION_DOWN && ((趋势线开关 == 开启 &&PriceBreakPosition() == ENUM_POSITION_DOWN) || 趋势线开关 != 开启))
     {
      double sellLots = Lots*(downBreakTimes);
      // ------------------------------------------------------------------------------------------
      // 加仓逻辑
      if(om.GetHandBuyCount()>0)
        {
         sellLots = Lots*OneWay;
        }
      if(om.GetHandSellCount()>0&&om.GetHandBuyCount() > 0)
        {
         sellLots  = Lots*TwoWay;
        }
      // ------------------------------------------------------------------------------------------
      int ticket = om.SellWithTicket(sellLots);
      if(ticket <= 0)
        {
         Alert("开空单错误，错误代码：", GetLastError());
        }
     }
  }
//+------------------------------------------------------------------+

void setStopLoss(){
   CList *buyOpenOrders = om.GetAllBuyOpenningList();
   if(buyOpenOrders.Total()>0){
      buyOpenOrders.MoveToIndex(0);
      OrderInfo *oos = (OrderInfo *)buyOpenOrders.GetCurrentNode();
      while(oos!=NULL)
        {
         oos.Update();
        if(oos.GetState() == ORDER_STATE_OPENING)
          {
           double floatProfit = oos.GetNetProfit();
           if(floatProfit/Point >= TrailingLimit){

            if(Bid - TrailingStop*Point > oos.GetStopLoss())
              {
               if(!oos.ModifyStopLoss(NormalizeDouble(Bid -TrailingStop*Point,Digits),false))
                 {
                  Print("Error in OrderModify. Error code=",GetLastError());
                 }
              }
           }
          }
         oos = (OrderInfo *)buyOpenOrders.GetNextNode();
        }
   }

   CList *sellOpenningOrders = om.GetAllSellOpenningList();
   if(sellOpenningOrders.Total()>0){
      sellOpenningOrders.MoveToIndex(0);
      OrderInfo *oos = (OrderInfo *)sellOpenningOrders.GetCurrentNode();
      while(oos!=NULL)
        {
         oos.Update();
        if(oos.GetState() == ORDER_STATE_OPENING)
          {
           double floatProfit = oos.GetNetProfit();
           if(floatProfit/Point >= TrailingLimit){

            if(Bid + TrailingStop*Point < oos.GetStopLoss())
              {
               if(!oos.ModifyStopLoss(NormalizeDouble(Bid +TrailingStop*Point,Digits),false))
                 {
                  Print("Error in OrderModify. Error code=",GetLastError());
                 }
              }
           }
          }
         oos = (OrderInfo *)sellOpenningOrders.GetNextNode();
        }
   }
   om.Update();
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam)
  {
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button1")
     {
      om.Buy(Lots,clrRed);
     }
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button2")
     {
      om.Sell(Lots,clrLime);
     }
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button3")
     {
      om.CloseAllOrders();
     }
  }

enum ENUM_POSITION
  {
   ENUM_POSITION_UP = 0,
   ENUM_POSITION_DOWN = 1,
   ENUM_POSITION_MID = 2
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_POSITION PriceMaPosition(int shift)
  {
   double price = Close[shift];
   double ma = iMA(Symbol(),MA_Time,MA_Period,0,MA_Method,MA_Price,shift);
   if(price > ma)
     {
      return ENUM_POSITION_UP;
     }
   if(price < ma)
     {
      return ENUM_POSITION_DOWN;
     }
   return ENUM_POSITION_MID;
  }


double UpBreakPriceLimit = 0;
double DownBreakPriceLimit = 0;
int upBreakTimes = 0;
int downBreakTimes = 0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void resetBreakArgs()
  {
   UpBreakPriceLimit = 0;
   DownBreakPriceLimit = 0;
   upBreakTimes = 0;
   downBreakTimes = 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_POSITION PriceBreakPosition()
  {
   if(UpBreakPriceLimit == 0)
     {
      UpBreakPriceLimit = Close[1];
     }

   if(DownBreakPriceLimit == 0)
     {
      DownBreakPriceLimit = Close[1];
     }

   if(Close[0]+BreakPoint*Point > UpBreakPriceLimit)
     {
      upBreakTimes +=1;
      UpBreakPriceLimit = Close[0]+BreakPoint;
      return ENUM_POSITION_UP;
     }

   if(Close[0]-BreakPoint*Point < DownBreakPriceLimit)
     {
      downBreakTimes +=1;
      DownBreakPriceLimit = Close[0]-BreakPoint;
      return ENUM_POSITION_DOWN;
     }

   return ENUM_POSITION_MID;

  }
//+------------------------------------------------------------------+

// 按钮子函数

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Button(string name, int width, int height, int clr_border, int clr_text, int clr_bg,
            int fontsize, int corner, int xd, int yd, string text)
  {
   ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clr_border);
   ObjectSetInteger(0,name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr_text);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, clr_bg);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontsize);
   ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, xd);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, yd);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
  }


//文本子函数
// name
// width

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void EditText(string name, int width, int height, int clr_border, int clr_text,
              int clr_bg, int fontsize, int corner, int xd, int yd, int align,
              int readonly, string text)
  {
   ObjectCreate(0, name, OBJ_EDIT, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clr_border);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr_text);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, clr_bg);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontsize);
   ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, xd);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, yd);
   ObjectSetInteger(0, name, OBJPROP_ALIGN, align);
   ObjectSetInteger(0, name, OBJPROP_READONLY, readonly);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
  }


//标签子函数
void Lable(string name, int width, int height, int clr_border, int clr_bg, int corner,
           int xd, int yd, bool back)
  {
   ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clr_border);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, clr_bg);
   ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, xd);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, yd);
   ObjectSetInteger(0, name, OBJPROP_BACK, back);
  }
//+------------------------------------------------------------------+
