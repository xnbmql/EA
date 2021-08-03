// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                      MTTool.mq4  |
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
#include "Ordermanager.mqh"
#include <arrays\list.mqh>
input int OpenMagic = 210803; // 魔术码
input int Slippage = 30; // 滑点
int StopProfit = 0; // 止盈点数
int StopLoss = 0; // 止损点数
int TrailingStopPoint = 0; // 移动止损点数
int PendingBuyOrderPoint = 0; // 挂单买入点数
int PendingSellOrderPoint = 0; // 挂单卖出点数

input int FontSize = 8; // 字体大小

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   datetime NY=D'2021.08.29 08:43:00'; //到期时间
   datetime d1 = TimeLocal();
   //Print(TimeLocal());
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

  }
