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

#include "sub\XY.mqh"
#include "sub\PositionCalculate.mqh"

//--- indents and gaps
#define INDENT_LEFT                         (11)      // indent from left (with allowance for border width)
#define INDENT_TOP                          (11)      // indent from top (with allowance for border width)
#define CONTROLS_GAP_X                      (5)       // gap by X coordinate
//--- for buttons
#define BUTTON_WIDTH                        (100)     // size by X coordinate
#define BUTTON_HEIGHT                       (20)      // size by Y coordinate

#define BUTTON_LEN                         (8)
#define EDIT_LEN                           (8)

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MTPanels : public CAppDialog
  {

private:
   CButton           btn;
   CEdit             ed;


   RowPositionCalculate *show;
public:
                     MTPanels(void);
                    ~MTPanels(void);
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);

   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);

   bool              CreateButton();
   bool              CreateEdit();
   void   click(){Print("I'm click");};
  };
//+------------------------------------------------------------------+

EVENT_MAP_BEGIN(MTPanels)
ON_EVENT(ON_CLICK,btn,click)
EVENT_MAP_END(CAppDialog)
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
      delete show;
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

   show= new RowPositionCalculate(20,20,200,60);
   if(!CreateButton())
     {
      return false;
     }
   if(!CreateEdit())
     {
      return false;
     }

   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreateButton()
  {
   XY xy = show.RegisterElement(4);
   if(xy.X1<=0)
     {
      return false;
     }
   Print( xy.X1," ",xy.Y1," ",xy.X2," ",xy.Y2);
      //if(!btn.Create(m_chart_id,m_name+"Btn",m_subwin, 22,22,52,58))
   if(!btn.Create(m_chart_id,m_name+"Btn",m_subwin, xy.X1,xy.Y1,xy.X2,xy.Y2))
     {
      return false;
     }

   if(!btn.Text("not"))
     {
      return false;
     }
     if(!btn.ColorBackground(clrRed)){
      return false;
     }
   if(!Add(btn))
     {
      return false;
     }
   return true;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MTPanels::CreateEdit()
  {
   XY xy = show.RegisterElement(EDIT_LEN);
   if(xy.X1<=0)
     {
      return false;
     }
   Print("edit: ", xy.X1," ",xy.Y1," ",xy.X2," ",xy.Y2);
 
   //if(!ed.Create(m_chart_id,m_name+"Btn",m_subwin, xy.X1,xy.Y1,xy.X2,xy.Y2))
   if(!ed.Create(m_chart_id,m_name+"Ed",m_subwin, xy.X1,xy.Y1,xy.X2,xy.Y2))
     {
      return false;
     }

   if(!ed.Text("not init"))
     {
      return false;
     }
   if(!Add(ed))
     {
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
