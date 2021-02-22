//+------------------------------------------------------------------+
//|                                                      rush种田人.mq4 |
//|                                                 992249804@qq.com |
//|                                     http://shop.zbj.com/23451428 |
//+------------------------------------------------------------------+
#property copyright "992249804@qq.com"
#property link      "http://shop.zbj.com/23451428"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Mylib\Trade\trade.mqh>
#include <Mylib\Panels\DisplayPanel.mqh>
DisplayPanel Dp;


input double 手数 = 0.01;
input string 开仓备注 = "种田人";
input int 开仓magic码 = 923185;
input int Slippage = 30; //滑点

input int 点差距离 = 300;
input int 单数 = 4;
input int 亏损单平仓点 = 0;

OrderInfo oiss[3][2];
OrderInfo WaitClose[100];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(!Dp.Create(0,"盈亏面板",0,0,0,200,100))
     {
      return -3;
     }

   if(!Dp.Run())
     {
      return -2;
     }
   loadPreOrder();
   ArrayResize(oiss,单数);

   for(int i=0; i<单数; i++)
     {
      for(int j=0; j<2; j++)
        {

         OrderInfo oit(0);

         oiss[i][j] = oit;
        }
     }
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Dp.Destroy();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   string info = StringFormat("关闭次数：%d \r\n浮动盈利：%.4f\r\n",closeTimes, histroyProfit+getFloatProfit());
   Comment(info);
   Dp.SetAction(closeTimes);
   Dp.SetProfit(histroyProfit+getFloatProfit());
   MonitorAndCloseWaitOrder();

   if(OrderPairSize()==0)
     {
      sendOrderPair();
      return;
     }

   if(pointDiffEnough())
     {
      sendOrderPair();
     }

   if(OrderPairSize()==单数)
     {
      // 这里的逻辑建立在，必定能够平完
      ClosePairOrder();
     }

// 监控并关闭亏损转盈利的订单
//MonitorAndCloseWaitOrder();

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
void loadPreOrder()
  {
   OrderInfo ois[];
   GetAllCurrentOpenedOrder(ois);
   for(int i=ArraySize(ois)-1; i>=0; i--)
     {
      ois[i].Update();
      if(ois[i].magicNum == 开仓magic码 && ois[i].symbol == Symbol())
        {
         addWaitClose(ois[i]);
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void sendOrderPair()
  {

   int Ticket1 = OrderSend(Symbol(),OP_BUY,手数,Ask,Slippage,0,0,开仓备注,开仓magic码,0,clrRed);
   if(Ticket1 < 0)
     {
      Print("开单错误，错误代码是:  ", GetLastError());
      return;
     }
   OrderInfo oi1(Ticket1);
   int Ticket2 = OrderSend(Symbol(),OP_SELL,手数,Bid,Slippage,0,0,开仓备注,开仓magic码,0,clrRed);
   if(Ticket2 < 0)
     {
      Print("开单错误，错误代码是:  ", GetLastError());
      return;
     }
   OrderInfo oi2(Ticket2);
   for(int i = 0; i<ArrayRange(oiss,0); i++)
     {
      if(oiss[i][0].ticket ==0)
        {
         oi1.Update();
         oi2.Update();
         oiss[i][0] = oi1;
         oiss[i][1] = oi2;
         break;
        }
     }

  }

//+------------------------------------------------------------------+
//|获取 oiss中订单对数                                               |
//+------------------------------------------------------------------+
int OrderPairSize()
  {
   for(int i=ArrayRange(oiss,0)-1; i>=0; i--)
     {

      if(oiss[i][0].ticket > 0)
        {
         return i+1;
        }
     }
   return 0;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ClosePairOrder()
  {
   closeTimes++;
   int closeCount = 0;
   int waitCount = 0;
   for(int i=0; i<ArrayRange(oiss,0)-1; i++)
     {


      for(int j=0; j<2; j++)
        {

         oiss[i][j].Update();
         if(oiss[i][j].profit>0)
           {
            closeCount++;
            histroyProfit += oiss[i][j].profit;
            bool CloseOrder = oiss[i][j].Close(Slippage);
            if(!CloseOrder)
              {
               Print("平仓错误，错误代码是：  ", GetLastError(),"++++++++Ticket 是：",oiss[i][j].ticket);
              }
           }
         else
           {
            waitCount++;
            addWaitClose(oiss[i][j]);

           }
         OrderInfo oit(0);

         oiss[i][j] = oit;
        }
     }

   oiss[0][0] =  oiss[单数-1][0];
   oiss[0][1] =  oiss[单数-1][1];
   OrderInfo oit1(0);
   oiss[单数-1][0] = oit1;
   OrderInfo oit2(0);
   oiss[单数-1][1] = oit2;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void addWaitClose(OrderInfo &oi)
  {
   for(int i=0; i<ArraySize(WaitClose); i++)
     {
      if(WaitClose[i].ticket==0)
        {
         WaitClose[i] = oi;
         return;
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MonitorAndCloseWaitOrder()
  {
   for(int i=0; i<ArraySize(WaitClose); i++)
     {
      if(WaitClose[i].ticket != 0)
        {
         WaitClose[i].Update();
         if(WaitClose[i].state == OPENED && WaitClose[i].profit >= 亏损单平仓点*Point)
           {
            histroyProfit += WaitClose[i].profit;
            bool WaitCloseOrder = WaitClose[i].Close(Slippage);
            if(!WaitCloseOrder)
              {
               Print("平仓错误，错误代码是：  ", GetLastError(),"----Ticket 是：",WaitClose[i].ticket);
              }
            OrderInfo oit(0);

            WaitClose[i] = oit;
           }
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int pointDiff(double price1,double price2)
  {
   double spread = (price1 - price2)/Point;
   return (int)spread;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getMaxPrice()
  {
   double mp = 0.0;
   for(int i=ArrayRange(oiss,0)-1; i>=0; i--)
     {

      if(oiss[i][0].ticket != 0)
        {
         if(mp < oiss[i][0].openPrice)
           {
            mp =oiss[i][0].openPrice;
           }
        }
     }
   if(mp == 0.0)
     {
      return -1.0;

     }
   return mp;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getMinPrice()
  {
   double mp = 0.0;
   for(int i=ArrayRange(oiss,0)-1; i>=0; i--)
     {
      if(oiss[i][0].ticket != 0)
        {

         if(mp > oiss[i][0].openPrice || mp == 0.0)
           {
            mp =oiss[i][0].openPrice;
           }
        }
     }
   if(mp == 0.0)
     {
      return -1.0;
     }
   return mp;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool pointDiffEnough()
  {
   double max = getMaxPrice();
   double min = getMinPrice();
   if(max <= 0|| min <=0)
     {
      return false;
     }

   double maxPd = pointDiff(max,Ask);
   double minPd = pointDiff(min,Ask);

   if(minPd >= 点差距离||maxPd <= -点差距离)
     {
      return true;
     }


   return false;

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OissIsThreePairOrder()
  {

   return oiss[ArrayRange(oiss,0)-1][0].ticket > 0;
  }
//+------------------------------------------------------------------+

double histroyProfit = 0.0;
int closeTimes = 0;
double getFloatProfit()
  {
   double fp = 0.0;
   for(int i=0; i<ArrayRange(oiss,0)-1; i++)
     {
      for(int j=0; j<2; j++)
        {
         oiss[i][j].Update();
         fp += oiss[i][j].profit;
        }
     }
   for(int i=0; i<ArraySize(WaitClose); i++)
     {
      WaitClose[i].Update();
      fp+= WaitClose[i].profit;
     }
   return fp;
  }
//+------------------------------------------------------------------+
