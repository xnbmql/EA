//+------------------------------------------------------------------+
//|                                                     手动多空加仓ea.mq4 |
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

input string comment = "手动多空加仓ea"; // 开仓备注
input int Magic = 525788;  // 开仓魔术码
input double Lots = 0.1; // 开仓手数
enum OrderDirection
  {
   多单 = 0, 空单 = 1
  };
input OrderDirection 做单方向 = 多单;

input string Currency_1 = ""; //货币对1 
input string Currency_2 = ""; //货币对2

input double FirstLoss = 100; // 第一层总亏损
input double FirstAddLots = 0.1; // 第一层加仓手数
input double FirstProfit = 200; // 第一层总获利

input double SecondLoss = 100; // 第二层总亏损
input double SecondAddLots = 0.1; // 第二层加仓手数
input double SecondProfit = 200; // 第二层总获利

input double ThirdLoss = 100; // 第三层总亏损
input double ThirdAddLots = 0.1; // 第三层加仓手数
input double ThirdProfit = 200; // 第三层总获利

input double FourthLoss = 100; // 第四层总亏损
input double FourthAddLots = 0.1; // 第四层加仓手数
input double FourthProfit = 200; // 第四层总获利

input double FifthLoss = 100; // 第五层总亏损
input double FifthAddLots = 0.1; // 第五层加仓手数
input double FifthProfit = 200; // 第五层总获利

input double SixthLoss = 100; // 第六层总亏损
input double SixthAddLots = 0.1; // 第六层加仓手数
input double SixthProfit = 200; // 第六层总获利

input double SeventhLoss = 100; // 第七层总亏损
input double SeventhAddLots = 0.1; // 第七层加仓手数
input double SeventhProfit = 200; // 第七层总获利

input double EighthLoss = 100; // 第八层总亏损
input double EighthAddLots = 0.1; // 第八层加仓手数
input double EighthProfit = 200; // 第八层总获利





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
