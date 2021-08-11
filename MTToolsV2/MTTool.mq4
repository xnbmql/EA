// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                      MTTool.mq5  |
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
//#include <Mylib\Trade\Ordermanager.mqh>
//#include "Ordermanager.mqh"
#include "MTPanels.mqh"

#include <arrays\list.mqh>
input int OpenMagic = 210803; // 魔术码
input int Slippage = 30; // 滑点
int StopProfit = 0; // 止盈点数
int StopLoss = 0; // 止损点数
int TrailingStopPoint = 0; // 移动止损点数
int PendingBuyOrderPoint = 0; // 挂单买入点数
int PendingSellOrderPoint = 0; // 挂单卖出点数

input int FontSize = 8; // 字体大小

long login_1 = 3;
long login_2 = 6934445;
long login_3 = 1;
long login_4 = 1;
long login_5 = 1;

OrderManager *om;
MTPanels mtp;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

   datetime NY=D'2021.08.29 08:43:00'; //到期时间
   datetime d1 = TimeLocal();
   if(d1>NY)
     {
      Alert("已到期请续费：",GetLastError());
      Sleep(3000);
      ExpertRemove();
     }
     
//+------------------------------------------------------------------+
//string account1 = AccountInfoString(ACCOUNT_NAME);
//Print("账户名称：",account1);
   long login=AccountInfoInteger(ACCOUNT_LOGIN);
   Print("账户ID: ",login);

   if((login==login_1) ||(login==login_2) || (login==login_3) || (login==login_4) || (login==login_5))
     {
      Print("账号验证成功...");
     }
   else
     {
      Alert("此账号暂无使用权限...");
      Sleep(3000);
      ExpertRemove();
     }

//+------------------------------------------------------------------+
   if(!mtp.Create(0,"MT助手v0.0.1",0,20,20,269,420))
     {
      //if(!mtp.Create(0,"mttt",0,20,20,300,450))
      //{
      return(INIT_FAILED);
     }
   om = new OrderManager("OrderManager",OpenMagic,Slippage);
   om.LoadOpenningOrder();
   mtp.SetOrderManager(om);
   mtp.Update();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   delete om;

   mtp.Destroy(0);
   ObjectsDeleteAll(0);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
//   datetime NY=D'2021.08.29 08:43:00'; //到期时间
//   datetime d1 = TimeLocal();
//   if(d1>NY)
//     {
//      Alert("已到期请续费：",GetLastError());
//      Sleep(3000);
//      ExpertRemove();
//     }
//
//   string account1 = AccountInfoString(ACCOUNT_NAME);
//   Print("账户名称：",account1);
//   long login=AccountInfoInteger(ACCOUNT_LOGIN);
//   Print("账户ID: ",login);

   om.LoadOpenningOrder();
   om.Update();
   mtp.Update();
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


   mtp.ChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
