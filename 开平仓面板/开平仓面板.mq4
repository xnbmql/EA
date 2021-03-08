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
int OnInit()
  {
//---
   
//---
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
   
  }
//+------------------------------------------------------------------+

//开仓函数
void openOrder(){
   
   int orderTicket1  = OrderSend(Symbol(),OP_BUY,手数,Ask,Slippage,0,0,开仓备注,开仓magic码,0,clrGreen);
   int orderTicket2  = OrderSend(Symbol(),OP_SELL,手数,Bid,Slippage,0,0,开仓备注,开仓magic码,0,clrGreen);
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