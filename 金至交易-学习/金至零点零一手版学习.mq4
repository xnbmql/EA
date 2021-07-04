//+------------------------------------------------------------------+
//|                                                     0.01学习.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//anniu("closeall",Red,15,15,"平所有货币市价单");
   anniu("buy",Red,15,55,"BUY");
   anniu("closeallben",Red,15,35,"CLOSE");
   anniu("sell",Red,15,75,"SELL");
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
   int t=OrdersTotal();
   for(int i=t-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==0 && OrderSymbol()==Symbol()&&OrderComment()==Symbol()+"buy")
           {
            buy(0,0,0,Symbol(),0);
           }
         if(OrderType()==1 && OrderSymbol()==Symbol()&&OrderComment()==Symbol()+"sell")
           {
            sell(0,0,0,Symbol(),0);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(sparam=="closeall")
        {
         //Alert("平仓按钮按下");
         closeall();
        }

      if(sparam=="closeallben")
        {
         //Alert("平仓按钮按下");
         closeallben();
        }
      if(sparam=="buy")
        {
         //Alert("平仓按钮按下");
         buy(0,0,0,Symbol()+"buy",0);
        }
      if(sparam=="sell")
        {
         //Alert("平仓按钮按下");
         sell(0,0,0,Symbol()+"sell",0);
        }
      ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
     }
  }
//+------------------------------------------------------------------+
void anniu(string name,color yanse,int x,int y,string text,int changdu=0)
  {
   ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_COLOR,yanse);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrLime);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   if(changdu==0)
     {
      int as=StringLen(text);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,as*17);
     }
   else
     {
      ObjectSetInteger(0,name,OBJPROP_XSIZE,changdu);
     }
   ObjectSetInteger(0,name,OBJPROP_YSIZE,20);
   ObjectSetString(0,name,OBJPROP_FONT,"Arial");
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrBlue);
//ObjectSetInteger(0,name,OBJPROP_CORNER,0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closeallben()
  {
   int t=OrdersTotal();
   for(int i=t-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()<=1 && OrderSymbol()==Symbol())
           {
           // todo 这里需要check错误
            OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Green);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closeall()
  {
   int t=OrdersTotal();
   for(int i=t-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()<=1)
           {
           // todo 这里需要check错误
            OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Green);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int buy(double Lots,double sun,double ying,string comment,int magic)
  {
// 和sell 其实逻辑相同，这两个函数可以合起来，这里不写了


// 这里的主体逻辑就是计算可以买多少手
// 但是没有考虑到最大手数
   double maxlot = MarketInfo(Symbol(),MODE_MAXLOT);
   double minlot    = MarketInfo(Symbol(),MODE_MINLOT);
   while(true)
     {


      // 账户可用保证金*0.01/(账户可用保证金-买了0.01手后剩余的保证金) 逻辑是计算买光仓内金额需要的手数
      Lots=NormalizeDouble(AccountFreeMargin()*0.01/(AccountFreeMargin()-(AccountFreeMarginCheck(NULL,OP_BUY,0.01)-1)),2);

      // 如果超过当前的最大手数限制，就只用最大手数，等下一次循环
      if(Lots > maxlot)
        {
         Lots = maxlot;
        }
      // 可能低于最小值，这个时候报警不能买卖了
      if(Lots < minlot)
        {
         Alert("当前余额已经不足以购买最小手数订单");
         return 0;
        }
      int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,300,0,0,comment,magic,0,White);
      if(ticket>0)
        {
         return(ticket);
        }
      else
        {
         Alert("Buy 下单出错：", GetLastError());
         return(0);
        }
      // 跳出while循环条件 再注释跟你解释下，如果当前手数不超过最大手数，说明已经买光手里的余额了
      if(Lots < maxlot)
        {
        Alert("已经买完了");
         break;
        }
     }
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int sell(double Lots,double sun,double ying,string comment,int magic)
  {

// 这里的主体逻辑就是计算可以买多少手
// 但是没有考虑到最大手数
   double maxlot = MarketInfo(Symbol(),MODE_MAXLOT);
   double minlot    = MarketInfo(Symbol(),MODE_MINLOT);
   while(true)
     {
      // 账户可用保证金*0.01/(账户可用保证金-买了0.01手后剩余的保证金) 逻辑是计算买光仓内金额需要的手数
      Lots=NormalizeDouble(AccountFreeMargin()*0.01/(AccountFreeMargin()-(AccountFreeMarginCheck(NULL,OP_BUY,0.01)-1)),2);
      // 如果超过当前的最大手数限制，就只用最大手数，等下一次循环
      if(Lots > maxlot)
        {
         Lots = maxlot;
        }
      // todo：可能低于最小值，这个时候报警不能买卖了
      if(Lots < minlot)
        {
         Alert("当前余额已经不足以购买最小手数订单");
         break;
        }

      int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,300,0,0,comment,magic,0,Red);
      if(ticket>0)
        {
         return(ticket);
        }
      else
        {
         Alert("Sell 下单出错：", GetLastError());
         return(0);
        }

      // 跳出while循环条件
      if(Lots < maxlot)
        {
         Alert("已经买完了");
         break;
        }
     }
   return 0;


  }



//+------------------------------------------------------------------+
