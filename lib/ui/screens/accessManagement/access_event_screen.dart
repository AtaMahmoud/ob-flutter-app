import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/access_events.dart';
import 'package:ocean_builder/core/models/access_request.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/screens/accessManagement/access_management_screen.dart';
import 'package:ocean_builder/ui/screens/notification/guest_request_response_screen.dart';
import 'package:ocean_builder/ui/screens/notification/invitation_response_screen.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class AccessEventScreen extends StatefulWidget {
  static const String routeName = '/accessEvent';
  final AccessType accessType;
  final AccessEvents accessEvents;

  AccessEventScreen({this.accessType, this.accessEvents});

  @override
  _AccessEventScreenState createState() => _AccessEventScreenState();
}

class _AccessEventScreenState extends State<AccessEventScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _updatingNotification = false;
  int parseNotificationsCallCout = 0;
  ScreenUtil _util;

  AccessEvents _accessEvents;
  int len = 0;
  List<AccessEvent> _accessEventList = [];

  @override
  void initState() {
    UIHelper.setStatusBarColor(color: Colors.white);
    _accessEvents = widget.accessEvents;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // GlobalContext.currentScreenContext = context;
    _util = ScreenUtil();
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    _parseAccessEvents(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: HomeDrawer(
          isSecondLevel: true,
          screenIndex: DrawerIndex.NOTIFICATIONS,
        ),
        drawerScrimColor: AppTheme.drawerScrimColor.withOpacity(.65),
        key: _scaffoldKey,
        body: Container(
            decoration: BoxDecoration(
                // gradient: profileGradient,
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)),
            child: Stack(
              children: <Widget>[
                CustomScrollView(
                  slivers: <Widget>[
                    UIHelper.getTopEmptyContainer(
                        _util.setHeight(256), //ScreenUtil.statusBarHeight * 3,
                        false),
                    len > 0
                        ? _buildAccessEventList(userProvider)
                        : _noEventFound(),
                    UIHelper.getTopEmptyContainer(90, false),
                  ],
                ),
                _titleBar()
              ],
            )
            // ),
            ),
      ),
    );
  }

  Positioned _titleBar() {
    return Positioned(
      top: ScreenUtil().statusBarHeight,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        // padding: EdgeInsets.only(top: 8.0, right: 12.0),
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
                    padding: EdgeInsets.all(32.h),
                    child: ImageIcon(
                      AssetImage(
                        ImagePaths.icHamburger,
                      ),
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
                    () {
                      if (widget.accessType == AccessType.RECEIVED_INVITATION)
                        return AppStrings.receivedInvitations;
                      else if (widget.accessType == AccessType.RECEIVED_REQUEST)
                        return AppStrings.receivedRequests;
                      else if (widget.accessType == AccessType.SENT_INVITATION)
                        return AppStrings.sentInvitations;
                      else if (widget.accessType == AccessType.SENT_REQUEST)
                        return AppStrings.sentRequests;

                      return AppStrings.accessEvent;
                    }(),
                    style: TextStyle(
                        color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                        fontWeight: FontWeight.normal,
                        fontSize: 60.sp),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    if (!_updatingNotification) goBack();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 48.w,
                      top: 32.h,
                      bottom: 32.h,
                    ),
                    child: Image.asset(
                      ImagePaths.cross,
                      width: 48.h,
                      height: 48.h,
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

  SliverToBoxAdapter _noEventFound() {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            () {
              if (widget.accessType == AccessType.RECEIVED_INVITATION)
                return AppStrings.noInvitationFound;
              else if (widget.accessType == AccessType.RECEIVED_REQUEST)
                return AppStrings.noRequestFound;
              else if (widget.accessType == AccessType.SENT_INVITATION)
                return AppStrings.noInvitationFound;
              else if (widget.accessType == AccessType.SENT_REQUEST)
                return AppStrings.noRequestFound;

              return AppStrings.accessEvent;
            }(),
            style: TextStyle(
                fontSize: 24, color: ColorConstants.COLOR_NOTIFICATION_ITEM),
          ),
        ),
      ),
    );
  }

  SliverList _buildAccessEventList(UserProvider userProvider) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        AccessEvent accessEvent = _accessEventList[index];
        String oceanBuilderId = accessEvent.seaPod.id;
        String oceanBuilderName = accessEvent.seaPod.name;
        DateTime dateTime =
            new DateTime.fromMillisecondsSinceEpoch(accessEvent.checkIn);
        String formatedDateTime =
            DateFormat('yyyy-MM-dd  HH:mm:ss a').format(dateTime);

        return InkWell(
          onTap: () async {
            if ( //_isUobExists &&
                accessEvent.accesEventType.contains(
                        describeEnum(AccessType.SENT_REQUEST)
                            .replaceAll('_', ' ')) &&
                    accessEvent.status
                        .contains(NotificationConstants.pending)) {
              _showCancelAlert(userProvider, oceanBuilderId, oceanBuilderName);
              MethodHelper.parseNotifications(context);
            } else if (accessEvent.accesEventType.contains(
                describeEnum(AccessType.RECEIVED_REQUEST)
                    .replaceAll('_', ' '))) {
              print(accessEvent.accesEventType);
              MethodHelper.parseNotifications(context);

              Navigator.of(context).pushNamed(
                  GuestRequestResponseScreen.routeName,
                  arguments: accessEvent);
            } else if (accessEvent.accesEventType.contains(
                describeEnum(AccessType.RECEIVED_INVITATION)
                    .replaceAll('_', ' '))) {
              MethodHelper.parseNotifications(context);

              Navigator.of(context).pushNamed(
                  InvitationResponseScreen.routeName,
                  arguments: accessEvent);
            } else if (accessEvent.accesEventType.contains(
                describeEnum(AccessType.SENT_INVITATION)
                    .replaceAll('_', ' '))) {
              _showCancelAlert(userProvider, oceanBuilderId, oceanBuilderName);

              MethodHelper.parseNotifications(context);
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            // decoration: UIHelper.customDecoration(
            // 2, 12, ColorConstants.TOP_CLIPPER_END.withOpacity(.4),bkgColor: ColorConstants.TOP_CLIPPER_START),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          ImagePaths.svgSeapod,
                          color: ColorConstants.COLOR_NOTIFICATION_NORMAL,
                          width: 40,
                          height: 40,
                        )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('$formatedDateTime',
                                    style: TextStyle(
                                        color: ColorConstants
                                            .COLOR_NOTIFICATION_SUB_ITEM)),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(accessEvent.reqMessage.trim(),
                                style: TextStyle(
                                    color: ColorConstants
                                        .COLOR_NOTIFICATION_ITEM)),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                                '${accessEvent.accesEventType.replaceAll('_', ' ').toUpperCase()}',
                                style: TextStyle(
                                    color: ColorConstants
                                        .COLOR_NOTIFICATION_SUB_ITEM)),
                            // Text('Status: $requestStatus'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 4,
                  color: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
                )
              ],
            ),
          ),
        );
      }, childCount: len),
    );
  }

  void _parseAccessEvents(BuildContext context) {
    if (widget.accessType == AccessType.RECEIVED_INVITATION &&
        _accessEvents != null &&
        _accessEvents.receivedInvitations != null) {
      _accessEventList =
          new List<AccessEvent>.from(_accessEvents.receivedInvitations);

      len = _accessEventList.length ?? 0;

      _accessEventList.retainWhere((event) {
        event.accesEventType =
            describeEnum(AccessType.RECEIVED_INVITATION).replaceAll('_', ' ');
        event.reqMessage =
            '${event.user.name.toUpperCase()} has invited you to access SeaPod ${event.seaPod.name.toUpperCase()} ( ${event.seaPod.vessleCode} ) for ${Duration(milliseconds: event.period).inDays.toString().toLowerCase()} starting on ${DateFormat('yMMMMd').format(DateTime.fromMillisecondsSinceEpoch(event.checkIn))}';
        return true;
      });
      len = _accessEventList.length;
      debugPrint('RECEIVED_INVITATION count -- $len');
    } else if (widget.accessType == AccessType.SENT_INVITATION &&
        _accessEvents != null &&
        _accessEvents.sentInvitations != null) {
      _accessEventList =
          new List<AccessEvent>.from(_accessEvents.sentInvitations);

      len = _accessEvents.sentInvitations?.length ?? 0;

      _accessEventList.retainWhere((event) {
        event.accesEventType =
            describeEnum(AccessType.SENT_INVITATION).replaceAll('_', ' ');
        event.reqMessage =
            'You sent SeaPod access invitation to ${event.user.name.toUpperCase()} to access SeaPod ${event.seaPod.name.toUpperCase()} ( ${event.seaPod.vessleCode} ) for ${Duration(milliseconds: event.period).inDays.toString().toLowerCase()} starting on ${DateFormat('yMMMMd').format(DateTime.fromMillisecondsSinceEpoch(event.checkIn))}';
        return true;
      });
      len = _accessEventList.length;
      debugPrint('SENT_INVITATION count -- $len');
    } else if (widget.accessType == AccessType.RECEIVED_REQUEST &&
        _accessEvents != null &&
        _accessEvents.receivedRequests != null) {
      _accessEventList =
          new List<AccessEvent>.from(_accessEvents.receivedRequests);

      len = _accessEvents.receivedRequests?.length ?? 0;

      _accessEventList.retainWhere((event) {
        event.accesEventType =
            describeEnum(AccessType.RECEIVED_REQUEST).replaceAll('_', ' ');

        event.reqMessage =
            '${event.user.name.toUpperCase()} has requested access to your SeaPod ${event.seaPod.name.toUpperCase()} ( ${event.seaPod.vessleCode} ) for ${Duration(milliseconds: event.period).inDays.toString().toLowerCase()} starting on ${DateFormat('yMMMMd').format(DateTime.fromMillisecondsSinceEpoch(event.checkIn))}';
        return true;
      });
      len = _accessEventList.length;
      debugPrint('RECEIVED_REQUEST count -- $len');
    } else if (widget.accessType == AccessType.SENT_REQUEST &&
        _accessEvents != null &&
        _accessEvents.sentRequests != null) {
      _accessEventList = new List<AccessEvent>.from(_accessEvents.sentRequests);

      len = _accessEvents.sentRequests?.length ?? 0;

      _accessEventList.retainWhere((event) {
        event.accesEventType =
            describeEnum(AccessType.SENT_REQUEST).replaceAll('_', ' ');
        event.reqMessage =
            'You sent SeaPod access request to owner of SeaPod ${event.seaPod.name.toUpperCase()} ( ${event.seaPod.vessleCode} ) for ${Duration(milliseconds: event.period).inDays.toString().toLowerCase()} days starting on ${DateFormat('yMMMMd').format(DateTime.fromMillisecondsSinceEpoch(event.checkIn))}';
        // '${event.user.name.toUpperCase()} has requested access to your SeaPod ${event.seaPod.name.toUpperCase()} ( ${event.seaPod.vessleCode} ) for ${Duration(milliseconds: event.period).inDays.toString().toLowerCase()} starting on ${DateFormat('yMMMMd').format(DateTime.fromMillisecondsSinceEpoch(event.checkIn))}';
        return true;
      });
      len = _accessEventList.length;
      debugPrint('SENT_REQUEST count -- $len');
    }

    // _accessEventList = _accessEventList.reversed.toList();

    // debugPrint('parseNotificationsCallCout $parseNotificationsCallCout');
    if (parseNotificationsCallCout == 0) {
      MethodHelper.parseNotifications(context);
      parseNotificationsCallCout++;
    }
  }

  goBack() {
    Navigator.of(context).pop();
  }

  goNext() {
    // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  UserProvider _cancelUserProvider;
  String _cancelUserOceanBuilderId;
  String alertButtonText = 'Cancel';
  bool cancelling = false;

// show cancel alert
  _showCancelAlert(UserProvider userProvider, String oceanBuilderId,
      String oceanBuilderName) {
    // Navigator.of(context).pushReplacementNamed(PendingOBScreen.routeName,arguments: userOceanBuilder);
    // _showCancelAlert(userOceanBuilder);
    _cancelUserProvider = userProvider;
    _cancelUserOceanBuilderId = oceanBuilderId;

    String vesselCode = MethodHelper.getVesselCode(oceanBuilderId);
    showAlertWithOneButton(
        title: "CANCEL ACCESS REQUEST",
        desc:
            "Do you want to cancel access request of $oceanBuilderName\n (VesselCode: $vesselCode) ?",
        buttonText: alertButtonText,
        buttonCallback: cancelCallback,
        context: context);
  }

  cancelCallback() {
    if (!cancelling)
      _cancelRequest(_cancelUserProvider, _cancelUserOceanBuilderId);
  }

  _cancelRequest(UserProvider userProvider, String oceanBuilderId) async {
    setState(() {
      cancelling = true;
      alertButtonText = 'Cancelling';
    });
    ServerNotification accessEvent;
    List<ServerNotification> notifications =
        userProvider.authenticatedUser.notifications;
    int len = userProvider.authenticatedUser.notifications.length;
    for (int i = 0; i < len; i++) {
      ServerNotification noti = notifications[i];

      if (noti.data.seaPod.id != null &&
          noti.data.seaPod.id.contains(oceanBuilderId)) {
        accessEvent = noti;
        break;
      }
    }
  }
}
