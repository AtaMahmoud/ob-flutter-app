
/*

The Feels Like temperature is equal to the Heat Index if the temperature is at or 
above 80°F and the relative humidity is at or above 40%. Alternatively, the 
Feels Like temperature is equal to Wind Chill if the temperature is at or 
below 50°F and wind speeds are above 3mph. If neither condition applies, 
the Feels Like temperature is equal to the air temperature.

Thi = −42.379+(2.04901523×T)+(10.1433127×RH)−(0.22475541×T×RH)−(6.83783×10−3×T2)−(5.481717×10−2×RH2)+(1.22874×10−3×T2×RH)+(8.5282×10−4×T×RH2)−(1.99×10−6×T2×RH2)
T= temperature in degrees Fahrenheit (°F)

RH = relative humidity (%)

Wind chill
Twc = 35.74 + (0.6215 * T) - ( 35.75 * V to the power(.16) ) + (0.4275*T* V to the power(0.16))
T = temperature in degrees Farneheit ('F)
V = wind speed in mph


*/
// t = temperature
// rh = relative humidity
// v = wind speed
// thi = heat index
// twc = wind chill
import 'dart:math';

import 'package:flutter/material.dart';

double getFeelsLikeTemperature(t,rh,v){

  double thi = 0.0;
  double twc = 0.0;
  double feelsLikeTemp = 0.0;

  thi = -42.379 + 2.04901523 * t + 10.1433127 * rh - 0.22475541*t*rh - (6.83783*pow(10, -3)*t*t) - (5.481717 * pow(10, -2)*rh*rh)+(1.22874*pow(10, -3)*t*t*rh)+(8.5282*pow(10, -4)*t*rh*rh)-(1.99*pow(10, -6)*t*t*rh*rh);
  twc = 35.74 + (0.6215 * t) - ( 35.75 * pow(v, .16)) + (0.4275*t* pow(v, 0.16));

  if(t>=80 && rh >=40){
    feelsLikeTemp = thi;
  }else if(t<=50 && v>3){
    feelsLikeTemp = twc;
  }else{
    feelsLikeTemp = t;
  }

  return feelsLikeTemp;

}

int getWeatherType(temperature, atmosphericPressure, wind, humidity, precipitation){

  debugPrint('detect weather type ---- temperature = $temperature\natmosphericPressure = $atmosphericPressure\nwind = $wind\nhumidity = $humidity\nprecipitation = $precipitation\n');

  return 113;

}

