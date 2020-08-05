import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/guest_reqest_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/access_request.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/screens/menu/landing_screen.dart';
import 'package:ocean_builder/ui/shared/drop_downs.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class InvitationResponseScreen extends StatefulWidget {
  static const String routeName = '/invitationResponse';

  final AccessEvent accessInvitation;

  const InvitationResponseScreen({this.accessInvitation});

  @override
  _InvitationResponseScreenState createState() =>
      _InvitationResponseScreenState();
}

class _InvitationResponseScreenState extends State<InvitationResponseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GuestRequestValidationBloc _bloc = GuestRequestValidationBloc();

  String requestAccessTime;

  ScreenUtil _util;

  OceanBuilderProvider _oceanBuilderProvider;

  bool isFromNotificationTray = false;

  @override
  void initState() {
    super.initState();
    Duration d = Duration(milliseconds: widget.accessInvitation.period);
    // debugPrint('acces invitation time in days-- ' + d.inDays.toString());
    String accessFor;
    if (d.inDays <= 15) {
      if (d.inDays == 1)
        accessFor = '${d.inDays} DAY';
      else
        accessFor = '${d.inDays} DAYS';
    } else if (d.inDays == 30) {
      accessFor = '1 MONTH';
    } else if (d.inDays == 90) {
      accessFor = '3 MONTHS';
    } else if (d.inDays == 180) {
      accessFor = '6 MONTHS';
    } else if (d.inDays == 360) {
      accessFor = '1 YEAR';
    } else if (d.inDays == 1800 || d.inDays == 0) {
      accessFor = 'PERMANENT ACCESS';
    }
    if (accessFor.compareTo('0 DAYS') == 0) accessFor = 'PERMANENT ACCESS';

    int index = ListHelper.getAccessTimeList().indexOf(accessFor);

    _bloc.requestAccessTimeChanged(ListHelper.getAccessTimeList()[index]);
    requestAccessTime = accessFor;
    _bloc.requestAccessTimeController.listen((onData) {
      requestAccessTime = onData;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    final UserProvider userProvider = Provider.of<UserProvider>(context);

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

    userProvider.autoLogin();

    _util = ScreenUtil();
    _oceanBuilderProvider = Provider.of<OceanBuilderProvider>(context);
    double topClipperRatio =
        Platform.isIOS ? (153.5) / 813 : (153.5 + 16) / 813;
    double height = MediaQuery.of(context).size.height * topClipperRatio;

    String vesselCode = widget.accessInvitation.seaPod.vessleCode;

    if (!mounted)
      MethodHelper.parseNotifications(GlobalContext.currentScreenContext);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: true,
        drawer: HomeDrawer(
          isSecondLevel: true,
          screenIndex: DrawerIndex.NOTIFICATIONS,
        ),
        drawerScrimColor: AppTheme.drawerScrimColor.withOpacity(.65),
        body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            CustomScrollView(
              shrinkWrap: true,
              slivers: <Widget>[
                UIHelper.getTopEmptyContainer(height * .9, false),
                userProvider.isLoading
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate([
                        _messageRow(widget.accessInvitation.reqMessage),
                        SizedBox(height: _util.setHeight(128)),
                        _itemRow('Email Address',
                            widget.accessInvitation.user.email),
                        SizedBox(height: _util.setHeight(128)),
                        _itemRow('Contact Number',
                            widget.accessInvitation.user.mobileNumber),
                        SizedBox(height: _util.setHeight(128)),
                        _itemRow('SEAPOD NAME /\nVESSEL CODE',
                            '${widget.accessInvitation.seaPod.name} /\n $vesselCode'),
                        SizedBox(height: _util.setHeight(128)),
                        _accessRow('Access As', widget.accessInvitation.type,
                            ' Access For', 'accessForValue'),
                        SizedBox(height: _util.setHeight(128)),
                      ])),
                UIHelper.getTopEmptyContainer(90, false),
              ],
            ),
            Positioned(
              top: ScreenUtil.statusBarHeight,
              left: 0,
              right: 0,
              child: Container(
                // color: Colors.white,
                // padding: EdgeInsets.only(top: 8.0, right: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                _scaffoldKey.currentState.openDrawer();
                                // _innerDrawerKey.currentState.toggle();
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
                                  color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  _util.setWidth(32),
                                  _util.setHeight(32),
                                  0.0, //_util.setWidth(32),
                                  _util.setHeight(32)),
                              child: Text(
                                ScreenTitle.INVITATION_REQUEST,
                                style: TextStyle(
                                    color:
                                        ColorConstants.WEATHER_MORE_ICON_COLOR,
                                    fontSize: ScreenUtil().setSp(64),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            if (isFromNotificationTray) {
                              Navigator.of(context)
                                  .pushReplacementNamed(HomeScreen.routeName);
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: _util.setWidth(32),
                              right: _util.setWidth(32),
                              top: _util.setHeight(32),
                              bottom: _util.setHeight(32),
                            ),
                            child: Image.asset(
                              ImagePaths.cross,
                              width: _util.setWidth(48),
                              height: _util.setHeight(48),
                              color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: _util.setHeight(32),
              child: _approvalButtons(userProvider),
            )
            // OB24sP6
          ],
        ),
      ),
    );
  }

  _messageRow(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _util.setWidth(48)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Message'.toUpperCase(),
              style: TextStyle(
                  color: ColorConstants.COLOR_NOTIFICATION_SUB_ITEM,
                  fontWeight: FontWeight.w400,
                  fontSize: _util.setSp(42))),
          SizedBox(height: _util.setHeight(32)),
          Text(message,
              style: TextStyle(
                  color: ColorConstants.COLOR_NOTIFICATION_ITEM,
                  fontSize: _util.setSp(42)))
        ],
      ),
    );
  }

  _itemRow(String itemTitle, itemValue) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _util.setWidth(48)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$itemTitle'.toUpperCase(),
              style: TextStyle(
                  color: ColorConstants.COLOR_NOTIFICATION_SUB_ITEM,
                  fontWeight: FontWeight.w400,
                  fontSize: _util.setSp(42))),
          // SizedBox(
          //   height: util.setHeight(32)
          //   ),
          Text(itemValue,
              style: TextStyle(
                  color: ColorConstants.COLOR_NOTIFICATION_ITEM,
                  fontSize: _util.setSp(42)))
        ],
      ),
    );
  }

  _accessRow(accessAsTitle, accessAsValue, accessForTitle, accessForValue) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _util.setWidth(48)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('$accessAsTitle'.toUpperCase(),
                  style: TextStyle(
                      color: ColorConstants.COLOR_NOTIFICATION_SUB_ITEM,
                      fontWeight: FontWeight.w400,
                      fontSize: _util.setSp(42))),
              SizedBox(height: _util.setHeight(32)),
              Text(accessAsValue,
                  style: TextStyle(
                      color: ColorConstants.COLOR_NOTIFICATION_ITEM,
                      fontSize: _util.setSp(42)))
            ],
          ),
          SizedBox(
            width: _util.setWidth(96),
          ),
          Expanded(
            child: getDropdown(ListHelper.getAccessTimeList(),
                _bloc.requestAccessTime, _bloc.requestAccessTimeChanged, false,
                label: 'Access for'),
          )
