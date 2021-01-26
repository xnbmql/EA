#property description "Relative Strength Index" 
#property strict 
#property indicator_separate_window 
#property indicator_buffers 3 
#property indicator_color1     clrDodgerBlue 
//--- input parameters 
input int InpRSIPeriod=14; // RSI Period 
//--- buffers 
double ExtRSIBuffer[]; 
double ExtPosBuffer[]; 
double ExtNegBuffer[]; 
//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         | 
//+------------------------------------------------------------------+ 
int OnInit(void) 
  { 
   string short_name; 
//--- 2 additional buffers are used for calculations. 
   IndicatorBuffers(3); 
   SetIndexBuffer(0,ExtRSIBuffer); 
   SetIndexBuffer(1,ExtPosBuffer); 
   SetIndexBuffer(2,ExtNegBuffer); 
//--- set levels    
   IndicatorSetInteger(INDICATOR_LEVELS,2); 
   IndicatorSetDouble(INDICATOR_LEVELVALUE,0,30); 
   IndicatorSetDouble(INDICATOR_LEVELVALUE,1,70); 
//--- set maximum and minimum for subwindow  
   IndicatorSetDouble(INDICATOR_MINIMUM,0); 
   IndicatorSetDouble(INDICATOR_MAXIMUM,100); 
//--- indicator line 
   SetIndexStyle(0,DRAW_LINE); 
   SetIndexBuffer(0,ExtRSIBuffer); 
//--- name for DataWindow and indicator subwindow label 
   short_name="RSI("+string(InpRSIPeriod)+")"; 
   IndicatorShortName(short_name); 
   SetIndexLabel(0,short_name); 
//--- check for input 
   if(InpRSIPeriod<2) 
     { 
      Print("Incorrect value for input variable InpRSIPeriod = ",InpRSIPeriod); 
      return(INIT_FAILED); 
     } 
//--- 
   SetIndexDrawBegin(0,InpRSIPeriod); 
//--- initialization done 
   return(INIT_SUCCEEDED); 
  } 
//+------------------------------------------------------------------+ 
//| Relative Strength Index                                          | 
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
   int    i,pos; 
   double diff; 
//--- 
   if(Bars<=InpRSIPeriod || InpRSIPeriod<2) 
      return(0); 
//--- counting from 0 to rates_total 
   ArraySetAsSeries(ExtRSIBuffer,false); 
   ArraySetAsSeries(ExtPosBuffer,false); 
   ArraySetAsSeries(ExtNegBuffer,false); 
   ArraySetAsSeries(close,false); 
//--- preliminary calculations 
   pos=prev_calculated-1; 
   if(pos<=InpRSIPeriod) 
     { 
      //--- first RSIPeriod values of the indicator are not calculated 
      ExtRSIBuffer[0]=0.0; 
      ExtPosBuffer[0]=0.0; 
      ExtNegBuffer[0]=0.0; 
      double sump=0.0; 
      double sumn=0.0; 
      for(i=1; i<=InpRSIPeriod; i++) 
        { 
         ExtRSIBuffer[i]=0.0; 
         ExtPosBuffer[i]=0.0; 
         ExtNegBuffer[i]=0.0; 
         diff=close[i]-close[i-1]; 
         if(diff>0) 
            sump+=diff; 
         else 
            sumn-=diff; 
        } 
      //--- calculate first visible value 
      ExtPosBuffer[InpRSIPeriod]=sump/InpRSIPeriod; 
      ExtNegBuffer[InpRSIPeriod]=sumn/InpRSIPeriod; 
      if(ExtNegBuffer[InpRSIPeriod]!=0.0) 
         ExtRSIBuffer[InpRSIPeriod]=100.0-(100.0/(1.0+ExtPosBuffer[InpRSIPeriod]/ExtNegBuffer[InpRSIPeriod])); 
      else 
        { 
         if(ExtPosBuffer[InpRSIPeriod]!=0.0) 
            ExtRSIBuffer[InpRSIPeriod]=100.0; 
         else 
            ExtRSIBuffer[InpRSIPeriod]=50.0; 
        } 
      //--- prepare the position value for main calculation 
      pos=InpRSIPeriod+1; 
     } 
//--- the main loop of calculations 
   for(i=pos; i<rates_total && !IsStopped(); i++) 
     { 
      diff=close[i]-close[i-1]; 
      ExtPosBuffer[i]=(ExtPosBuffer[i-1]*(InpRSIPeriod-1)+(diff>0.0?diff:0.0))/InpRSIPeriod; 
      ExtNegBuffer[i]=(ExtNegBuffer[i-1]*(InpRSIPeriod-1)+(diff<0.0?-diff:0.0))/InpRSIPeriod; 
      if(ExtNegBuffer[i]!=0.0) 
         ExtRSIBuffer[i]=100.0-100.0/(1+ExtPosBuffer[i]/ExtNegBuffer[i]); 
      else 
        { 
         if(ExtPosBuffer[i]!=0.0) 
            ExtRSIBuffer[i]=100.0; 
         else 
            ExtRSIBuffer[i]=50.0; 
        } 
     } 
//--- 
   return(rates_total); 
  }