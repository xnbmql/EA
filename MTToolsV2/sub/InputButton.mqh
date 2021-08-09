// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                  InputButton.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|  https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482 |
//+------------------------------------------------------------------+
#property copyright "https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-2315001482"
#property link      "19956480259"
#property version   "1.00"
#property strict

#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>

#include "PositionCalculate.mqh"
#include "XY.mqh"

#define BUTTON_LEN                         (10)
#define EDIT_LEN                           (10)


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class InputButton : public CWndContainer
  {

private:
   CButton           btn;
   CEdit             ed;
   RowPositionCalculate *pc;
public:
                     InputButton(void);
                    ~InputButton(void);
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   bool              Value(const string value) {return ed.Text(value); };
   string            Value() {return ed.Text(); };
   bool              InitAll(string btnText,string iValue)
     {
      if(!btn.Text(btnText))
        {
         return false;
        }
      if(!ed.Text(iValue))
        {
         return false;
        }
      return true;
     };
   bool              OnClickBtn();
protected:
   virtual bool      CreateButton();
   virtual bool      CreateEdit();
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
InputButton::InputButton(void) {}
InputButton::~InputButton(void) {}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(InputButton)
EVENT_MAP_END(CWndContainer)

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool InputButton::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   if(!CWndContainer::Create(chart,name,subwin,x1,y1,x2,y2))
     {
      return(false);
     }

   pc = new RowPositionCalculate(0,0,x2-x1,y2-y1);
   if(!CreateEdit())
     {
      return false;
     }
   if(!CreateButton())
     {
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool InputButton::CreateButton()
  {
   XY xy = pc.RegisterElement(BUTTON_LEN);
   if(xy.X1<=0)
     {
      return false;
     }

   if(!btn.Create(m_chart_id,m_name+"Btn",m_subwin, xy.X1,xy.Y1,xy.X2,xy.Y2))
     {
      return false;
     }

   if(!btn.Text("not init"))
     {
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
bool InputButton::CreateEdit()
  {
   XY xy = pc.RegisterElement(EDIT_LEN);
   if(xy.X1<=0)
     {
      return false;
     }

   if(!ed.Create(m_chart_id,m_name+"Btn",m_subwin, xy.X1,xy.Y1,xy.X2,xy.Y2))
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
