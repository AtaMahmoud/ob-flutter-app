import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/bloc/guest_reqest_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/permission.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/screens/menu/landing_screen.dart';
import 'package:ocean_builder/ui/screens/permission/custom_permission_screen.dart';
import 'package:ocean_builder/ui/shared/drop_downs.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:ocean_builder/core/models/access_request.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GuestRequestResponseScreen extends StatefulWidget {
  static const String routeName = '/guestRequestResponse';

  final AccessEvent accessRequest;

  const GuestRequestResponseScreen({this.accessRequest});

  @override
  _GuestRequestResponseScreenState createState() =>
      _GuestRequestResponseScreenState();
}

class _GuestRequestResponseScreenState
    extends State<GuestRequestResponseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GuestRequestValidationBloc _bloc = GuestRequestValidationBloc();

  String requestAccessTime;

  ScreenUtil _util;

  bool isFromNotificationTray = false;

  String permissionSet;

  bool _isMemberSelected = false;

  bool _isGuestSelected = false;

  @override
  void initState() {
    super.initState();
    Duration d = Duration(milliseconds: widget.accessRequest.period);
    // debugPrint('acces request time in days-- ' + d.inDays.toString());
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
    } else if (d.inDays == 1800) {
      accessFor = 'PERMANENT ACCESS';
    }
    int index = ListHelper.getAccessTimeList().indexOf(accessFor);
    // debugPrint('index   ' + index.toString());
    _bloc.requestAccessTimeChanged(ListHelper.getAccessTimeList()[index]);
    requestAccessTime = accessFor;
    _bloc.requestAccessTimeController.listen((onData) {
      requestAccessTime = onData;
    });
    _bloc.requestAccessAsChanged(widget.accessRequest.type);
    _bloc.requestAccessAsController.listen((onData) {
      if (onData.compareTo(ListHelper.getAccessAsList()[1]) == 0) {
        // _reciever.userType = ListHelper.getAccessAsList()[1];
        // // debugPrint(_user.userType.toString());
        _bloc.permissionChanged(ListHelper.getPermissionList()[4]);

        setState(() {
          if (!_isMemberSelected) _isMemberSelected = true;
          if (_isGuestSelected) _isGuestSelected = false;
        });
      } else if (onData.compareTo(ListHelper.getAccessAsList()[2]) == 0) {
        // _reciever.userType = ListHelper.getAccessAsList()[2];
        // // debugPrint(_user.userType.toString());
        _bloc.permissionChanged(ListHelper.getPermissionList()[3]);

        setState(() {
          if (_isMemberSelected) _isMemberSelected = false;
          if (!_isGuestSelected) _isGuestSelected = true;
          // _reciever.requestAccessTime = ListHelper.getAccessTimeList()[1];
        });
      } else if (onData.compareTo(ListHelper.getAccessAsList()[3]) == 0) {
        _bloc.permissionChanged(ListHelper.getPermissionList()[1]);

        setState(() {
          if (_isMemberSelected) _isMemberSelected = false;
          if (_isGuestSelected) _isGuestSelected = false;
        });
      }
    });

    _bloc.permissionController.listen((onData) {
      permissionSet = onData;
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
          userProvider
              .updateNotificationReadStatus(widget.accessRequest.id)
              .then((onValue) {
            MethodHelper.parseNotifications(context);
          });
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
// SE14606
/*     if (userProvider.authenticatedUser == null)
      userProvider.resetAuthenticatedUser(widget.fcmNotification.data.ownerID); */

//  userProvider.getAuthUserProfile(widget.fcmNotification.data.ownerID).then((onValue){
//      userProvider.authenticatedUser = onValue;
//  });
    _util = ScreenUtil();
    double topClipperRatio =
        Platform.isIOS ? (153.5) / 813 : (153.5 + 16) / 813;
    double height = MediaQuery.of(context).size.height * topClipperRatio;

    String vesselCode = widget.accessRequest.seaPod.vessleCode;

    // String reqMsg = '${widget.accessRequest.user.name} has requested access to your SeaPod ${widget.accessRequest.seaPod.name}(${widget.accessRequest.seaPod.vessleCode}) for ';

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
                        _messageRow(widget.accessRequest.reqMessage),
                        SizedBox(height: _util.setHeight(72)),
                        _itemRow('Email Address',
                            '${widget.accessRequest.user.email}'),
                        SizedBox(height: _util.setHeight(72)),
                        _itemRow('Contact Number',
                            '${widget.accessRequest.user.mobileNumber}'),
                        SizedBox(height: _util.setHeight(72)),
                        _itemRow('SEAPOD NAME /\nVESSEL CODE',
                            '${widget.accessRequest.seaPod.name} /\n ${widget.accessRequest.seaPod.vessleCode}'),
                        SizedBox(height: _util.setHeight(72)),
                        _accessAsRow(),
                        SizedBox(height: _util.setHeight(72)),
                        _accessForRow(
                            'Access From',
                            DateFormat('MM/dd/yyyy').format(
                                DateTime.fromMicrosecondsSinceEpoch(widget
                                    .accessRequest
                                    .checkIn)), //widget.accessRequest.checkIn,
                            ' Access For',
                            'accessForValue'),
                        SizedBox(height: _util.setHeight(72)),
                        _permissionSetRow(),
                        SizedBox(height: 24),
                        _customPermissionsRow(),
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
                                widget.accessRequest.accesEventType,
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
              bottom: _util.setHeight(48),
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
          Text('Message',
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
          Text('$itemTitle',
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

  _accessAsRow() {
    return Stack(
      children: <Widget>[
        getDropdown(ListHelper.getAccessAsList().sublist(1),
            _bloc.requestAccessAs, _bloc.requestAccessAsChanged, true,
            label: 'Access As'),
        _isMemberSelected
            ? Positioned(
                bottom: _util.setHeight(16),
                right: _util.setWidth(96),
                child: Text('Indefinite access to your seapod',
                    style: TextStyle(
                        color: ColorConstants.COLOR_NOTIFICATION_ITEM,
                        fontWeight: FontWeight.w400,
                        fontSize: _util.setSp(42))),
              )
            : Container(),
      ],
    );
  }

  _accessForRow(
      accessFromTitle, accessFromValue, accessForTitle, accessForValue) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _util.setWidth(48)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          !_isGuestSelected
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('$accessFromTitle',
                        style: TextStyle(
                            color: ColorConstants.COLOR_NOTIFICATION_ITEM,
                            fontWeight: FontWeight.w400,
                            fontSize: _util.setSp(42))),
                    SizedBox(width: _util.setWidth(32)),
                    Text(accessFromValue,
                        style: TextStyle(
                            color: ColorConstants.COLOR_NOTIFICATION_ITEM,
                            fontSize: _util.setSp(42)))
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('$accessFromTitle',
                        style: TextStyle(
                            color: ColorConstants.COLOR_NOTIFICATION_ITEM,
                            fontWeight: FontWeight.w400,
                            fontSize: _util.setSp(42))),
                    SizedBox(height: _util.setHeight(32)),
                    Text(accessFromValue,
                        style: TextStyle(
                            color: ColorConstants.COLOR_NOTIFICATION_ITEM,
                            fontSize: _util.setSp(42)))
                  ],
                ),
          SizedBox(
            width: _util.setWidth(200),
          ),
          _isGuestSelected
              ? Expanded(
                  child: getDropdown(
                      ListHelper.getGrantAccessTimeList(),
                      _bloc.requestAccessTime,
                      _bloc.requestAccessTimeChanged,
                      false,
                      label: 'Access for'),
                )
              : Container(),
/*           Text('Access for',
              style: TextStyle(
                  color: ColorConstants.COLOR_NOTIFICATION_ITEM,
                  fontSize: util.setSp(42))) */
        ],
      ),
    );
  }

  _approvalButtons(UserProvider userProvider) {
    bool isOwner = userProvider.authenticatedUser == null ||
        userProvider.authenticatedUser.userID
                .compareTo(widget.accessRequest.user.id) !=
            0;

    return isOwner &&
            widget.accessRequest.status
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
                      _approveRequest(userProvider);
                    },
                    padding: EdgeInsets.only(
                        left: _util.setWidth(64), right: _util.setWidth(64)),
                    child: Text('APPROVE'),
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
/*     if (userProvider.authenticatedUser == null)
      await userProvider
          .resetAuthenticatedUser(widget.fcmNotification.data.ownerID); */
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  _approveRequest(UserProvider userProvider) async {
    String accessRequestId = widget.accessRequest.id;
    String type = widget.accessRequest.type;
    int period = widget.accessRequest.period;

    userProvider
        .acceptAccessReqeust(accessRequestId, type, period)
        .then((status) {
      if (status.status == 200) {
        userProvider.autoLogin().then((onValue) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        });
      } else {
        // debugPrint('Approve request failed');
        showInfoBar(parseErrorTitle(status.code), status.message, context);
      }
    });
  }

  _denyRequest(UserProvider userProvider) async {
    String accessRequestId = widget.accessRequest.id;
    userProvider.rejectAccessReqeust(accessRequestId).then((status) {
      if (status.status == 200) {
        userProvider.autoLogin().then((onValue) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        });
      } else {
        // debugPrint('Access request reject failed');
        showInfoBar(parseErrorTitle(status.code), status.message, context);
      }
    });
  }

  _customPermissionsRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _util.setWidth(48)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              PermissionSet ps = TempPermissionData.permissionSet;
              ps.permissionSetName = permissionSet;
              Navigator.of(context)
                  .pushNamed(CustomPermissionScreen.routeName, arguments: ps);
            },
            child: Row(
              children: <Widget>[
                SvgPicture.asset(ImagePaths.svgEdit),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  'CUSTOM PERMISSIONS',
                  style: TextStyle(
                      fontSize: _util.setSp(48),
                      color: ColorConstants.COLOR_NOTIFICATION_ITEM),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _permissionSetRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _util.setWidth(48)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: getDropdown(ListHelper.getPermissionList(), _bloc.permission,
                _bloc.permissionChanged, false,
                label: 'Permissions'),
          )
        ],
      ),
    );
  }
}
