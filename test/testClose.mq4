//+------------------------------------------------------------------+
//|                                                    testClose.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <Mylib\Trade\Account.mqh>

AccountInfo message;

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
   Print("账户余额 = ",message.GetBalance());
   Print("账户活动资金 = ",message.GetAssets());
   Print("账户锁定保证金 = ",message.GetCommissio_blocked());
   Print("交易商公司名称 = ",message.GetCompany());
   Print("账户亏损 = ",message.GetCredit());
   Print("结算货币 = ",message.GetCurrency());
   Print("账户净值 = ",message.GetEquity());
   Print("杠杆倍数 = ",message.GetLeverage());
   Print("最大持仓单数 = ",message.GetLimitOrders());
   Print("账户ID = ",message.GetLoginID());
   Print("账户已用保证金 = ",message.GetMargin());
   Print("账户可用保证金 = ",message.GetMargin_free());
   Print("账户初始保证金 = ",message.GetMargin_initial());
   Print("账户可用保证金比例 = ",message.GetMargin_levle());
   Print("账户维持保证金 = ",message.GetMargin_maintenance());
   Print("账户追加保证金比例 = ",message.GetMargin_so_call());
   Print("保证金的计算模式 = ",message.GetMargin_so_mode());
   Print("爆仓保证金比例 = ",message.GetMargin_so_so());
   Print("账户名称 = ",message.GetName());
   Print("账户利润 = ",message.GetProfit());
   Print("交易商服务器的名称 = ",message.GetServer());
   Print("是否允许账户交易 = ",message.GetTrade_allowed());
   Print("是否允许EA交易 = ",message.GetTrade_expert());
   
  }
//+------------------------------------------------------------------+
