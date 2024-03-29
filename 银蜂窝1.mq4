//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "鱼儿编程 QQ：276687220"
#property link"http://babelfish.taobao.com/"
input bool 是否显示信息框=true;
input double 单量=0.1;
input string 备注="";
input int magic=15420;
input string comm1X="----------------------------";
input string comm2X="----------------------------";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum XHWZ
  {
   实时出现信号判断=0,收盘出现信号判断=1
  };
input string _____MA_____="------MA------";
input bool 指标1开关=true;
input XHWZ 指标1信号位置=收盘出现信号判断;
input ENUM_TIMEFRAMES 指标1时间轴=PERIOD_CURRENT;
input string 指标1名称="MA";
input int  指标1MA周期1=20;
input int  指标1MA平移1=0;
input ENUM_MA_METHOD  指标1MA计算方式1=MODE_SMA;
input ENUM_APPLIED_PRICE  指标1MA价格方式1=PRICE_CLOSE;

input int  指标1MA周期2=55;
input int  指标1MA平移2=0;
input ENUM_MA_METHOD  指标1MA计算方式2=MODE_SMA;
input ENUM_APPLIED_PRICE  指标1MA价格方式2=PRICE_CLOSE;

input int  指标1MA周期3=220;
input int  指标1MA平移3=0;
input ENUM_MA_METHOD  指标1MA计算方式3=MODE_SMA;
input ENUM_APPLIED_PRICE  指标1MA价格方式3=PRICE_CLOSE;

input int  指标1MA周期4=660;
input int  指标1MA平移4=0;
input ENUM_MA_METHOD  指标1MA计算方式4=MODE_SMA;
input ENUM_APPLIED_PRICE  指标1MA价格方式4=PRICE_CLOSE;

input string 指标2名称="Bands";
input int 指标2Bands周期=55;
input double 指标2Bands偏差=2;
input int 指标2Bands平移=0;
input ENUM_APPLIED_PRICE 指标2Bands价格方式=PRICE_CLOSE;

input double 止损1=50;
input double 止盈1=50;
input double 布林宽度大于点数=250;
input double 止损2=100;
input double 止盈2=100;
double 止损;
double 止盈;
int 指标1做多,指标1做空;
//+------------------------------------------------------------------+
//| |
//+------------------------------------------------------------------+
void 指标1()
  {
   指标1做多=0;
   指标1做空=0;

   if(指标1开关==false)
     {
      指标1做多=1;
      指标1做空=1;
      return;
     }

   double MA20=iMA(Symbol(),指标1时间轴,指标1MA周期1,指标1MA平移1,指标1MA计算方式1,指标1MA价格方式1,指标1信号位置);
   double MA55=iMA(Symbol(),指标1时间轴,指标1MA周期2,指标1MA平移2,指标1MA计算方式2,指标1MA价格方式2,指标1信号位置);
   double MA220=iMA(Symbol(),指标1时间轴,指标1MA周期3,指标1MA平移3,指标1MA计算方式3,指标1MA价格方式3,指标1信号位置);
   double MA660=iMA(Symbol(),指标1时间轴,指标1MA周期4,指标1MA平移4,指标1MA计算方式4,指标1MA价格方式4,指标1信号位置);

   double UpperBuffer=iBands(Symbol(),指标1时间轴 ,指标2Bands周期,指标2Bands偏差,指标2Bands平移,指标2Bands价格方式,MODE_UPPER,指标1信号位置);
   double LowerBuffer=iBands(Symbol(),指标1时间轴 ,指标2Bands周期,指标2Bands偏差,指标2Bands平移,指标2Bands价格方式,MODE_LOWER,指标1信号位置);

   double UpperBuffer2=iBands(Symbol(),指标1时间轴 ,指标2Bands周期,指标2Bands偏差,指标2Bands平移,指标2Bands价格方式,MODE_UPPER,指标1信号位置+1);
   double LowerBuffer2=iBands(Symbol(),指标1时间轴 ,指标2Bands周期,指标2Bands偏差,指标2Bands平移,指标2Bands价格方式,MODE_LOWER,指标1信号位置+1);

//double MA=iMA(Symbol(),指标2时间轴,指标2Bands周期,指标2Bands平移,MODE_SMA,指标2Bands价格方式,指标2信号位置);
//double MA2=iMA(Symbol(),指标2时间轴,指标2Bands周期,指标2Bands平移,MODE_SMA,指标2Bands价格方式,指标2信号位置+1);

   止损=止损1;
   止盈=止盈1;

   if(UpperBuffer-LowerBuffer>=布林宽度大于点数*Point*系数(Symbol()))
     {
      止损=止损2;
      止盈=止盈2;
     }

   if(MA20>=MA220)
      if(MA55>=MA220)
         if(MA220>=MA660)
            if(iClose(Symbol(),指标1时间轴,指标1信号位置)<=LowerBuffer)
               if(iClose(Symbol(),指标1时间轴,指标1信号位置+1)>LowerBuffer2)
                  if(LowerBuffer>=MA660)
                     指标1做多=1;

   if(MA20<=MA220)
      if(MA55<=MA220)
         if(MA220<=MA660)
            if(iClose(Symbol(),指标1时间轴,指标1信号位置)>=UpperBuffer)
               if(iClose(Symbol(),指标1时间轴,指标1信号位置+1)<UpperBuffer2)
                  if(UpperBuffer<=MA660)
                     指标1做空=1;
  }

input string comm3X="----------------------------";
input string comm4X="----------------------------";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum HTFS
  {
   回调固定距离=1,回调比例=2
  };

