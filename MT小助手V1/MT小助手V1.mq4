// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                      忆娜纪交易助手.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|  https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482 |
//+------------------------------------------------------------------+
#property copyright "https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482"
#property link      "19956480259"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Mylib\Trade\Ordermanager.mqh>
#include <arrays\list.mqh>

input double OpenLots = 0.01; // 手数
input int OpenMagic = 210727; // 魔术码
input int Slippage = 30; // 滑点
int StopProfit = 0; // 止盈点数
int StopLoss = 0; // 止损点数
int TrailingStopPoint = 0; // 移动止损点数
int PendingBuyOrderPoint = 0; // 挂单买入点数
int PendingSellOrderPoint = 0; // 挂单卖出点数

input int FontSize = 7; // 字体大小

OrderManager *om;
OrderManager *np;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   ObjectDelete(0, "lable");

   ObjectDelete(0, "TEXT1");
   ObjectDelete(0, "TEXT2");
   ObjectDelete(0, "TEXT3");
   ObjectDelete(0, "TEXT4");
   ObjectDelete(0, "TEXT5");
   ObjectDelete(0, "TEXT6");

   ObjectDelete(0, "button1");
   ObjectDelete(0, "button2");
   ObjectDelete(0, "button3");
   ObjectDelete(0, "button4");
   ObjectDelete(0, "button5");
   ObjectDelete(0, "button6");
   ObjectDelete(0, "button7");
   ObjectDelete(0, "button8");
   ObjectDelete(0, "button9");
   ObjectDelete(0, "button10");
   ObjectDelete(0, "button11");
   ObjectDelete(0, "button12");
   ObjectDelete(0, "button13");
   ObjectDelete(0, "button14");
   ObjectDelete(0, "button15");
   ObjectDelete(0, "button16");

   Lable("lable", 150, 370, clrNONE, clrNavy, CORNER_RIGHT_UPPER, 190, 20,false);
   Button("button1", 60, 25, clrNONE, clrBlack, clrDeepPink, FontSize, CORNER_RIGHT_UPPER, 180, 30, "手数");
   EditText("TEXT1", 60, 25, clrNONE, clrBlack, clrWhite, 10, CORNER_RIGHT_UPPER, 110, 30,ALIGN_CENTER, false, (string)OpenLots);

   Button("button2", 60, 25, clrNONE, clrWhite, clrRed, FontSize, CORNER_RIGHT_UPPER, 180, 60, "买入");
   Button("button3", 60, 25, clrNONE, clrWhite, clrRed, 8, CORNER_RIGHT_UPPER, 110, 60, "卖出");

   Button("button4", 60, 25, clrNONE, clrBlack, clrDeepPink, FontSize, CORNER_RIGHT_UPPER, 180, 90, "止损点数");
   EditText("TEXT2", 60, 25, clrBlack, clrBlack, clrWhite, 10, CORNER_RIGHT_UPPER, 110, 90, ALIGN_CENTER, false, (string)StopLoss);

   Button("button5", 60, 25, clrNONE, clrBlack, clrDeepPink, FontSize, CORNER_RIGHT_UPPER, 180, 120, "止盈点数");
   EditText("TEXT3", 60, 25, clrBlack, clrBlack, clrWhite, 10, CORNER_RIGHT_UPPER, 110, 120, ALIGN_CENTER, false, (string)StopProfit);

   Button("button6", 60, 25, clrNONE, clrBlack, clrDeepPink, FontSize, CORNER_RIGHT_UPPER, 180, 150, "移动止损");
   EditText("TEXT4", 60, 25, clrBlack, clrBlack, clrWhite, 10, CORNER_RIGHT_UPPER, 110, 150, ALIGN_CENTER, false, (string)TrailingStopPoint);

   Button("button7", 60, 25, clrNONE, clrBlack, clrDeepPink, FontSize, CORNER_RIGHT_UPPER, 180, 180, "挂单买入");
   EditText("TEXT5", 60, 25, clrBlack, clrBlack, clrWhite, 10, CORNER_RIGHT_UPPER, 110, 180, ALIGN_CENTER, false, (string)PendingBuyOrderPoint);

   Button("button8", 60, 25, clrNONE, clrBlack, clrDeepPink, FontSize, CORNER_RIGHT_UPPER, 180, 210, "挂单卖出");
   EditText("TEXT6", 60, 25, clrBlack, clrBlack, clrWhite, 10, CORNER_RIGHT_UPPER, 110, 210, ALIGN_CENTER, false, (string)PendingSellOrderPoint);

   Button("button9", 130, 25, clrNONE, clrBlack, clrDeepPink, 10, CORNER_RIGHT_UPPER, 180, 240, "删除挂单");

   Button("button10", 130, 25, clrNONE, clrBlack, clrDeepPink, 10, CORNER_RIGHT_UPPER, 180, 270, "全部平仓");

   Button("button11", 60, 25, clrNONE, clrWhite, clrRed, FontSize, CORNER_RIGHT_UPPER, 180, 300, "多单平仓");

   Button("button12", 60, 25, clrNONE, clrWhite, clrGreen, FontSize, CORNER_RIGHT_UPPER, 110, 300, "空单平仓");

   Button("button13", 60, 25, clrNONE, clrWhite, clrRed, FontSize, CORNER_RIGHT_UPPER, 180, 330, "盈利平仓");

   Button("button14", 60, 25, clrNONE, clrWhite, clrGreen, FontSize, CORNER_RIGHT_UPPER, 110, 330, "亏损平仓");

   Button("button15", 60, 25, clrNONE, clrWhite, clrRed, FontSize, CORNER_RIGHT_UPPER, 180, 360, "一键锁单");

   Button("button16", 60, 25, clrNONE, clrWhite, clrGreen, FontSize, CORNER_RIGHT_UPPER, 110, 360, "一键反向");

