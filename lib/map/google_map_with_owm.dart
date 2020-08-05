// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:ocean_builder/constants/constants.dart';
// import 'package:ocean_builder/helper/method_helper.dart';

// class RadarMap extends StatefulWidget {
//     static const routeName = '/radar_map';
//   @override
//   State<RadarMap> createState() => RadarMapState();
// }

// class RadarMapState extends State<RadarMap> {
//   GoogleMapController controller;
  


//   static final CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(9.616966,-79.591037),
//       tilt: 59.440717697143555,
//       zoom: 8);

//     TileOverlay _tileOverlay;

//   void _onMapCreated(GoogleMapController controller) {
//     this.controller = controller;
//     Future.delayed(Duration.zero).then((_){
//     _addTileOverlay();
//     });

//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   void _removeTileOverlay() {
//     // print("Remove tile overlay");
//     setState(() {
//       _tileOverlay = null;
//     });
//   }

//   void _addTileOverlay() {
//     // print("Add tile overlay");
//     final TileOverlay tileOverlay = TileOverlay(
//       tileOverlayId: TileOverlayId("tile_overlay_1"),
//       tileProvider: DebugTileProvider(context),
//     );
//     setState(() {
//       _tileOverlay = tileOverlay;
//     });
//   }

//   void _clearTileCache() {
//     // print("Clear tile cache");
//     if (_tileOverlay != null && controller != null) {
//       controller.clearTileCache(_tileOverlay.tileOverlayId);
//     }
//   }    

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body:Center(
//           child: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             height:MediaQuery.of(context).size.height,
//             child: GoogleMap(
//               mapType: MapType.hybrid,
//               initialCameraPosition: const CameraPosition(
//                 target: LatLng(9.616966,-79.591037),
//                 zoom: 6.0,
//                 // tilt: 59.440717697143555,
                
//               ),
//               tileOverlays:
//                   _tileOverlay != null ? <TileOverlay>{_tileOverlay} : null,
//               onMapCreated: _onMapCreated,
//             ),
//           ),
//         ),
//     );
//   }
// }

// /*   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   } */

// class DebugTileProvider implements TileProvider {
//   DebugTileProvider(BuildContext context) {
//     boxPaint.isAntiAlias = true;
//     boxPaint.color = Colors.blue;
//     boxPaint.strokeWidth = 1.0;
//     boxPaint.style = PaintingStyle.stroke;
//     width =  256;//MediaQuery.of(context).size.width~/128;
//     height =  256;//MediaQuery.of(context).size.width~/128;
//     // debugPrint('w ----------$width  h --------------- $height');
//   }


//     int width;
//     int height;
//   static final Paint boxPaint = Paint();
//   static final TextStyle textStyle = TextStyle(
//     color: Colors.red,
//     fontSize:ScreenUtil().setSp(48),
//   );

//   @override
//   Future<Tile> getTile(int x, int y, int zoom) async {
//     // print("TileProvider: getTile x = $x, y = $y, zoom = $zoom");


//     // https://api.aerisapi.com/forecasts/9.616966,-79.591037?client_id=4p3odBMEXO6X4jv0mnVcI&client_secret=eQPqDrUNHMnJzOvELRX3uUDhnkeZK7UlEpQ2qihM
//     // https://api.aerisapi.com/observations/closest/9.616966,-79.591037?client_id=4p3odBMEXO6X4jv0mnVcI&client_secret=eQPqDrUNHMnJzOvELRX3uUDhnkeZK7UlEpQ2qihM

//       // wind speed
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://maps2.aerisapi.com/4p3odBMEXO6X4jv0mnVcI_eQPqDrUNHMnJzOvELRX3uUDhnkeZK7UlEpQ2qihM/wind-speeds/$zoom/$x/$y/current.png');
//       // visibility
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://maps2.aerisapi.com/4p3odBMEXO6X4jv0mnVcI_eQPqDrUNHMnJzOvELRX3uUDhnkeZK7UlEpQ2qihM/fsatellite/$zoom/$x/$y/current.png');
//       // dew-points
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://maps2.aerisapi.com/4p3odBMEXO6X4jv0mnVcI_eQPqDrUNHMnJzOvELRX3uUDhnkeZK7UlEpQ2qihM/dew-points/$zoom/$x/$y/current.png');
//       // humidity
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://maps2.aerisapi.com/4p3odBMEXO6X4jv0mnVcI_eQPqDrUNHMnJzOvELRX3uUDhnkeZK7UlEpQ2qihM/humidity/$zoom/$x/$y/current.png');
//       //wind-gusts
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://maps2.aerisapi.com/4p3odBMEXO6X4jv0mnVcI_eQPqDrUNHMnJzOvELRX3uUDhnkeZK7UlEpQ2qihM/wind-gusts/$zoom/$x/$y/current.png');
//       // wind-dir
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://maps2.aerisapi.com/4p3odBMEXO6X4jv0mnVcI_eQPqDrUNHMnJzOvELRX3uUDhnkeZK7UlEpQ2qihM/wind-dir/$zoom/$x/$y/current.png');
//       // feels-like
//       Uint8List byteData = await MethodHelper.networkImageToByte('https://maps2.aerisapi.com/4p3odBMEXO6X4jv0mnVcI_eQPqDrUNHMnJzOvELRX3uUDhnkeZK7UlEpQ2qihM/feels-like/$zoom/$x/$y/current.png');
//       // precip-normals
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://maps2.aerisapi.com/4p3odBMEXO6X4jv0mnVcI_eQPqDrUNHMnJzOvELRX3uUDhnkeZK7UlEpQ2qihM/precip-normals/$zoom/$x/$y/current.png');
//       // heat-index
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://maps2.aerisapi.com/4p3odBMEXO6X4jv0mnVcI_eQPqDrUNHMnJzOvELRX3uUDhnkeZK7UlEpQ2qihM/heat-index/$zoom/$x/$y/current.png');
//       // debugPrint('https://maps2.aerisapi.com/4p3odBMEXO6X4jv0mnVcI_eQPqDrUNHMnJzOvELRX3uUDhnkeZK7UlEpQ2qihM/fsatellite/$zoom/$x/$y/current.png');

//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://api.climacell.co/v3/weather/layers/temperature/now/$zoom/$x/$y.png?region=global&apikey=8j9XZnTS3of2fKUyNgzJjVzyE58WB8WC');
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://api.climacell.co/v3/weather/layers/wind-speed/now/$zoom/$x/$y.png?region=global&apikey=8j9XZnTS3of2fKUyNgzJjVzyE58WB8WC');
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://api.climacell.co/v3/weather/layers/wind-direction/now/$zoom/$x/$y.png?region=global&apikey=8j9XZnTS3of2fKUyNgzJjVzyE58WB8WC');
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://api.climacell.co/v3/weather/layers/wind-gust/now/$zoom/$x/$y.png?region=global&apikey=8j9XZnTS3of2fKUyNgzJjVzyE58WB8WC');
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://api.climacell.co/v3/weather/layers/visibility/now/$zoom/$x/$y.png?region=global&apikey=8j9XZnTS3of2fKUyNgzJjVzyE58WB8WC');
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://api.climacell.co/v3/weather/layers/pressure/now/$zoom/$x/$y.png?region=global&apikey=8j9XZnTS3of2fKUyNgzJjVzyE58WB8WC');
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://api.climacell.co/v3/weather/layers/humidity/now/$zoom/$x/$y.png?region=global&apikey=8j9XZnTS3of2fKUyNgzJjVzyE58WB8WC');
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://api.climacell.co/v3/weather/layers/cloud-cover/now/$zoom/$x/$y.png?region=global&apikey=8j9XZnTS3of2fKUyNgzJjVzyE58WB8WC');
//       // Uint8List byteData = await MethodHelper.networkImageToByte('https://api.climacell.co/v3/weather/layers/precipitation/now/$zoom/$x/$y.png?region=global&apikey=8j9XZnTS3of2fKUyNgzJjVzyE58WB8WC');
//       // // debugPrint('https://api.climacell.co/v3/weather/layers/temperature/now/$zoom/$x/$y.png?region=us&apikey=8j9XZnTS3of2fKUyNgzJjVzyE58WB8WC');


//     // Uint8List byteData = await MethodHelper.networkImageToByte('https://tile.openweathermap.org/map/temp_new/$zoom/$x/$y.png?appid=a25bdea195a3512f05a575ca361c0973');
//     // Uint8List byteData = await MethodHelper.networkImageToByte('https://tile.openweathermap.org/map/precipitation_new/$zoom/$x/$y.png?appid=a25bdea195a3512f05a575ca361c0973');
//     // Uint8List byteData = await MethodHelper.networkImageToByte('https://tile.openweathermap.org/map/pressure_new/$zoom/$x/$y.png?appid=a25bdea195a3512f05a575ca361c0973');
//     // Uint8List byteData = await MethodHelper.networkImageToByte('https://tile.openweathermap.org/map/wind_new/$zoom/$x/$y.png?appid=a25bdea195a3512f05a575ca361c0973');
//     // Uint8List byteData = await MethodHelper.networkImageToByte('https://tile.openweathermap.org/map/clouds_new/$zoom/$x/$y.png?appid=a25bdea195a3512f05a575ca361c0973');
   
//     // // debugPrint('https://tile.openweathermap.org/map/temp_new/$zoom/$x/$y.png?appid=a25bdea195a3512f05a575ca361c0973');
//     // current weather 
//     // https://api.openweathermap.org/data/2.5/weather?lat=9.616966&lon=-79.591037&appid=a25bdea195a3512f05a575ca361c0973
//     //  uv index data
//     // http://api.openweathermap.org/data/2.5/uvi/forecast?appid=a25bdea195a3512f05a575ca361c0973&lat=9.616966&lon=-79.591037&cnt=7
//     // http://api.openweathermap.org/data/2.5/uvi/history?appid=a25bdea195a3512f05a575ca361c0973&lat=9.616966&lon=-79.591037&cnt=7&start=1582867749&end=1583213349

//     // api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={your api key}
//     // http://api.openweathermap.org/data/2.5/forecast?lat=9.616966&lon=-79.591037&appid=a25bdea195a3512f05a575ca361c0973

//     return Tile(width, height, byteData);

//   }
// }