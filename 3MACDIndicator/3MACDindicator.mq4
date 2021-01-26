// vim:filetype=cpp
//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "鱼儿编程 QQ：276687220"
#property link"http://babelfish.taobao.com/"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrMagenta
#property indicator_color2 clrMagenta

#property indicator_width1 2
#property indicator_width2 2
//--- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];
double ExtMapBuffer8[];


input int 指标1MACD参数1=12;
input int 指标1MACD参数2=26;
input int 指标1MACD参数3=9;
input ENUM_APPLIED_PRICE 指标1MACD价格方式=PRICE_CLOSE;
input int 指标2MACD参数1=24;
input int 指标2MACD参数2=50;
input int 指标2MACD参数3=20;
input ENUM_APPLIED_PRICE 指标2MACD价格方式=PRICE_CLOSE;
input int 指标3MACD参数1=40;
input int 指标3MACD参数2=100;
input int 指标3MACD参数3=50;
input ENUM_APPLIED_PRICE 指标3MACD价格方式=PRICE_CLOSE;

enum BJWZ
  {
   实时出现信号报警=0,收盘出现信号报警=1
  };
input BJWZ 报警信号位置=收盘出现信号报警;
input bool 文字报警开关=true;
input bool 邮件报警开关=false;
input bool 推送报警开关=false;
input bool 音乐报警开关=false;
input string 报警内容自定义1="做多";
input string 报警内容自定义2="做空";
input string 音乐名称1="alert.wav";
input string 音乐名称2="alert.wav";
datetime timebx[100];
bool soundsx[100];
input double 间隔=20;
enum MACDCOLOR{
 macdGreen = 0, macdGray = 1,macdRed=2
};
//+------------------------------------------------------------------+
//| Custom indicator initialization function |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   IndicatorBuffers(50);

   int pp=0;
   SetIndexStyle(pp,DRAW_ARROW);
   SetIndexArrow(pp,233);
   SetIndexEmptyValue(pp,0.0);
   pp++;
   SetIndexStyle(pp,DRAW_ARROW);
   SetIndexArrow(pp,234);
   SetIndexEmptyValue(pp,0.0);
   pp++;



   pp=0;
   SetIndexBuffer(pp,ExtMapBuffer7);
   pp++;
   SetIndexBuffer(pp,ExtMapBuffer8);
   pp++;

   SetIndexBuffer(pp,ExtMapBuffer1);
   pp++;
   SetIndexBuffer(pp,ExtMapBuffer2);
   pp++;
   SetIndexBuffer(pp,ExtMapBuffer3);
   pp++;
   SetIndexBuffer(pp,ExtMapBuffer4);
   pp++;
   SetIndexBuffer(pp,ExtMapBuffer5);
   pp++;
   SetIndexBuffer(pp,ExtMapBuffer6);
   pp++;
   SetLevelValue(0,0);

   IndicatorShortName("20200908 WX 中国移不动");
   IndicatorDigits(Digits+1);
//EventSetMillisecondTimer(300);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//----
   ObjectsDeleteAll(0,"20200908");
