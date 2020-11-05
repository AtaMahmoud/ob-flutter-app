import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/fake_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/singletons/headers_manager.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/screens/menu/landing_screen.dart';
import 'package:ocean_builder/ui/screens/profile/profile_screen.dart';
import 'package:ocean_builder/ui/shared/shared_pref_data.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserProvider userProvider;
  SelectedOBIdProvider _selectedOBIdProvider;
  HeadersManager _headerManager;
  //  var _listener;
  @override
  void initState() {
    UIHelper.setStatusBarColor(color: ColorConstants.SPLASH_BKG);
    super.initState();
    _headerManager = HeadersManager.getInstance();
    if (!AppLaunchState.LAUNCH_FROM_NOTIFICATION_TRAY) {
      Future.delayed(Duration.zero).then((_) {
        initData().then((value) {
          // // debugPrint('Navigating to Home screen --------');
          navigateToHomeScreen();
        });
      });
    } else {
      // // debugPrint('Navigating to other screen --------');
      initData();
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    ScreenUtil.init(context);
    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);

    _headerManager.initalizeBasicHeaders(context);
    _headerManager.initializeEssentialHeaders();

    return Center(
      child: Container(
        decoration: BoxDecoration(
            image: new DecorationImage(
          image: new AssetImage('images/splash.png'),
          fit: BoxFit.cover,
        )),
      ),
    );
  }

  Future initData() async {
    await Future.delayed(Duration(seconds: 3));
    // // debugPrint('context is --  ${context} ------------ global context --  ${GlobalContext.currentScreenContext}');
    FakeDataProvider fakeDataProvider = Provider.of<FakeDataProvider>(context);
    fakeDataProvider.fetchFakeData();
    userProvider = Provider.of<UserProvider>(context);
    userProvider.isAuthenticatedUser;
    SelectedOBIdProvider selectedOBIdProvider =
        Provider.of<SelectedOBIdProvider>(context);
    SharedPrefHelper.getCurrentOB().then((onValue) {
      if (onValue != null && onValue.length > 3)
        selectedOBIdProvider.selectedObId = onValue;
      else {
        selectedOBIdProvider.selectedObId = AppStrings.selectOceanBuilder;
      }
    });
  }

  Future navigateToHomeScreen() async {
    if (!AppLaunchState.LAUNCH_FROM_NOTIFICATION_TRAY) {
      bool installStatus = await SharedPrefHelper.getFirstInstallStatus();
      if (installStatus ?? true) {
        await userProvider.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LandingScreen(),
              settings: RouteSettings(name: LandingScreen.routeName)),
          (Route<dynamic> route) => false,
        );
      } else {
        // await userProvider.autoAuthenticate().then((onValue) {
        await userProvider.autoLogin().then((onValue) async {
          if (userProvider.authenticatedUser == null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => LandingScreen(),
                  settings: RouteSettings(name: LandingScreen.routeName)),
              (Route<dynamic> route) => false,
            );
          } else {
            await MethodHelper.selectOnlyOBasSelectedOB();
            MethodHelper.parseNotifications(context);
            debugPrint(
                '_selectedOBIdProvider.selectedObId ---------------------------------------- ${_selectedOBIdProvider.selectedObId}');
            if (!(_selectedOBIdProvider.selectedObId
                    .compareTo(AppStrings.selectOceanBuilder) ==
                0)) {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            } else {
              // Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                    settings: RouteSettings(name: ProfileScreen.routeName)),
                (Route<dynamic> route) => false,
              );
            }
          }
        }).catchError((e) {
          // // print(e);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => LandingScreen(),
                settings: RouteSettings(name: LandingScreen.routeName)),
            (Route<dynamic> route) => false,
          );
        });
      }
    }
  }

  // _skipLogin() {
  //   String email = 'skiplogin@oceanbuilders.com';
  //   String password = "123456";

  //   UserProvider userProvider = Provider.of<UserProvider>(context);

  //   userProvider.signIn(email, password).then((status) {
  //     if (status.status == 200) {
  //       MethodHelper.parseNotifications(context);

  //       MethodHelper.selectOnlyOBasSelectedOB();
  //       if (userProvider.authenticatedUser.userOceanBuilder == null ||
  //           userProvider.authenticatedUser.userOceanBuilder.length > 1) {
  //         Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  //       } else if (userProvider.authenticatedUser.userOceanBuilder.length <=
  //           1) {
  //         Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  //       }
  //     } else {
  //       debugPrint('status  ' +
  //           status.status.toString() +
  //           'status code ' +
  //           status.code +
  //           ' msg ' +
  //           status.message);
  //       debugPrint("--" + parseErrorTitle(status.code) + "---");
  //       String title = parseErrorTitle(status.code);
  //       showInfoBar(title, status.message, context);
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => LandingScreen()),
  //         (Route<dynamic> route) => false,
  //       );
  //     }
  //   });
  // }
}
