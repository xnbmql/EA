//+------------------------------------------------------------------+
//|                                                        ttttt.mq4 |
//|                                                 992249804@qq.com |
//|                                     http://shop.zbj.com/23451428 |
//+------------------------------------------------------------------+
#property copyright "992249804@qq.com"
#property link      "http://shop.zbj.com/23451428"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   ObjectDelete(0,"lable");
   ObjectDelete(0,"button");
   ObjectDelete(0,"TEXT");
   ObjectDelete(0,"button1");
   ObjectDelete(0,"TEXT1");
   ObjectDelete(0,"button2");
   ObjectDelete(0,"TEXT2");
   ObjectDelete(0,"button3");
   ObjectDelete(0,"TEXT3");
   ObjectDelete(0,"button4");
   ObjectDelete(0,"button5");
   ObjectDelete(0,"button6");
   ObjectDelete(0,"TEXT4");
   ObjectDelete(0,"button7");
   ObjectDelete(0,"button8");
   ObjectDelete(0,"button9");
   ObjectDelete(0,"button10");
   ObjectDelete(0,"button11");
   ObjectDelete(0,"button12");

   lable("lable",180,280,clrDarkViolet,clrLightSlateGray,CORNER_RIGHT_UPPER,190,
         10,false);

   button("button1",50,25,clrNONE,clrBlack,clrDeepPink,10,CORNER_RIGHT_UPPER,175,20,"Lot",true);
   edittext("TEXT1",100,25,clrBlack,clrBlack,clrWhite,10,CORNER_RIGHT_UPPER,125,20,ALIGN_CENTER,false,"0.01");

   button("button2",50,25,clrNONE,clrBlack,clrDeepPink,10,CORNER_RIGHT_UPPER,175, 50,"SL",true);
   edittext("TEXT2",100,25,clrBlack,clrBlack,clrWhite,10,CORNER_RIGHT_UPPER,125, 50,ALIGN_CENTER,false,"100");

   button("button3",50,25,clrNONE,clrBlack,clrDeepPink,10,CORNER_RIGHT_UPPER,175, 80,"TP",true);
   edittext("TEXT3",100,25,clrBlack,clrBlack,clrWhite,10,CORNER_RIGHT_UPPER,125,80,ALIGN_CENTER,false,"100");

   button("button4",70,30,clrNONE,clrWhite,clrRed,10,CORNER_RIGHT_UPPER,175, 110,"BUY", false);
   button("button5",70,30,clrNONE,clrWhite,clrGreen,10,CORNER_RIGHT_UPPER,95,
          110,"SELL", false);
   button("button6",50,25,clrNONE,clrBlack,clrDeepPink,10,CORNER_RIGHT_UPPER,175, 145,"Price",true);
   edittext("TEXT4",100,25,clrBlack,clrBlack,clrWhite,10,CORNER_RIGHT_UPPER,125,
            145,ALIGN_CENTER,false,"0");

   button("button7",70,30,clrNONE,clrWhite,clrRed,10,CORNER_RIGHT_UPPER,175, 175,"BUYLIMIT", false);
   button("button8",70,30,clrNONE,clrWhite,clrGreen,10,CORNER_RIGHT_UPPER,95,
          175,"SELLLIMIT", false);

   button("button9",70,30,clrNONE,clrWhite,clrRed,10,CORNER_RIGHT_UPPER,175, 210,"BUYSTOP", false);
   button("button10",70,30,clrNONE,clrWhite,clrGreen,10,CORNER_RIGHT_UPPER,95,
          210,"SELLSTOP", false);

   button("button11",70,30,clrNONE,clrWhite,clrRed,10,CORNER_RIGHT_UPPER,175, 245," Close", false);
   button("button12",70,30,clrNONE,clrWhite,clrGreen,10,CORNER_RIGHT_UPPER,95,
          245," Delete", false);

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectDelete(0,"lable");
   ObjectDelete(0,"button");
   ObjectDelete(0,"TEXT");
   ObjectDelete(0,"button1");
   ObjectDelete(0,"TEXT1");
   ObjectDelete(0,"button2");
   ObjectDelete(0,"TEXT2");
   ObjectDelete(0,"button3");
   ObjectDelete(0,"TEXT3");
   ObjectDelete(0,"button4");
   ObjectDelete(0,"button5");
   ObjectDelete(0,"button6");
   ObjectDelete(0,"TEXT4");
   ObjectDelete(0,"button7");
   ObjectDelete(0,"button8");
   ObjectDelete(0,"button9");
   ObjectDelete(0,"button10");
   ObjectDelete(0,"button11");
   ObjectDelete(0,"button12");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   double lot=(double)ObjectGetString(0,"TEXT1",OBJPROP_TEXT,0);
   double price=(double)ObjectGetString(0,"TEXT4",OBJPROP_TEXT,0);
   double sl;
   double tp;
   int check;
   int mag=12345;
   int huadian=10;
   string sym= Symbol();
   int i;
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="button4")
     {
      //买单按钮设置
      if(ObjectGetInteger(0,"button4",OBJPROP_STATE,0))
        {
         sl=MarketInfo(Symbol(),MODE_BID)-(int)ObjectGetString(0,"TEXT2",
               OBJPROP_TEXT,0)*MarketInfo(Symbol(),MODE_POINT)*10;
         tp=MarketInfo(Symbol(),MODE_BID)+(int)ObjectGetString(0,"TEXT3",
               OBJPROP_TEXT,0)*MarketInfo(Symbol(),MODE_POINT)*10;
         check=OrderSend(Symbol(),OP_BUY,lot,MarketInfo(Symbol(),MODE_ASK),
                         huadian,sl,tp,"BUY",mag,0,clrBlue);
        }
      ObjectSetInteger(0,"button4",OBJPROP_STATE,false);
     }
