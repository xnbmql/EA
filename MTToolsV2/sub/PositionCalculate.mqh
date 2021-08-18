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
//#define DEFAULT_PADDING (1);
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
   int               padding;
   //CList
public:
                     RowPositionCalculate(int xStart, int yStart, int xEnd, int yEnd);
                     RowPositionCalculate();
                    ~RowPositionCalculate(void);
   void              SetDefaultPadding(int default_padding) {padding = default_padding;};
   // register a elment
   // params:
   //  cols: this element will ocuppy how many columns
   // returns:
   //  index: element index if index is
   XY                RegisterElement(int cols,int topPadding=2, int bottomPadding=0, int leftPadding=0, int rightPadding=2);
   XY                RegisterElementWithDefaultPadding(int cols);
   // RestRows:: return the rest rows
   // returns:
   // int RestRows();
   // XY GetElementPosition(int elementIndex);
private:
   bool              verifyElement(int cols,int topPadding=0, int bottomPadding=0, int leftPadding=0, int rightPadding=0);
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RowPositionCalculate::RowPositionCalculate()
  {
   padding = 2;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RowPositionCalculate::RowPositionCalculate(int xStart, int yStart, int xEnd, int yEnd)
  {
   rowXStart = xStart;
   rowYStart = yStart;
   rowXEnd = xEnd;
   rowYEnd = yEnd;

   singleRowHeight = (rowYEnd  - rowYStart);
   singleColWeight = (rowXEnd - rowXStart)/20;
   rowXStart=rowXStart+1+padding;

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
XY RowPositionCalculate::RegisterElement(int cols,int topPadding=2, int bottomPadding=0, int leftPadding=0, int rightPadding=2)
  {
////Print(currentOccupyCols," ----  ",cols);
   if(!verifyElement(cols, topPadding,bottomPadding,leftPadding,rightPadding))
     {

      if(currentOccupyCols+cols > 20)
        {
         XY xy(-1,-1,-1,-1);
         Print("new element error, too big for those cols");
         return xy;
        }
     }
// current x start
   int cxs = currentOccupyCols*singleColWeight+rowXStart;
// current x end
   int cxe = cxs+cols*singleColWeight;
   if(currentOccupyCols+cols == 20)
     {
      cxe-=padding;
     }
   currentOccupyCols += cols;
   XY xy(cxs+leftPadding,cxe-rightPadding, rowYStart+topPadding, rowYEnd - bottomPadding);
   return xy;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
XY RowPositionCalculate::RegisterElementWithDefaultPadding(int cols)
  {
   int topPadding = padding;
   int bottomPadding = 0;
   int leftPadding = 0;
   int rightPadding  = padding;
   return RegisterElement(cols,topPadding,bottomPadding,leftPadding,rightPadding);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RowPositionCalculate::verifyElement(int cols,int topPadding=0, int bottomPadding=0, int leftPadding=0, int rightPadding=0)
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
