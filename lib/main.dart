import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
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
import 'package:ocean_builder/core/models/access_request.dart' as ar;
import 'package:ocean_builder/core/models/notification.dart';
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
import 'package:ocean_builder/ui/screens/iot/light_control_data_provider.dart';
import 'package:ocean_builder/ui/screens/notification/guest_request_response_screen.dart';
import 'package:ocean_builder/ui/screens/notification/invitation_response_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/email_verification_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/your_obs_screen.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'constants/constants.dart';
import 'core/providers/device_type_provider.dart';
import 'package:uni_links/uni_links.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
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

  // await _configureLocalTimeZone();

  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  // String initialRoute = '';

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
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

  // let's initilaize flutter location notification
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
  MethodChannel platform = MethodChannel('com.ss.oceanbuilders/res');
  bool isConnected;
  String _initialLink;
  Uri _initialUri;
  String _latestLink = 'Unknown';
  Uri _latestUri;
  StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _configureLocalTimeZone(platform);
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
      print(
          '_configureDidReceiveLocalNotificationSubject notifiaction -------------${receivedNotification.payload}');
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
      print('got to x screen with payload $payload');
      // locator<NavigationService>().navigateTo(DesignScreen.routeName);
      _handleNotification(payload);
      // await Navigator.of(context).pushNamed(SplashScreen.routeName);
    });
  }

  void _setUpFirebaseCloudMessageing() {
    FirebaseMessaging.instance.getToken().then((token) {
      print('FCM token----------------------------------');
      print(token);
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print(
            '------------------------initial message -- when opening from terminated state ----- ${jsonEncode(message).toString()}');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        _showLocalNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('   --------${message.toString()}');
      _handleNotification(message.data);
    });
  }

  // handle notification

  _handleNotification(payload) async {
    print('   --- $payload');
    print('-----------------------');
    payload = payload.toString().replaceAll('\\', '');
    print('   --- $payload');
    // json.encode(payload).toString();
    NotificationData notificationData =
        NotificationData.fromJson(jsonDecode(payload)['payload']);
    debugPrint(
        'notification data -----' + notificationData.toJson().toString());

    FcmNotification fcmNotification = FcmNotification();
    fcmNotification.data = notificationData;
    fcmNotification.notification = NotificationTitleData(
        title: 'Notification Title', body: 'Nnotification message');
    ar.AccessEvent accessEvent = ar.AccessEvent();
    accessEvent.reqMessage = fcmNotification.notification.body;
    accessEvent.accesEventType = 'Access Request';
    // get notification details froms server
/*     accessEvent = await Provider.of<UserProvider>(context, listen: false)
        .getAccessRequest(fcmNotification.data.id);
    accessEvent.reqMessage = fcmNotification.notification.body;
    accessEvent.accesEventType = 'Access Request'; */

//     Provider.of<UserProvider>(context, listen: false)
//         .getAccessRequest(fcmNotification.data.id)
//         .then((accessRequest) {
//       if (accessRequest != null) {
//         accessRequest.reqMessage = fcmNotification.notification.body;
//         accessRequest.accesEventType = 'Access Request';

//         // debugPrint('access request fetched from server -==------------------------------------ ${accessRequest.id}');
// /*         Navigator.of(context).pushNamed(GuestRequestResponseScreen.routeName,
//             arguments: accessRequest); */
//       }
//     });

    if (fcmNotification.data.notificationType
            .toUpperCase()
            .compareTo(NotificationConstants.request) ==
        0) {
      showInAppNotification(
          GuestRequestResponseScreen.routeName, accessEvent, context);
    } else if (fcmNotification.data.notificationType
            .toUpperCase()
            .compareTo(NotificationConstants.response) ==
        0) {
      showInAppNotification(YourObsScreen.routeName, accessEvent, context);
    } else if (fcmNotification.data.notificationType
            .toUpperCase()
            .compareTo(NotificationConstants.invitation) ==
        0) {
      showInAppNotification(
          InvitationResponseScreen.routeName, accessEvent, context);
    } else if (fcmNotification.data.notificationType
            .toUpperCase()
            .compareTo(NotificationConstants.invitationResponse) ==
        0) {
      showInAppNotification(YourObsScreen.routeName, accessEvent, context);
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    var notification = message.notification;
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              channel.id, channel.name, channel.description,
              icon: 'ic_notification',
              largeIcon: const DrawableResourceAndroidBitmap('ic_launcher'),
              color: ColorConstants.TOP_CLIPPER_END_DARK),
        ),
        payload: jsonEncode(message.data));
  }

  Future<void> _showSoundUriNotification(
      RemoteNotification notification) async {
    /// this calls a method over a platform channel implemented within the
    /// example app to return the Uri for the default alarm sound and uses
    /// as the notification sound
    final String alarmUri = await platform.invokeMethod<String>('getAlarmUri');
    final UriAndroidNotificationSound uriSound =
        UriAndroidNotificationSound(alarmUri);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'uri channel id', 'uri channel name', 'uri channel description',
            sound: uriSound,
            styleInformation: const DefaultStyleInformation(true, true));
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(notification.hashCode,
        notification.title, notification.body, platformChannelSpecifics);
  }

  Future<void> _showPublicNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            visibility: NotificationVisibility.public);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'public notification title',
        'public notification body', platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
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
        ),
        ChangeNotifierProvider(
          create: (context) => LightControlDataProvider(),
        )
      ],
      child: ScreenUtilInit(
        designSize: Size(1080, 1960),
        allowFontScaling: false,
        builder: () => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ocean Builders',
          theme: ThemeData(fontFamily: 'Archivo'),
          navigatorKey: locator<NavigationService>().navigatorKey,
          initialRoute: obRoute.initialRoute,
          onGenerateRoute: obRoute.Router.generateRoute,
        ),
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
      _latestUri = uri;
      _parseDeepLinkingUri(uri);
    }, onError: (Object err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        _latestLink = 'Failed to get latest link: $err.';
      });
    });

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
Future<void> _configureLocalTimeZone(platform) async {
  tz.initializeTimeZones();

  final String timeZoneName =
      await platform.invokeMethod<String>('getTimeZoneName');

  print('current timezone name ----$timeZoneName');
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

/*
/usr/bin/xcrun simctl openurl booted "ss://ob.com/auth/verify/?uid=123&token=abc1"
ob://oceanbuilders.com/auth/verify/?uid=123&token=abc1
ob://oceanbuilders.com/auth/confirmation/?token=
Notifiation ToDo 
1. Use latest firebase plugins 
    1. upgrade all other conflicting and cognate libraries to resolve dependency loop.  -- Done
2. Add Local notifiaction to solve the foreground, backgourd, terminated state related issues.  Set notification icon -- Done
3. Make sure that notifications are comming with data not only notification message -- Done
4. Show custom notifcations for different purposes and flever -- Pending
5. Navigate to rleated screen on Notifiaction tap -- Done
6. Trigger relevant action on notification tap     -- Done
7. Add notification channel -- Pending
8. Handle various types of notification 
*/