//卖单按钮设置
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="button5")
     {
      if(ObjectGetInteger(0,"button5",OBJPROP_STATE,0))
        {
         sl=MarketInfo(Symbol(),MODE_ASK)+(int)ObjectGetString(0,"TEXT2",
               OBJPROP_TEXT,0)*MarketInfo(Symbol(),MODE_POINT)*10;
         tp=MarketInfo(Symbol(),MODE_ASK)-(int)ObjectGetString(0,"TEXT3",
               OBJPROP_TEXT,0)*MarketInfo(Symbol(),MODE_POINT)*10;
         check=OrderSend(sym,OP_SELL,lot,MarketInfo(sym,MODE_BID),
                         huadian,sl,tp,"SELL",mag,0,clrRed);
        }
      ObjectSetInteger(0,"button5",OBJPROP_STATE,false);
     }
//买单限价挂单
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="button7")
     {
      if(ObjectGetInteger(0,"button7",OBJPROP_STATE,0)==true &&
         price<MarketInfo(Symbol(),MODE_ASK))
        {
         sl=price-(int)ObjectGetString(0,"TEXT2",OBJPROP_TEXT,0)*
            MarketInfo(Symbol(),MODE_POINT)*10;
         tp=price+(int)ObjectGetString(0,"TEXT3",OBJPROP_TEXT,0)*
            MarketInfo(Symbol(),MODE_POINT)*10;
         check=OrderSend(sym,OP_BUYLIMIT,lot,price,huadian,sl,tp,"BUY",mag,0,clrBlue);
        }
      ObjectSetInteger(0,"button7",OBJPROP_STATE,false);
     }
//卖单限价挂单
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="button8")
     {
      if(ObjectGetInteger(0,"button8",OBJPROP_STATE,0)==true &&
         price>MarketInfo(Symbol(),MODE_BID))
        {
         sl=price+(int)ObjectGetString(0,"TEXT2",OBJPROP_TEXT,0)*
            MarketInfo(Symbol(),MODE_POINT)*10;
         tp=price-(int)ObjectGetString(0,"TEXT3",OBJPROP_TEXT,0)*
            MarketInfo(Symbol(),MODE_POINT)*10;
         check=OrderSend(sym,OP_SELLLIMIT,lot,price,huadian,sl,tp,"SELL",mag,0,clrRed);
        }
      ObjectSetInteger(0,"button8",OBJPROP_STATE,false);
     }
//买单止损挂单
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="button9")
     {
      if(ObjectGetInteger(0,"button9",OBJPROP_STATE,0)==true &&
         price>MarketInfo(Symbol(),MODE_ASK))
        {
         sl=price-(int)ObjectGetString(0,"TEXT2",OBJPROP_TEXT,0)*
            MarketInfo(Symbol(),MODE_POINT)*10;
         tp=price+(int)ObjectGetString(0,"TEXT3",OBJPROP_TEXT,0)*
            MarketInfo(Symbol(),MODE_POINT)*10;
         check=OrderSend(sym,OP_BUYSTOP,lot,price,huadian,sl,tp,"BUY",mag,0,clrBlue);
        }
      ObjectSetInteger(0,"button9",OBJPROP_STATE,false);
     }
