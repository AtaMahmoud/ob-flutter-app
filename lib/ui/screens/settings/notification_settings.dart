import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class NotificationSettingsWidget extends StatefulWidget {
  static const String routeName = '/notificationSettingsWidget';

  @override
  _NotificationSettingsWidgetState createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserProvider userProvider;

  @override
  void initState() {
    UIHelper.setStatusBarColor(color: Colors.white);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    userProvider = Provider.of<UserProvider>(context);
    return _mainContent();
  }

  _mainContent() {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: HomeDrawer(
          isSecondLevel: true,
          screenIndex: DrawerIndex.SETTINGS,
        ),
        drawerScrimColor: AppTheme.drawerScrimColor.withOpacity(.65),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  UIHelper.getTopEmptyContainerWithColor(256.h, Colors.white),
                  SliverPadding(
                    padding:
                        EdgeInsets.symmetric(vertical: 48.h, horizontal: 16.w),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _horizontalLine(),
                        _settingsAccessRequestReceived(),
                        _horizontalLine(),
                        _settingsAccessRequestApprovedOrRejected(),
                        _horizontalLine(),
                        _settingsInvitationReceived(),
                        _horizontalLine(),
                        _settingsInvitationAcceptedOrRejected(),
                        _horizontalLine(),
                        _settingsUrgentNotification(),
                      ]),
                    ),
                  ),
                ],
              ),
              _topBar()
            ],
          ),
        ),
      ),
    );
  }

  Positioned _topBar() {
    return Positioned(
      top: ScreenUtil().statusBarHeight,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      32.w,
                      32.h,
                      32.w,
                      32.h,
                    ),
                    child: ImageIcon(
                      AssetImage(ImagePaths.icHamburger),
                      size: 50.w,
                      color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 48.w,
                    top: 32.h,
                    bottom: 32.h,
                  ),
                  child: Text(
                    'Notification Settings',
                    style: TextStyle(
                        color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                        fontWeight: FontWeight.normal,
                        fontSize: 60.sp),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    goBack();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 48.w,
                      top: 32.h,
                      bottom: 32.h,
                    ),
                    child: Image.asset(
                      ImagePaths.cross,
                      width: 58.w,
                      height: 58.h,
                      color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding _settingsUrgentNotification() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: _title('Urgent Notifications'),
            ),
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: _imageIconPhone(),
                ),
                SpaceW32(),
                InkWell(
                  onTap: () {},
                  child: _imageIconMail(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Padding _settingsInvitationAcceptedOrRejected() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: _title('Invitation accepted or rejected'),
            ),
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: _imageIconPhone(),
                ),
                SpaceW32(),
                InkWell(
                  onTap: () {},
                  child: _imageIconMail(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Padding _settingsInvitationReceived() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: _title('Invitation recieved'),
            ),
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: _imageIconPhone(),
                ),
                SpaceW32(),
                InkWell(
                  onTap: () {},
                  child: _imageIconMail(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Padding _settingsAccessRequestApprovedOrRejected() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: _title('Access Request Approved Or Rejected'),
            ),
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: _imageIconPhone(),
                ),
                SpaceW32(),
                InkWell(
                  onTap: () {},
                  child: _imageIconMail(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Padding _settingsAccessRequestReceived() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: _title('Access Request Recieved'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: _imageIconPhone(),
                ),
                SpaceW32(),
                InkWell(
                  onTap: () {},
                  child: _imageIconMail(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _horizontalLine() {
    return SvgPicture.asset(
      ImagePaths.svgWeatherInfoDividerLine,
      fit: BoxFit.fitWidth,
      color: ColorConstants.TOP_CLIPPER_END,
    );
  }

  goBack() {
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
    Navigator.of(context).pop();
  }

  ImageIcon _imageIconMail() {
    return ImageIcon(
      AssetImage(ImagePaths.icMail),
      size: 64.w,
      color: Colors.grey,
    );
  }

  ImageIcon _imageIconPhone() {
    return ImageIcon(
      AssetImage(ImagePaths.icPhone),
      size: 64.w,
      color: Colors.grey,
    );
  }

  Text _title(String title) {
    return Text(title.toUpperCase(),
        style: TextStyle(
            color: ColorConstants.TOP_CLIPPER_END,
            fontWeight: FontWeight.normal,
            fontSize: 48.sp));
  }
}
