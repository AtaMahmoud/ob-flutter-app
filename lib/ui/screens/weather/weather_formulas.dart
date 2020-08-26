
/*

The Feels Like temperature is equal to the Heat Index if the temperature is at or 
above 80°F and the relative humidity is at or above 40%. Alternatively, the 
Feels Like temperature is equal to Wind Chill if the temperature is at or 
below 50°F and wind speeds are above 3mph. If neither condition applies, 
the Feels Like temperature is equal to the air temperature.

Thi = −42.379+(2.04901523×T)+(10.1433127×RH)−(0.22475541×T×RH)−(6.83783×10−3×T2)−(5.481717×10−2×RH2)+(1.22874×10−3×T2×RH)+(8.5282×10−4×T×RH2)−(1.99×10−6×T2×RH2)
T= temperature in degrees Fahrenheit (°F)

RH = relative humidity (%)

*/

double getFeelsLikeTemperature(temperature){

  double windChill = 0.0;
  double windSpeed = 0.0;
  double heatIndex = 0.0;
  double relativeHumidity = 0.0;


}