// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                               Moving Average.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link        "http://www.mql4.com"
#property description "Moving Average sample expert advisor"
#property strict
#define MAGICMA  20210607

//--- Inputs
input double Lots          =0.01;//手数

input int    MovingPeriod5  =60;//5分钟均线周期
input int    MovingPeriod15  =60;//15分钟均线周期
input int    MovingPeriod60  =60;//60分钟均线周期
input int    MovingPeriod240  =120;//240分钟均线周期
input int    MovingShift   =2;//均线平移
input int baobenStart=400;// 盈利保本启动点数
input int baobenMore=100;// 保本多保点数
extern double bili=50;//百分比
datetime time;
//+------------------------------------------------------------------+
//| Calculate open positions                                         |
//+------------------------------------------------------------------+
int CalculateCurrentOrders(string symbol)
  {
   int buys=0,sells=0;
//---
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
         break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)
            buys++;
         if(OrderType()==OP_SELL)
            sells++;
        }
     }
//--- return orders volume
   if(buys>0)
     {
      return(buys);
     }
   else
     {
      return(-sells);
     }
  }

//+------------------------------------------------------------------+
//| Check for open order conditions                                  |
//+------------------------------------------------------------------+
void CheckForOpen()
  {
   double ma5,ma51,ma15,ma60,ma240;
   int    res;

//--- get Moving Average
   ma5=iMA(NULL,5,MovingPeriod5,MovingShift,MODE_SMA,PRICE_CLOSE,0);
   ma51=iMA(NULL,5,MovingPeriod5,MovingShift,MODE_SMA,PRICE_CLOSE,1);
   ma15=iMA(NULL,15,MovingPeriod15,MovingShift,MODE_SMA,PRICE_CLOSE,0);
   ma60=iMA(NULL,60,MovingPeriod60,MovingShift,MODE_SMA,PRICE_CLOSE,0);
   ma240=iMA(NULL,240,MovingPeriod240,MovingShift,MODE_SMA,PRICE_CLOSE,0);
// 5周期当前柱收盘价 在 当前柱均线下面
// 5周期上一柱柱收盘价 在 上一柱均线上面
// 15周期收盘价在   15均线下面    实时柱
// 60 在 60均线 下    实时柱
// 240 在 240 下面   实时柱
//--- sell conditions
   if(iClose(Symbol(),5,0)<ma5&&iClose(Symbol(),5,1)>ma51&&iClose(Symbol(),15,0)<ma15&&iClose(Symbol(),60,0)<ma60&&iClose(Symbol(),240,0)<ma240)
     {
      res=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,0,"",MAGICMA,0,Red);
      time=Time[0];
      return;
     }
//--- buy conditions
   if(iClose(Symbol(),5,0)>ma5&&iClose(Symbol(),5,1)<ma51&&iClose(Symbol(),15,0)>ma15&&iClose(Symbol(),60,0)>ma60&&iClose(Symbol(),240,0)>ma240)
     {
      res=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,0,"",MAGICMA,0,Blue);
      time=Time[0];
      return;
     }
//---
  }
//+------------------------------------------------------------------+
//| Check for close order conditions                                 |
//+------------------------------------------------------------------+
void CheckForClose()
  {
   double ma5,ma15,ma60,ma240;

//--- get Moving Average
   ma5=iMA(NULL,5,MovingPeriod5,MovingShift,MODE_SMA,PRICE_CLOSE,0);
   ma15=iMA(NULL,15,MovingPeriod15,MovingShift,MODE_SMA,PRICE_CLOSE,0);
   ma60=iMA(NULL,60,MovingPeriod60,MovingShift,MODE_SMA,PRICE_CLOSE,0);
   ma240=iMA(NULL,240,MovingPeriod240,MovingShift,MODE_SMA,PRICE_CLOSE,0);
   Print(iClose(Symbol(),60,0));
//---
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
         break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol())
         continue;
      //--- check order type
      if(OrderType()==OP_BUY)
        {
         if(//iClose(Symbol(),5,0)<ma5&&iClose(Symbol(),15,0)<ma15&&
            iClose(Symbol(),60,0)<ma60
            //&&iClose(Symbol(),240,0)<ma240
         )
           {
            if(!OrderClose(OrderTicket(),OrderLots(),Bid,3,White))
               Print("OrderClose error ",GetLastError());
           }
         break;
        }
      if(OrderType()==OP_SELL)
        {
         if(//iClose(Symbol(),5,0)>ma5&&iClose(Symbol(),15,0)>ma15&&
            iClose(Symbol(),60,0)>ma60
            // &&iClose(Symbol(),240,0)>ma240
         )
           {
            if(!OrderClose(OrderTicket(),OrderLots(),Ask,3,White))
               Print("OrderClose error ",GetLastError());
           }
         break;
        }
     }
