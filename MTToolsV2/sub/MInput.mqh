// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                  MInput.mqh |
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
#include <Controls\Edit.mqh>

#include "PositionCalculate.mqh"
#include "XY.mqh"

#define ELEMENT_LEN                         (10)



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MInput : public CWndContainer
  {

private:
   CButton            m_label;
   CEdit             ed;
   RowPositionCalculate *pc;
   bool              read_only;
public:
                     MInput(void);
                    ~MInput(void);
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   bool              Value(const string value) {return ed.Text(value); };
   string            Value() {return ed.Text(); };
   bool              FontSize(const int value)
     {
      return ed.FontSize(value)&&m_label.FontSize(value);
     };
   bool              InitAll(string m_labelText,string i_value,bool iread_only=false)
     {
      if(!m_label.Text(m_labelText))
        {
         return false;
        }
      if(!ed.Text(i_value))
        {
         return false;
        }
      if(!ed.ReadOnly(iread_only))
        {
         return false;
        }
      return true;
     };
   bool              OnClickBtn();
protected:
   virtual bool      CreateLabel();
   virtual bool      CreateEdit();
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MInput::MInput(void) {}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MInput::~MInput(void)
  {
   delete pc;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(MInput)
EVENT_MAP_END(CWndContainer)

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MInput::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   if(!CWndContainer::Create(chart,name,subwin,x1,y1,x2,y2))
     {
      return(false);
     }

   pc = new RowPositionCalculate(0,0,x2-x1,y2-y1);
   if(!CreateLabel())
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
bool MInput::CreateLabel()
  {
   XY xy = pc.RegisterElement(ELEMENT_LEN);
   if(xy.X1<=0)
     {
      return false;
     }
//Print("X1:",xy.X1,"X2:",xy.X2,"Y1:",xy.Y1,"Y2:",xy.Y2);
   if(!m_label.Create(m_chart_id,m_name+"label",m_subwin, xy.X1,xy.Y1,xy.X2,xy.Y2))
     {
      return false;
     }
//m_label.Disable();
//m_label.Deactivate();
//m_label.ColorBorder(clrRed);
//m_label.Locking(true);


   if(!m_label.ColorBorder(clrSilver))
     {
      return false;
     }
   if(!m_label.ColorBackground(clrSilver))
     {
      return false;
     }


   if(!m_label.Text("not init"))
     {
      return false;
     }
   if(!Add(m_label))
     {
      return false;
     }
   return true;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MInput::CreateEdit()
  {
   XY xy = pc.RegisterElement(ELEMENT_LEN);
   if(xy.X1<=0)
     {
      return false;
     }
//Print("X1:",xy.X1,"X2:",xy.X2,"Y1:",xy.Y1,"Y2:",xy.Y2);
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
