// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                        trade.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Object.mqh>
enum ENUM_ORDER_STATE
  {
   ORDER_STATE_UNKNOW=0, ORDER_STATE_PENDING=1, ORDER_STATE_OPENING=2, ORDER_STATE_CLOSED=3, ORDER_STATE_CANCELED=4
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderInfo: public CObject
  {

private:
   int               ticket; // 订单编号
   int               type;// OP_BUY - buy order,OP_SELL - sell order,OP_BUYLIMIT - buy limit pending order,OP_BUYSTOP - buy stop pending order,OP_SELLLIMIT - sell limit pending order,OP_SELLSTOP - sell stop pending order.
   string            symbol; // 订单交易品种
   int               magicNum; // 魔术编号
   double            netProfit;
   //有即固定字段
   double            closePrice; // 收盘价
   datetime          closeTime; // 收盘时间

   // 暂时不知道是不是固定的字段
   string            comment; //注释
   double            commission; // 佣金费用
   datetime          expiration; // 过期时间
   double            lots; // 手数
   double            openPrice; // 开盘价
   datetime          openTime;// 开盘时间
   double            profit; // 利润
   double            stopLoss; // 止损价格
   double            takeProfit; // 止盈价格

   bool              closeOrder;
   // int               Slippage; // 滑点

   ENUM_ORDER_STATE  state; // 状态
   double            swap;

   bool              stopTrace; // 是否是跟踪止损
   double            initStopLoss;
   double            getStopBasePriceByOrderType();
   double            calculateStopLossByPoint(double price,  int stopLossPoint);
   //--- A constructor with an initialization list
   //CPerson(string surname,string name): m_second_name(surname), m_first_name(name) {};
   // void              PrintName()
   //   {
   //    PrintFormat("---------------------------ticket=%d type=%d symbol=%s profit=%f closePrice=%f state=%d------------------",
   //                ticket,type,symbol,netProfit,closePrice,state);
   //   };
public:
   bool              Update();
   ENUM_ORDER_STATE  GetState();
   int               GetType();
   int               GetTicket(){return ticket;};
   bool              Close(int slippage,color clr=clrLime);
   double            GetNetProfit();
   double            GetOpenPrice() {return openPrice;};
   void              SetTicket(int ticketo);
   double            GetLots(){return lots;};
   bool              ModifyStopLoss(double stopLosso,bool needUpdate=true);
   bool              ModifyTakeProfit(double takeProfito,bool needUpdate=true);
   double            GetStopLoss() {return stopLoss;};
   double            GetTakeProfit() {return takeProfit;};
   void              SetTraceStopLoss(int stopLossPoint);
   //--- An empty default constructor
                     OrderInfo() {};
   //--- A parametric constructor
                     OrderInfo(int ticketa): ticket(ticketa) {};
                     OrderInfo(int ticketo,bool stopTraceo,double initStopLosso=0) {ticket=ticketo; stopTrace=stopTraceo; initStopLoss=initStopLosso;};
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderInfo::GetType()
  {
   return type;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_ORDER_STATE OrderInfo::GetState()
  {
   return state;
  }

//+------------------------------------------------------------------+
//| 关闭当前订单                                                     |
//+------------------------------------------------------------------+
bool OrderInfo::Close(int slippage,color clr=clrLime)
  {
   RefreshRates();
   Update();

   bool ok = OrderClose(ticket,lots,closePrice,slippage,clr);
   if(!ok)
     {
      int lastErrorCode = GetLastError();
      switch(lastErrorCode)
        {
         case 4018:
            return true;
         default:
            return false;
        };
     }
   return ok;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderInfo::ModifyStopLoss(double stopLosso,bool needUpdate=true)
  {
   if(needUpdate)
     {
      Update();
     }

   color orderColor = clrRed;
   if(type == OP_SELL)
     {
      orderColor = clrGreen;
     }
   if(NormalizeDouble(stopLosso,Digits) == NormalizeDouble(stopLoss,Digits))
     {
      return true;
     }
   return OrderModify(ticket,openPrice,NormalizeDouble(stopLosso,Digits),takeProfit,0,orderColor);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderInfo::ModifyTakeProfit(double takeProfito,bool needUpdate=true)
  {
   if(needUpdate)
     {
      Update();
     }

   color orderColor = clrRed;
   if(type == OP_SELL)
     {
      orderColor = clrGreen;
     }
   if(NormalizeDouble(takeProfito,Digits) == NormalizeDouble(takeProfit,Digits))
     {
      return true;
     }
   return OrderModify(ticket,openPrice,stopLoss,NormalizeDouble(takeProfito,Digits),0,orderColor);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderInfo::Update()//更新订单信息
  {
   if(ticket!=0&&OrderSelect(ticket, SELECT_BY_TICKET)) //选择订单
     {
      type = OrderType(); //
      symbol = OrderSymbol();
      magicNum = OrderMagicNumber();
      profit = OrderProfit();
      swap = OrderSwap();
      commission = OrderCommission();
      netProfit =  profit + swap + commission;
      closePrice = OrderClosePrice();
      closeTime = OrderCloseTime();
      comment = OrderComment();
      expiration = OrderExpiration();
      lots = OrderLots();
      openPrice = OrderOpenPrice();
      openTime = OrderOpenTime();
      stopLoss = OrderStopLoss();
      takeProfit = OrderTakeProfit();

      if(closeTime > 0)
        {
         switch(type)
           {
            case OP_BUY:
            case OP_SELL:
               state = ORDER_STATE_CLOSED;
               break;
            case OP_BUYLIMIT:
            case OP_BUYSTOP:
            case OP_SELLLIMIT:
            case OP_SELLSTOP:
               state = ORDER_STATE_CANCELED;
               break;
            default:
               state = ORDER_STATE_UNKNOW;
               break;
           }
        }
      if(closeTime == 0)
        {
         switch(type)
           {
            case OP_BUY:
            case OP_SELL:
               state = ORDER_STATE_OPENING;
               break;
            case OP_BUYLIMIT:
            case OP_BUYSTOP:
            case OP_SELLLIMIT:
            case OP_SELLSTOP:
               state = ORDER_STATE_PENDING;
               break;
            default:
               state = ORDER_STATE_UNKNOW;
               break;
           }
        }


      if(stopTrace&&state==ORDER_STATE_OPENING&&(type==OP_BUY||type==OP_SELL))
        {
         double cBid = MarketInfo(symbol,MODE_BID);
         double cPoint = MarketInfo(symbol,MODE_POINT);
         if(type==OP_BUY)
           {
            //Print("Bid: ",Bid, " Bid - initStopLoss*Point: ", Bid - initStopLoss*Point, " stoploss: ", stopLoss);
            if(cBid - initStopLoss*cPoint > stopLoss)
              {
               if(!ModifyStopLoss(NormalizeDouble(cBid -initStopLoss*cPoint,Digits),false))
                 {
                  Print("Error in OrderModify. Error code=",GetLastError());
                 }
              }
           }
         else
           {
            if(cBid + initStopLoss*cPoint < stopLoss||stopLoss==0)
              {
               if(!ModifyStopLoss(NormalizeDouble(cBid + initStopLoss*cPoint,Digits),false))
                 {
                  Print("Error in OrderModify. Error code=",GetLastError());
                 }
              }
           }
        }

      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderInfo::SetTraceStopLoss(int stopLossPoint)
  {
   Update();
   initStopLoss = calculateStopLossByPoint(getStopBasePriceByOrderType(),stopLossPoint);
   stopTrace = true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OrderInfo::calculateStopLossByPoint(double price,  int stopLossPoint)
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
double OrderInfo::getStopBasePriceByOrderType()
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
double OrderInfo::GetNetProfit()
  {
   Update();
   return netProfit;
  }
// // GetAllCurrentOrder 获取所有 opened 和 pending 状态订单
// void GetAllCurrentOpenedOrder(OrderInfo & ois[])
//   {
//    ArrayResize(ois, OrdersTotal());
//
//    for(int i=0; i<OrdersTotal(); i++)
//      {
//       if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
//         {
//          OrderInfo oi(OrderTicket());
//          oi.Update();
//          ois[i] = oi;
//         }
//      }
//    return;
//   }
//
// //+------------------------------------------------------------------+
// //|                                                                  |
// //+------------------------------------------------------------------+
// void GetOrderInfo(OrderInfo & ois[], string symbol="")
//   {
//    int tickets[20000];
//    int currIndex = 0;
//    int historyLimit = 10;
//    for(int j=OrdersHistoryTotal()-1; j>=0; j--)
//      {
//       if(OrderSelect(j,SELECT_BY_POS, MODE_HISTORY))
//         {
//          if(symbol == "" || OrderSymbol()==symbol)
//            {
//             tickets[currIndex] = OrderTicket();
//             currIndex++;
//            }
//         }
//       historyLimit --;
//       if(historyLimit <0)
//         {
//          break;
//         }
//      }
//
//    for(int i=0; i<OrdersTotal(); i++)
//      {
//       if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
//         {
//          //Print("-----",symbol,OrderSymbol(),"++++++++");
//          if(symbol == "" || OrderSymbol()==symbol)
//            {
//             tickets[currIndex] = OrderTicket();
//             currIndex++;
//            }
//         }
//      }
//
//    ArrayResize(ois,currIndex);
//
//    for(int i=currIndex-1; i>=0; i--)
//      {
//       OrderInfo oi(tickets[i]);
//       oi.Update();
//       ois[i] = oi;
//      }
//    return;
//   }
//
// void GetOpenningOrderInfo(OrderInfo & ois[], string symbol="", int op=-1)
//   {
//    int tickets[2000];
//    int currIndex = 0;
//
//    for(int i=0; i<OrdersTotal(); i++)
//      {
//       if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
//         {
//          //Print("-----",symbol,OrderSymbol(),"++++++++");
//          if((symbol == "" || OrderSymbol()==symbol) && (op == -1 || OrderType()==op))
//            {
//             tickets[currIndex] = OrderTicket();
//             currIndex++;
//            }
//         }
//      }
//
//    ArrayResize(ois,currIndex);
//
//    for(int i=currIndex-1; i>=0; i--)
//      {
//       OrderInfo oi(tickets[i]);
//       oi.Update();
//       ois[i] = oi;
//      }
//    return;
//   }
//
//
// // 获取所有历史订单
// void GetAllHistoryOrder(OrderInfo & ois[])
//   {
//    ArrayResize(ois,OrdersHistoryTotal());
//
//    for(int j=OrdersHistoryTotal()-1; j>=0; j--)
//      {
//       if(OrderSelect(j,SELECT_BY_POS, MODE_HISTORY))
//         {
//          OrderInfo oi(OrderTicket());
//          oi.Update();
//          ois[j] = oi;
//         }
//      }
//    return;
//   }
// //+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderInfo::SetTicket(int ticketo)
  {
   ticket = ticketo;
   Update();
  }
//+------------------------------------------------------------------+