//EditText("TEXT4", 150, 25, clrNONE, clrNONE, clrPaleGreen, 10, CORNER_RIGHT_UPPER, 175, 210,ALIGN_LEFT, true, (string)instructions);

   om = new OrderManager("OrderManager",OpenMagic,Slippage);
   np = new OrderManager("OrderManager",456874,Slippage);
//---
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
   delete np;
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   datetime NY=D'2021.07.29 08:43:00'; //到期时间
   datetime d1 = TimeLocal();
   Print(TimeLocal());
   if(d1>NY)
     {
      Alert("已到期请续费：",GetLastError());
      Sleep(3000);
      ExpertRemove();
     }
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam)
  {
   double lot = (double)ObjectGetString(0, "TEXT1", OBJPROP_TEXT, 0); //手数
   StopLoss = (int)ObjectGetString(0,"TEXT2",OBJPROP_TEXT,0); // 止损
   StopProfit = (int)ObjectGetString(0,"TEXT3",OBJPROP_TEXT,0); // 止盈
   PendingBuyOrderPoint = (int)ObjectGetString(0,"TEXT5",OBJPROP_TEXT,0); // 挂单买入
   PendingSellOrderPoint = (int)ObjectGetString(0,"TEXT6",OBJPROP_TEXT,0); // 挂单卖出

//多单开仓(买入)
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button2")
     {
      if(ObjectGetInteger(0, "button2", OBJPROP_STATE, 0))
        {
         if(!om.BuyWithStAndTp(lot,StopLoss,StopProfit,true,0,"买入",clrRed))
           {
            Alert("多单开单错误：",GetLastError());
           }
         Print("SL = ",StopLoss," TP = ",StopProfit);
        }
      ObjectSetInteger(0, "button2", OBJPROP_STATE, false);
     }
//空单开仓
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button3")
     {
      if(ObjectGetInteger(0, "button3", OBJPROP_STATE, 0))
        {
         if(!om.SellWithStAndTp(lot,StopLoss,StopProfit,0,0,"卖出",clrLime))
           {
            Alert("空单开单错误：",GetLastError());
           }
         Print("SL = ",StopLoss," TP = ",StopProfit);
        }
      ObjectSetInteger(0, "button3", OBJPROP_STATE, false);
     }

//移动止损
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button6")
     {
      if(ObjectGetInteger(0, "button6", OBJPROP_STATE, 0))
        {
         TrailingStopPoint = (int)ObjectGetString(0,"TEXT4",OBJPROP_TEXT,0); // 移动止损
         CList *bl = om.GetAllBuyOpenningList();
         CList *sl = om.GetAllSellOpenningList();
         setTraceStopLoss(bl);
         setTraceStopLoss(sl);
         om.Update();
        }
      ObjectSetInteger(0, "button6", OBJPROP_STATE, false);
     }
//挂单买入
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button7")
     {
      if(ObjectGetInteger(0, "button7", OBJPROP_STATE, 0))
        {
         if(!om.PennigBuyWithPoint(PendingBuyOrderPoint,lot,0,0,0,"挂单买入",clrRed))
           {
            Alert("挂单买入错误：",GetLastError());
           }
        }
      ObjectSetInteger(0, "button7", OBJPROP_STATE, false);
     }

//挂单卖出
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button8")
     {
      if(ObjectGetInteger(0, "button8", OBJPROP_STATE, 0))
        {
         if(!om.PennigSellWithPoint(PendingSellOrderPoint,lot,0,0,0,"挂单卖出",clrLime))
           {
            Alert("挂单卖出错误：",GetLastError());
           }
        }
      ObjectSetInteger(0, "button8", OBJPROP_STATE, false);
     }

//删除挂单
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button9")
     {
      if(ObjectGetInteger(0, "button9", OBJPROP_STATE, 0))
        {
         for(int cnt=OrdersTotal(); cnt>=0; cnt--)
           {
            if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
              {
               if(OrderType()==OP_BUYLIMIT || OrderType()==OP_BUYSTOP || OrderType()==OP_SELLLIMIT || OrderType()==OP_SELLSTOP)
                 {
                  if(!OrderDelete(OrderTicket()))
                    {
                     Alert(GetLastError());
                    }
                 }
              }
           }
        }
      ObjectSetInteger(0, "button9", OBJPROP_STATE, false);
     }


// 全部平仓
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button10")
     {
      if(ObjectGetInteger(0, "button10", OBJPROP_STATE, 0))
        {
         for(int cnt=OrdersTotal(); cnt>=0; cnt--)
           {
            if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol())
              {
               if(OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT || OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP)
                  if(!OrderDelete(OrderTicket()))
                    {
                     Alert(GetLastError());
                    }
               if(OrderType()==OP_BUY)
                 {
                  if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Green))
                    {
                     Alert(GetLastError());
                    }
                 }
               if(OrderType()==OP_SELL)
                 {
                  if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Green))
                    {
                     Alert(GetLastError());
                    }
                 }
              }
           }
        }
      ObjectSetInteger(0, "button10", OBJPROP_STATE, false);
     }
