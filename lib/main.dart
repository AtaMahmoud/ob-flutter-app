import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:ocean_builder/configs/config_reader.dart';
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
import 'package:ocean_builder/core/providers/search_history_provider.dart';
import 'package:ocean_builder/core/providers/storm_glass_data_provider.dart';
import 'package:ocean_builder/core/providers/user_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/providers/selected_history_provider.dart';
import 'package:ocean_builder/core/providers/wow_data_provider.dart';
import 'package:ocean_builder/core/services/initializer_service.dart';
import 'package:ocean_builder/core/services/locator.dart';
import 'package:ocean_builder/core/services/navigation_service.dart';
import 'package:ocean_builder/router.dart' as obRoute;
import 'package:ocean_builder/splash/splash_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/design_screen.dart';
import 'package:ocean_builder/ui/screens/menu/landing_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/email_verification_screen.dart';
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'constants/constants.dart';
import 'core/providers/device_type_provider.dart';
import 'package:uni_links/uni_links.dart';

/* 

alias countFiles='ls -la | wc -l'
alias listAvds='cd c:/Users/asad/AppData/Local/Android/Sdk/tools && ./emulator -list-avds'
alias runPixel='cd c:/Users/asad/AppData/Local/Android/Sdk/tools && ./emulator - avd Pixel_XL_API_30'


 */

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(
      'background notification handler R-------${message.notification.title} ');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

// const MethodChannel platform = MethodChannel('ob.dev/ocean_builder');

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

String selectedNotificationPayload;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  setupLocator();
  await ConfigReader.initialize();

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

  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     systemNavigationBarColor: Colors.red,

  //   ),
  // );

  // await _configureLocalTimeZone();

  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  // String initialRoute = '';

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
    // initialRoute = 'SecondPage.routeName';
    print(
        'didNotificationLaunchApp----------------------${selectedNotificationPayload}');
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notification');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {
            didReceiveLocalNotificationSubject.add(ReceivedNotification(
                id: id, title: title, body: body, payload: payload));
          });

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (payload) {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectedNotificationPayload = payload;
      selectNotificationSubject.add(payload);
    },
  );

// flutterLocalNotificationsPlugin.initialize(initializationSettings,
  // onSelectNotification: onSelectNotification)

  print('running app--------------');

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(notificationAppLaunchDetails),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp(
    this.notificationAppLaunchDetails, {
    Key key,
  }) : super(key: key);

  static const String routeName = obRoute.initialRoute;

  final NotificationAppLaunchDetails notificationAppLaunchDetails;

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isConnected;
  String _initialLink;
  Uri _initialUri;
  String _latestLink = 'Unknown';
  Uri _latestUri;
  StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    print('initializing My app widegt');
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    initPlatformStateForUriDeepLinks();
    _setUpFirebaseCloudMessageing();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      print('on receive local notifiaction');
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title ?? '')
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body ?? '')
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                // Navigator.of(context).pushNamed(LandingScreen.routeName);
                /* await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        SecondPage(receivedNotification.payload),
                  ),
                ); */
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      print('On Select Notification');
      print('got to desing screen');
      locator<NavigationService>().navigateTo(DesignScreen.routeName);
      // await Navigator.of(context).pushNamed(SplashScreen.routeName);
    });
  }

  void _setUpFirebaseCloudMessageing() {
    FirebaseMessaging.instance.getToken().then((token) {
      print('fcm token----------------------------------');
      print(token);
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print(
            '------------------------initial message -- when opening from terminated state ----- $message');
        // Navigator.pushNamed(context, '/message',
        //     arguments: MessageArguments(message, true));
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      print('notification message --- ${notification.title}');
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  // TODO add a proper drawable resource to android, for now using
                  //      one that already exists in example app.
                  icon: 'ic_notification',
                  color: ColorConstants.TOP_CLIPPER_END_DARK),
            ),
            payload: notification.title);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('message --------------- ${message.notification.title}');
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
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
          create: (context) => InitalizerService(),
        ),
        ChangeNotifierProvider(
          create: (context) => SelectedHistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchHistoryProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ocean Builders',
        theme: ThemeData(fontFamily: 'Archivo'),
        navigatorKey: locator<NavigationService>().navigatorKey,
        initialRoute: obRoute.initialRoute,
        onGenerateRoute: obRoute.Router.generateRoute,
      ),
    );
  }

  @override
  void dispose() {
    GlobalListeners.listener.cancel();
    if (_sub != null) _sub.cancel();
    Hive.box('searchItems').compact();
    Hive.close();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
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

    if (_latestUri != null) _parseDeepLinkingUri(_initialUri);
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
    locator<NavigationService>().dpNavigateToEmailVeriScreen(
        EmailVerificationData(
            isDeepLinkData: true, verificationCode: authCode));
  }
} // End of MyApp

//--- local notification helper methods are here
Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = 'GMT';
  // await platform.invokeMethod<String>('getTimeZoneName');
  // tz.setLocalLocation(tz.getLocation(timeZoneName));
}

/*

/usr/bin/xcrun simctl openurl booted "ss://ob.com/auth/verify/?uid=123&token=abc1"
ob://oceanbuilders.com/auth/verify/?uid=123&token=abc1
ob://oceanbuilders.com/auth/confirmation/?token=
ToDo 
1. Use latest firebase plugins 
    1. upgrade all other conflicting and cognate libraries to resolve dependency loop.  -- Done
2. Add Local notifiaction to solve the foreground, backgourd, terminated state related issues.  Set notification icon 
3. Make sure that notifications are comming with data not only notification message
4. Show custom notifcations for different purposes and flever
5. Navigate to rleated screen on Notifiaction tap
6. Trigger relevant action on notification tap     
7. Add notification channel
*/