input bool 移动止损开关=true;
input double 移动止损激活点数=150;
input double 移动止损停止点数=200;
HTFS 移动止损回调方式=1;
input double 移动止损回调离场距离=50;
double 移动止损回调离场比例=50;
input string comm5X="----------------------------";
input string comm6X="----------------------------";
input string comm7X="----------------------------";
input string comm8X="----------------------------";
input string comm9X="----------------------------";
//+------------------------------------------------------------------+
//||
//+------------------------------------------------------------------+
enum 做单方向
  {
   做多=1,做空=2,全做=3
  };
input 做单方向 做单方向选择=3;
input bool EA加载首个柱子不开仓=false;
input color 多单颜色标记=Blue;
input color 空单颜色标记=Red;
int check;
int X=20;
int Y=20;
int Y间隔=15;
color 标签颜色=Yellow;
int 标签字体大小=10;
ENUM_BASE_CORNER 固定角=0;
//////////////////////////////////////////////////////////////

datetime time1,time2;
int 单量小数保留=2;
datetime 启动时间;
bool 不允许智能交易报警=false;
//+------------------------------------------------------------------+
//| expert initialization function|
//+------------------------------------------------------------------+
int OnInit()
  {
//----
//Alert("急速模式程序,修改参数后需重置EA开关");
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<10)单量小数保留=0;
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<1)单量小数保留=1;
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<0.1)单量小数保留=2;

   启动时间=TimeCurrent();

   if(EA加载首个柱子不开仓)
     {
      time1=iTime(Symbol(),指标1时间轴,0);
      time2=iTime(Symbol(),指标1时间轴,0);
     }

//EventSetMillisecondTimer(300);
//----
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//----
   if(IsTesting()==false)
      for(int i=ObjectsTotal();i>=0;i--)
        {
         if(StringFind(ObjectName(i),"标签",0)==0)
           {
            ObjectDelete(ObjectName(i));
            i=ObjectsTotal();
           }
        }
//----
  }
//+------------------------------------------------------------------+
//| expert start function|
//+------------------------------------------------------------------+
void OnTick()
  {
   while(true)
     {
      if(IsTesting()==false)
         if(TimeCurrent()-MarketInfo(Symbol(),MODE_TIME)>=30)
            return;

      if(IsConnected()==false)return;

      RefreshRates();
      ChartRedraw();

      string 内容[100];
      if((IsTesting()==false && IsOptimization()==false) && (IsTradeAllowed()==false || IsExpertEnabled()==false))
        {
         内容[0]="     不允许智能交易";
         内容[1]="1.需保证主图右上角为笑脸";
         内容[2]="2.请检查并按下了\"EA交易\"开关";
         内容[3]="3.请检查\"EA属性\"--\"常用\"--\"允许实时自动交易\"需勾选";
         内容[4]="4.如右上角为笑脸依旧不支持智能交易,请联系平台客服";
         内容[5]="   4-1.平台某些服务器可能不支持智能交易";
         内容[6]="   4-2.平台服务器支持但是当前货币对可能不支持智能交易";

         固定位置标签("标签"+0,内容[0],50,50+15*0,clrRed,20,0);
         for(int ixx=1;ixx<=50;ixx++)
            固定位置标签("标签"+ixx,内容[ixx],50,60+25*ixx,clrYellow,15,0);
         ChartRedraw();
         不允许智能交易报警=true;
         return;
        }
      else
      if(不允许智能交易报警)
        {
         for(ixx=0;ixx<=50;ixx++)
            固定位置标签("标签"+ixx,内容[ixx],50,60+25*ixx,clrYellow,15,0);
         不允许智能交易报警=false;
        }
      //----

      按钮("全平按钮","全平按钮","全平按钮",80,30,60,20,CORNER_RIGHT_LOWER,clrRed,clrBlack);

      if(ObjectGetInteger(0,"全平按钮",OBJPROP_STATE)==1)
        {
         deleteorder(-100,magic,"");
         ObjectDelete("启动时间");
         return;
        }

      if(objectFind("启动时间")==-1)
         画直线("启动时间",0,0,TimeCurrent(),clrNONE,0,0);
      启动时间=objectGet("启动时间",OBJPROP_TIME1);

      double lots=单量;

      指标1();

      if(做单方向选择==1 || 做单方向选择==3)
         if(time1!=iTime(Symbol(),指标1时间轴,0))
            if(指标1做多==1)
               if(分项单据统计(-100,magic,"")==0)
                 {
                  int t1=建立单据(Symbol(),OP_BUY,lots,0,0,止损,止盈,备注,magic,多单颜色标记);
                  if(OrderSelect(t1,SELECT_BY_TICKET))
                    {
                     time1=iTime(Symbol(),指标1时间轴,0);
                    }
                 }

      if(做单方向选择==2 || 做单方向选择==3)
         if(time2!=iTime(Symbol(),指标1时间轴,0))
            if(指标1做空==1)
               if(分项单据统计(-100,magic,"")==0)
                 {
                  int t2=建立单据(Symbol(),OP_SELL,lots,0,0,止损,止盈,备注,magic,空单颜色标记);
                  if(OrderSelect(t2,SELECT_BY_TICKET))
                    {
                     time2=iTime(Symbol(),指标1时间轴,0);
                    }
                 }

      if(指标1做多==1)
         time1=iTime(Symbol(),指标1时间轴,0);
      if(指标1做空==1)
         time2=iTime(Symbol(),指标1时间轴,0);

      if(移动止损开关==true)
         移动止损距离比例(-100,移动止损激活点数,移动止损停止点数,移动止损回调方式,移动止损回调离场距离,移动止损回调离场比例,magic,"");

      if(是否显示信息框 && IsOptimization()==false)
        {
         int pp=0;
         内容[pp]="";pp++;
         内容[pp]="平台商:" +AccountCompany()+" 杠杆:"+DoubleToStr(AccountLeverage(),0);pp++;
         内容[pp]="EA独立代码 magic :"+magic;pp++;
         内容[pp]="启动时间:"+DoubleToStr((TimeCurrent()-启动时间)/60/60,1)+"小时";pp++;
         内容[pp]="------------------------------------";pp++;
         内容[pp]="多单个数:"+分项单据统计(OP_BUY,magic,"");pp++;
         内容[pp]="多单获利:"+DoubleToStr(分类单据利润(OP_BUY,magic,""),2);pp++;
         内容[pp]="多单手数:"+DoubleToStr(总交易量(OP_BUY,magic,""),2);pp++;
         内容[pp]="------------------------------------";pp++;
         内容[pp]="空单个数:"+分项单据统计(OP_SELL,magic,"");pp++;
         内容[pp]="空单获利:"+DoubleToStr(分类单据利润(OP_SELL,magic,""),2);pp++;
         内容[pp]="空单手数:"+DoubleToStr(总交易量(OP_SELL,magic,""),2);pp++;
         内容[pp]="------------------------------------";pp++;
         内容[pp]="浮动盈亏:"+DoubleToStr(分类单据利润(-100,magic,""),2);pp++;
         内容[pp]="------------------------------------";pp++;

         for(ixx=0;ixx<pp;ixx++)
            固定位置标签("标签"+ixx,内容[ixx],X,Y+Y间隔*ixx,标签颜色,标签字体大小,固定角);
        }
      ChartRedraw();
      //if((!IsStopped() && IsExpertEnabled() && IsTesting()==false && IsOptimization()==false && IsConnected()))Sleep(300);else
      return;
     }
   return;
  }
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   OnTick();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void 获利后一次性止损保护(int type,double 保护距离,double 启动距离,int c,string comm)
  {
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderSymbol()==Symbol())
            if(OrderMagicNumber()==c || c==-1)
               if(OrderType()==type || type==-100)
                  if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                    {
                     double a=OrderClosePrice();

                     if(OrderType()==OP_BUY)
                        if(a-OrderOpenPrice()>启动距离*MarketInfo(OrderSymbol(),MODE_POINT)*系数(OrderSymbol()))
                           if(OrderStopLoss()+MarketInfo(OrderSymbol(),MODE_POINT)<OrderOpenPrice()+保护距离*MarketInfo(OrderSymbol(),MODE_POINT)*系数(OrderSymbol()) || OrderStopLoss()==0)
                             {
                              if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+保护距离*MarketInfo(OrderSymbol(),MODE_POINT)*系数(OrderSymbol()),MarketInfo(OrderSymbol(),MODE_DIGITS)),OrderTakeProfit(),0)==false)
                                 报错组件("");
                             }

                     if(OrderType()==OP_SELL)
                        if(OrderOpenPrice()-a>启动距离*MarketInfo(OrderSymbol(),MODE_POINT)*系数(OrderSymbol()))
                           if(OrderStopLoss()-MarketInfo(OrderSymbol(),MODE_POINT)>OrderOpenPrice()-保护距离 *MarketInfo(OrderSymbol(),MODE_POINT)*系数(OrderSymbol()) || OrderStopLoss()==0)
                             {
                              if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-保护距离*MarketInfo(OrderSymbol(),MODE_POINT)*系数(OrderSymbol()),MarketInfo(OrderSymbol(),MODE_DIGITS)),OrderTakeProfit(),0)==false)
                                 报错组件("");
                             }
                    }
     }
  }