//多单平仓
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="button11")
     {
      if(ObjectGetInteger(0,"button11",OBJPROP_STATE,0))
        {
         if(!om.CloseAllBuyOrders())
           {
            Alert(GetLastError());
           }
        }
      ObjectSetInteger(0,"button11",OBJPROP_STATE,false);
     }
//空单平仓
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button12")
     {
      if(ObjectGetInteger(0, "button12", OBJPROP_STATE,0))
        {
         if(!om.CloseAllSellOrders())
           {
            Alert(GetLastError());
           }
        }
      ObjectSetInteger(0, "button12", OBJPROP_STATE, false);
     }
//盈利平仓
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button13")
     {
      if(ObjectGetInteger(0, "button13", OBJPROP_STATE,0))
        {
         if(!om.CloseProfitOrders())
           {
            Alert(GetLastError());
           }
        }
      ObjectSetInteger(0, "button13", OBJPROP_STATE, false);
     }
//亏损平仓
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button14")
     {
      if(ObjectGetInteger(0, "button14", OBJPROP_STATE,0))
        {
         if(!om.CloseLossOrders())
           {
            Alert(GetLastError());
           }
        }
      ObjectSetInteger(0, "button14", OBJPROP_STATE, false);
     }
//一键锁单 第一步，获取当前的单子，第二步，下相反的单子
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button15")
     {
      int i;
      if(ObjectGetInteger(0, "button15", OBJPROP_STATE,0))
        {
         for(i=OrdersTotal()-1; i>=0; i--)
           {
            if(OrderSelect(i,SELECT_BY_POS))
              {
               if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
                 {
                  int ticket1 = om.Sell(lot,clrRed);
                  if(ticket1 < 0)
                    {
                     Alert("锁单空单开仓错误，错误代码：",GetLastError());
                    }
                 }
               if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
                 {
                  int ticket2 = om.Buy(lot,clrLime);
                  if(ticket2 < 0)
                    {
                     Alert("锁单多单开仓错误，错误代码：",GetLastError());
                    }
                 }
              }
           }
        }
      ObjectSetInteger(0, "button15", OBJPROP_STATE, false);
     }
//一键反向 把之前的单子全平了，再下相反的单子
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button16")
     {
      //int i;
      if(ObjectGetInteger(0, "button16", OBJPROP_STATE,0))
        {
         om.ReverseOrder();
         om.Update();
        }
      ObjectSetInteger(0, "button16", OBJPROP_STATE, false);
     }


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setTraceStopLoss(CList *list)
  {

   if(list.Total()>0)
     {
      list.MoveToIndex(0);
      OrderInfo *oos = (OrderInfo *)list.GetCurrentNode();
      while(oos!=NULL)
        {
         Print(oos.GetType());
         oos.Update();
         if(oos.GetState() == ORDER_STATE_OPENING)
           {
            oos.SetTraceStopLoss(TrailingStopPoint);
           }
         oos = (OrderInfo *)list.GetNextNode();
        }
     }
  }
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

//+------------------------------------------------------------------+
