import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:flutter/services.dart';
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
import 'package:ocean_builder/router.dart' as obRoute;
import 'package:ocean_builder/ui/screens/sign_in_up/email_verification_screen.dart';
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'core/providers/device_type_provider.dart';
import 'package:uni_links/uni_links.dart';

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

  String _initialLink;
  Uri _initialUri;
  String _latestLink = 'Unknown';
  Uri _latestUri;
  StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    initPlatformStateForUriDeepLinks();

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

    final queryParams = _latestUri?.queryParametersAll?.entries?.toList();

    queryParams?.map((item) {
      // return new ListTile(
      //   title: new Text('${item.key}'),
      //   trailing: new Text('${item.value?.join(', ')}'),
      // );
      print('key ---- ${item.key}');
      print('value ----- ${item.value?.join(', ')}');
    })?.toList();

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
        initialRoute: obRoute.initialRoute,
        onGenerateRoute: obRoute.Router.generateRoute,
      ),
    );
  }

  @override
  void dispose() {
    // _listener.cancel();
    GlobalListeners.listener.cancel();
    if (_sub != null) _sub.cancel();
    super.dispose();
  }

  Future<void> initPlatformStateForUriDeepLinks() async {
    // Attach a listener to the Uri links stream
    _sub = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      print(
          'got uri in first listener : ${uri?.path} ${uri?.queryParametersAll}');
      _latestUri = uri;
      // setState(() {
      //   _latestUri = uri;
      //   _latestLink = uri?.toString() ?? 'Unknown';
      // });

      // setState(() {
      //   _parseDeepLinkingUri(uri);
      // });
      _parseDeepLinkingUri(uri);

    }, onError: (Object err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        _latestLink = 'Failed to get latest link: $err.';
      });
    });

    // // Attach a second listener to the stream
    // getUriLinksStream().listen((Uri uri) {
    //   print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
    // }, onError: (Object err) {
    //   print('got err: $err');
    // });

    // Get the latest Uri
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _initialUri = await getInitialUri();
      print('initial uri: ${_initialUri?.path}'
          ' ${_initialUri?.queryParametersAll}');
      _initialLink = _initialUri?.toString();
    } on PlatformException {
      _initialUri = null;
      _initialLink = 'Failed to get initial uri.';
    } on FormatException {
      _initialUri = null;
      _initialLink = 'Bad parse the initial link as Uri.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    _latestUri = _initialUri;

    if(_latestUri != null)
    _parseDeepLinkingUri(_initialUri);
    // setState(() {
    //   _latestUri = _initialUri;
    //   _latestLink = _initialLink;
    // });
  }

  _parseDeepLinkingUri(Uri uri) {
    String parh = uri?.path;
    print('path ------ $parh');
    final queryParams = _latestUri?.queryParametersAll?.entries?.toList();

    queryParams?.map((item) {
      print('key ---- ${item.key}');
      print('value ----- ${item.value?.join(', ')}');
    })?.toList();
    // Navigator.of(context).pushNamed(EmailVerificationScreen.routeName);
    String authCode = queryParams[0].value[0];
    print('------------- authCode  $authCode');
    locator<NavigationService>().dpNavigateToEmailVeriScreen(EmailVerificationData(isDeepLinkData: true,verificationCode: authCode));
  }
}

/*

/usr/bin/xcrun simctl openurl booted "ss://ob.com/auth/verify/?uid=123&token=abc1"
ob://oceanbuilders.com/auth/verify/?uid=123&token=abc1
ob://oceanbuilders.com/auth/confirmation/?token=

https://u14190272.ct.sendgrid.net/ls/click?upn=OLvoOHzP3-2ByCuvufJYvJtbI2Wtxboop07l4pVYbrzqkjJDSCvBc-2BFrjzk6cyzdVNlquYGFE2p9ziy457RvNRBCVNhVRZKXpLulTn69kJ427NSJZfy-2B-2FxQbCOsEZO5yrYlkPrxJUyAySqYiRGZYqI9uKuTT8sBwefOoXx4a2r2vzJmwpDPAh8D3rLJaDdgAz4ZmZ-2Fs-2BfNxXqEK00YgoEyqDyxIFT8btQaqH352gt6hk5wB8mn27Z30L1me4OKknM-2BzVwnXI-2Bl0gYeLg2TYRlwsdOZjJ5owl4pFGCJckQSbircHYN5AWt9P0lsZQFw3uynkW2Z_vZteg0lqx4dX9dLgnDQA7uNVaFd1A6lNq1lnPauTIiT-2FwBG14G6kl3GMLSaWdbGP21yREptEOouG8uM3bW84Akwmrhmp3vrtyoZKBNinJKfmrAdkovgvDXm0RXIm8xrZ5C8uKUEfBqh6Wumd0sUigqVCzpmdLEEvgTytWPDADDYutU-2FlAVB8JzFLVz6hov3w3LlzFDn-2FKpBXDO-2BkgrPtXbULMTGW31D4R6DECshqVHQ-3D



*/
