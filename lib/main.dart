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
import 'package:ocean_builder/route_info/page_manager.dart';
import 'package:ocean_builder/router.dart' as obRoute;
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:ocean_builder/route_info/route_info_parser.dart';
import 'package:ocean_builder/route_info/router_delegate.dart';
import 'package:ocean_builder/route_info/back_button_dispatcher.dart';

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

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
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

    GlobalListeners.listener =
        DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          // // print('Data connection is available.');
          if (GlobalContext.internetStatus != null &&
              !GlobalContext.internetStatus) {
            displayInternetInfoBar(context, AppStrings.internetConnection);
            GlobalContext.internetStatus = true;
          }
          break;
        case DataConnectionStatus.disconnected:
          // // print('You are disconnected from the internet.');
          displayInternetInfoBar(context, AppStrings.noInternetConnection);
          GlobalContext.internetStatus = false;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: true);
    service.SystemChrome.setPreferredOrientations([
      service.DeviceOrientation.portraitUp,
      service.DeviceOrientation.portraitDown,
    ]);

    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START);
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
        ChangeNotifierProvider(
          create: (context) => PageManager(),
        ),
        // Provider<FirebaseAnalytics>.value(value: analytics),
        // Provider<FirebaseAnalyticsObserver>.value(value: observer),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ocean Builders',
        theme: ThemeData(fontFamily: 'Archivo'),
        // navigatorKey: locator<NavigationService>().navigatorKey,
        // initialRoute: obRoute.initialRoute,
        // onGenerateRoute: obRoute.Router.generateRoute,
        home: Stack(
          children: [
            MainNavigatorPage(),
            _NavStateLabel(),
          ],
        ),
      ),
      // child: MaterialApp.router(
      //   debugShowCheckedModeBanner: false,
      //   title: 'Ocean Builders',
      //   theme: ThemeData(fontFamily: 'Archivo'),
      //   onGenerateTitle: (context) {
      //     return context.findAncestorStateOfType().toString();
      //   },
      //   routeInformationParser: RouteInformationParserOB(),
      //   routerDelegate: RouterDelegateOB(),
      //   // backButtonDispatcher: BackButtonDispatcherOB(),
      // )
      // MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   title: 'Ocean Builders',
      //   // navigatorObservers: <NavigatorObserver>[
      //   // observer
      //   // ],
      //   theme: ThemeData(fontFamily: 'Archivo'),
      //   navigatorKey: locator<NavigationService>().navigatorKey,
      //   initialRoute: obRoute.initialRoute,
      //   onGenerateRoute: obRoute.Router.generateRoute,
      // ),
      //     MaterialApp.router(
      //   debugShowCheckedModeBanner: false,
      //   title: 'Ocean Builders',
      //   theme: ThemeData(fontFamily: 'Varela'),
      //   // navigatorKey: locator<NavigationService>().navigatorKey,
      // )
    );
  }

  @override
  void dispose() {
    // _listener.cancel();
    GlobalListeners.listener.cancel();
    super.dispose();
  }
}

class MainNavigatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(
      // using provider here, but it could be bloc,
      // setState or any other way to notify about the changes
      builder: (context, pageManager, _) {
        // This is required to handle back button on Android
        // The same navigator key must be used to check WillPopScope's condition
        // and provided to Navigator widget
        return WillPopScope(
          onWillPop: () async =>
              !await pageManager.navigatorKey.currentState.maybePop(),
          child: Navigator(
            key: pageManager.navigatorKey,
            pages: pageManager.pages,
            onPopPage: (route, result) {
              // _onWillPop(context, route, result, pageManager);
              // return true;
              return _onPopPage(route, result, pageManager);
            },

            /// You can provide your own [TransitionDelegate] implementation
            /// to decide if navigation operation should be animated
            ///
            /// Note that it's not specifying the animation itself
            // transitionDelegate: const CustomTransitionDelegate(),
          ),
        );
      },
    );
  }

  /// You need to provide `onPopPage` to [Navigator]
  /// to properly clean up `pages` list if a page has been popped.
  bool _onPopPage(
      Route<dynamic> route, dynamic result, PageManager pageManager) {
    pageManager.didPop(route.settings, result);

    return route.didPop(result);
  }

  Future<bool> _onWillPop(context, route, result, pageManager) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  // exit(0);
                  Navigator.of(context).pop(true);
                  // _onPopPage(route, result, pageManager);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class _NavStateLabel extends StatelessWidget {
  const _NavStateLabel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Consumer<PageManager>(
        builder: (context, pageManager, _) {
          return Material(
            elevation: 2,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 8,
                  top: kBottomNavigationBarHeight + 24,
                ),
                child: Text(
                  pageManager.pages.map((e) => '${e.name}').join('/'),
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
