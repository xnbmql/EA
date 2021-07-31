// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                 OrderManager.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Object.mqh>
#include <arrays\list.mqh>
#include "trade.mqh"


// enum ENUM_ORDER_TYPE
// {
//   ORDER_TYPE_ALL = 0;
//   ORDER_TYPE_CURRENT = 1;
//   ORDER_TYPE_OTHER = 2;
//   ORDER_TYPE_PENDING = 3;
// }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderManager: public CObject
  {
public:
                     OrderManager(string comment,int magic, int slippage);
                     OrderManager(string symbol,string comment,int magic, int slippage);
                    ~OrderManager();
   // 关闭所有本货币的订单和其他货币的订单
   // bool CloseCurrentAllAndOtherAll(); //this operate is dangerous, waitting
   // 平多单
   bool              CloseAllBuyOrders(color clr=clrNONE);
   // 平买单
   bool              CloseAllSellOrders(color clr=clrNONE);
   // 平所有
   bool              CloseAllOrders(color clr=clrNONE);
   // 关闭对应的订单
   bool              CloseOrder(int ticket,color clr=clrNONE);


   bool              CloseFirstBuyOrder(color clr=clrNONE);
   bool              CloseFirstSellOrder(color clr=clrNONE);

   bool              CloseProfitOrders(color clr=clrNONE); // 平盈利单
   bool              CloseLossOrders(color clr=clrNONE); // 平亏损单

   CList*            GetAllBuyOpenningList() {return buyOpenOrders;};
   CList*            GetAllSellOpenningList() {return sellOpenOrders;};
   //bool OpenPairOrders();
   //bool GetPairOrders();
   // 获取固定的收益 (关闭订单的收益)
   double            SoildProfit();
   // 获取浮动的收益 (开启订单的收益)
   double            FloatProfit();
   //
   bool              CloseAllOldeOrders();
   // 历史订单的收益
   // double HistoryProfit(); // 这个暂时不重要不写那么重
   // 开多单
   bool              Buy(double volume,color arrow_color=clrNONE);
   // 开多单并且返回ticket
   int               BuyWithTicket(double volume,color arrow_color=clrNONE);
   // 开空单
   bool              Sell(double volume,color arrowColor=clrNONE);
   // 开空单并且返回ticket
   int               SellWithTicket(double volume,color arrowColor=clrNONE);
   // 开止盈止损单
   int               BuyWithStAndTp(double volume,int stopLossPoint=0, int takeProfitPoint=0,bool stopTrace = false,datetime expiration=0,string comment=NULL,color arrowColor=clrNONE);
   int               SellWithStAndTp(double volume,int stopLossPoint=0, int takeProfitPoint=0,bool stopTrace = false,datetime expiration=0,string comment=NULL,color arrowColor=clrNONE);

   bool              SetOldOrdersIntoCurrentList();
   // 挂单买
   // int               PenningBuy(double price, double volume,int stopLossPoint=0, int takeProfitPoint=0,datetime expiration=0,string comment=NULL,color arrowColor=clrNONE);
   // 挂单卖
   // int               PenningSell(double price, double volume,int stopLossPoint=0, int takeProfitPoint=0,datetime expiration=0,string comment=NULL,color arrowColor=clrNONE);
   // open penning buy order by Point diff
   int               PennigBuyWithPoint(int pricePointDiff, double volume,int stopLossPoint=0, int takeProfitPoint=0,datetime expiration=0,string commento=NULL,color arrowColoro=clrNONE);
   // open penning sell order by Point diff
   int               PennigSellWithPoint(int pricePointDiff, double volume,int stopLossPoint=0, int takeProfitPoint=0,datetime expiration=0,string commento=NULL,color arrowColoro=clrNONE);
   // important method, this method will monitor and update all changeable statues,
   // like floatProfit and soildProfit
   // pendingOrder to openning order
   // openning order to closed order
   bool              Update();

   // get penning sell order in hand, in this function body it just return sellCount
   // handPenningSellCount state change depends on Update  method to udate
   int               GetHandPenningSellCount() {return handPenningSellCount;};
   int               GetHandPenningBuyCount() {return handPenningBuyCount;};

   // get current hand opening order count, it also depends on Udate method to monitor
   // and update
   int               GetHandSellCount() {return handSellCount;};
   int               GetHandBuyCount() {return handBuyCount;};
   // get all order open by this ordermanger
   int               GetSellCount() {return buyCount;};
   int               GetBuyCount() {return sellCount;};
   bool              ReverseOrder();
   bool              LoadOpenningOrder();

private:
   int               buyCount;
   int               sellCount;
   int               handBuyCount;// 持有多单数量
   int               handSellCount;// 持有空单数量
   int               handPenningBuyCount;// 持有多单挂数量
   int               handPenningSellCount;// 持有空单挂单数量
   int               BuyWithStAndTpCount;
   int               SellWithStAndTpCount;
   int               sellLimitPenningCount;
   int               sellStopPenningCount;
   int               buyLimitPenningCount;
   int               buyStopPenningCount;
   int               magic;
   string            comment;
   int               slippage;
   double            buySoildProfit;
   double            sellSoildProfit;
   double            buyFloatProfit;
   double            sellFloatProfit;
   string            symbol;
   CList             *buyOpenOrders;
   CList             *sellOpenOrders;
   CList             *historyOrders;
   CList             *oldOpenOrders;
   CList             *buyStopPenningOrders;
   CList             *buyLimitPenningOrders;
   CList             *sellStopPenningOrders;
   CList             *sellLimitPenningOrders;
   // CList pendingOrders; //pendingOrder is similar nomral order

   bool              handleCloseOrder(OrderInfo* order);
   int               sendNormalOrder(int operation, double volume,color arrow_color=clrNONE);
   int               sendWithStAndTpOrder(int operation, double volume,int stopLossProfitPoint=0, int takeProfitPoint=0,datetime expiration=0,string commento=NULL,color arrow_color=clrNONE,bool stopTrace=false);
   bool              closeAllByDirection(int operate,color clr=clrNONE);
   bool              updateByDirection(int operate);
   double            calculateTakeProfitByPoint(double price, int type, int takeProfitPoint);
   double            calculateStopLossByPoint(double price, int type, int stopLossPoint);
   bool              addOrderByTicket(int ticket);

   int               sendOrder(int cmd, double volume, double price, int slippageo, double stoploss, double takeprofit,
                               string commento=NULL, datetime expiration=0, color arrow_coloro=clrNONE,bool stopTrace=false);
   double            getStopBasePriceByOrderType(int type);
   double            getBasePriceByOrderType(int type);
   // protected:
  };

