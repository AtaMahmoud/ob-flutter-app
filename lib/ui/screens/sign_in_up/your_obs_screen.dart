import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/guest_reqest_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/notification.dart';
import 'package:ocean_builder/core/models/user_ocean_builder.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/screens/menu/landing_screen.dart';
import 'package:ocean_builder/ui/screens/profile/profile_screen.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:provider/provider.dart';

class YourObsScreen extends StatefulWidget {
  static const String routeName = '/yourObs';

  final FcmNotification fcmNotification;

  const YourObsScreen({this.fcmNotification});

  @override
  _YourObsScreenState createState() => _YourObsScreenState();
}

class _YourObsScreenState extends State<YourObsScreen> {
  GuestRequestValidationBloc _bloc = GuestRequestValidationBloc();

  String requestAccessTime;

  bool isFromNotificationTray;

  SelectedOBIdProvider _selectedOBIdProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;

    final UserProvider userProvider = Provider.of<UserProvider>(context);

    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);

    if (AppLaunchState.LAUNCH_FROM_NOTIFICATION_TRAY) {
      AppLaunchState.LAUNCH_FROM_NOTIFICATION_TRAY = false;

      isFromNotificationTray = true;

      userProvider.autoLogin().then((onValue) {
        if (userProvider.authenticatedUser == null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => LandingScreen(),
                settings: RouteSettings(name: LandingScreen.routeName)),
            (Route<dynamic> route) => false,
          );
        } else {
          MethodHelper.parseNotifications(context);
        }
      }).catchError((e) {
        // print(e);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LandingScreen(),
              settings: RouteSettings(name: LandingScreen.routeName)),
          (Route<dynamic> route) => false,
        );
      });
    }

    List<UserOceanBuilder> pendigOceanBuilderList = [];
    int len = userProvider?.authenticatedUser?.userOceanBuilder?.length ?? 0;
    if (len > 0) {
      pendigOceanBuilderList = new List<UserOceanBuilder>.from(
          userProvider?.authenticatedUser?.userOceanBuilder);
      pendigOceanBuilderList.retainWhere((uob) {
        return uob.reqStatus != null &&
            uob.reqStatus.contains(NotificationConstants.initiated) &&
            !uob.userType.toLowerCase().contains('owner');
      });
    }

    // MethodHelper.parseNotifications(GlobalContext.currentScreenContext);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Appbar(ScreenTitle.YOUR_OBS),
              _textObInfor(pendigOceanBuilderList),
              _bottomBar()
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<String> _bottomBar() {
    return StreamBuilder<String>(
      stream: _bloc.requestAccessTimeController,
      builder: (context, snapshot) {
        return BottomClipper(
            ButtonText.BACK, ButtonText.NEXT, () => goBack(), () => goNext());
      },
    );
  }

  Padding _textObInfor(List<UserOceanBuilder> pendigOceanBuilderList) {
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Text(
          widget.fcmNotification == null
              ? InfoTexts.YOUR_OB_INFO(pendigOceanBuilderList.length.toString())
              : widget.fcmNotification.data.message,
          style: TextStyle(
              color: Colors.black,
              // wordSpacing: 4.0,

              fontWeight: FontWeight.w500,
              fontSize: 24)),
    );
  }

  goNext() {
    if (!(_selectedOBIdProvider.selectedObId
            .compareTo(AppStrings.selectOceanBuilder) ==
        0)) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(),
            settings: RouteSettings(name: ProfileScreen.routeName)),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.of(context).pushNamed(HomeScreen.routeName);
    }
  }

  goBack() {
    if (isFromNotificationTray) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } else {
      Navigator.of(context).pop();
    }
  }
}