//---
  }
//+------------------------------------------------------------------+
//| OnTick function                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- check for history and trading
   if(Bars<100 || IsTradeAllowed()==false)
      return;
//Print(AccountFreeMargin());
   if((AccountFreeMargin()/AccountBalance())<(bili/100))
      return;

//--- calculate open orders by current symbol
   if(time!=Time[0])
     {
      CheckForOpen();
      CheckForClose();
     }
////---
//   TPbaoben(Symbol(),baobenStart,baobenMore,0);
//   TPbaobenSel(Symbol(),baobenStart,baobenMore,1);
  }
//+------------------------------------------------------------------+
void TPbaoben(string sym,int point,int pointMore,int path)
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS) && OrderSymbol()==sym && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==path)
           {
            // double price = StringToDouble(DoubleToString(OrderOpenPrice()+((fabs(OrderSwap())+fabs(OrderCommission()))/OrderLots()*MarketInfo(sym,MODE_POINT)) + pointMore * Point(),int(SymbolInfoInteger(sym,SYMBOL_DIGITS))));
            double price = StringToDouble(DoubleToString(OrderOpenPrice()+((fabs(OrderSwap())+fabs(OrderCommission()))/OrderLots()*MarketInfo(sym,MODE_POINT)) + pointMore * Point(),int(SymbolInfoInteger(sym,SYMBOL_DIGITS))));
            if(SymbolInfoDouble(sym,SYMBOL_ASK) > OrderOpenPrice()+point*MarketInfo(sym,MODE_POINT) && OrderStopLoss()<price)
              {
               if(!OrderModify(OrderTicket(),SymbolInfoDouble(sym,SYMBOL_ASK),price,OrderTakeProfit(),0,NULL))
                 {
                  Print("多单保本止盈失败，失败订单号：",OrderTicket()," >> 失败原因：",GetLastError()," 止损=",price);
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TPbaobenSel(string sym,int point,int pointMore,int path)
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS) && OrderSymbol()==sym && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==path)
           {
            //Print("sl=",OrderStopLoss() > StrToDouble(DoubleToString(OrderOpenPrice()-((fabs(OrderSwap())+fabs(OrderCommission()))/OrderLots()*MarketInfo(sym,MODE_POINT)) - pointMore * Point(),Digits)));
            double price = StringToDouble(DoubleToString(OrderOpenPrice()-((fabs(OrderSwap())+fabs(OrderCommission()))/OrderLots()*MarketInfo(sym,MODE_POINT)) - pointMore * Point(),int(SymbolInfoInteger(sym,SYMBOL_DIGITS))));
            if(SymbolInfoDouble(sym,SYMBOL_BID) < OrderOpenPrice()-point*MarketInfo(sym,MODE_POINT) && (OrderStopLoss()>price || OrderStopLoss() == 0))
              {
               if(!OrderModify(OrderTicket(),SymbolInfoDouble(sym,SYMBOL_BID),price,OrderTakeProfit(),0,NULL))
                 {
                  Print("空单保本止盈失败，失败订单号：",OrderTicket()," >> 失败原因：",(GetLastError())," 止损=",price);
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
