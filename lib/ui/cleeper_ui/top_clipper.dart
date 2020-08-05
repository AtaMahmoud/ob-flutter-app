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
import 'package:ocean_builder/ui/screens/profile/profile_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:provider/provider.dart';

class TopClipper extends StatefulWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  final bool hasAvator;
  final bool isMarine;
  final bool enableSkipLogin;
  final bool isDesignScreen;

  const TopClipper(this.title,
      {this.scaffoldKey,
      this.innerDrawerKey,
      this.hasAvator,
      this.isMarine,
      this.enableSkipLogin,
      this.isDesignScreen});

  @override
  _TopClipperState createState() => _TopClipperState();
}

class _TopClipperState extends State<TopClipper> {
  UserProvider _userProvider;
  ScreenUtil _util;
  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);
    _util = ScreenUtil();

    return Stack(
      children: <Widget>[
        ClipPath(
            clipper: CustomTopShapeClipper(),
            child: widget.hasAvator ? _customContainer() : _defaultContainer()),
        widget.hasAvator
            ? Positioned(
                right: ScreenUtil().setWidth(32),
                top: ScreenUtil().setHeight(100),
                child: InkWell(
                    onTap: () {
                      widget.scaffoldKey.currentState.openDrawer();
                    },
                    child: CircleAvatar(
                      backgroundColor: ColorConstants.CONTROL_END,
                      radius: ScreenUtil().setHeight(86),
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
      height: ScreenUtil().setHeight(400),
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
              _util.setWidth(32),
              _util.setHeight(32),
              0.0, //_util.setWidth(32),
              _util.setHeight(32)),
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
                          left: _util.setWidth(32),
                          right: _util.setWidth(32),
                          top: _util.setHeight(32),
                          bottom: _util.setHeight(32),
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
                          fontSize: ScreenUtil().setSp(70),
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
                                fontSize: ScreenUtil().setSp(48),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // _skipLogin();
                          },
                          child: Padding(
                              padding: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(32)),
                              child: Container()
                              // SvgPicture.asset(
                              //   ImagePaths.svgSettings,
                              //   // width: ScreenUtil().setWidth(196),
                              //   // height: ScreenUtil().setWidth(196),
                              // ),
                              ),
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
                              fontSize: ScreenUtil().setSp(48),
                              fontWeight: FontWeight.w400),
                        ),
                        widget.enableSkipLogin
                            ? InkWell(
                                onTap: () {
                                  if (!_userProvider.isLoading) _skipLogin();
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(32)),
                                  child: Text(
                                    "SKIP LOGIN",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: ScreenUtil().setSp(48),
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
      decoration: BoxDecoration(gradient: topGradientDark
          // LinearGradient(colors: [
          //   ColorConstants.TOP_CLIPPER_START,
          //   ColorConstants.TOP_CLIPPER_END
          // ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            _util.setWidth(32),
            _util.setHeight(32),
            0.0, //_util.setWidth(32),
            _util.setHeight(32)),
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
                        left: _util.setWidth(32),
                        right: _util.setWidth(32),
                        top: _util.setHeight(32),
                        bottom: _util.setHeight(32),
                      ),
                      child: ImageIcon(
                        AssetImage(ImagePaths.icHamburger),
                        size: _util.setWidth(50),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  widget.isMarine != null && widget.isMarine
                      ? Container()
                      : SizedBox(
                          width: ScreenUtil().setWidth(64),
                        ),
                  widget.isMarine != null && widget.isMarine
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(
                              _util.setWidth(32),
                              _util.setHeight(32),
                              0.0, //_util.setWidth(32),
                              _util.setHeight(32)),
                          child: Text(
                            AppStrings.marine.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(48),
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
                                      fontSize: ScreenUtil().setSp(48),
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
                                      fontSize: ScreenUtil().setSp(48),
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
                    fontSize: ScreenUtil().setSp(70),
                    fontWeight: FontWeight.w400),
              ),
      ),
    );
  }

  _skipLogin() async {
    String email = 'skiplogin@oceanbuilders.com';
    String password = "Asad@123";

    bool internetStatus = await DataConnectionChecker().hasConnection;
    // debugPrint('internte status  ' + internetStatus.toString());
    if (!internetStatus) {
      displayInternetInfoBar(context, AppStrings.noInternetConnectionTryAgain);
      // showInfoBar('NO INTERNET', AppStrings.noInternetConnection, context);
      return;
    }

    UserProvider userProvider = Provider.of<UserProvider>(context);

    userProvider.logIn(email, password).then((status) {
      if (status.status == 200) {
        MethodHelper.parseNotifications(context);

        MethodHelper.selectOnlyOBasSelectedOB();

        // debugPrint('--     ----------- ^^^^^^^^^^^^^^^^^^ ----- ${userProvider.authenticatedUser.userOceanBuilder.length}');

        if (userProvider.authenticatedUser.userOceanBuilder == null ||
            userProvider.authenticatedUser.userOceanBuilder.length >= 1) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        } else if (userProvider.authenticatedUser.userOceanBuilder.length < 1) {
          Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
        } else {
          // debugPrint('other case');
        }
      } else {
        // debugPrint('status  ' +
        // status.status.toString() +
        // 'status code ' +
        // status.code +
        // ' msg ' +
        // status.message);
        // debugPrint("--" + parseErrorTitle(status.code) + "---");
        String title = parseErrorTitle(status.code);
        showInfoBar(title, status.message, context);
      }
    });
  }
}
