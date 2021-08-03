// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                     ValueBox.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//#include "WndContainer.mqh"
//#include "Button.mqh"
#include "PositionCalculate.mqh"
#include <Controls\WndContainer.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>

#include "XY.mqh"
#define BUTTON_LEN                         (2)
#define EDIT_LEN                           (8)

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ValueBox : public CWndContainer
  {
private:
   CButton           plus_btn;
   CButton           plus_up_btn;
   CButton           plus_up_up_btn;
   CButton           sub_btn;
   CButton           sub_down_btn;
   CButton           sub_down_down_btn;
   CEdit             valueInput;
   CButton           CloseAll;

   double            my_value;
   double            step1;
   double            step2;
   double            step3;
   double            mini;
   double            startX;
   double            startY;
   RowPositionCalculate *pc;
public:
                     ValueBox(void);
                    ~ValueBox(void);
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   double            Value(void) const {return my_value;}
   bool              Value(const double value)
     {
      if(value<mini)
        {
         my_value=mini;
        }
      else
        {
         my_value=value;
        }
      return valueInput.Text(DoubleToString(my_value,2));
     }
   void              Init(double initValue, double step1o, double step2o, double step3o,double minio)
     {
      my_value = initValue;
      Value(initValue);
      step1 = step1o;
      step2 = step2o;
      step3 = step3o;
      this.mini = minio;
     }
protected:
   virtual bool      CreatePlus();
   virtual bool      CreatePlusUp();
   virtual bool      CreatePlusUpUp();
   virtual bool      CreateValueInput();
   virtual bool      CreateSub();
   virtual bool      CreateSubDown();
   virtual bool      CreateSubDownDown();
   virtual bool      CloseAllOrders();

   virtual void      OnClickPlus(void);
   virtual void      OnClickPlusUp(void);
   virtual void      OnClickPlusUpUp(void);
   virtual void      OnValueInputChange(void);
   virtual void      OnClickSub(void);
   virtual void      OnClickSubDown(void);
   virtual void      OnClickSubDownDown(void);

   virtual void      OnCloseAllOrders(void);

  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(ValueBox)
ON_EVENT(ON_CLICK,plus_btn,OnClickPlus)
ON_EVENT(ON_CLICK,plus_up_btn,OnClickPlusUp)
ON_EVENT(ON_CLICK,plus_up_up_btn,OnClickPlusUpUp)
ON_EVENT(ON_CHANGE,valueInput,OnValueInputChange)
ON_EVENT(ON_CLICK,sub_btn,OnClickSub)
ON_EVENT(ON_CLICK,sub_down_btn,OnClickSubDown)
ON_EVENT(ON_CLICK,sub_down_down_btn,OnClickSubDownDown)
EVENT_MAP_END(CWndContainer)


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ValueBox::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   if(!CWndContainer::Create(chart,name,subwin,x1,y1,x2,y2))
     {
      return(false);
     }

   pc = new RowPositionCalculate(0,0,x2-x1,y2-y1);
   Print(x1," ",y1,"  ",x2,"  ", y2);
   if(!CreatePlusUpUp())
     {
      Print("Create plus up up btn failed");
      return false;
     }
   if(!CreatePlusUp())
     {
      Print("Create plus up btn failed");
      return false;
     }
   if(!CreatePlus())
     {
      Print("Create plus btn failed");
      return false;
     }

   if(!CreateValueInput())
     {
      Print("Create value input failed");
      return false;
     }
   if(!CreateSub())
     {
      Print("Create sub btn failed");
      return false;
     }
   if(!CreateSubDown())
     {
      Print("Create sub down btn failed");
      return false;
     }
   if(!CreateSubDownDown())
     {
      Print("Create sub down down btn failed");
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//ValueBox::ValueBox(double initValue, double step1o, double step2o, double step3o)
//  {
//
//  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ValueBox::ValueBox()
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ValueBox::~ValueBox()
  {
   delete pc;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ValueBox::CreateValueInput()
  {

   XY xy = pc.RegisterElement(EDIT_LEN);
   if(xy.X1<=0)
     {
      return false;
     }
   if(!valueInput.Create(m_chart_id,m_name+"ValueInput",m_subwin, xy.X1,xy.Y1,xy.X2,xy.Y2))
     {
      return false;
     }
   if(!valueInput.Text(string(my_value)))
     {
      return false;
     }
   if(!Add(valueInput))
     {
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ValueBox::CreatePlusUpUp()
  {
   XY xy = pc.RegisterElement(BUTTON_LEN);
//Print(xy.X1);
   if(xy.X1<=0)
     {
      return false;
     }
   if(!plus_up_up_btn.Create(m_chart_id,m_name+"PlusUpUpBtn",m_subwin, xy.X1,xy.Y1,xy.X2,xy.Y2))
     {
      return false;
     }
   if(!plus_up_up_btn.Text("▲"))
     {
      return false;
     }
   if(!Add(plus_up_up_btn))
     {
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ValueBox::CreatePlusUp()
  {
   XY xy = pc.RegisterElement(BUTTON_LEN);
   if(xy.X1<=0)
     {
      return false;
     }
   if(!plus_up_btn.Create(m_chart_id,m_name+"PlusUpBtn",m_subwin, xy.X1,xy.Y1,xy.X2,xy.Y2))
     {
      return false;
     }
   if(!plus_up_btn.Text("△"))
     {
      return false;
     }
   if(!Add(plus_up_btn))
     {
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ValueBox::CreatePlus()
  {

   XY xy = pc.RegisterElement(BUTTON_LEN);
   if(xy.X1<=0)
     {
      return false;
     }
   if(!plus_btn.Create(m_chart_id,m_name+"PlusBtn",m_subwin, xy.X1,xy.Y1,xy.X2,xy.Y2))
     {
      return false;
     }
   if(!plus_btn.Text("+"))
     {
      return false;
     }
   if(!Add(plus_btn))
     {
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ValueBox::CreateSub()
  {
   XY xy = pc.RegisterElement(BUTTON_LEN);
   if(xy.X1<=0)
     {
      return false;
     }
   if(!sub_btn.Create(m_chart_id,m_name+"SubBtn",m_subwin, xy.X1,xy.Y1,xy.X2,xy.Y2))
     {
      return false;
     }
   if(!sub_btn.Text("-"))
     {
      return false;
     }
   if(!Add(sub_btn))
     {
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ValueBox::CreateSubDown()
  {
   XY xy = pc.RegisterElement(BUTTON_LEN);
   if(xy.X1<=0)
     {
      return false;
     }
   if(!sub_down_btn.Create(m_chart_id,m_name+"SubDownBtn",m_subwin, xy.X1,xy.Y1,xy.X2,xy.Y2))
     {
      return false;
     }
   if(!sub_down_btn.Text("▽"))
     {
      return false;
     }
   if(!Add(sub_down_btn))
     {
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ValueBox::CreateSubDownDown()
  {
   XY xy = pc.RegisterElement(BUTTON_LEN);
   if(xy.X1<=0)
     {
      return false;
     }
   if(!sub_down_down_btn.Create(m_chart_id,m_name+"SubDownDownBtn",m_subwin, xy.X1,xy.Y1,xy.X2,xy.Y2))
     {
      return false;
     }
   if(!sub_down_down_btn.Text("▼"))
     {
      return false;
     }
   if(!Add(sub_down_down_btn))
     {
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ValueBox::OnClickPlus(void)
  {
   my_value += step1;
   Value(my_value);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ValueBox::OnClickPlusUp(void)
  {
   my_value += step2;
   Value(my_value);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ValueBox::OnClickPlusUpUp(void)
  {
   my_value += step3;
   Value(my_value);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ValueBox::OnValueInputChange(void)
  {
   Value(double(valueInput.Text()));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ValueBox::OnClickSub(void)
  {

   my_value -= step1;
   Value(my_value);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ValueBox::OnClickSubDown(void)
  {
   my_value -= step2;
   Value(my_value);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ValueBox::OnClickSubDownDown(void)
  {
   my_value -= step3;
   Value(my_value);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ValueBox::CloseAllOrders()
  {
   XY xy = pc.RegisterElement(BUTTON_LEN);
   if(xy.X1<=0)
     {
      return false;
     }
   if(!CloseAll.Create(m_chart_id,m_name+"CloseAllOrders",m_subwin, xy.X1,xy.Y1,xy.X2,xy.Y2))
     {
      return false;
     }
   if(!CloseAll.Text("一键平仓"))
     {
      return false;
     }
   if(!Add(CloseAll))
     {
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