//+------------------------------------------------------------------+
//| |
//+------------------------------------------------------------------+
void 移动止损距离比例(int type,double 启动距离1,double 启动距离2,int 回调模式,double 保持距离,double 保持比例,int magicX,string comm)
  {
   for(int i=0;i<OrdersTotal();i++)
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderSymbol()==Symbol())
            if(OrderType()==type || type==-100)
               if(OrderMagicNumber()==magicX || magicX==-1)
                  if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                    {
                     RefreshRates();

                     if(回调模式==1)
                        double 保持距离X=保持距离;

                     if(回调模式==2)
                        保持距离X=MathAbs(OrderClosePrice()-OrderOpenPrice())*保持比例/100/MarketInfo(OrderSymbol(),MODE_POINT)/系数(OrderSymbol());

                     if(保持距离X<MarketInfo(OrderSymbol(),MODE_STOPLEVEL)/系数(OrderSymbol()))
                        return;


                     if(OrderType()==OP_BUY)
                        if(OrderClosePrice()-OrderOpenPrice()>=启动距离1*MarketInfo(OrderSymbol(),MODE_POINT)*系数(OrderSymbol()))
                           if(OrderClosePrice()-OrderOpenPrice()<=启动距离2*MarketInfo(OrderSymbol(),MODE_POINT)*系数(OrderSymbol()))
                              if(NormalizeDouble(OrderClosePrice()-(保持距离X*系数(OrderSymbol())+1)*MarketInfo(OrderSymbol(),MODE_POINT),MarketInfo(OrderSymbol(),MODE_DIGITS))>=OrderStopLoss() || OrderStopLoss()==0)
                                {
                                 if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderClosePrice()-保持距离X*MarketInfo(OrderSymbol(),MODE_POINT)*系数(OrderSymbol()),MarketInfo(OrderSymbol(),MODE_DIGITS)),OrderTakeProfit(),0)==false)
                                    报错组件("");
                                }

                     if(OrderType()==OP_SELL)
                        if(OrderOpenPrice()-OrderClosePrice()>=启动距离1*MarketInfo(OrderSymbol(),MODE_POINT)*系数(OrderSymbol()))
                           if(OrderOpenPrice()-OrderClosePrice()<=启动距离2*MarketInfo(OrderSymbol(),MODE_POINT)*系数(OrderSymbol()))
                              if(NormalizeDouble(OrderClosePrice()+(保持距离X*系数(OrderSymbol())+1)*MarketInfo(OrderSymbol(),MODE_POINT),MarketInfo(OrderSymbol(),MODE_DIGITS))<=OrderStopLoss() || OrderStopLoss()==0)
                                {
                                 if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderClosePrice()+保持距离X*MarketInfo(OrderSymbol(),MODE_POINT)*系数(OrderSymbol()),MarketInfo(OrderSymbol(),MODE_DIGITS)),OrderTakeProfit(),0)==false)
                                    报错组件("");
                                }
                    }
  }
