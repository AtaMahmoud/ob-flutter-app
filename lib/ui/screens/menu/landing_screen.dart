import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/user_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/ui/screens/designSteps/design_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/smart_home_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/smart_home_screen_node_js.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/login_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/registration_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/registration_screen_accept_invitation.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LandingScreen extends StatefulWidget {
  static const String routeName = '/landingScreen';

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Future initState() {
    UIHelper.setStatusBarColor();
    super.initState();
  }

  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();

  UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    // return customDrawer(_innerDrawerKey, _currentScreen());
    userProvider = Provider.of<UserProvider>(context);

    return _currentScreen();
  }

  _currentScreen() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[_topBar(), _mainContent()],
      ),
    );
  }

  Expanded _mainContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            userProvider.isLoading
                ? CircularProgressIndicator()
                : _loginToDashboard(),
            _requestOrAcceptAccess(),
            _design(),
            InkWell(
              child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
                child: UIHelper.imageTextColumn(
                    ImagePaths.svgSeapod, AppStrings.smartHome),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(SmartHomeScreen.routeName);
              },
            ),
            InkWell(
              child: Padding(
                padding: EdgeInsets.all(32.w),
                child: UIHelper.imageTextColumn(
                    ImagePaths.svgSeapod, AppStrings.smartHome_local_server),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(SmartHomeScreenNodeServer.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }

  InkWell _design() {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
        child:
            UIHelper.imageTextColumn(ImagePaths.svgSeapod, AppStrings.design),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(DesignScreen.routeName);
      },
    );
  }

  InkWell _requestOrAcceptAccess() {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
        child: UIHelper.imageTextColumn(
            ImagePaths.svgAccessKey, AppStrings.requestAcceptHomeAccess),
      ),
      onTap: () {
        // Navigator.of(context)
        //     .pushNamed(RegistrationScreen.routeName);
        _showAddOBDialog(userProvider, context);
      },
    );
  }

  InkWell _loginToDashboard() {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
        child: UIHelper.imageTextColumn(
            ImagePaths.loginToDashboard, AppStrings.loginToDashboard),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(LoginScreen.routeName,
            arguments: ScreenTitle.LANDING_SCREEN);
      },
    );
  }

  Appbar _topBar() {
    return Appbar(
      ScreenTitle.WELCOME,
      enableSkipLogin: true,
    );
  }


  _showAddOBDialog(UserProvider userProvider, BuildContext cntxt) {
    Alert(
      context: cntxt,
      title: '',
      style: AlertStyle(isCloseButton: false, isOverlayTapDismiss: true),
      content: _alertContent(cntxt),
      buttons: [],
    ).show();
  }

  Column _alertContent(BuildContext cntxt) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buttonRequestAccess(cntxt),
        _buttonAcceptInvitation(cntxt),
      ],
    );
  }

  InkWell _buttonAcceptInvitation(BuildContext cntxt) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: UIHelper.imageTextColumn(ImagePaths.svgSendInvitation,
            AppStrings.acceptHomeAccessInvitation),
      ),
      onTap: () {
        Navigator.of(cntxt, rootNavigator: true).pop();
        Navigator.of(cntxt)
            .pushNamed(RegistrationScreenAcceptInvitation.routeName);
      },
    );
  }

  InkWell _buttonRequestAccess(BuildContext cntxt) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: UIHelper.imageTextColumn(
            ImagePaths.svgRequestAccess, AppStrings.requestHomeAccess),
      ),
      onTap: () {
        Navigator.of(cntxt, rootNavigator: true).pop();
        Navigator.of(cntxt).pushNamed(RegistrationScreen.routeName);
      },
    );
  }
}
