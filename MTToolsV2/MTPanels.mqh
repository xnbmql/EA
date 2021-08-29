// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                      MTPanels.mqh|
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|  https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482 |
//+------------------------------------------------------------------+
#property copyright "https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482"
#property link      "19956480259"
#property version   "1.00"
#property strict

#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Label.mqh>
#include <Controls\RadioGroup.mqh>
#include <Controls\Edit.mqh>
#include <Controls\CheckBox.mqh>
#include <Controls\Rect.mqh>
#include "sub\Trade\OrderManager.mqh"

#include "sub\XY.mqh"
#include "sub\PositionCalculate.mqh"
#include "sub\MInput.mqh"
#import "shell32.dll"
int ShellExecuteA(int hwnd, string Operation, string File, string Parameters, string Directory, int ShowCmd);
int ShellExecuteW(int hwnd,string Operation,string File,string Parameters,string Directory,int ShowCmd);
#import


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MTPanels : public CAppDialog
  {

private:


   MInput            volume_ed;
   double            volume;
   MInput            profit_dp;
   double            profit;

   CButton           buy_btn;
   CButton           sell_btn;
   int               ROW_WIDTH;
   int               ROW_HEIGHT;

   MInput            sl_ed;
   double            stop_loss_price;
   MInput            tp_ed;
   double            take_profit_price;

   MInput            t_sl_ed;
   double            trace_stop_loss_price;
   MInput            t_tp_ed;
   int               trace_take_profit_price;

   CButton           p_buy_btn;
   CEdit             p_buy_ed;
   double            penning_buy_price;

   CButton           p_sell_btn;
   CEdit             p_sell_ed;
   double            penning_sell_price;

   CCheckBox         switch_box;
   bool              switch_all;

   CButton           delete_penning_order_btn;

   CButton           lock_order_btn;
   CButton           reverse_order_btn;

   CButton           buy_order_close_btn;
   CButton           sell_order_close_btn;

   CButton           profit_order_close_btn;
   CButton           loss_order_close_btn;

   CButton           all_order_close_btn;
   CButton           accountInfo_btn;
   OrderManager      *om;
   CLabel            ed_label;
   CButton           okos;
   datetime          expire_date;

   string            spec_url;
   bool              CreateProfitDp();
   bool              CreateVolumeEd();
   bool              CreateTradeButton();
   bool              CreateStopLossEdit();
   bool              CreateTakeProfitEdit();

   bool              CreateTraceStopLossEdit();
   bool              CreatePenningBuyEdit();
   bool              CreatePenningSellEdit();

   bool              CreateSwitchBox();

   bool              CreateDeletePenningOrderBtn();

   bool              CreateLockAndReverseOrderBtn();

   bool              CreateBuyAndSellOrderCloseBtn();

   bool              CreateProfitAndLossOrderCloseBtn();

   bool              CreateAllOrderCloseBtn();
   bool              CreateOneKeyOpenSite(void);
   bool              CreateExpireDateDp(void);

   int               current_row;

   bool              buyClick();

   void              sellClick();

   int               GetCurrentRowYEnd() {return current_row*ROW_HEIGHT;};

   bool              OpenWebSite(string URL);
   void              closeAll();
   void              deletePenningOrder();
   void              closeProfit();
   void              closeLoss();
   void              closeBuy();
   void              closeSell();
   void              lockOrders();
   void              reverseOrders();
   bool              send(int operate);
   bool              UpdateSwtich();
   void              PenningBuy();
   double            AllProfit();
   void              PenningSell();
protected:
   void              MTPanels::Minimize(void);
public:

                     MTPanels(void);
                    ~MTPanels(void);
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   void              SetOrderManager(OrderManager *omo)
     {
      this.om = omo;
     };
   bool              Update();

   void              SetExpireDate(datetime d)
     {
      expire_date = d;
      ed_label.Text("到期时间："+(string)expire_date);
     };

   void              SetSpecURL(string sUrl)
     {
      spec_url = sUrl;

     };

   bool              SetFontSize(int val);

   void              MMax()
     {
      Maximize();
     }
   bool              MRebound();
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MTPanels::Minimize(void)
  {
//--- set flag
   m_minimized=true;
//--- hide client area
   ClientAreaVisible(false);
//--- resize
   MRebound();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::MRebound()
  {
   if(!Move(m_norm_rect.LeftTop()))
      return(false);
   if(!Size(m_min_rect.Size()))
      return(false);

//--- succeedSetSpecURL
   return(true);
  }
//+------------------------------------------------------------------+

//全部平仓按钮
bool      MTPanels::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {

   if(sparam==all_order_close_btn.Name()&& (ON_CLICK+CHARTEVENT_CUSTOM == id))
     {
      closeAll();
      return true;
     }
//删除挂单按钮
   if(sparam==delete_penning_order_btn.Name()&& (ON_CLICK+CHARTEVENT_CUSTOM == id))
     {
      deletePenningOrder();
      return true;
     }
//空单按钮
   if(sparam==sell_btn.Name()&& (ON_CLICK+CHARTEVENT_CUSTOM == id))
     {
      sellClick();
      return true;
     }
//盈利平仓按钮
   if(sparam==profit_order_close_btn.Name()&& (ON_CLICK+CHARTEVENT_CUSTOM == id))
     {
      closeProfit();
      return true;
     }
//亏损平仓按钮
   if(sparam==loss_order_close_btn.Name()&& (ON_CLICK+CHARTEVENT_CUSTOM == id))
     {
      closeLoss();
      return true;
     }
//多单平仓按钮
   if(sparam==buy_order_close_btn.Name()&& (ON_CLICK+CHARTEVENT_CUSTOM == id))
     {
      closeBuy();
      return true;
     }
//空单平仓按钮
   if(sparam==sell_order_close_btn.Name()&& (ON_CLICK+CHARTEVENT_CUSTOM == id))
     {
      closeSell();
      return true;
     }
//一键锁单按钮
   if(sparam==lock_order_btn.Name()&& (ON_CLICK+CHARTEVENT_CUSTOM == id))
     {
      lockOrders();
      return true;
     }
//一键反向按钮
   if(sparam==reverse_order_btn.Name()&& (ON_CLICK+CHARTEVENT_CUSTOM == id))
     {
      reverseOrders();
      return true;
     }
//多单按钮
   if(sparam==buy_btn.Name()&& (ON_CLICK+CHARTEVENT_CUSTOM == id))
     {
      // Print("buy order");
      buyClick();
      return true;
     }
// 挂单买入
   if(sparam==p_buy_btn.Name()&& (ON_CLICK+CHARTEVENT_CUSTOM == id))
     {

      PenningBuy();
      return true;
     }
// 挂单卖出
   if(sparam==p_sell_btn.Name()&& (ON_CLICK+CHARTEVENT_CUSTOM == id))
     {

      PenningSell();
      return true;
     }
// 一键加群
   if(sparam==okos.Name()&& (ON_CLICK+CHARTEVENT_CUSTOM == id))
     {
      OpenWebSite(spec_url);
      return true;
     }

   return CAppDialog::OnEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MTPanels::MTPanels()
  {

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MTPanels::~MTPanels()
  {
   delete om;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool  MTPanels::SetFontSize(int val)
  {
   volume_ed.FontSize(val);

   profit_dp.FontSize(val);

   buy_btn.FontSize(val);
   sell_btn.FontSize(val);

   sl_ed.FontSize(val);
   tp_ed.FontSize(val);

   t_sl_ed.FontSize(val);
   t_tp_ed.FontSize(val);

   p_buy_btn.FontSize(val);
   p_buy_ed.FontSize(val);

   p_sell_btn.FontSize(val);
   p_sell_ed.FontSize(val);


   delete_penning_order_btn.FontSize(val);

   lock_order_btn.FontSize(val);
   reverse_order_btn.FontSize(val);

   buy_order_close_btn.FontSize(val);
   sell_order_close_btn.FontSize(val);

   profit_order_close_btn.FontSize(val);
   loss_order_close_btn.FontSize(val);

   all_order_close_btn.FontSize(val);
   accountInfo_btn.FontSize(val);
   ed_label.FontSize(val);
   okos.FontSize(val);
   m_chart.Redraw();
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::OpenWebSite(string URL)
  {
   int ret = ShellExecuteW(0,"open",URL,"","",7);
   return ret==42;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::buyClick()
  {
   Update();
   if(!send(OP_BUY))
     {
      Print("buyClick error: ",GetLastError());
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MTPanels::sellClick()
  {
   Update();
   if(!send(OP_SELL))
     {
      Print("sellClick error: ",GetLastError());
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MTPanels::reverseOrders()
  {
   int tickets[];
   ArrayResize(tickets,OrdersTotal());
   for(int cnt=OrdersTotal(); cnt>=0; cnt--)
     {
      UpdateSwtich();
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true && (OrderSymbol()==Symbol() || switch_all))
        {
         tickets[cnt] = OrderTicket();
        }
     }

   closeAll();
   for(int i = 0; i < ArraySize(tickets); i++)
     {
      int ticket = tickets[i];
      if(ticket!=0&&OrderSelect(ticket, SELECT_BY_TICKET)) //选择订单
        {
         int type = OrderType();
         if(type ==OP_BUYLIMIT || type ==OP_SELLLIMIT || type ==OP_BUYSTOP || type==OP_SELLSTOP)
           {
            continue;
           }
         string symbol = OrderSymbol();
         int magicNum = OrderMagicNumber();
         string comment = OrderComment();
         double lots = OrderLots();
         if(type==OP_BUY)
           {
            if(!sendOrder(symbol,lots,OP_SELL,magicNum,comment))
              {
               Print("reverseOrders OP_SELL error: ",GetLastError());
               return;
              }
           }
         else
           {
            if(!sendOrder(symbol,lots,OP_BUY,magicNum,comment))
              {
               Print("reverseOrders OP_BUY error: ",GetLastError());
               return;
              }
           }

        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MTPanels::lockOrders()
  {
   int tickets[];
   ArrayResize(tickets,OrdersTotal());
   for(int cnt=OrdersTotal(); cnt>=0; cnt--)
     {
      UpdateSwtich();
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true && (OrderSymbol()==Symbol() || switch_all))
        {
         tickets[cnt] = OrderTicket();
        }
     }

   for(int i = 0; i < ArraySize(tickets); i++)
     {
      int ticket = tickets[i];
      if(ticket!=0&&OrderSelect(ticket, SELECT_BY_TICKET)) //选择订单
        {
         int type = OrderType();
         if(type ==OP_BUYLIMIT || type ==OP_SELLLIMIT || type ==OP_BUYSTOP || type==OP_SELLSTOP)
           {
            continue;
           }
         string symbol = OrderSymbol();
         int magicNum = OrderMagicNumber();
         string comment = OrderComment();
         double lots = OrderLots();
         if(type==OP_BUY)
           {

            if(!sendOrder(symbol,lots,OP_SELL,magicNum,comment))
              {
               Print("lockOrder OP_SELL error: ",GetLastError());
               return;
              }
           }
         else
           {
            if(!sendOrder(symbol,lots,OP_BUY,magicNum,comment))
              {
               Print("lockOrder OP_BUY error: ",GetLastError());
               return;
              }
           }

        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool sendOrder(string sybl,double volume,int operate,int magicNum,string commento)
  {
   double price = 0.0;
   switch(operate)
     {
      case OP_BUY:
         price = MarketInfo(sybl,MODE_ASK);
         break;
      case OP_SELL:
         price = MarketInfo(sybl,MODE_BID);
         break;
      default:
         Print("UNKNOW type");
         return false;
     }
   int slp =(int) MarketInfo(Symbol(),MODE_SPREAD);
   int ticket = OrderSend(sybl,operate,volume,price,slp,0,0,commento, magicNum,0,clrNONE);
   return ticket > 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MTPanels::deletePenningOrder()
  {
   for(int cnt=OrdersTotal(); cnt>=0; cnt--)
     {
      UpdateSwtich();
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true && (OrderSymbol()==Symbol() || switch_all))
        {
         if(OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT || OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP)
           {
            if(!OrderDelete(OrderTicket()))
              {
               Print("deletePenningOrder order error",GetLastError());
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MTPanels::closeLoss()
  {
   for(int cnt=OrdersTotal(); cnt>=0; cnt--)
     {
      UpdateSwtich();
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true && (OrderSymbol()==Symbol() || switch_all))
        {
         int slp =(int) MarketInfo(OrderSymbol(),MODE_SPREAD);
         double netProfit =  OrderProfit() + OrderSwap() + OrderCommission();
         if(netProfit>0)
           {
            continue;
           }
         if(OrderType()==OP_BUY)
           {
            if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slp,clrNONE))
              {
               Print("closeLoss buy order error",GetLastError());
               return;
              }
           }
         if(OrderType()==OP_SELL)
           {
            if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slp,clrNONE))
              {
               Print("closeLoss sell order error",GetLastError());
               return;
              }
           }
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MTPanels::closeBuy()
  {
   for(int cnt=OrdersTotal(); cnt>=0; cnt--)
     {
      UpdateSwtich();
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true && (OrderSymbol()==Symbol() || switch_all))
        {
         int slp =(int) MarketInfo(OrderSymbol(),MODE_SPREAD);
         if(OrderType()==OP_BUY)
           {
            if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slp,clrNONE))
              {
               Print("closeBuy order error",GetLastError());
               return;
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MTPanels::closeSell()
  {
   for(int cnt=OrdersTotal(); cnt>=0; cnt--)
     {
      UpdateSwtich();
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true && (OrderSymbol()==Symbol() || switch_all))
        {
         int slp =(int) MarketInfo(OrderSymbol(),MODE_SPREAD);
         if(OrderType()==OP_SELL)
           {
            if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slp,clrNONE))
              {
               Print("closeSell order error",GetLastError());
               return;
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MTPanels::closeProfit()
  {
   for(int cnt=OrdersTotal(); cnt>=0; cnt--)
     {
      UpdateSwtich();
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true && (OrderSymbol()==Symbol() || switch_all))
        {
         int slp =(int) MarketInfo(OrderSymbol(),MODE_SPREAD);
         double netProfit =  OrderProfit() + OrderSwap() + OrderCommission();
         if(netProfit<0)
           {
            continue;
           }
         if(OrderType()==OP_BUY)
           {
            if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slp,clrNONE))
              {
               Print("closeProfit buy order error",GetLastError());
               return;
              }
           }
         if(OrderType()==OP_SELL)
           {
            if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slp,clrNONE))
              {
               Print("closeProfit sell order error",GetLastError());
               return;
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MTPanels::closeAll()
  {
   for(int cnt=OrdersTotal(); cnt>=0; cnt--)
     {
      UpdateSwtich();
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true && (OrderSymbol()==Symbol() || switch_all))
        {
         if(OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT || OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP)
           {
            if(!OrderDelete(OrderTicket()))
              {
               Print("closeAll delete order error",GetLastError());
               return ;
              }
           }
         int slp =(int) MarketInfo(OrderSymbol(),MODE_SPREAD);
         if(OrderType()==OP_BUY)
           {
            if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slp,clrNONE))
              {
               Print("closeAll buy order error",GetLastError());
               return ;
              }
           }
         if(OrderType()==OP_SELL)
           {
            if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slp,clrNONE))
              {
               Print("closeAll sell order error",GetLastError());
               return ;
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MTPanels::AllProfit()
  {
   double netProfit = 0;
   for(int cnt=OrdersTotal(); cnt>=0; cnt--)
     {
      UpdateSwtich();
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         netProfit +=  OrderProfit()+ OrderSwap() + OrderCommission();
        }
     }
   return netProfit;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  MTPanels::PenningSell()
  {
   Update();
   if(penning_sell_price != 0)
     {
      if(om.PennigSellWithPrice(penning_sell_price,volume)==0)
        {
         Print("Penning sell erro ",GetLastError());
        }
     }
   else
     {
      Print("Price is zero");
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  MTPanels::PenningBuy()
  {
   Update();
   if(penning_buy_price != 0)
     {
      if(om.PennigBuyWithPrice(penning_buy_price,volume)==0)
        {
         Print("Penning buy erro ",GetLastError());
        }

     }
   else
     {
      Print("Price is zero");
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::send(int operate)
  {
   bool stop_loss_trace = false;
   if(trace_stop_loss_price != 0)
     {
      stop_loss_price = trace_stop_loss_price;
      stop_loss_trace = true;
     }

   double price = 0.0;

   switch(operate)
     {
      case OP_BUY:
      case OP_SELL:
         return om.SendWithStAndTpOrderByPrice(operate,volume,stop_loss_price,take_profit_price,0,NULL,clrNONE,stop_loss_trace)!=0;
      default:
         Print("MTPanels::send error: unknown operate type");
         return false;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::Update()
  {
   volume = NormalizeDouble(StringToDouble(volume_ed.Value()),2);
   if(volume < MarketInfo(Symbol(),MODE_MINLOT))
     {
      volume = MarketInfo(Symbol(),MODE_MINLOT);
      volume_ed.Value(DoubleToString(volume,2));
     }
   if(volume > MarketInfo(Symbol(),MODE_MAXLOT))
     {
      volume = MarketInfo(Symbol(),MODE_MAXLOT);
      volume_ed.Value(DoubleToString(volume,2));
     }

   double lot_min=MarketInfo(Symbol(),MODE_MINLOT);
   double lot_max=MarketInfo(Symbol(),MODE_MAXLOT);
   profit = AllProfit();
   if(!profit_dp.Value(DoubleToString(NormalizeDouble(profit,2),2)))
     {
      Print("Set Profit DP error, content: ", profit);
     }

   stop_loss_price = StringToDouble(sl_ed.Value());
   take_profit_price = StringToDouble(tp_ed.Value());

   trace_stop_loss_price = StringToDouble(t_sl_ed.Value());

   penning_buy_price = NormalizeDouble(StringToDouble(p_buy_ed.Text()),Digits);
   penning_sell_price = NormalizeDouble(StringToDouble(p_sell_ed.Text()),Digits);
   UpdateSwtich();


   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::UpdateSwtich()
  {
   switch_all = switch_box.Checked();
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {

   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
     {
      return(false);
     }
// 18 代表一个页面的元素行数
   ROW_HEIGHT = (y2-y1)/18;
   if(ROW_HEIGHT < 20)
     {
      ROW_HEIGHT = 20;
     }
   ROW_WIDTH = ClientAreaWidth();

   if(!CreateOneKeyOpenSite())
     {
      return false;
     }
   if(!CreateProfitDp())
     {
      return false;
     }

   if(!CreateVolumeEd())
     {
      return false;
     }

   if(!CreateTradeButton())
     {
      return false;
     }
   if(!CreateStopLossEdit())
     {
      return false;
     }
   if(!CreateTakeProfitEdit())
     {
      return false;
     }
   if(!CreateTraceStopLossEdit())
     {
      return false;
     }

   if(!CreatePenningBuyEdit())
     {
      return false;
     }
   if(!CreatePenningSellEdit())
     {
      return false;
     }
   if(!CreateSwitchBox())
     {
      return false;
     }

   if(!CreateDeletePenningOrderBtn())
     {
      return false;
     }

   if(!CreateLockAndReverseOrderBtn())
     {
      return false;
     }

   if(!CreateBuyAndSellOrderCloseBtn())
     {
      return false;
     }

   if(!CreateProfitAndLossOrderCloseBtn())
     {
      return false;
     }

   if(!CreateAllOrderCloseBtn())
     {
      return false;
     }

   if(!CreateExpireDateDp())
     {
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreateProfitDp()
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   if(!profit_dp.Create(m_chart_id,m_name+"pdp",m_subwin, 0,yStart,ROW_WIDTH,yEnd))
     {
      return false;
     }

   if(!profit_dp.InitAll("总盈亏","0",true))
     {
      return false;
     }
   if(!Add(profit_dp))
     {
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreateVolumeEd()
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   if(!volume_ed.Create(m_chart_id,m_name+"ved",m_subwin, 0,yStart,ROW_WIDTH,yEnd))
     {
      return false;
     }

   if(!volume_ed.InitAll("手数","0",false))
     {
      return false;
     }
   if(!Add(volume_ed))
     {
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreateTraceStopLossEdit(void)
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   if(!t_sl_ed.Create(m_chart_id,m_name+"sled",m_subwin, 0,yStart,ROW_WIDTH,yEnd))
     {
      return false;
     }

   if(!t_sl_ed.InitAll("移动止损","0",false))
     {
      return false;
     }
   if(!Add(t_sl_ed))
     {
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreateStopLossEdit(void)
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   if(!sl_ed.Create(m_chart_id,m_name+"tsled",m_subwin, 0,yStart,ROW_WIDTH,yEnd))
     {
      return false;
     }

   if(!sl_ed.InitAll("止损","0",false))
     {
      return false;
     }
   if(!Add(sl_ed))
     {
      return false;
     }
   return true;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreateTakeProfitEdit(void)
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   if(!tp_ed.Create(m_chart_id,m_name+"tped",m_subwin, 0,yStart,ROW_WIDTH,yEnd))
     {
      return false;
     }

   if(!tp_ed.InitAll("止盈","0",false))
     {
      return false;
     }
   if(!Add(tp_ed))
     {
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreatePenningBuyEdit()
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   RowPositionCalculate *pc = new RowPositionCalculate(0,yStart,ROW_WIDTH,yEnd);
   XY p1 = pc.RegisterElement(10);
   XY p2 = pc.RegisterElement(10);
   delete pc;

   if(!p_buy_btn.Create(m_chart_id,"pbb",m_subwin, p1.X1,p1.Y1,p1.X2,p1.Y2))
     {
      return false;
     }
   if(!p_buy_btn.Text("挂单买入"))
     {
      return false;
     }
   if(!p_buy_btn.FontSize(30))
     {
      return false;
     }

   if(!Add(p_buy_btn))
     {
      return false;
     }

   if(!p_buy_ed.Create(m_chart_id,"pbe",m_subwin, p2.X1,p2.Y1,p2.X2,p2.Y2))
     {
      return false;
     }

   if(!p_buy_ed.Text("0.0"))
     {
      return false;
     }

   if(!Add(p_buy_ed))
     {
      return false;
     }

   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool              MTPanels::CreatePenningSellEdit()
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   RowPositionCalculate *pc = new RowPositionCalculate(0,yStart,ROW_WIDTH,yEnd);
   XY p1 = pc.RegisterElement(10);
   XY p2 = pc.RegisterElement(10);
   delete pc;

   if(!p_sell_btn.Create(m_chart_id,"psb",m_subwin, p1.X1,p1.Y1,p1.X2,p1.Y2))
     {
      return false;
     }
   if(!p_sell_btn.Text("挂单卖出"))
     {
      return false;
     }

   if(!Add(p_sell_btn))
     {
      return false;
     }

   if(!p_sell_ed.Create(m_chart_id,"pse",m_subwin, p2.X1,p2.Y1,p2.X2,p2.Y2))
     {
      return false;
     }

   if(!p_sell_ed.Text("0.0"))
     {
      return false;
     }

   if(!Add(p_sell_ed))
     {
      return false;
     }

   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreateTradeButton()
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;

   int yEnd = GetCurrentRowYEnd();
   RowPositionCalculate *pc = new RowPositionCalculate(0,yStart,ROW_WIDTH,yEnd);
   XY p1 = pc.RegisterElement(10);
   XY p2 = pc.RegisterElement(10);
   delete pc;
   if(!buy_btn.Create(m_chart_id,"bbtn1",m_subwin, p1.X1,p1.Y1,p1.X2,p1.Y2))
     {
      return false;
     }

   if(!buy_btn.Text("买入"))
     {
      return false;
     }

   if(!Add(buy_btn))
     {
      return false;
     }

   if(!sell_btn.Create(m_chart_id,"sbtn",m_subwin, p2.X1,p2.Y1,p2.X2,p2.Y2))
     {
      return false;
     }

   if(!sell_btn.Text("卖出"))
     {
      return false;
     }

   if(!Add(sell_btn))
     {
      return false;
     }

   return true;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreateSwitchBox(void)
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;

   int yEnd = GetCurrentRowYEnd();
   RowPositionCalculate *pc = new RowPositionCalculate(0,yStart,ROW_WIDTH,yEnd);
   XY p0 = pc.RegisterElement(4);
   XY p1 = pc.RegisterElement(12);
   delete pc;
   if(!switch_box.Create(m_chart_id,m_name+"sr",m_subwin, p1.X1,p1.Y1,p1.X2,p1.Y2))
     {
      return false;
     }

   if(!switch_box.Text("全部货币对"))
     {
      return false;
     }
   if(!Add(switch_box))
     {
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreateOneKeyOpenSite(void)
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   RowPositionCalculate *pc = new RowPositionCalculate(0,yStart,ROW_WIDTH,yEnd);
   XY p1 = pc.RegisterElement(20);
   delete pc;
   if(!okos.Create(m_chart_id,m_name+"okaq",m_subwin, p1.X1,p1.Y1,p1.X2,p1.Y2))
     {
      return false;
     }

   //if(!okos.Text("一键加群"))
   if(!okos.Text("程序定制"))
     {
      return false;
     }
   if(!Add(okos))
     {
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreateExpireDateDp(void)
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   RowPositionCalculate *pc = new RowPositionCalculate(0,yStart,ROW_WIDTH,yEnd);
   XY p1 = pc.RegisterElement(20);
   delete pc;
   if(!ed_label.Create(m_chart_id,m_name+"sr",m_subwin, p1.X1,p1.Y1,p1.X2,p1.Y2))
     {
      return false;
     }

   if(!ed_label.Text(""))
     {
      return false;
     }
   if(!Add(ed_label))
     {
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool  MTPanels::CreateDeletePenningOrderBtn()
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   RowPositionCalculate *pc = new RowPositionCalculate(0,yStart,ROW_WIDTH,yEnd);
   XY p1 = pc.RegisterElement(20);
   delete pc;

   if(!delete_penning_order_btn.Create(m_chart_id,m_name+"dpob",m_subwin, p1.X1,p1.Y1,p1.X2,p1.Y2))
     {
      return false;
     }

   if(!delete_penning_order_btn.Text("删除挂单"))
     {
      return false;
     }
   if(!Add(delete_penning_order_btn))
     {
      return false;
     }
   return true;
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreateLockAndReverseOrderBtn()
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   RowPositionCalculate *pc = new RowPositionCalculate(0,yStart,ROW_WIDTH,yEnd);
   XY p1 = pc.RegisterElement(10);
   XY p2 = pc.RegisterElement(10);
   delete pc;
   if(!lock_order_btn.Create(m_chart_id,m_name+"lob",m_subwin, p1.X1,p1.Y1,p1.X2,p1.Y2))
     {
      return false;
     }

   if(!lock_order_btn.Text("一键锁单"))
     {
      return false;
     }

   if(!Add(lock_order_btn))
     {
      return false;
     }

   if(!reverse_order_btn.Create(m_chart_id,m_name+"rob",m_subwin, p2.X1,p2.Y1,p2.X2,p2.Y2))
     {
      return false;
     }

   if(!reverse_order_btn.Text("一键反向"))
     {
      return false;
     }

   if(!Add(reverse_order_btn))
     {
      return false;
     }

   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreateBuyAndSellOrderCloseBtn()
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   RowPositionCalculate *pc = new RowPositionCalculate(0,yStart,ROW_WIDTH,yEnd);
   XY p1 = pc.RegisterElement(10);
   XY p2 = pc.RegisterElement(10);
   delete pc;
   if(!buy_order_close_btn.Create(m_chart_id,m_name+"bocb",m_subwin, p1.X1,p1.Y1,p1.X2,p1.Y2))
     {
      return false;
     }

   if(!buy_order_close_btn.Text("多单平仓"))
     {
      return false;
     }

   if(!Add(buy_order_close_btn))
     {
      return false;
     }


   if(!sell_order_close_btn.Create(m_chart_id,m_name+"socb",m_subwin, p2.X1,p2.Y1,p2.X2,p2.Y2))
     {
      return false;
     }

   if(!sell_order_close_btn.Text("空单平仓"))
     {
      return false;
     }

   if(!Add(sell_order_close_btn))
     {
      return false;
     }

   return true;
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreateProfitAndLossOrderCloseBtn()
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   RowPositionCalculate *pc = new RowPositionCalculate(0,yStart,ROW_WIDTH,yEnd);
   XY p1 = pc.RegisterElement(10);
   XY p2 = pc.RegisterElement(10);
   delete pc;
   if(!profit_order_close_btn.Create(m_chart_id,m_name+"pocb",m_subwin, p1.X1,p1.Y1,p1.X2,p1.Y2))
     {
      return false;
     }

   if(!profit_order_close_btn.Text("盈利平仓"))
     {
      return false;
     }

   if(!Add(profit_order_close_btn))
     {
      return false;
     }


   if(!loss_order_close_btn.Create(m_chart_id,m_name+"locb",m_subwin, p2.X1,p2.Y1,p2.X2,p2.Y2))
     {
      return false;
     }

   if(!loss_order_close_btn.Text("亏损平仓"))
     {
      return false;
     }

   if(!Add(loss_order_close_btn))
     {
      return false;
     }

   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreateAllOrderCloseBtn()
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   RowPositionCalculate *pc = new RowPositionCalculate(0,yStart,ROW_WIDTH,yEnd);
   XY p1 = pc.RegisterElement(20);
   delete pc;
   if(!all_order_close_btn.Create(0,m_name+"caob",0, p1.X1,p1.Y1,p1.X2,p1.Y2))
     {
      return false;
     }

   if(!all_order_close_btn.Text("全部平仓"))
     {
      return false;
     }
   if(!Add(all_order_close_btn))
     {
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