//卖单止损挂单
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="button10")
     {
      if(ObjectGetInteger(0,"button10",OBJPROP_STATE,0)==true &&
         price<MarketInfo(Symbol(),MODE_BID))
        {
         sl=price+(int)ObjectGetString(0,"TEXT2",OBJPROP_TEXT,0)*
            MarketInfo(Symbol(),MODE_POINT)*10;
         tp=price-(int)ObjectGetString(0,"TEXT3",OBJPROP_TEXT,0)*
            MarketInfo(Symbol(),MODE_POINT)*10;
         check=OrderSend(sym,OP_SELLSTOP,lot,price,huadian,sl,tp,"SELL",mag,0,clrRed);
        }
      ObjectSetInteger(0,"button10",OBJPROP_STATE,false);
     }
//平仓
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="button11")
     {
      if(ObjectGetInteger(0,"button11",OBJPROP_STATE,0)==true)
        {
         for(i=OrdersTotal()-1; i>=0; i--)
           {
            if(OrderSelect(i,SELECT_BY_POS))
              {
               if(OrderSymbol()==sym && OrderMagicNumber()==mag)
                 {
                  if(OrderType()==OP_SELL)
                    {
                     check=OrderClose(OrderTicket(),OrderLots(),
                                      MarketInfo(sym,MODE_ASK),huadian);
                    }
                  else
                     if(OrderType()==OP_BUY)
                       {
                        check=OrderClose(OrderTicket(),OrderLots(),
                                         MarketInfo(sym,MODE_BID),huadian);
                       }
                 }
              }
           }
        }
      ObjectSetInteger(0,"button11",OBJPROP_STATE,false);
     }
//删除挂单
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="button12")
     {
      if(ObjectGetInteger(0,"button12",OBJPROP_STATE,0)==true)
        {
         for(i=OrdersTotal()-1; i>=0; i--)
           {
            if(OrderSelect(i,SELECT_BY_POS))
              {
               if(OrderSymbol()==sym && OrderMagicNumber()==mag)
                 {
                  if(OrderType()==OP_SELLLIMIT || OrderType()==OP_BUYLIMIT ||
                     OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP)
                    {
                     check=OrderDelete(OrderTicket(),clrRed);
                    }
                 }
              }
           }
        }
      ObjectSetInteger(0,"button12",OBJPROP_STATE,false);
     }
   if(check < 0)
     {
      Print("开单错误，错误代码是:  ", GetLastError());
      return;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void button(string name,int width,int height,int clr_border,int clr_text,int clr_bg,
            int fontsize,int corner,int xd,int yd,string text, bool select)
  {
   ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR, clr_border);
   ObjectSetInteger(0,name,OBJPROP_XSIZE, width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE, height);
   ObjectSetInteger(0,name,OBJPROP_COLOR, clr_text);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR, clr_bg);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE, fontsize);
   ObjectSetInteger(0,name,OBJPROP_CORNER, corner);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE, xd);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE, yd);
   ObjectSetString(0,name,OBJPROP_TEXT, text);
   ObjectSetInteger(0,name, OBJPROP_SELECTABLE, select);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void edittext(string name,
              int width,
              int height,
              int clr_border,
              int clr_text,
              int clr_bg,
              int fontsize,
              int corner,
              int xd,
              int yd,
              int align,
              int readonly,
              string text)
  {
   ObjectCreate(0, name,OBJ_EDIT,0,0,0);
   ObjectSetInteger(0, name,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR, clr_border);
   ObjectSetInteger(0,name,OBJPROP_COLOR, clr_text);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR, clr_bg);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE, fontsize);
   ObjectSetInteger(0,name,OBJPROP_CORNER, corner);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE, xd);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE, yd);
   ObjectSetInteger(0,name,OBJPROP_ALIGN, align);
   ObjectSetInteger(0,name,OBJPROP_READONLY, readonly);
   ObjectSetString(0,name,OBJPROP_TEXT, text);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void lable(string name,
           int width,
           int height,
           int clr_border,
           int clr_bg,
           int corner,
           int xd,
           int yd,
           bool back)
  {
   ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clr_border);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clr_bg);
   ObjectSetInteger(0,name,OBJPROP_CORNER,corner);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,xd);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,yd);
   ObjectSetInteger(0,name,OBJPROP_BACK,back);
  }
//+------------------------------------------------------------------+