// Destructor manage memory
OrderManager::~OrderManager()
  {
   delete buyOpenOrders;
   delete sellOpenOrders;
   delete historyOrders;
   delete oldOpenOrders;
   delete buyStopPenningOrders;
   delete buyLimitPenningOrders;
   delete sellStopPenningOrders;
   delete sellLimitPenningOrders;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderManager::OrderManager(string commento,int magico, int slippageo)
  {
   comment=commento;
   slippage=slippageo;
   magic=magico;
   symbol = Symbol();
   oldOpenOrders = new CList;
   buyOpenOrders = new CList;
   sellOpenOrders = new CList;
   buyStopPenningOrders = new CList;
   buyLimitPenningOrders = new CList;
   sellStopPenningOrders = new CList;
   sellLimitPenningOrders = new CList;
   historyOrders= new CList;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderManager::OrderManager(string symbolo,string commento,int magico, int slippageo)
  {
   comment=commento;
   slippage=slippageo;
   magic=magico;
   symbol = symbolo;
   oldOpenOrders = new CList;
   buyOpenOrders = new CList;
   sellOpenOrders = new CList;
   buyStopPenningOrders = new CList;
   buyLimitPenningOrders = new CList;
   sellStopPenningOrders = new CList;
   sellLimitPenningOrders = new CList;
   historyOrders= new CList;
  }
// recalculate buyFloatProfit and sellFloatProfit, if order is close then send it into close list
bool OrderManager::Update()
  {
   return updateByDirection(OP_BUY) && updateByDirection(OP_SELL) && updateByDirection(OP_SELLLIMIT)
          && updateByDirection(OP_SELLSTOP)&&updateByDirection(OP_BUYLIMIT)&&updateByDirection(OP_BUYSTOP);
  }

// update nomral order by direction
bool OrderManager::updateByDirection(int operate)
  {
   double floatProfit = 0.0;
   CList *list;
   int handCount = 0;
   switch(operate)
     {
      case OP_BUY:
         list = buyOpenOrders;
         break;
      case OP_SELL:
         list = sellOpenOrders;
         break;
      case OP_BUYSTOP:
         list = buyStopPenningOrders;
         break;
      case OP_BUYLIMIT:
         list = buyLimitPenningOrders;
         break;
      case OP_SELLSTOP:
         list = sellStopPenningOrders;
         break;
      case OP_SELLLIMIT:
         list = sellLimitPenningOrders;
         break;
      default:
         Print("unknown operate code:",operate);
         return false;
     };
// use for loop to monitor and update all orders
   if(list.Total()>0)
     {
      list.MoveToIndex(0);
      OrderInfo *oos = (OrderInfo *)list.GetCurrentNode();
      while(oos!=NULL)
        {
         oos.Update();
         if(oos.GetState() == ORDER_STATE_CLOSED)
           {
            list.DetachCurrent();
            handleCloseOrder(oos);
            oos = (OrderInfo *)list.GetCurrentNode();
            continue;
           }
         else
            if(oos.GetState() == ORDER_STATE_OPENING)
              {
               handCount++;
               floatProfit += oos.GetNetProfit();
              }
         if(oos.GetState() == ORDER_STATE_PENDING)
           {
            handCount++;
           }
         oos = (OrderInfo *)list.GetNextNode();
        }
     }
   switch(operate)
     {
      case OP_BUY:
         handBuyCount = handCount;
         buyFloatProfit = floatProfit;
         break;
      case OP_SELL:
         handSellCount = handCount;
         sellFloatProfit = floatProfit;
         break;
      case OP_BUYSTOP:
      case OP_BUYLIMIT:
         handPenningBuyCount=handCount;
         break;
      case OP_SELLSTOP:
      case OP_SELLLIMIT:
         handPenningSellCount=handCount;
         break;
      default:
         Print("unknown operate code:",operate);
         return false;
     };
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderManager::ReverseOrder()
  {
   Update();
   int btl = buyOpenOrders.Total();
   double buyLots[];
   ArrayResize(buyLots,btl);
   int stl = sellOpenOrders.Total();
   double sellLots[];
   ArrayResize(sellLots,stl);
   if(buyOpenOrders.Total()>0)
     {
      buyOpenOrders.MoveToIndex(0);
      OrderInfo *oos = (OrderInfo *)buyOpenOrders.GetCurrentNode();
      int index = 0;
      while(oos!=NULL)
        {
         // buyTickets[index] = oos.GetTicket();
         buyLots[index] = oos.GetLots();
         oos = (OrderInfo *)buyOpenOrders.GetNextNode();
         index++;
        }
     }

   if(sellOpenOrders.Total()>0)
     {
      sellOpenOrders.MoveToIndex(0);
      OrderInfo *oos = (OrderInfo *)sellOpenOrders.GetCurrentNode();
      int index = 0;
      while(oos!=NULL)
        {
         // sellTickets[index] = oos.GetTicket();
         sellLots[index] = oos.GetLots();
         oos = (OrderInfo *)sellOpenOrders.GetNextNode();
         index++;
        }
     }
   if(!CloseAllOrders())
     {
      return false;
     }
   for(int i=0; i<btl; i++)
     {
      double lot = buyLots[i];
      if(!Sell(lot))
        {
         return false;
        }
     }

   for(int i=0; i<stl; i++)
     {
      double lot = sellLots[i];
      if(!Buy(lot))
        {
         return false;
        }
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderManager::CloseAllOldeOrders()
  {
   oldOpenOrders.MoveToIndex(0);
   while(true)
     {
      OrderInfo *oos = (OrderInfo *)oldOpenOrders.GetCurrentNode();
      if(oos==NULL)
        {
         break;
        }
      if(!oos.Close(slippage))
        {
         return false;
        }
      oldOpenOrders.DeleteCurrent();
     }
   return true;
  }

// 把旧的订单放入当前流程中
bool OrderManager::SetOldOrdersIntoCurrentList()
  {

   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol()==symbol && OrderMagicNumber()==magic)
           {
            addOrderByTicket(OrderTicket());
            // OrderInfo *oo = new OrderInfo(OrderTicket()) ;
            // oldOpenOrders.Add(oo);
           }
        }
     }
   return Update();

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderManager::LoadOpenningOrder()
  {
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol()==symbol)
           {
            int ticket = OrderTicket();
            //Print("tttttt: ",ticket);
            return addOrderByTicket(ticket);
           }
        }
     }
   return Update();
  }


