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

#include "Mylib\Trade\OrderManager.mqh"
#include "Mylib\Panels\sub\XY.mqh"
#include "Mylib\Panels\sub\PositionCalculate.mqh"
#include "Mylib\Panels\sub\MInput.mqh"


class ControlPannel : public CAppDialog
 {

                     ControlPannel(void);
                    ~MTPanels(void);
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
 };


bool ControlPannel::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
     {
      Print("create dialog failed");
      return(false);
     }
   return true;
  }


ControlPannel::ControlPannel(void){}