//+------------------------------------------------------------------+
//||
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   OnTick();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void 按钮(string name,string txt1,string txt2,int XX,int YX,int XL,int YL,int WZ,color A,color B)
  {
   if(ObjectFind(0,name)==-1)
      ObjectCreate(0,name,OBJ_BUTTON,0,0,0);

   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,XX);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,YX);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,XL);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,YL);
   ObjectSetString(0,name,OBJPROP_FONT,"微软雅黑");
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7);
   ObjectSetInteger(0,name,OBJPROP_CORNER,WZ);

   if(ObjectGetInteger(0,name,OBJPROP_STATE)==1)
     {
      ObjectSetInteger(0,name,OBJPROP_COLOR,A);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,B);
      ObjectSetString(0,name,OBJPROP_TEXT,txt1);
     }
   else
     {
      ObjectSetInteger(0,name,OBJPROP_COLOR,B);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,A);
      ObjectSetString(0,name,OBJPROP_TEXT,txt2);
     }
  }
//+------------------------------------------------------------------+
//||
//+------------------------------------------------------------------+
int 最高最低单据订单号(int a,int b,int magicX,string 高低,string comm,int pc1,int pc2)
  {
   double 价格=0;
   int 订单号=0;
   for(int i=0;i<OrdersTotal();i++)
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderTicket()!=pc1 && OrderTicket()!=pc2)
            if(OrderSymbol()==Symbol())
               if(OrderMagicNumber()==magicX || magicX==-1)
                  if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                     if(OrderType()==a || OrderType()==b || a==-100 || b==-100)
                        if(((价格==0 || 价格>OrderOpenPrice()) && 高低=="L")
                           || ((价格==0 || 价格<OrderOpenPrice()) && 高低=="H"))
                          {
                           价格=OrderOpenPrice();
                           订单号=OrderTicket();
                          }
   return(订单号 );
  }
//+----------------------------------------------------- -------------+
//| |
//+------------------------------------------------------------------+
int findlassorder(int type1,int type2,int magicX,string fx,string 现在与历史,string comm,int 排除)
  {
   if(现在与历史=="现在")
      if(fx=="后")
         for(int i=OrdersTotal()-1;i>=0;i--)
            if(OrderSelect(i,SELECT_BY_POS))
               if(OrderTicket()!=排除 || 排除==0)
                  if(Symbol()==OrderSymbol())
                     if(OrderMagicNumber()==magicX || magicX==-1)
                        if(
                           OrderType()==type1
                           || OrderType()==type2
                           || type1==-100
                           || type2==-100
                           ||(type1==-200&&OrderType()<2)
                           ||(type2==-200&&OrderType()<2)
                           ||(type1==-300&&OrderType()>=2)
                           ||(type2==-300&&OrderType()>=2)
                           )
                           if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                              return(OrderTicket());

   if(现在与历史=="现在")
      if(fx=="前")
         for(i=0;i<OrdersTotal();i++)
            if(OrderSelect(i,SELECT_BY_POS))
               if(OrderTicket()!=排除 || 排除==0)
                  if(Symbol()==OrderSymbol())
                     if(OrderMagicNumber()==magicX || magicX==-1)
                        if(
                           OrderType()==type1
                           || OrderType()==type2
                           || type1==-100
                           || type2==-100
                           ||(type1==-200&&OrderType()<2)
                           ||(type2==-200&&OrderType()<2)
                           ||(type1==-300&&OrderType()>=2)
                           ||(type2==-300&&OrderType()>=2)
                           )
                           if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                              return(OrderTicket());

   if(现在与历史=="历史")
      if(fx=="后")
         for(i=OrdersHistoryTotal()-1;i>=0;i--)
            if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
               if(OrderTicket()!=排除 || 排除==0)
                  if(Symbol()==OrderSymbol())
                     if(OrderMagicNumber()==magicX || magicX==-1)
                        if(OrderType()<=5 && OrderType()>=0)
                           if(
                              OrderType()==type1
                              || OrderType()==type2
                              || type1==-100
                              || type2==-100
                              ||(type1==-200&&OrderType()<2)
                              ||(type2==-200&&OrderType()<2)
                              ||(type1==-300&&OrderType()>=2)
                              ||(type2==-300&&OrderType()>=2)
                              )
                              if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                                 if(OrderCloseTime()!=0)
                                    return(OrderTicket());

   if(现在与历史=="历史")
      if(fx=="前")
         for(i=0;i<OrdersHistoryTotal();i++)
            if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
               if(OrderTicket()!=排除 || 排除==0)
                  if(Symbol()==OrderSymbol())
                     if(OrderMagicNumber()==magicX || magicX==-1)
                        if(OrderType()<=5 && OrderType()>=0)
                           if(
                              OrderType()==type1
                              || OrderType()==type2
                              || type1==-100
                              || type2==-100
                              ||(type1==-200&&OrderType()<2)
                              ||(type2==-200&&OrderType()<2)
                              ||(type1==-300&&OrderType()>=2)
                              ||(type2==-300&&OrderType()>=2)
                              )
                              if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                                 if(OrderCloseTime()!=0)
                                    return(OrderTicket());

   return(-1);
  }