// close all opening orders
bool OrderManager::CloseAllOrders(color clr=clrNONE)
  {
   return CloseAllSellOrders(clr)&&CloseAllBuyOrders(clr);
  }


// close all sell orders
bool OrderManager::CloseAllSellOrders(color clr=clrNONE)
  {
   return closeAllByDirection(OP_SELL,clr);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderManager::CloseAllBuyOrders(color clr=clrNONE)
  {
   return closeAllByDirection(OP_BUY,clr);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderManager::closeAllByDirection(int operate,color clr=clrNONE)
  {
   CList *list;
   switch(operate)
     {
      case OP_BUY:
         list = buyOpenOrders;
         break;
      case OP_SELL:
         list = sellOpenOrders;
         break;
      default:
         Print("unknown operate code:",operate);
         return false;
     };
   if(list.Total()> 0)
     {

      while(true)
        {
         list.MoveToIndex(0);
         OrderInfo *oo = (OrderInfo *)list.GetCurrentNode();
         if(oo == NULL)
           {
            break;
           }
         oo.Update();
         if(oo.GetState()==ORDER_STATE_OPENING)
           {
            if(!oo.Close(slippage,clr))
              {
               Alert("CloseAllSellOrders error, code:  ", GetLastError());
               return false;
              }
           }
         //sellOpenOrders.DeleteCurrent();
         list.DetachCurrent();
         handleCloseOrder(oo);
        }
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderManager::CloseFirstBuyOrder(color clr=clrNONE)
  {
   buyOpenOrders.MoveToIndex(0);

   OrderInfo *oos = (OrderInfo *)buyOpenOrders.GetCurrentNode();
   if(oos==NULL)
     {
      return true;
     }
   if(!oos.Close(slippage,clr))
     {
      return false;
     }
   buyOpenOrders.DetachCurrent();
   handleCloseOrder(oos);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderManager::CloseFirstSellOrder(color clr=clrNONE)
  {
   sellOpenOrders.MoveToIndex(0);

   OrderInfo *oos = (OrderInfo *)sellOpenOrders.GetCurrentNode();
   if(oos==NULL)
     {
      return true;
     }
   if(!oos.Close(slippage,clr))
     {
      return false;
     }
   sellOpenOrders.DetachCurrent();
   handleCloseOrder(oos);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderManager::Sell(double volume,color arrow_color=clrNONE)
  {
// sellCount++;
   int ticket = sendNormalOrder(OP_SELL,volume,arrow_color);
   return ticket!=0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderManager::BuyWithTicket(double volume,color arrow_color=clrNONE)
  {
   return sendNormalOrder(OP_BUY,volume,arrow_color);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderManager::Buy(double volume,color arrow_color=clrNONE)
  {
// buyCount++;
   int ticket = sendNormalOrder(OP_BUY,volume,arrow_color);
   return ticket!=0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderManager::SellWithTicket(double volume,color arrow_color=clrNONE)
  {
   return sendNormalOrder(OP_SELL,volume,arrow_color);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderManager::sendNormalOrder(int operation, double volume,color arrow_coloro=clrNONE)
  {
   double price = 0;
   RefreshRates();
   price = getBasePriceByOrderType(operation);
   return sendOrder(operation,volume,price,slippage,0,0,NULL,0,arrow_coloro);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderManager::BuyWithStAndTp(double volume,int stopLossPoint=0, int takeProfitPoint=0,bool stopTrace = false,datetime expiration=0,string commento=NULL,color arrowColor=clrNONE)
  {
   BuyWithStAndTpCount++;
   return sendWithStAndTpOrder(OP_BUY,volume, stopLossPoint,takeProfitPoint,expiration,commento,arrowColor,stopTrace);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderManager::SellWithStAndTp(double volume,int stopLossPoint=0, int takeProfitPoint=0,bool stopTrace = false,datetime expiration=0,string commento=NULL,color arrowColor=clrNONE)
  {
   SellWithStAndTpCount++;
   return sendWithStAndTpOrder(OP_SELL,volume, stopLossPoint,takeProfitPoint,expiration,commento,arrowColor,stopTrace);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderManager::sendWithStAndTpOrder(int operation, double volume,int stopLossProfitPoint=0, int takeProfitPoint=0,datetime expiration=0,string commento=NULL,color arrowColoro=clrNONE,bool stopTrace=false)
  {
   RefreshRates();
   double basePrice = getBasePriceByOrderType(operation);
   double sl = calculateStopLossByPoint(getStopBasePriceByOrderType(operation),operation,stopLossProfitPoint);
   double tp = calculateTakeProfitByPoint(getStopBasePriceByOrderType(operation),operation,takeProfitPoint);
   return sendOrder(operation,volume,basePrice,slippage,sl,tp,commento,expiration,arrowColoro,stopTrace);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderManager::PennigBuyWithPoint(int pricePointDiff, double volume,int stopLossPoint=0, int takeProfitPoint=0,datetime expiration=0,string commento=NULL,color arrowColoro=clrNONE)
  {
   double price = 0.0;
   int type = 0;
// 跟当前价格点差不能是0 差值（绝对值）要大于 Slippage
   if(pricePointDiff == 0 || MathAbs(pricePointDiff)<=slippage)
     {
      Print("wrong pricePoint");
      return 0;
     }

   if(pricePointDiff > 0)
     {
      type = OP_BUYSTOP;
     }

   if(pricePointDiff < 0)
     {
      type = OP_BUYLIMIT;
     }

   price = getBasePriceByOrderType(type) + MarketInfo(symbol,MODE_POINT)*pricePointDiff;
   double sl = calculateStopLossByPoint(getStopBasePriceByOrderType(type),type,stopLossPoint);
   double tp = calculateTakeProfitByPoint(getStopBasePriceByOrderType(type),type,takeProfitPoint);
   return sendOrder(type,volume,price,slippage,sl,tp,commento,expiration,arrowColoro);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderManager::PennigSellWithPoint(int pricePointDiff, double volume,int stopLossPoint=0, int takeProfitPoint=0,datetime expiration=0,string commento=NULL,color arrowColoro=clrNONE)
  {
   double price = 0.0;
   int type = 0;
// 跟当前价格点差不能是0 差值（绝对值）要大于 Slippage
   if(pricePointDiff == 0 || MathAbs(pricePointDiff)<=slippage)
     {
      Print("wrong pricePoint");
      return 0;
     }

   if(pricePointDiff < 0)
     {
      type = OP_SELLSTOP;
     }

   if(pricePointDiff > 0)
     {
      type = OP_SELLLIMIT;
     }

   price = getBasePriceByOrderType(type) + MarketInfo(symbol,MODE_POINT)*pricePointDiff;
   double sl = calculateStopLossByPoint(getStopBasePriceByOrderType(type),type,stopLossPoint);
   double tp = calculateTakeProfitByPoint(getStopBasePriceByOrderType(type),type,takeProfitPoint);
//Print(" Bid:",Bid," pricePointDiff:",pricePointDiff," price:",price," type:",type," sl:",sl," tp:",tp," bp:",MarketInfo(Symbol(),MODE_BID)+MarketInfo(Symbol(),MODE_SPREAD)*MarketInfo(Symbol(),MODE_POINT));
   return sendOrder(type,volume,price,slippage,sl,tp,commento,expiration,arrowColoro);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OrderManager::calculateTakeProfitByPoint(double price, int type, int takeProfitPoint)
  {
   if(takeProfitPoint == 0)
     {
      return 0;
     }
   switch(type)
     {
      case OP_BUY:
      case OP_BUYLIMIT:
      case OP_BUYSTOP:
         return price + takeProfitPoint*MarketInfo(symbol,MODE_POINT);
      case OP_SELL:
      case OP_SELLLIMIT:
      case OP_SELLSTOP:
         return price - takeProfitPoint*MarketInfo(symbol,MODE_POINT);
      default:
         return 0;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OrderManager::calculateStopLossByPoint(double price, int type, int stopLossPoint)
  {
   if(stopLossPoint == 0)
     {
      return 0;
     }
   switch(type)
     {
      case OP_BUY:
      case OP_BUYLIMIT:
      case OP_BUYSTOP:
         return price - stopLossPoint*MarketInfo(symbol,MODE_POINT);
      case OP_SELL:
      case OP_SELLLIMIT:
      case OP_SELLSTOP:
         return price + stopLossPoint*MarketInfo(symbol,MODE_POINT);
      default:
         return 0;
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderManager::sendOrder(int cmd, double volume, double price, int slippageo, double stoploss, double takeprofit,
                            string commento=NULL, datetime expiration=0, color arrow_coloro=clrNONE,bool stopTrace=false)
  {
   int ticket = OrderSend(symbol,cmd,volume,price,slippageo,stoploss,takeprofit,commento==NULL?comment:commento, magic,expiration,arrow_coloro);
   if(ticket <= 0)
     {
      return 0;
     }
   OrderInfo *oo;
   if(stopTrace&&stoploss>0)
     {
      oo = new OrderInfo(ticket,stopTrace,stoploss);
     }
   else
     {
      oo = new OrderInfo(ticket);
     }
   switch(cmd)
     {
      case OP_BUY:
         buyOpenOrders.Add(oo);
         buyCount++;
         break;
      case OP_SELL:
         sellOpenOrders.Add(oo);
         sellCount++;
         break;
      case OP_SELLLIMIT:
         sellLimitPenningOrders.Add(oo);
         sellLimitPenningCount++;
         break;
      case OP_SELLSTOP:
         sellStopPenningOrders.Add(oo);
         sellStopPenningCount++;
         break;
      case OP_BUYLIMIT:
         buyLimitPenningOrders.Add(oo);
         buyLimitPenningCount++;
         break;
      case OP_BUYSTOP:
         buyStopPenningOrders.Add(oo);
         buyStopPenningCount++;
         break;
      default:
         // 不知道的类型就是错误的
         return 0;
         break;
     }
   return ticket;
  }

// 将订单加入到当前列表中
bool OrderManager::addOrderByTicket(int ticket)
  {
   OrderInfo *oo = new OrderInfo(ticket);
   if(!oo.Update())
     {
      Print("订单更新错误，订单id：",ticket);
      return false;
     }
   Print("ss:",oo.GetState());
   if(oo.GetState()!=ORDER_STATE_OPENING && oo.GetState()!=ORDER_STATE_PENDING)
     {
      return handleCloseOrder(oo);
     }
   Print("load: ",ticket);
   switch(oo.GetType())
     {
      case OP_BUY:
         //buyOpenOrders.Add(oo);
         addToList(buyOpenOrders,ticket);
         buyCount++;
         break;
      case OP_SELL:
         //sellOpenOrders.Add(oo);
         addToList(sellOpenOrders,ticket);
         sellCount++;
         break;
      case OP_SELLLIMIT:
         //sellLimitPenningOrders.Add(oo);
         addToList(sellLimitPenningOrders,ticket);
         sellLimitPenningCount++;
         break;
      case OP_SELLSTOP:
         //sellStopPenningOrders.Add(oo);
         addToList(sellStopPenningOrders,ticket);
         sellStopPenningCount++;
         break;
      case OP_BUYLIMIT:
         //buyLimitPenningOrders.Add(oo);
         addToList(buyLimitPenningOrders,ticket);
         buyLimitPenningCount++;
         break;
      case OP_BUYSTOP:
         //buyStopPenningOrders.Add(oo);
         addToList(buyStopPenningOrders,ticket);
         buyStopPenningCount++;
         break;
      default:
         // 不知道的类型就是错误的
         return false;
         break;
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool addToList(CList *list,int  ticket)
  {
   OrderInfo *oo = new OrderInfo(ticket);
   if(!isExistInOrderList(list,ticket))
     {
      Print("added: ",ticket);
      list.Add(oo);
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isExistInOrderList(CList *list,int  ticket)
  {
   if(list.Total()>0)
     {
      list.MoveToIndex(0);
      OrderInfo *oos = (OrderInfo *)list.GetCurrentNode();
      while(oos!=NULL)
        {
         int exist_ticket = oos.GetTicket();
         if(exist_ticket  == ticket)
           {
            return true;
           }
         oos = (OrderInfo *)list.GetNextNode();
        }
     }
   return false;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OrderManager::getStopBasePriceByOrderType(int type)
  {
   switch(type)
     {
      case OP_BUY:
      case OP_BUYLIMIT:
      case OP_BUYSTOP:
         return MarketInfo(symbol,MODE_BID);
      case OP_SELL:
      case OP_SELLLIMIT:
      case OP_SELLSTOP:
         return MarketInfo(symbol,MODE_ASK);
      default:
         return 0;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OrderManager::getBasePriceByOrderType(int type)
  {
   switch(type)
     {
      case OP_BUY:
      case OP_BUYLIMIT:
      case OP_BUYSTOP:
         return MarketInfo(symbol,MODE_ASK);
      case OP_SELL:
      case OP_SELLLIMIT:
      case OP_SELLSTOP:
         return MarketInfo(symbol,MODE_BID);
      default:
         return 0;
     }
  }


//+------------------------------------------------------------------+
bool OrderManager::handleCloseOrder(OrderInfo* order)
  {
   switch(order.GetType())
     {
      case OP_BUY:
         buySoildProfit += order.GetNetProfit();
         break;
      case OP_SELL:
         sellSoildProfit += order.GetNetProfit();
         break;
      default:
         Print("UnSupport operation:",order.GetType());
         return false;
     };
   historyOrders.Add(order);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OrderManager::SoildProfit(void)
  {
   return (buySoildProfit + sellSoildProfit);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OrderManager::FloatProfit(void)
  {
   return (buyFloatProfit + sellFloatProfit);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderManager::CloseProfitOrders(color clr=clrNONE)
  {
   if(buyOpenOrders.Total()>0)
     {
      buyOpenOrders.MoveToIndex(0);
      OrderInfo *oos = (OrderInfo *)buyOpenOrders.GetCurrentNode();
      while(oos!=NULL)
        {
         oos.Update();
         if(oos.GetState()== ORDER_STATE_OPENING&&oos.GetNetProfit()>0)
           {
            if(!oos.Close(slippage,clr))
              {
               return false;
              }
            buyOpenOrders.DetachCurrent();
            handleCloseOrder(oos);
            oos = (OrderInfo *)buyOpenOrders.GetCurrentNode();
            continue;
           }
         oos = (OrderInfo *)buyOpenOrders.GetNextNode();
        }
     }
   if(sellOpenOrders.Total()>0)
     {
      sellOpenOrders.MoveToIndex(0);
      OrderInfo *oos = (OrderInfo *)sellOpenOrders.GetCurrentNode();
      while(oos!=NULL)
        {
         oos.Update();
         if(oos.GetState()== ORDER_STATE_OPENING&&oos.GetNetProfit()>0)
           {
            if(!oos.Close(slippage,clr))
              {
               return false;
              }
            sellOpenOrders.DetachCurrent();
            handleCloseOrder(oos);
            oos = (OrderInfo *)sellOpenOrders.GetCurrentNode();
            continue;
           }
         oos = (OrderInfo *)sellOpenOrders.GetNextNode();
        }
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderManager::CloseLossOrders(color clr=clrNONE)
  {
   if(buyOpenOrders.Total()>0)
     {
      buyOpenOrders.MoveToIndex(0);
      OrderInfo *oos = (OrderInfo *)buyOpenOrders.GetCurrentNode();
      while(oos!=NULL)
        {
         oos.Update();
         if(oos.GetState()== ORDER_STATE_OPENING&&oos.GetNetProfit()<0)
           {
            if(!oos.Close(slippage,clr))
              {
               return false;
              }
            buyOpenOrders.DetachCurrent();
            handleCloseOrder(oos);
            oos = (OrderInfo *)buyOpenOrders.GetCurrentNode();
            continue;
           }
         oos = (OrderInfo *)buyOpenOrders.GetNextNode();
        }
     }
   if(sellOpenOrders.Total()>0)
     {
      sellOpenOrders.MoveToIndex(0);
      OrderInfo *oos = (OrderInfo *)sellOpenOrders.GetCurrentNode();
      while(oos!=NULL)
        {
         oos.Update();
         if(oos.GetState()== ORDER_STATE_OPENING&&oos.GetNetProfit()<0)
           {
            if(!oos.Close(slippage,clr))
              {
               return false;
              }
            sellOpenOrders.DetachCurrent();
            handleCloseOrder(oos);
            oos = (OrderInfo *)sellOpenOrders.GetCurrentNode();
            continue;
           }
         oos = (OrderInfo *)sellOpenOrders.GetNextNode();
        }
     }
   return true;
  }
//+------------------------------------------------------------------+
