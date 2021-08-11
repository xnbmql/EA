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
#include <Controls\CheckBox.mqh>
#include <Mylib\Trade\OrderManager.mqh>

#include "sub\XY.mqh"
#include "sub\PositionCalculate.mqh"
#include "sub\MInput.mqh"


#define ROW_HEIGHT                          (24)      // size by Y coordinate
#define ROW_WIDTH                           (240)      // size by Y coordinate



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

   MInput            sl_ed;
   int               stop_loss_point;
   MInput            tp_ed;
   int               take_profit_point;

   MInput            t_sl_ed;
   int               trace_stop_loss_point;
   MInput            t_tp_ed;
   int               trace_take_profit_point;

   MInput            p_buy_ed;
   double            penning_buy_price;
   MInput            p_sell_ed;
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
   OrderManager      *om;


   bool              CreateProfitDp();
   bool              CreateVolumeEd();
   bool              CreateTradeButton();
   bool              CreateStopLossEdit();
   bool              CreateTakeProfitEdit();

   bool              CreateTraceStopLossEdit();
   bool              CreateTraceTakeProfitEdit();

   bool              CreatePenningBuyEdit();
   bool              CreatePenningSellEdit();

   bool              CreateSwitchBox();

   bool              CreateDeletePenningOrderBtn();

   bool              CreateLockAndReverseOrderBtn();

   bool              CreateBuyAndSellOrderCloseBtn();

   bool              CreateProfitAndLossOrderCloseBtn();

   bool              CreateAllOrderCloseBtn();

   int               current_row;

   bool              buyClick();

   void              sellClick();

   int               GetCurrentRowYEnd() {return current_row*ROW_HEIGHT;};


   void              closeAll();
   void              deletePenningOrder();
   void              closeProfit();
   void              closeLoss();
   void              closeBuy();
   void              closeSell();
   void              lockOrders();
   void              reverseOrders();
   bool              send(int operate);
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

  };
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//EVENT_MAP_BEGIN(MTPanels)
//ON_EVENT(ON_CLICK,sell_btn,sellClick)
//ON_EVENT(ON_CLICK,this.all_order_close_btn,this.closeAll)
//ON_EVENT(ON_CLICK,delete_penning_order_btn,deletePenningOrder)
//ON_EVENT(ON_CLICK,profit_order_close_btn,closeProfit)
//ON_EVENT(ON_CLICK,loss_order_close_btn,closeLoss)
//ON_EVENT(ON_CLICK,buy_order_close_btn,closeBuy)
//ON_EVENT(ON_CLICK,sell_order_close_btn,closeSell)
//ON_EVENT(ON_CLICK,lock_order_btn,lockOrders)
//ON_EVENT(ON_CLICK,reverse_order_btn,reverseOrders)
//ON_EVENT(ON_CLICK,buy_btn,buyClick)
//EVENT_MAP_END(CAppDialog)
//全部平仓按钮
bool      MTPanels::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(sparam==all_order_close_btn.Name()&& (ON_CLICK+CHARTEVENT_CUSTOM == id))
     {
      //Print(id,"---",lparam,"---",dparam,"---",sparam);
      //  Print(ON_CHANGE,": event");
      //Print(ON_CLICK+CHARTEVENT_CUSTOM,": event ",CHARTEVENT_CUSTOM);
      closeAll();
      return true;
     }
//能帮我绑定号事件嘛
//上面几行看得懂嘛
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
      Print("buy order");
      buyClick();
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
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::buyClick()
  {
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
   Print("111");
   
   for(int cnt=OrdersTotal(); cnt>=0; cnt--)
     {
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
bool MTPanels::send(int operate)
  {
   if(penning_buy_price != 0)
     {
      return om.PennigBuyWithPrice(penning_buy_price,volume)!=0;
     }
   if(penning_sell_price != 0)
     {
      return om.PennigSellWithPrice(penning_sell_price,volume)!=0;
     }
   bool stop_loss_trace = false;
   bool take_profit_trace = false;
   if(trace_stop_loss_point != 0)
     {
      stop_loss_point = trace_stop_loss_point;
      stop_loss_trace = true;
     }

   double price = 0.0;

   switch(operate)
     {
      case OP_BUY:
         return om.BuyWithStAndTp(volume,stop_loss_point,take_profit_point,stop_loss_trace)!=0;
      case OP_SELL:
         return om.SellWithStAndTp(volume,stop_loss_point,take_profit_point,stop_loss_trace)!=0;
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
   profit = om.FloatProfit();
   if(!profit_dp.Value(DoubleToString(NormalizeDouble(profit,2))))
     {
      Print("Set Profit DP error, content: ", profit);
     }

   stop_loss_point = int(StringToInteger(sl_ed.Value()));
   take_profit_point = int(StringToInteger(tp_ed.Value()));

   trace_stop_loss_point = int(StringToInteger(t_sl_ed.Value()));
   trace_take_profit_point = int(StringToInteger(t_tp_ed.Value()));

   penning_buy_price = NormalizeDouble(StringToDouble(p_buy_ed.Value()),Digits);
   penning_sell_price = NormalizeDouble(StringToDouble(p_sell_ed.Value()),Digits);

   switch_all = switch_box.Value()==1;

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
   if(!CreateTraceTakeProfitEdit())
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
bool MTPanels::CreateTraceTakeProfitEdit(void)
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   if(!t_tp_ed.Create(m_chart_id,m_name+"ttped",m_subwin, 0,yStart,ROW_WIDTH,yEnd))
     {
      return false;
     }

   if(!t_tp_ed.InitAll("移动止盈","0",false))
     {
      return false;
     }
   if(!Add(t_tp_ed))
     {
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool              MTPanels::CreatePenningBuyEdit()
  {
   int yStart = GetCurrentRowYEnd();
   current_row++;
   int yEnd = GetCurrentRowYEnd();
   if(!p_buy_ed.Create(m_chart_id,m_name+"pbed",m_subwin, 0,yStart,ROW_WIDTH,yEnd))
     {
      return false;
     }

   if(!p_buy_ed.InitAll("挂单买入","0",false))
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
   if(!p_sell_ed.Create(m_chart_id,m_name+"psed",m_subwin, 0,yStart,ROW_WIDTH,yEnd))
     {
      return false;
     }

   if(!p_sell_ed.InitAll("挂单卖出","0",false))
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
   XY p1 = pc.RegisterElement(9);
   pc.RegisterElement(1);
   XY p2 = pc.RegisterElement(10);
   delete pc;
   Print(m_chart_id);
   Print(m_subwin);

   if(!buy_btn.Create(m_chart_id,"bbtn1",m_subwin, p1.X1+2,p1.Y1,p1.X2,p1.Y2))
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
//Print("X1:",p1.X1," Y1:",p1.Y1," X2:",p1.X2," Y2:",p1.Y2);
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