//----
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function|
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
	// 获取需要计算柱数的逻辑
   int counted=MathMax(prev_calculated,0);
   if(counted<0)
      return(-1);
   if(counted>0)
      counted--;
	// i 需要计算的柱数 
   int i=MathMin(rates_total-counted,rates_total-0);
   // m 当前正在计算柱子的索引（位移值）
   for(int m=i; m>=0; m--) // 一个循环 遍历从i到0位移的柱子
      if(ArraySize(ExtMapBuffer1)>m)
        {
				// 各个imacd的主线和信号线
         ExtMapBuffer1[m]=iMACD(Symbol(),0,指标1MACD参数1,指标1MACD参数2,指标1MACD参数3,指标1MACD价格方式,MODE_MAIN,m);
         ExtMapBuffer2[m]=iMACD(Symbol(),0,指标1MACD参数1,指标1MACD参数2,指标1MACD参数3,指标1MACD价格方式,MODE_SIGNAL,m);
         ExtMapBuffer3[m]=iMACD(Symbol(),0,指标2MACD参数1,指标2MACD参数2,指标2MACD参数3,指标2MACD价格方式,MODE_MAIN,m);
         ExtMapBuffer4[m]=iMACD(Symbol(),0,指标2MACD参数1,指标2MACD参数2,指标2MACD参数3,指标2MACD价格方式,MODE_SIGNAL,m);
         ExtMapBuffer5[m]=iMACD(Symbol(),0,指标3MACD参数1,指标3MACD参数2,指标3MACD参数3,指标3MACD价格方式,MODE_MAIN,m);
         ExtMapBuffer6[m]=iMACD(Symbol(),0,指标3MACD参数1,指标3MACD参数2,指标3MACD参数3,指标3MACD价格方式,MODE_SIGNAL,m);
					// 两个示警箭头
         ExtMapBuffer7[m]=0;
         ExtMapBuffer8[m]=0;
         // 三条都是红色
         if(getMacdColor(1,m)==macdRed&&getMacdColor(2,m)==macdRed&&getMacdColor(3,m)==macdRed)
						// 之前三条不都是红色
            if(!(getMacdColor(1,m+1)==macdRed&&getMacdColor(2,m+1)==macdRed&&getMacdColor(3,m+1)==macdRed))
              {
								// 报警
               ExtMapBuffer7[m]=Low[m]-间隔*Point;
               if(m==报警信号位置)
                  if(timebx[1]!=Time[0])
                    {
                     timebx[1]=Time[0];
                     string 报警内容=StringConcatenate(Symbol(),"周期:",周期转换(0)," ",报警内容自定义1);
                     if(文字报警开关)
                        Alert(报警内容);
                     if(推送报警开关)
                        SendNotification(报警内容);
                     if(邮件报警开关)
                        SendMail(报警内容," ");
                     if(音乐报警开关)
                        soundsx[1]=true;
                    }
              }
         // 三条都是绿色
         if(getMacdColor(1,m)==macdGreen&&getMacdColor(2,m)==macdGreen&&getMacdColor(3,m)==macdGreen)
						// 之前三条不都是 green
            if(!(getMacdColor(1,m+1)==macdGreen&&getMacdColor(2,m+1)==macdGreen&&getMacdColor(3,m+1)==macdGreen))
              {
							// 报警
               ExtMapBuffer8[m]=High[m]+间隔*Point;
               if(m==报警信号位置)
                  if(timebx[2]!=Time[0])
                    {
                     timebx[2]=Time[0];
                     报警内容=StringConcatenate(Symbol(),"周期:",周期转换(0)," ",报警内容自定义2);
                     if(文字报警开关)
                        Alert(报警内容);
                     if(推送报警开关)
                        SendNotification(报警内容);
                     if(邮件报警开关)
                        SendMail(报警内容," ");
                     if(音乐报警开关)
                        soundsx[2]=true;
                    }
              }
        }

   return(rates_total);
  }

MACDCOLOR getMacdColor(int macdindex, int shift ){
	
  double main = 0;
  double signal = 0;
	switch(macdindex)
	{
		case 1:
			main = ExtMapBuffer1[shift];
			signal = ExtMapBuffer2[shift];
			break;
		case 2:
			main = ExtMapBuffer3[shift];
			signal = ExtMapBuffer4[shift];
			break;
		case 3:
			main = ExtMapBuffer5[shift];
			signal = ExtMapBuffer6[shift];
			break;
		default:
			return macdGray;
	}
	if(main>0&&main>signal){
		return macdRed;
	}
	if(main<0&&main<signal){
			return macdGreen;
	}
	return macdGray;
}

//+------------------------------------------------------------------+
string 周期转换(int x)
  {
   if(x==0)
      x=Period();

   switch(x)
     {
      case 1:
         return("1分钟");
      case 5:
         return("5分钟");
      case 15:
         return("15分钟");
      case 30:
         return("30分钟");
      case 60:
         return("1小时");
      case 240:
         return("4小时");
      case 1440:
         return("日");
      case 10080:
         return("周");
      case 43200:
         return("月");
      default :
         return("");
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---

  }

//+------------------------------------------------------------------+
input datetime 程序最终编译时间=__DATETIME__;
//+------------------------------------------------------------------+