//+------------------------------------------------------------------+
//| |
//+------------------------------------------------------------------+
void deleteorder(int type,int magicX,string comm)
  {
//datetime time=TimeCurrent();
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
         if(Symbol()==OrderSymbol())
            if(OrderMagicNumber()==magicX || magicX==-1)
               if(
                  (OrderType()==type || type==-100)
                  || (OrderType()<2 && type==-200)
                  || (OrderType()>=2 && type==-300)
                  )
                  if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                     //if(OrderOpenTime()<=time)
                    {
                     if(OrderType()>=2)
                       {
                        if(OrderDelete(OrderTicket())==false)
                           报错组件("");
                        i=OrdersTotal();
                       }
                     else
                       {
                        if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),滑点*系数(OrderSymbol()))==false)
                           报错组件("");
                        i=OrdersTotal();
                       }
                    }
     }
  }
//+------------------------------------------------------------------+
//| |
//+------------------------------------------------------------------+
int 分项单据统计(int type,int magicX,string comm)
  {
   int 数量=0;
   for(int i=0;i<OrdersTotal();i++)
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderSymbol()==Symbol())
            if(OrderMagicNumber()==magicX || magicX==-1)
               if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                  if(
                     (OrderType()==type || type==-100)
                     || (OrderType()<2 && type==-200)
                     || (OrderType()>=2 && type==-300)
                     )
                     数量++;
   return(数量);
  }
//+------------------------------------------------------------------+
//| |
//+------------------------------------------------------------------+
double 分类单据利润(int type,int magicX,string comm)
  {
   double 利润=0;
   for(int i=0;i<OrdersTotal();i++)
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderSymbol()==Symbol())
            if(OrderMagicNumber()==magicX || magicX==-1)
               if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                  if(
                     (OrderType()==type || type==-100)
                     || (OrderType()<2 && type==-200)
                     || (OrderType()>=2 && type==-300)
                     )
                     利润+=OrderProfit()+OrderSwap()+OrderCommission();
   return(利润);
  }
//+------------------------------------------------------------------+
//| |
//+------------------------------------------------------------------+
double 总交易量(int type,int magicX,string comm)
  {
   double js=0;
   for(int i=0;i<OrdersTotal();i++)
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderSymbol()==Symbol())
            if(OrderMagicNumber()==magicX || magicX==-1)
               if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                  if(OrderType()==type || (type==-100 && OrderType()<2))
                     js+=OrderLots();

   return(NormalizeDouble(js,2));
  }
