import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_clipper/custom_clipper.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/screens/iot/smart_home_settings_screen.dart';
import 'package:ocean_builder/ui/screens/profile/profile_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:provider/provider.dart';
import 'package:ocean_builder/core/providers/mqtt_settings_provider.dart';

class TopClipper extends StatefulWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  final bool hasAvator;
  final bool isMarine;
  final bool enableSkipLogin;
  final bool enableSettings;
  final bool isDesignScreen;

  const TopClipper(this.title,
      {this.scaffoldKey,
      this.innerDrawerKey,
      this.hasAvator,
      this.isMarine,
      this.enableSkipLogin,
      this.enableSettings,
      this.isDesignScreen});

  @override
  _TopClipperState createState() => _TopClipperState();
}

class _TopClipperState extends State<TopClipper> {
  UserProvider _userProvider;
  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);

    return Stack(
      children: <Widget>[
        ClipPath(
            clipper: CustomTopShapeClipper(),
            child: widget.hasAvator ? _customContainer() : _defaultContainer()),
        widget.hasAvator
            ? Positioned(
                right: 32.w,
                top: 100.h,
                child: InkWell(
                    onTap: () {
                      widget.scaffoldKey.currentState.openDrawer();
                    },
                    child: CircleAvatar(
                      backgroundColor: ColorConstants.CONTROL_END,
                      radius: 86.h,
                      child: ImageIcon(
                        AssetImage(ImagePaths.icGroup),
                        color: ColorConstants.CONTROL_LIST_BKG,
                      ),
                    )),
              )
            : Container(),
      ],
    );
  }

  _defaultContainer() {
    return Container(
      height: 400.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          ColorConstants.TOP_CLIPPER_START,
          ColorConstants.TOP_CLIPPER_END
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              32.w,
              32.h,
              0.0, //_util.setWidth(32),
              32.h),
          child: widget.scaffoldKey != null
              ? Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        widget.scaffoldKey.currentState.openDrawer();
                        // widget.innerDrawerKey.currentState.toggle();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 48.w,
                          right: 48.w,
                          top: 48.h,
                          bottom: 48.h,
                        ),
                        child: Icon(
                          Icons.sort,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 70.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )
              : widget.isDesignScreen
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.title.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 48.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        widget.enableSettings
                            ? InkWell(
                                onTap: () {
                                  if (!_userProvider.isLoading) _goToSettnigs();
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(right: 32.w),
                                    child:
                                        SvgPicture.asset(ImagePaths.svgSettings)
/*                                   Text(
                                    "Settings",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 48.sp,
                                        fontWeight: FontWeight.w400),
                                  ), */
                                    ),
                              )
                            : Container(),
                        InkWell(
                          onTap: () {
                            // _skipLogin();
                          },
                          child: Padding(
                              padding: EdgeInsets.only(right: 32.w),
                              child: Container()),
                        )
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          widget.title.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 48.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        widget.enableSkipLogin
                            ? InkWell(
                                onTap: () {
                                  if (!_userProvider.isLoading) _skipLogin();
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 32.w),
                                  child: Text(
                                    "SKIP LOGIN",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 48.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
        ),
      ),
    );
  }

  _customContainer() {
    return Container(
      height: ScreenUtil().setHeight(400),
      decoration: BoxDecoration(gradient: topGradientDark),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            32.w,
            32.h,
            0.0, //_util.setWidth(32),
            32.h),
        child: widget.scaffoldKey != null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      widget.scaffoldKey.currentState.openDrawer();
                      // widget.innerDrawerKey.currentState.toggle();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 32.w,
                        right: 32.w,
                        top: 32.h,
                        bottom: 32.h,
                      ),
                      child: ImageIcon(
                        AssetImage(ImagePaths.icHamburger),
                        size: 50.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  widget.isMarine != null && widget.isMarine
                      ? Container()
                      : SizedBox(
                          width: 64.w,
                        ),
                  widget.isMarine != null && widget.isMarine
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(
                              32.w,
                              32.h,
                              0.0, //_util.setWidth(32),
                              32.h),
                          child: Text(
                            AppStrings.marine.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 48.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      : Container(),
                  Row(
                    children: <Widget>[
                      widget.isMarine != null && widget.isMarine
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Welcome ${_userProvider.authenticatedUser.firstName} ${_userProvider.authenticatedUser.lastName}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 48.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  _userProvider.authenticatedUser
                                              .userOceanBuilder.length >
                                          1
                                      ? '${_userProvider.authenticatedUser.userOceanBuilder[0].oceanBuilderName}'
                                          .toUpperCase()
                                      : '',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 48.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                    ],
                  ),
                ],
              )
            : Text(
                widget.title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 70.sp,
                    fontWeight: FontWeight.w400),
              ),
      ),
    );
  }

  _skipLogin() async {
    String email = 'abdullah@oceanbuilders.com';
    String password = "Asad@123";

    bool internetStatus = await DataConnectionChecker().hasConnection;
    if (!internetStatus) {
      displayInternetInfoBar(context, AppStrings.noInternetConnectionTryAgain);
      return;
    }

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    userProvider.logIn(email, password).then((status) async {
      if (status.status == 200) {
        MethodHelper.parseNotifications(context);

        await MethodHelper.selectOnlyOBasSelectedOB();

        if (userProvider.authenticatedUser.userOceanBuilder == null ||
            userProvider.authenticatedUser.userOceanBuilder.length >= 1) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        } else if (userProvider.authenticatedUser.userOceanBuilder.length < 1) {
          Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
        } else {}
      } else {
        String title = parseErrorTitle(status.code);
        showInfoBar(title, status.message, context);
      }
    });
  }

  void _goToSettnigs() {
    Navigator.of(context).pushNamed(MqttSettingsScreen.routeName);
  }
}