/*           Text('Access for',
              style: TextStyle(
                  color: ColorConstants.COLOR_NOTIFICATION_ITEM,
                  fontSize: util.setSp(42))) */
        ],
      ),
    );
  }

  _approvalButtons(UserProvider userProvider) {
    // bool isOwner = userProvider.authenticatedUser == null ||
    //     userProvider.authenticatedUser.userID
    //         .contains(widget.accessInvitation.user.id);
    return widget.accessInvitation.status
            .contains(NotificationConstants.initiated)
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                    onPressed: () {
                      _denyRequest(userProvider);
                    },
                    padding: EdgeInsets.only(
                        left: _util.setWidth(64), right: _util.setWidth(64)),
                    child: Text(
                      'DENY',
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            new BorderRadius.circular(_util.setWidth(48)),
                        side: BorderSide(
                          color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                        )),
                    textColor: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                    color: Colors.white //ColorConstants.TOP_CLIPPER_END
                    ),
                RaisedButton(
                    onPressed: () {
                      _acceptRequest(userProvider);
                    },
                    padding: EdgeInsets.only(
                        left: _util.setWidth(64), right: _util.setWidth(64)),
                    child: Text('ACCEPT'),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            new BorderRadius.circular(_util.setWidth(48)),
                        side: BorderSide(
                          color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                        )),
                    textColor: Colors.white,
                    color: ColorConstants.ACCESS_MANAGEMENT_BUTTON)
              ],
            ),
          )
        : Container();
  }

  goBack(UserProvider userProvider) async {
    // Navigator.pop(context);
    if (userProvider.authenticatedUser == null) await userProvider.autoLogin();
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  _acceptRequest(UserProvider userProvider) async {
    userProvider.acceptAccessnvitation(widget.accessInvitation).then((status) {
      if (status.status == 200) {
        userProvider.autoLogin().then((onValue) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        });
      } else {
        // debugPrint('Approve Invitation failed');
        showInfoBar(parseErrorTitle(status.code), status.message, context);
      }
    });
  }

  _denyRequest(UserProvider userProvider) async {
    userProvider.rejectAccessnvitation(widget.accessInvitation).then((status) {
      if (status.status == 200) {
        userProvider.autoLogin().then((onValue) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        });
      } else {
        // debugPrint('Access Invitation reject failed');
        showInfoBar(parseErrorTitle(status.code), status.message, context);
      }
    });
  }
}