//+------------------------------------------------------------------+
//| |
//+------------------------------------------------------------------+
void 固定位置标签(string 名称,string 内容,int XX,int YX,color C,int 字体大小,int 固定角内)
  {
   if(内容==EMPTY)
      return;
   if(ObjectFind(名称)==-1)
     {
      ObjectDelete(名称);
      ObjectCreate(名称,OBJ_LABEL,0,0,0);
     }
   ObjectSet(名称,OBJPROP_XDISTANCE,XX);
   ObjectSet(名称,OBJPROP_YDISTANCE,YX);
   ObjectSetText(名称,内容,字体大小,"宋体",C);
   ObjectSet(名称,OBJPROP_CORNER,固定角内);
   ObjectSetInteger(0,名称,OBJPROP_ANCHOR,ANCHOR_LEFT);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int 建立单据(string 货币对,int 类型,double 单量内,double 价位,double 间隔,double 止损内,double 止盈内,string 备注内,int magicX,color 颜色标记)
  {

   备注内=备注内+"-"+Period()+"-"+magicX;
   if(MarketInfo(货币对,MODE_LOTSTEP)<10)int 单量小数保留内=0;
   if(MarketInfo(货币对,MODE_LOTSTEP)<1)单量小数保留内=1;
   if(MarketInfo(货币对,MODE_LOTSTEP)<0.1)单量小数保留内=2;

   单量内=NormalizeDouble(单量内,单量小数保留内);

   if(单量内<MarketInfo(货币对,MODE_MINLOT))
     {
      laber("低于最低单量",Yellow,0);
      return(-1);
     }

   if(单量内>MarketInfo(货币对,MODE_MAXLOT))
      单量内=MarketInfo(货币对,MODE_MAXLOT);

   int t;
   double POINT=MarketInfo(货币对,MODE_POINT)*系数(货币对);
   int DIGITS=MarketInfo(货币对,MODE_DIGITS);
   int 滑点内=滑点*系数(货币对);

   if(类型==OP_BUY)
     {
      t=-1;
      for(int ix2=0;ix2<1;ix2++)
         if(t==-1)
           {
            RefreshRates();
            t=OrderSend(货币对,OP_BUY,单量内,MarketInfo(货币对,MODE_ASK),滑点内,0,0,备注内,magicX,0,颜色标记);
            报错组件("");
            if(OrderSelect(t,SELECT_BY_TICKET))
              {
               if(止损内!=0 && 止盈内!=0)
                  for(int ix=0;ix<3;ix++)
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-止损内 *POINT,DIGITS),NormalizeDouble(OrderOpenPrice()+止盈内 *POINT,DIGITS),0))
                        break;

               if(止损内==0 && 止盈内!=0)
                  for(ix=0;ix<3;ix++)
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),0,NormalizeDouble(OrderOpenPrice()+止盈内 *POINT,DIGITS),0))
                        break;

               if(止损内!=0 && 止盈内==0)
                  for(ix=0;ix<3;ix++)
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-止损内 *POINT,DIGITS),0,0))
                        break;

               报错组件("");
              }
           }
     }

   if(类型==OP_SELL)
     {
      t=-1;
      for(ix2=0;ix2<1;ix2++)
         if(t==-1)
           {
            RefreshRates();
            t=OrderSend(货币对,OP_SELL,单量内,MarketInfo(货币对,MODE_BID),滑点内,0,0,备注内,magicX,0,颜色标记);
            报错组件("");
            if(OrderSelect(t,SELECT_BY_TICKET))
              {
               if(止损内!=0 && 止盈内!=0)
                  for(ix=0;ix<3;ix++)
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+止损内 *POINT,DIGITS),NormalizeDouble(OrderOpenPrice()-止盈内 *POINT,DIGITS),0))
                        break;

               if(止损内==0 && 止盈内!=0)
                  for(ix=0;ix<3;ix++)
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),0,NormalizeDouble(OrderOpenPrice()-止盈内 *POINT,DIGITS),0))
                        break;

               if(止损内!=0 && 止盈内==0)
                  for(ix=0;ix<3;ix++)
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+止损内 *POINT,DIGITS),0,0))
                        break;
              }
            报错组件("");
           }
     }

   if(类型==OP_BUYLIMIT || 类型==OP_BUYSTOP)
     {
      t=-1;
      for(ix2=0;ix2<1;ix2++)
         if(t==-1)
           {
            if(价位==0)
              {
               RefreshRates();
               价位=MarketInfo(货币对,MODE_ASK);
              }

            if(类型==OP_BUYLIMIT)
              {
               if(止损内!=0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_BUYLIMIT,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位-间隔*POINT-止损内 *POINT,DIGITS),NormalizeDouble(价位-间隔*POINT+止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_BUYLIMIT,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,0,NormalizeDouble(价位-间隔*POINT+止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内!=0 && 止盈内==0)
                  t=OrderSend(货币对,OP_BUYLIMIT,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位-间隔*POINT-止损内 *POINT,DIGITS),0,备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内==0)
                  t=OrderSend(货币对,OP_BUYLIMIT,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,0,0,备注内,magicX,0,颜色标记);
              }

            if(类型==OP_BUYSTOP)
              {
               if(止损内!=0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_BUYSTOP,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位+间隔*POINT-止损内 *POINT,DIGITS),NormalizeDouble(价位+间隔*POINT+止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_BUYSTOP,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,0,NormalizeDouble(价位+间隔*POINT+止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内!=0 && 止盈内==0)
                  t=OrderSend(货币对,OP_BUYSTOP,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位+间隔*POINT-止损内 *POINT,DIGITS),0,备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内==0)
                  t=OrderSend(货币对,OP_BUYSTOP,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,0,0,备注内,magicX,0,颜色标记);
              }
            报错组件("");
           }
     }

   if(类型==OP_SELLLIMIT || 类型==OP_SELLSTOP)
     {
      t=-1;
      for(ix2=0;ix2<1;ix2++)
         if(t==-1)
           {
            if(价位==0)
              {
               RefreshRates();
               价位=MarketInfo(货币对,MODE_BID);
              }

            if(类型==OP_SELLSTOP)
              {
               if(止损内!=0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_SELLSTOP,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位-间隔*POINT+止损内 *POINT,DIGITS),NormalizeDouble(价位-间隔*POINT-止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_SELLSTOP,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,0,NormalizeDouble(价位-间隔*POINT-止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内!=0 && 止盈内==0)
                  t=OrderSend(货币对,OP_SELLSTOP,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位-间隔*POINT+止损内 *POINT,DIGITS),0,备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内==0)
                  t=OrderSend(货币对,OP_SELLSTOP,单量内,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点内,0,0,备注内,magicX,0,颜色标记);
              }

            if(类型==OP_SELLLIMIT)
              {
               if(止损内!=0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_SELLLIMIT,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位+间隔*POINT+止损内 *POINT,DIGITS),NormalizeDouble(价位+间隔*POINT-止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内!=0)
                  t=OrderSend(货币对,OP_SELLLIMIT,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,0,NormalizeDouble(价位+间隔*POINT-止盈内 *POINT,DIGITS),备注内,magicX,0,颜色标记);
               if(止损内!=0 && 止盈内==0)
                  t=OrderSend(货币对,OP_SELLLIMIT,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,NormalizeDouble(价位+间隔*POINT+止损内 *POINT,DIGITS),0,备注内,magicX,0,颜色标记);
               if(止损内==0 && 止盈内==0)
                  t=OrderSend(货币对,OP_SELLLIMIT,单量内,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点内,0,0,备注内,magicX,0,颜色标记);
              }
            报错组件("");
           }
     }
   return(t);
  }

double 滑点=30;
input bool 是否显示文字标签=true;
input bool 国际点差自适应=true;
//+------------------------------------------------------------------+
//||
//+------------------------------------------------------------------+
double 系数(string symbol)
  {
   int 系数=1;
   if(
      MarketInfo(symbol,MODE_DIGITS)==3
      || MarketInfo(symbol,MODE_DIGITS)==5
      || (StringFind(symbol,"XAU",0)==0 && MarketInfo(symbol,MODE_DIGITS)==2)
      ||(StringFind(symbol,"GOLD",0)==0&&MarketInfo(symbol,MODE_DIGITS)==2)
      ||(StringFind(symbol,"Gold",0)==0&&MarketInfo(symbol,MODE_DIGITS)==2)
      || (StringFind(symbol,"USD_GLD",0)==0 && MarketInfo(symbol,MODE_DIGITS)==2)
      )系数=10;

   if(StringFind(symbol,"XAU",0)==0 && MarketInfo(symbol,MODE_DIGITS)==3)系数=100;
   if(StringFind(symbol,"GOLD",0)==0 && MarketInfo(symbol,MODE_DIGITS)==3)系数=100;
   if(StringFind(symbol,"Gold",0)==0 && MarketInfo(symbol,MODE_DIGITS)==3)系数=100;
   if(StringFind(symbol,"USD_GLD",0)==0 && MarketInfo(symbol,MODE_DIGITS)==3)系数=100;

   if(国际点差自适应==false)
      return(1);

   return(系数);
  }
