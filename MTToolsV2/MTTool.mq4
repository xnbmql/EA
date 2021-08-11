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

// 将账号填入这里，英文逗号分割
long loginAccounts[] = {6934445, 1,2,3,4,5,6};

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

   if(!accountVaild())
     {
      Alert("此账号暂无使用权限...");
      Sleep(3000);
      ExpertRemove();
     }

   if(!mtp.Create(0,"MT助手v0.0.1",0,20,20,269,420))
     {
      return(INIT_FAILED);
     }
   om = new OrderManager("OrderManager",OpenMagic,Slippage);
   om.LoadOpenningOrder();
   mtp.SetOrderManager(om);
   mtp.Update();
   return(INIT_SUCCEEDED);
  }

bool accountVaild(long accountID){
  // ENUM_ACCOUNT_TRADE_MODE tradeMode=(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);
  // if(tradeMode == ACCOUNT_TRADE_MODE_DEMO)
  //   {
  //   Print("模拟模式随意使用");
  //     return true;
  //   }

   long login=AccountInfoInteger(ACCOUNT_LOGIN);
  for(int i=0;i<ArraySize(loginAccounts);i++){
    if(loginAccounts[i]==accountID){
      return true;
    }
  }
  return false;
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
