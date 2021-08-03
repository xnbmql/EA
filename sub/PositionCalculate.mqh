// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                            PositionCalculate.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


#include "XY.mqh"
//#include

// RowPositionCalculate:: this class is a row position calculate
// required xStart yStart and xEnd yEnd
// then it will auto divid this area to 20 columns, only if the area
// is bigger than minBorder(42) + minElementWith(40) = 82
class RowPositionCalculate
  {
private:
   int               rowXStart;
   int               rowYStart;
   int               rowXEnd;
   int               rowYEnd;
   int               singleColWeight; // 单列长度
   int               singleRowHeight;
   int               currentOccupyCols;
   //CList
public:
                     RowPositionCalculate(int xStart, int yStart, int xEnd, int yEnd);
                    ~RowPositionCalculate(void);
   // register a elment
   // params:
   //  cols: this element will ocuppy how many columns
   // returns:
   //  index: element index if index is
   XY                RegisterElement(int cols,int topPadding=2, int bottomPadding=2, int leftPadding=0, int rightPadding=2);
   // RestRows:: return the rest rows
   // returns:
   // int RestRows();
   // XY GetElementPosition(int elementIndex);
private:
   bool              verifyElement(int cols,int topPadding=2, int bottomPadding=2, int leftPadding=2, int rightPadding=2);
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RowPositionCalculate::RowPositionCalculate(int xStart, int yStart, int xEnd, int yEnd)
  {
   rowXStart = xStart+2;
   rowYStart = yStart;
   rowXEnd = xEnd;
   rowYEnd = yEnd;
   singleRowHeight = (rowYEnd  - rowYStart);
   singleColWeight = (rowXEnd - rowXStart)/20;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RowPositionCalculate::~RowPositionCalculate(void)
  {
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
XY RowPositionCalculate::RegisterElement(int cols,int topPadding=2, int bottomPadding=2, int leftPadding=0, int rightPadding=2)
  {
   if(!verifyElement(cols, topPadding,bottomPadding,leftPadding,rightPadding))
     {
      XY xy(-1,-1,-1,-1);
      Print("new element error, too big for those cols");
      return xy;
     }
   int cxs = currentOccupyCols*singleColWeight+rowXStart;
   int cxe = cxs+cols*singleColWeight;
   currentOccupyCols += cols;
   XY xy(cxs+leftPadding,cxe-rightPadding, rowYStart+topPadding, rowYEnd - bottomPadding);
   return xy;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RowPositionCalculate::verifyElement(int cols,int topPadding=2, int bottomPadding=2, int leftPadding=2, int rightPadding=2)
  {
   if((currentOccupyCols+cols) > 20)
     {
      return false;
     }
   if(singleColWeight <= 0 || singleRowHeight <= 0)
     {
      return false;
     }
   if(cols * singleColWeight - leftPadding - rightPadding <=0)
     {
      return false;
     }
   if(singleRowHeight - topPadding - bottomPadding <= 0)
     {
      return false;
     }
   return true;

  }

//+------------------------------------------------------------------+
