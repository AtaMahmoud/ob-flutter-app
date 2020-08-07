import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/configs/config_reader.dart';
import 'package:ocean_builder/core/notification/firebase_notification_handler.dart';
import 'package:ocean_builder/core/providers/color_picker_data_provider.dart';
import 'package:ocean_builder/core/providers/connection_status_provider.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/core/providers/drawer_state_data_provider.dart';
import 'package:ocean_builder/core/providers/earth_station_data_provider.dart';
import 'package:ocean_builder/core/providers/fake_data_provider.dart';
import 'package:ocean_builder/core/providers/local_noti_data_provider.dart';
import 'package:ocean_builder/core/providers/local_weather_flow_data_provider.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/qr_code_data_provider.dart';
import 'package:ocean_builder/core/providers/storm_glass_data_provider.dart';
import 'package:ocean_builder/core/providers/user_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/providers/wow_data_provider.dart';
import 'package:ocean_builder/core/services/locator.dart';
import 'package:ocean_builder/core/services/navigation_service.dart';
import 'package:ocean_builder/router.dart';
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'core/providers/device_type_provider.dart';


// Future<void> main() async {
//   await mainCommon();
// }

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // Load the JSON config into memory
  await ConfigReader.initialize();
  new FirebaseNotifications().setUpFirebase();
  setupLocator();

  // Crashlytics.instance.enableInDevMode = false;
  // FlutterError.onError = Crashlytics.instance.recordFlutterError;
  // runApp(
  //   DevicePreview(
  //     enabled: false,
  //     builder:(context){
  //       // ScreenUtil.init(context,allowFontScaling: true,width: 1080 , height: 1920);
  //       return MyApp();
  //       }
  //     )
  //   );
  //   runZoned(() {
  //   runApp(
  //     DevicePreview(
  //       enabled: false,

  //       builder:(context) => MyApp()
  //       )
  //     );
  // }, onError: Crashlytics.instance.recordError);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp() ,
    ),
  );
  
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  bool isConnected;
  // static FirebaseAnalytics analytics = FirebaseAnalytics();
  // static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);


  @override
  void initState() {
    super.initState();
  
  GlobalListeners.listener = DataConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case DataConnectionStatus.connected:
        // // print('Data connection is available.');
        if(GlobalContext.internetStatus!=null && !GlobalContext.internetStatus)
        {
        displayInternetInfoBar(context,AppStrings.internetConnection);
        GlobalContext.internetStatus = true;
        }
        break;
      case DataConnectionStatus.disconnected:
        // // print('You are disconnected from the internet.');
        displayInternetInfoBar(context,AppStrings.noInternetConnection);
         GlobalContext.internetStatus = false;
        break;
    }
  });  

  }
  

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,allowFontScaling: true);
    service.SystemChrome.setPreferredOrientations([
      service.DeviceOrientation.portraitUp,
      service.DeviceOrientation.portraitDown,
    ]);

   UIHelper.setStatusBarColor(color:ColorConstants.TOP_CLIPPER_START);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => OceanBuilderProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => DesignDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => UserDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => QrCodeDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DeviceTypeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectionStatusProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WOWDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StormGlassDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SelectedOBIdProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalNotiDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FakeDataProvider(),
        ), //DrawerStateDataProvider
        ChangeNotifierProvider(
          create: (context) => SwiperDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ColorPickerDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EarthStationDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalWeatherDataProvider(),
        ),
        // Provider<FirebaseAnalytics>.value(value: analytics),
        // Provider<FirebaseAnalyticsObserver>.value(value: observer),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ocean Builders',
        // navigatorObservers: <NavigatorObserver>[
        // observer
        // ],
        theme: ThemeData(fontFamily: 'Archivo'),
        navigatorKey: locator<NavigationService>().navigatorKey,
        initialRoute: initialRoute,
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }

  @override
void dispose() {
  // _listener.cancel();
  GlobalListeners.listener.cancel();
  super.dispose();
}

}
