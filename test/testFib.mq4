//+------------------------------------------------------------------+
//|                                                      testFib.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property description "Script draws \"Fibonacci Retracement\" graphical object." 
#property description "Anchor point coordinates are set in percentage of" 
#property description "the chart window size." 
//--- 启动脚本期间显示输入参数的窗口 
#property script_show_inputs 
//--- 脚本的输入参数 
input string          InpName="FiboLevels";      // 对象名称 
input int             InpDate1=10;               // 第1个点的日期，% 
input int             InpPrice1=65;              // 第1个点的价格，% 
input int             InpDate2=90;               // 第2个点的日期，% 
input int             InpPrice2=85;              // 第2个点的价格，% 
input color           InpColor=clrRed;           // 对象的颜色 
input ENUM_LINE_STYLE InpStyle=STYLE_DASHDOTDOT; // 线的风格 
input int             InpWidth=2;                // 线的宽度 
input bool            InpBack=false;             // 背景对象 
input bool            InpSelection=true;         // 突出移动 
input bool            InpRayLeft=false;          // 对象延续向左 
input bool            InpRayRight=false;         // 对象延续向右 
input bool            InpHidden=true;            // 隐藏在对象列表 
input long            InpZOrder=0;               // 鼠标单击优先 
//+------------------------------------------------------------------+ 
//| 通过已给的坐标创建斐波纳契回调线                                     | 
//+------------------------------------------------------------------+ 
bool FiboLevelsCreate(const long            chart_ID=0,        // 图表 ID 
                      const string          name="FiboLevels", // 对象名称 
                      const int             sub_window=0,      // 子窗口指数  
                      datetime              time1=0,           // 第一个点的时间 
                      double                price1=0,          // 第一个点的价格 
                      datetime              time2=0,           // 第二个点的时间 
                      double                price2=0,          // 第二个点的价格 
                      const color           clr=clrRed,        // 对象颜色 
                      const ENUM_LINE_STYLE style=STYLE_SOLID, // 对象线的风格 
                      const int             width=1,           // 对象线的宽度 
                      const bool            back=false,        // 在背景中 
                      const bool            selection=true,    // 突出移动 
                      const bool            ray_left=false,    // 对象持续向左 
                      const bool            ray_right=false,   // 对象持续向右 
                      const bool            hidden=true,       // 隐藏在对象列表 
                      const long            z_order=0)         // 鼠标单击优先 
  { 
//--- 若未设置则设置定位点的坐标 
   ChangeFiboLevelsEmptyPoints(time1,price1,time2,price2); 
//--- 重置错误的值 
   ResetLastError(); 
//--- 用给定的坐标创建斐波纳契回调线 
   if(!ObjectCreate(chart_ID,name,OBJ_FIBO,sub_window,time1,price1,time2,price2)) 
     { 
      Print(__FUNCTION__, 
            ": failed to create \"Fibonacci Retracement\"! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- 设置颜色 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- 设置线的风格 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- 设置线的宽度 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
//--- 显示前景 (false) 或背景 (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- 启用 (true) 或禁用 (false) 突出通道移动的模式 
//--- 当使用ObjectCreate函数创建图形对象时，对象不能 
//--- 默认下突出并移动。在这个方法中，默认选择参数 
//--- true 可以突出移动对象 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- 启用 (true) 或禁用 (false) 延续向左显示对象的模式 
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_LEFT,ray_left); 
//--- 启用 (true) 或禁用 (false) 延续向右显示对象的模式 
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right); 
//--- 在对象列表隐藏(true) 或显示 (false) 图形对象名称 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- 设置在图表中优先接收鼠标点击事件 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- 成功执行 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| 设置水平的数量和参数                                                | 
//+------------------------------------------------------------------+ 
bool FiboLevelsSet(int             levels,            // 水平线的数量 
                   double          &values[],         // 水平线的值 
                   color           &colors[],         // 水平线的颜色 
                   ENUM_LINE_STYLE &styles[],         // 水平线的风格 
                   int             &widths[],         // 水平线的宽度 
                   const long      chart_ID=0,        // 图表ID 
                   const string    name="FiboLevels") // 对象名称 
  { 
//--- 检查数组大小 
   if(levels!=ArraySize(colors) || levels!=ArraySize(styles) || 
      levels!=ArraySize(widths) || levels!=ArraySize(widths)) 
     { 
      Print(__FUNCTION__,": array length does not correspond to the number of levels, error!"); 
      return(false); 
     } 
//--- 设置水平数量 
   ObjectSetInteger(chart_ID,name,OBJPROP_LEVELS,levels); 
//--- 设置循环中水平的属性 
   for(int i=0;i<levels;i++) 
     { 
      //--- 水平的值 
      ObjectSetDouble(chart_ID,name,OBJPROP_LEVELVALUE,i,values[i]); 
      //--- 水平的颜色 
      ObjectSetInteger(chart_ID,name,OBJPROP_LEVELCOLOR,i,colors[i]); 
      //--- 水平的风格 
      ObjectSetInteger(chart_ID,name,OBJPROP_LEVELSTYLE,i,styles[i]); 
      //--- 水平的宽度 
      ObjectSetInteger(chart_ID,name,OBJPROP_LEVELWIDTH,i,widths[i]); 
      //--- 水平的描述 
      ObjectSetString(chart_ID,name,OBJPROP_LEVELTEXT,i,DoubleToString(100*values[i],1)); 
     } 
//--- 成功执行 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| 移动斐波纳契回调线的定位点                                           | 
//+------------------------------------------------------------------+ 
bool FiboLevelsPointChange(const long   chart_ID=0,        // 图表 ID 
                           const string name="FiboLevels", // 对象名称 
                           const int    point_index=0,     // 定位点指数 
                           datetime     time=0,            // 定位点时间坐标 
                           double       price=0)           // 定位点价格坐标 
  { 
//--- 如果没有设置点的位置，则将其移动到当前的卖价柱 
   if(!time) 
      time=TimeCurrent(); 
   if(!price) 
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
//--- 重置错误的值 
   ResetLastError(); 
//--- 移动定位点 
   if(!ObjectMove(chart_ID,name,point_index,time,price)) 
     { 
      Print(__FUNCTION__, 
            ": failed to move the anchor point! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- 成功执行 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| 删除斐波纳契回调线                                                  | 
//+------------------------------------------------------------------+ 
bool FiboLevelsDelete(const long   chart_ID=0,        // 图表 ID 
                      const string name="FiboLevels") // 对象名称 
  { 
//--- 重置错误的值 
   ResetLastError(); 
//--- 删除对象 
   if(!ObjectDelete(chart_ID,name)) 
     { 
      Print(__FUNCTION__, 
            ": failed to delete \"Fibonacci Retracement\"! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- 成功执行 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| 检查斐波纳契回调线定位点的值和为空点设置                               | 
//| 默认的值                                                          | 
//+------------------------------------------------------------------+ 
void ChangeFiboLevelsEmptyPoints(datetime &time1,double &price1, 
                                 datetime &time2,double &price2) 
  { 
//--- 如果第二点的时间没有设置，它将位于当前柱 
   if(!time2) 
      time2=TimeCurrent(); 
//--- 如果第二点的价格没有设置，则它将用卖价值 
   if(!price2) 
      price2=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
//--- 如果第一点的时间没有设置，它则位于第二点左侧的9个柱 
   if(!time1) 
     { 
      //--- 接收最近10柱开盘时间的数组 
      datetime temp[10]; 
      CopyTime(Symbol(),Period(),time2,10,temp); 
      //--- 在第二点左侧9柱设置第一点 
      time1=temp[0]; 
     } 
//--- 如果第一个点的价格没有设置，则低于第二个点移动200点 
   if(!price1) 
      price1=price2-200*SymbolInfoDouble(Symbol(),SYMBOL_POINT); 
  } 
int OnInit()
  {
//---
   Fib();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   //Fib();
  }
//+------------------------------------------------------------------+
void Fib() 
  { 
//--- 检查输入参数的正确性 
   if(InpDate1<0 || InpDate1>100 || InpPrice1<0 || InpPrice1>100 ||  
      InpDate2<0 || InpDate2>100 || InpPrice2<0 || InpPrice2>100) 
     { 
      Print("Error! Incorrect values of input parameters!"); 
      return; 
     } 
//--- 图表窗口的可见柱的数量 
   int bars=(int)ChartGetInteger(0,CHART_VISIBLE_BARS); 
//--- 价格数组大小 
   int accuracy=1000; 
//--- 存储要使用的日期和价格值的数组 
//--- 设置和改变斐波纳契回调线的定位点的坐标 
   datetime date[]; 
   double   price[]; 
//--- 内存分配 
   ArrayResize(date,bars); 
   ArrayResize(price,accuracy); 
//--- 填写日期数组 
   ResetLastError(); 
   if(CopyTime(Symbol(),Period(),0,bars,date)==-1) 
     { 
      Print("Failed to copy time values! Error code = ",GetLastError()); 
      return; 
     } 
//--- 填写价格数组 
//--- 找出图表的最高值和最低值 
   double max_price=ChartGetDouble(0,CHART_PRICE_MAX); 
   double min_price=ChartGetDouble(0,CHART_PRICE_MIN); 
//--- 定义变化的价格并填写该数组 
   double step=(max_price-min_price)/accuracy; 
   for(int i=0;i<accuracy;i++) 
      price[i]=min_price+i*step; 
//--- 定义绘制斐波纳契回调线的点 
   int d1=InpDate1*(bars-1)/100; 
   int d2=InpDate2*(bars-1)/100; 
   int p1=InpPrice1*(accuracy-1)/100; 
   int p2=InpPrice2*(accuracy-1)/100; 
//--- 创建对象 
   if(!FiboLevelsCreate(0,InpName,0,date[d1],price[p1],date[d2],price[p2],InpColor, 
      InpStyle,InpWidth,InpBack,InpSelection,InpRayLeft,InpRayRight,InpHidden,InpZOrder)) 
     { 
      return; 
     } 
//--- 重画图表并等待1秒 
   ChartRedraw(); 
   Sleep(1000); 
//--- 现在，移动定位点 
//--- 循环计数器 
   int v_steps=accuracy*2/5; 
//--- 移动第一个定位点 
   for(int j=0;j<v_steps;j++) 
     { 
      //--- 使用下面的值 
      if(p1>1) 
         p1-=1; 
      //--- 移动点 
      if(!FiboLevelsPointChange(0,InpName,0,date[d1],price[p1])) 
         return; 
      //--- 检查脚本操作是否已经强制禁用 
      if(IsStopped()) 
         return; 
      //--- 重画图表 
      ChartRedraw(); 
     } 
//--- 1 秒延迟 
   Sleep(1000); 
//--- 循环计数器 
   v_steps=accuracy*4/5; 
//--- 移动第二个定位点 
   for(int k=0;k<v_steps;k++) 
     { 
      //--- 使用下面的值 
      if(p2>1) 
         p2-=1; 
      //--- 移动点 
      if(!FiboLevelsPointChange(0,InpName,1,date[d2],price[p2])) 
         return; 
      //--- 检查脚本操作是否已经强制禁用 
      if(IsStopped()) 
         return; 
      //--- 重画图表 
      ChartRedraw(); 
     } 
//--- 1 秒延迟 
   Sleep(1000); 
//--- 删除图表对象 
   FiboLevelsDelete(0,InpName); 
   ChartRedraw(); 
//--- 1 秒延迟 
   Sleep(1000); 
//--- 
  }