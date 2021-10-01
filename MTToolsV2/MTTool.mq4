// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                      MTTool.mq5  |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|  https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482 |
//+------------------------------------------------------------------+
#property copyright  "一键加群"


#property link     "https://www.baidu.com"
#property version   "1.00"
#property strict

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
string MYURL = "http://baidu.com"; // 一键加群的链接
//string MYURL = "https://item.taobao.com/item.htm?spm=a230r.1.14.8.30bd4e3dqk9kTD&id=651269419591&ns=1&abbucket=15#detail"; //
// 将账号填入这里，英文逗号分割
long loginAccounts[] = {6934445,1,2,3,4,5,6};

//是否开启绑定  false是不开启 true是开启
bool IsOpenLock = false;

OrderManager *om;
MTPanels *mtp;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print("TERMINAL_SCREEN_DPI:",TerminalInfoInteger(TERMINAL_SCREEN_DPI));
   int terminalDPI = TerminalInfoInteger(TERMINAL_SCREEN_DPI);
   datetime NY=D'2022.02.23 08:43:00'; //到期时间
   datetime d1 = TimeLocal();
   if(d1>NY)
     {
      Alert("已到期请续费：",GetLastError());
      Sleep(3000);
      ExpertRemove();
     }

   if(!accountVaild() && IsOpenLock)
     {
      Alert("此账号暂无使用权限...");
      Sleep(3000);
      ExpertRemove();
     }

   if(IsDllsAllowed()==false)
     {
      Alert("请允许dll（工具--》选项--》EA交易--》允许DLL），再运行");
      Sleep(3000);
      ExpertRemove();
     }
   int screen_dpi = TerminalInfoInteger(TERMINAL_SCREEN_DPI); // Find DPI of the user monitor
   int w = ChartWidthInPixels();
   int h = ChartHeightInPixels();
//--- Calculating the scaling factor as a percentage
   int scale_factor=(TerminalInfoInteger(TERMINAL_SCREEN_DPI) * 100) / 96;

   int roww =30*FontSize;
   if(roww <= 180)
     {
      roww = 180;
     }
   roww = roww*scale_factor/100;

   int fontsize;
   fontsize = FontSize*scale_factor/100;

   int rowh = 21*(FontSize*3);
//Print(rowh);
   if(rowh<= 21*20)
     {
      rowh =21*20;
     }
//Print(rowh);
   rowh = rowh*scale_factor/100;
   Print("w:",roww," h: ",rowh," dpi: ", screen_dpi, " scale_factor:", scale_factor, " fontsize:",fontsize);
   mtp = new MTPanels();
   if(!mtp.Create(0,"MT4交易助手",0,w-roww-20,20,w-20,rowh+20))
     {
      Print("新建助手失败");
      return(INIT_FAILED);
     }
   om = new OrderManager("OrderManager",OpenMagic,Slippage);
   om.LoadOpenningOrder();
   mtp.SetOrderManager(om);
   mtp.SetExpireDate(NY);
   mtp.Update();
   mtp.SetSpecURL(MYURL);

   mtp.Run();
   mtp.Minimized(false);
   mtp.SetFontSize(fontsize);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool accountVaild()
  {
// ENUM_ACCOUNT_TRADE_MODE tradeMode=(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);
// if(tradeMode == ACCOUNT_TRADE_MODE_DEMO)
//   {
//     Print("模拟模式随意使用");
//     return true;
//   }

   long accountID=AccountInfoInteger(ACCOUNT_LOGIN);
   for(int i=0; i<ArraySize(loginAccounts); i++)
     {
      if(loginAccounts[i]==accountID)
        {
         return true;
        }
     }
   return false;
  }

//+------------------------------------------------------------------+
//| The function gets the distance in pixels between the upper frame |
//| of the subwindow and the upper frame of the chart's main window. |
//+------------------------------------------------------------------+
int ChartWindowsYDistance(const long chart_ID=0,const int sub_window=0)
  {
//--- prepare the variable to get the property value
   long result=-1;
//--- reset the error value
   ResetLastError();
//--- receive the property value
   if(!ChartGetInteger(chart_ID,CHART_WINDOW_YDISTANCE,sub_window,result))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
     }
//--- return the value of the chart property
   return((int)result);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   delete om;
   mtp.Destroy(reason);
   delete mtp;
   ObjectsDeleteAll(0);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

   om.LoadOpenningOrder();
   om.Update();
   mtp.Update();

  }
//+------------------------------------------------------------------+


//bool tt = false;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam)
  {
   if(id!=CHARTEVENT_CHART_CHANGE)
     {
      mtp.ChartEvent(id,lparam,dparam,sparam);
     }

  }


//+------------------------------------------------------------------+
//| The function receives the chart width in pixels.                 |
//+------------------------------------------------------------------+
int ChartWidthInPixels(const long chart_ID=0)
  {
//--- prepare the variable to get the property value
   long result=-1;
//--- reset the error value
   ResetLastError();
//--- receive the property value
   if(!ChartGetInteger(chart_ID,CHART_WIDTH_IN_PIXELS,0,result))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
     }
//--- return the value of the chart property
   return((int)result);
  }

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ChartHeightInPixels(const long chart_ID=0)
  {
//--- prepare the variable to get the property value
   long result=-1;
//--- reset the error value
   ResetLastError();
//--- receive the property value
   if(!ChartGetInteger(chart_ID,CHART_HEIGHT_IN_PIXELS,0,result))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
     }
//--- return the value of the chart property
   return((int)result);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
