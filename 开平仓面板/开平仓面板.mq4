//+------------------------------------------------------------------+
//|                                                        开平仓面板.mq4 |
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

input double OpenLots = 0.01;
//input int OpenMagic = 314159;
//input string OpenComment = "hello";
//input int Slippage = 30;
input int 止损 = -10000;
input int 止盈 = 10000;


double sl;
double tp;
int OnInit()
  {
//---
   //ObjectDelete(0, "Lable");
   //Lable("Lable", 180, 280, clrDarkViolet, clrBlueViolet, CORNER_RIGHT_UPPER,
   //      190, 10, false);
   
   ObjectDelete(0, "lable");
   ObjectDelete(0, "button");
   ObjectDelete(0, "TEXT");
   ObjectDelete(0, "button1");
   ObjectDelete(0, "TEXT1");
   ObjectDelete(0, "button2");
   ObjectDelete(0, "TEXT2");
   ObjectDelete(0, "button3");
   ObjectDelete(0, "TEXT3");
   ObjectDelete(0, "button4");
   ObjectDelete(0, "TEXT4");
   ObjectDelete(0, "button5");
   ObjectDelete(0, "TEXT5");
   ObjectDelete(0, "button6");
   ObjectDelete(0, "TEXT6");
   ObjectDelete(0, "button7");
   ObjectDelete(0, "TEXT7");
   
   Lable("lable", 180, 280, clrDarkViolet, clrLightSlateGray, CORNER_RIGHT_UPPER, 190, 10,false);
   
   Button("button1", 50, 25, clrNONE, clrBlack, clrDeepPink, 10, CORNER_RIGHT_UPPER, 175, 20, "手数");
   EditText("TEXT1", 100, 25, clrBlack, clrBlack, clrWhite, 10, CORNER_RIGHT_UPPER, 125, 20,ALIGN_LEFT, true, (string)OpenLots);
   
   Button("button2", 50, 25, clrNONE, clrBlack, clrDeepPink, 10, CORNER_RIGHT_UPPER, 175, 50, "止损");
   EditText("TEXT2", 100, 25, clrBlack, clrBlack, clrWhite, 10, CORNER_RIGHT_UPPER, 125, 50, ALIGN_LEFT, true, (string)sl);
   
   Button("button3", 50, 25, clrNONE, clrBlack, clrDeepPink, 10, CORNER_RIGHT_UPPER, 175, 80, "止盈");
   EditText("TEXT3", 100, 25, clrBlack, clrBlack, clrWhite, 10, CORNER_RIGHT_UPPER, 125, 80, ALIGN_LEFT, true, (string)tp);
   
   Button("button4", 150, 25, clrNONE, clrBlack, clrDeepPink, 10, CORNER_RIGHT_UPPER, 175, 145, "全部平仓");
   
   Button("button5", 70, 30, clrNONE, clrWhite, clrRed, 10, CORNER_RIGHT_LOWER, 175, 255, "做多");
   
   Button("button6", 70, 30, clrNONE, clrWhite, clrGreen, 10, CORNER_RIGHT_UPPER, 95, 110, "做空");
   
   Button("button7", 70, 30, clrNONE, clrWhite, clrRed, 10, CORNER_RIGHT_UPPER, 175, 175, "平多");
   
   Button("button8", 70, 30, clrNONE, clrWhite, clrGreen, 10, CORNER_RIGHT_UPPER, 95, 175, "平空");
      
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
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+

void OnChartEvent(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam)
  {
      double lot = (double)ObjectGetString(0, "TEXT1", OBJPROP_TEXT, 0);
      //double price = (double)ObjectGetString(0, "")
      //double sl;
      //double tp;
      int check;
      int magic = 342422;
      int Slippage = 30;
      //int i;
      if(id == CHARTEVENT_OBJECT_CLICK && sparam == "button5")
        {
         if(ObjectGetInteger(0, "button5", OBJPROP_STATE, 0))
           {
            sl = MarketInfo(Symbol(),MODE_BID) - (int)ObjectGetString(0, "TEXT2", OBJPROP_TEXT, 0)*MarketInfo(Symbol(), MODE_POINT)*10;
            tp = MarketInfo(Symbol(),MODE_BID) + (int)ObjectGetString(0, "TEXT3", OBJPROP_TEXT, 0)*MarketInfo(Symbol(), MODE_POINT)*10;
            check = OrderSend(Symbol(), OP_BUY, lot, MarketInfo(Symbol(), MODE_ASK), Slippage, sl, tp, "做多", magic, 0, clrAliceBlue);
           }
           ObjectSetInteger(0, "button5", OBJPROP_STATE, false);
        }
  }

//开仓函数
void openOrder(){
   
   //int orderTicket1  = OrderSend(Symbol(),OP_BUY,OpenLots,Ask,Slippage,0,0,OpenComment,OpenMagic,0,clrAqua);
   //int orderTicket2  = OrderSend(Symbol(),OP_SELL,OpenLots,Bid,Slippage,0,0,OpenComment,OpenMagic,0,clrAliceBlue);
}



//平仓函数
int Magic = OrderMagicNumber();
void closeall()

  {

   for(int cnt=OrdersTotal(); cnt>=0; cnt--)

     {

      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true && OrderMagicNumber()== Magic && OrderSymbol()==Symbol())

        {

         if(OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT || OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP)

            if(!OrderDelete(OrderTicket()))
               Alert(GetLastError());

         if(OrderType()==OP_BUY)

            if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Green))
               Alert(GetLastError());

         if(OrderType()==OP_SELL)

            if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Green))
               Alert(GetLastError());

        }

     }

  }
  
// 开仓平仓按钮，多单空单下单按钮，手数的面板
 
 // 按钮子函数
 
 void Button(string name, int width, int height, int clr_border, int clr_text, int clr_bg,
 int fontsize, int corner, int xd, int yd, string text){
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
 void EditText(string name, int width, int height, int clr_border, int clr_text,
               int clr_bg, int fontsize, int corner, int xd, int yd, int align,
               int readonly, string text){
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
            int xd, int yd, bool back){
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
 
 