//+------------------------------------------------------------------+
//| |
//+------------------------------------------------------------------+
void laber(string a,color b,int jl)
  {
   Print(a);
   if(IsOptimization())
      return;

   if(是否显示文字标签==true)
     {
      int pp=WindowBarsPerChart();
      double hh=High[iHighest(Symbol(),0,MODE_HIGH,pp,0)];
      double ll=Low[iLowest(Symbol(),0,MODE_LOW,pp,0)];
      double 文字小距离=(hh-ll)*0.03;

      ObjectDelete("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a);
      ObjectCreate("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a,OBJ_TEXT,0,Time[0],Low[0]-jl*文字小距离);
      ObjectSetText("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a,a,8,"Times New Roman",b);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void 报错组件(string a)
  {

   RefreshRates();

   if(IsOptimization())
      return;

   int t=GetLastError();
   string 报警;
   if(t!=0)
      switch(t)
        {
         //case 0:报警="错误代码:"+0+"没有错误返回";break;
         //case 1:报警="错误代码:"+1+"没有错误返回但结果不明";break;
         //case 2:报警="错误代码:"+2+"一般错误";break;
         //case 3:报警="错误代码:"+3+"无效交易参量";break;
         case 4:报警="错误代码:"+4+"交易服务器繁忙";break;
         case 5:报警="错误代码:"+5+"客户终端旧版本";break;
         case 6:报警="错误代码:"+6+"没有连接服务器";break;
         case 7:报警="错误代码:"+7+"没有权限";break;
         //case 8:报警="错误代码:"+8+"请求过于频繁";break;
         case 9:报警="错误代码:"+9+"交易运行故障";break;
         case 64:报警="错误代码:"+64+"账户禁止";break;
         case 65:报警="错误代码:"+65+"无效账户";break;
         // case 128:报警="错误代码:"+128+"交易超时";break;
         //case 129:报警="错误代码:"+129+"无效价格";break;
         case 130:报警="错误代码:"+130+"无效停止";break;
         //case 131:报警="错误代码:"+131+"无效交易量";break;
         case 132:报警="错误代码:"+132+"市场关闭";break;
         case 133:报警="错误代码:"+133+"交易被禁止";break;
         case 134:报警="错误代码:"+134+"资金不足";break;
         case 135:报警="错误代码:"+135+"价格改变";break;
         //case 136:报警="错误代码:"+136+"开价";break;
         case 137:报警="错误代码:"+137+"经纪繁忙";break;
         //case 138:报警="错误代码:"+138+"重新开价";break;
         case 139:报警="错误代码:"+139+"定单被锁定";break;
         case 140:报警="错误代码:"+140+"只允许看涨仓位";break;
         //case 141:报警="错误代码:"+141+"过多请求";break;
         //case 145:报警="错误代码:"+145+"因为过于接近市场，修改否定";break;
         //case 146:报警="错误代码:"+146+"交易文本已满";break;
         case 147:报警="错误代码:"+147+"时间周期被经纪否定";break;
         case 148:报警="错误代码:"+148+"开单和挂单总数已被经纪限定";break;
         case 149:报警="错误代码:"+149+"当对冲备拒绝时,打开相对于现有的一个单置";break;
         case 150:报警="错误代码:"+150+"把为反FIFO规定的单子平掉";break;
         case 4000:报警="错误代码:"+4000+"没有错误";break;
         case 4001:报警="错误代码:"+4001+"错误函数指示";break;
         case 4002:报警="错误代码:"+4002+"数组索引超出范围";break;
         case 4003:报警="错误代码:"+4003+"对于调用堆栈储存器函数没有足够内存";break;
         case 4004:报警="错误代码:"+4004+"循环堆栈储存器溢出";break;
         case 4005:报警="错误代码:"+4005+"对于堆栈储存器参量没有内存";break;
         case 4006:报警="错误代码:"+4006+"对于字行参量没有足够内存";break;
         case 4007:报警="错误代码:"+4007+"对于字行没有足够内存";break;
         //case 4008:报警="错误代码:"+4008+"没有初始字行";break;
         case 4009:报警="错误代码:"+4009+"在数组中没有初始字串符";break;
         case 4010:报警="错误代码:"+4010+"对于数组没有内存";break;
         case 4011:报警="错误代码:"+4011+"字行过长";break;
         case 4012:报警="错误代码:"+4012+"余数划分为零";break;
         case 4013:报警="错误代码:"+4013+"零划分";break;
         case 4014:报警="错误代码:"+4014+"不明命令";break;
         case 4015:报警="错误代码:"+4015+"错误转换(没有常规错误)";break;
         case 4016:报警="错误代码:"+4016+"没有初始数组";break;
         case 4017:报警="错误代码:"+4017+"禁止调用DLL ";break;
         case 4018:报警="错误代码:"+4018+"数据库不能下载";break;
         case 4019:报警="错误代码:"+4019+"不能调用函数";break;
         case 4020:报警="错误代码:"+4020+"禁止调用智能交易函数";break;
         case 4021:报警="错误代码:"+4021+"对于来自函数的字行没有足够内存";break;
         case 4022:报警="错误代码:"+4022+"系统繁忙 (没有常规错误)";break;
         case 4050:报警="错误代码:"+4050+"无效计数参量函数";break;
         case 4051:报警="错误代码:"+4051+"无效参量值函数";break;
         case 4052:报警="错误代码:"+4052+"字行函数内部错误";break;
         case 4053:报警="错误代码:"+4053+"一些数组错误";break;
         case 4054:报警="错误代码:"+4054+"应用不正确数组";break;
         case 4055:报警="错误代码:"+4055+"自定义指标错误";break;
         case 4056:报警="错误代码:"+4056+"不协调数组";break;
         case 4057:报警="错误代码:"+4057+"整体变量过程错误";break;
         case 4058:报警="错误代码:"+4058+"整体变量未找到";break;
         case 4059:报警="错误代码:"+4059+"测试模式函数禁止";break;
         case 4060:报警="错误代码:"+4060+"没有确认函数";break;
         case 4061:报警="错误代码:"+4061+"发送邮件错误";break;
         case 4062:报警="错误代码:"+4062+"字行预计参量";break;
         case 4063:报警="错误代码:"+4063+"整数预计参量";break;
         case 4064:报警="错误代码:"+4064+"双预计参量";break;
         case 4065:报警="错误代码:"+4065+"数组作为预计参量";break;
         case 4066:报警="错误代码:"+4066+"刷新状态请求历史数据";break;
         case 4067:报警="错误代码:"+4067+"交易函数错误";break;
         case 4099:报警="错误代码:"+4099+"文件结束";break;
         case 4100:报警="错误代码:"+4100+"一些文件错误";break;
         case 4101:报警="错误代码:"+4101+"错误文件名称";break;
         case 4102:报警="错误代码:"+4102+"打开文件过多";break;
         case 4103:报警="错误代码:"+4103+"不能打开文件";break;
         case 4104:报警="错误代码:"+4104+"不协调文件";break;
         case 4105:报警="错误代码:"+4105+"没有选择定单";break;
         case 4106:报警="错误代码:"+4106+"不明货币对";break;
         case 4107:报警="错误代码:"+4107+"无效价格";break;
         case 4108:报警="错误代码:"+4108+"无效定单编码";break;
         case 4109:报警="错误代码:"+4109+"不允许交易";break;
         case 4110:报警="错误代码:"+4110+"不允许长期";break;
         case 4111:报警="错误代码:"+4111+"不允许短期";break;
         case 4200:报警="错误代码:"+4200+"定单已经存在";break;
         case 4201:报警="错误代码:"+4201+"不明定单属性";break;
         //case 4202:报警="错误代码:"+4202+"定单不存在";break;
         case 4203:报警="错误代码:"+4203+"不明定单类型";break;
         case 4204:报警="错误代码:"+4204+"没有定单名称";break;
         case 4205:报警="错误代码:"+4205+"定单坐标错误";break;
         case 4206:报警="错误代码:"+4206+"没有指定子窗口";break;
         case 4207:报警="错误代码:"+4207+"定单一些函数错误";break;
         case 4250:报警="错误代码:"+4250+"错误设定发送通知到队列中";break;
         case 4251:报警="错误代码:"+4251+"无效参量- 空字符串传递到SendNotification()函数";break;
         case 4252:报警="错误代码:"+4252+"无效设置发送通知(未指定ID或未启用通知)";break;
         case 4253:报警="错误代码:"+4253+"通知发送过于频繁";break;
        }
   if(t!=0)
     {
      while(IsTradeContextBusy())
         Sleep(300);
      Print(a+报警);
      laber(a+报警,Yellow,0);
     }
  }

string JLA[999];
double JLB[999];
datetime JLC[999];
string JLD[999];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int HQXH(string A)
  {
   int JL=-100;
   for(int ix=0;ix<999;ix++)
     {
      if(JLA[ix]==A)
         return(ix);
      else
      if(JLA[ix]==NULL)
      if(JL==-100)
         JL=ix;
     }
   return(JL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int objectFind(string A)
  {
   if(IsOptimization())
     {
      for(int ix=0;ix<999;ix++)
         if(JLA[ix]==A)
            return(0);
      return(-1);
     }
   return(ObjectFind(A));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void objectDelete(string A)
  {
   if(IsOptimization())
     {
      int WZ=HQXH(A);
      JLA[WZ]=NULL;
      return;
     }
   ObjectDelete(A);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double objectGet(string A,int B)
  {
   if(IsOptimization())
     {
      if(objectFind(A)!=-1)
        {
         if(B==OBJPROP_PRICE1)return(JLB[HQXH(A)]);
         if(B==OBJPROP_TIME1)return(JLC[HQXH(A)]);
        }
      else
         return(0);
     }
   return(ObjectGet(A,B));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string objectDescription(string A)
  {
   if(IsOptimization())
      return(JLD[HQXH(A)]);
   return(ObjectDescription(A));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void laber0(string name,string txt,color 颜色,datetime 时间,double 价位,int 字体大小,int 定位,int 窗口)
  {
   if(IsOptimization())
     {
      int WZ=HQXH(name);
      JLA[WZ]=name;
      JLB[WZ]=价位;
      JLC[WZ]=时间;
      JLD[WZ]=txt;
      return;
     }
   ObjectDelete(name);
   ObjectCreate(name,OBJ_TEXT,窗口,时间,价位);
   ObjectSetText(name,txt,字体大小,"Times New Roman",颜色);
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,定位);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void 画直线(string e,int type,double b,datetime c,color d,int type2,int width)
  {
   if(IsOptimization())
     {
      int WZ=HQXH(e);
      JLA[WZ]=e;
      JLB[WZ]=b;
      JLC[WZ]=c;
      return;
     }

   ObjectDelete(e);
   ObjectCreate(e,type,0,0,0);
   ObjectSet(e,OBJPROP_PRICE1,b);
   ObjectSet(e,OBJPROP_TIME1,c);
   ObjectSet(e,OBJPROP_COLOR,d);
   ObjectSet(e,OBJPROP_STYLE,type2);
   ObjectSet(e,OBJPROP_WIDTH,width);
  }
//+------------------------------------------------------------------+
input datetime 程序最终编译时间=__DATETIME__;
//+------------------------------------------------------------------+
