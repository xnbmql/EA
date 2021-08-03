// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                           XY.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class XY
  {
public:
   int               X1;
   int               X2;
   int               Y1;
   int               Y2;
                     XY(int x1, int x2, int y1, int y2): X1(x1),X2(x2),Y1(y1),Y2(y2) {};
                     XY(const XY &xy){this.X1 = xy.X1;this.X2=xy.X2;this.Y1=xy.Y1;this.Y2=xy.Y2;};
  };
//+------------------------------------------------------------------+
