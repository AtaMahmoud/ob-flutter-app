import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/access_request.dart';
import 'package:ocean_builder/core/models/user_ocean_builder.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/screens/notification/guest_request_response_screen.dart';
import 'package:ocean_builder/ui/screens/notification/invitation_response_screen.dart';
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:ocean_builder/ui/widgets/progress_indicator.dart';

class NotificationHistoryScreen extends StatefulWidget {
  static const String routeName = '/notificationhistory';
  final bool showOnlyAccessRequests;

  NotificationHistoryScreen({this.showOnlyAccessRequests = false});

  @override
  _NotificationHistoryScreenState createState() =>
      _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _updatingNotification = false;
  int parseNotificationsCallCout = 0;
  ScreenUtil _util;

  UserProvider _userProvider;
  List<ServerNotification> _notificationList = [];
  int _listLength = 0;
  bool _isLoading = true;

  @override
  void initState() {
    UIHelper.setStatusBarColor(color: Colors.white);
    Future.delayed(Duration.zero).then((_) {
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      _syncNotifications();
    });
    super.initState();
  }

  void _syncNotifications() {
    _userProvider.getNotifications().then((value) {
      _listLength =
          _userProvider?.authenticatedUser?.notifications?.length ?? 0;
      _notificationList = [];

      if (_listLength > 0) {
        _notificationList = new List<ServerNotification>.from(
            _userProvider.authenticatedUser.notifications);

        if (widget.showOnlyAccessRequests) {
          _notificationList.retainWhere((noti) {
            String currentUserID = _userProvider.authenticatedUser.userID;
            return noti.message.compareTo(NotificationConstants.request) == 0 &&
                noti.data.status.contains(NotificationConstants.initiated) &&
                noti.data.user.id.contains(currentUserID);
          });
          _listLength = _notificationList.length;
        }
      }
      MethodHelper.parseNotifications(context);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _updatingNotification = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('building notification list with drawer');
    _util = ScreenUtil();
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
                    _startSpace(),
                    _listLength > 0
                        ? SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              ServerNotification fcmNotification =
                                  _notificationList[index];

                              String notiMsg = fcmNotification.title;
                              String requestStatus =
                                  fcmNotification.data.status;
                              String notificationType = fcmNotification.message;

                              String ownerID =
                                  fcmNotification.data.user != null &&
                                          fcmNotification.data.user.id != null
                                      ? fcmNotification.data.user.id
                                      : 'id';

                              String currentUserID =
                                  _userProvider.authenticatedUser.userID;

                              String oceanBuilderId =
                                  fcmNotification.data.seaPod != null &&
                                          fcmNotification.data.seaPod.id != null
                                      ? fcmNotification.data.seaPod.id
                                      : 'id';

                              String oceanBuilderName =
                                  fcmNotification.data.seaPod != null &&
                                          fcmNotification.data.seaPod.name !=
                                              null
                                      ? fcmNotification.data.seaPod.name
                                      : 'name';
                              List<UserOceanBuilder> uobList =
                                  new List<UserOceanBuilder>.from(_userProvider
                                      .authenticatedUser.userOceanBuilder);
                              bool _isUobExists = false;
                              if (oceanBuilderId != null) {
                                uobList.retainWhere((uob) {
                                  return uob.oceanBuilderId
                                      .contains(oceanBuilderId);
                                });
                                _isUobExists = uobList.length == 1 &&
                                    uobList[0].reqStatus.contains(
                                        NotificationConstants.initiated);
                              }

                              DateTime dateTime =
                                  new DateTime.fromMillisecondsSinceEpoch(
                                      fcmNotification.data.checkIn);
                              String formatedDateTime =
                                  DateFormat('yyyy-MM-dd  HH:mm:ss a')
                                      .format(dateTime);

                              return InkWell(
                                onTap: () async {
                                  //show cancel pop up if not responded yet
                                  if (_isUobExists &&
                                      notificationType.contains(
                                          NotificationConstants.request) &&
                                      requestStatus.contains(
                                          NotificationConstants.initiated) &&
                                      !ownerID.contains(currentUserID)) {
                                    _showCancelAlert(_userProvider,
                                        oceanBuilderId, oceanBuilderName);
                                    MethodHelper.parseNotifications(context);
                                  } else if (notificationType.contains(
                                      NotificationConstants.request)) {
                                    AccessEvent _accessEvent =
                                        new AccessEvent();
                                    _accessEvent.notificationId =
                                        fcmNotification.id;
                                    _accessEvent.id = fcmNotification.data.id;
                                    _accessEvent.reqMessage =
                                        fcmNotification.title;

                                    Navigator.of(
                                            GlobalContext.currentScreenContext)
                                        .pushNamed(
                                            GuestRequestResponseScreen
                                                .routeName,
                                            arguments: _accessEvent);
                                  } else if (notificationType.contains(
                                      NotificationConstants.invitation)) {
                                    AccessEvent _accessEvent =
                                        new AccessEvent();
                                    _accessEvent.notificationId =
                                        fcmNotification.id;
                                    _accessEvent.id = fcmNotification.data.id;
                                    _accessEvent.reqMessage =
                                        fcmNotification.title;

                                    Navigator.of(
                                            GlobalContext.currentScreenContext)
                                        .pushNamed(
                                            InvitationResponseScreen.routeName,
                                            arguments: _accessEvent);
                                  }
                                },
                                child: _notificationItemCard(
                                    formatedDateTime,
                                    context,
                                    fcmNotification,
                                    notiMsg,
                                    notificationType),
                              );
                            }, childCount: _listLength),
                          )
                        : _isLoading
                            ? ProgressIndicatorBoxAdapter()
                            : _textNoNotification(),
                    _endSpace(),
                  ],
                ),
                _topBar()
              ],
            )
            // ),
            ),
      ),
    );
  }

  Container _notificationItemCard(
      String formatedDateTime,
      BuildContext context,
      ServerNotification fcmNotification,
      String notiMsg,
      String notificationType) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _imageSeaPod(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _timeStamp(formatedDateTime),
                          _readStatusBubble(context, fcmNotification),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      _notificationMessage(notiMsg),
                      SizedBox(
                        height: 8,
                      ),
                      _notificationType(notificationType),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _dividerH4()
        ],
      ),
    );
  }

  _readStatusBubble(BuildContext context, ServerNotification fcmNotification) {
    return InkWell(
        onTap: () async {
          if (_updatingNotification) return;
          bool internetStatus = await DataConnectionChecker().hasConnection;
          if (!internetStatus) {
            displayInternetInfoBar(
                context, AppStrings.noInternetConnectionTryAgain);
            return;
          }
          _updatingNotification = true;
          await _userProvider
              .updateNotificationReadStatus(fcmNotification.id)
              .then((value) => _syncNotifications());
        },
        child: ImageIcon(
          AssetImage(fcmNotification.seen != null && fcmNotification.seen
              ? ImagePaths.icRead
              : ImagePaths.icUnread),
          color: _updatingNotification
              ? Colors.grey
              : ColorConstants.COLOR_NOTIFICATION_BUBBLE,
          size: 15.0,
        ));
  }

  _startSpace() => UIHelper.getTopEmptyContainer(_util.setHeight(256), false);

  Text _notificationType(String notificationType) {
    return Text('${notificationType.toUpperCase()}',
        style: TextStyle(color: ColorConstants.COLOR_NOTIFICATION_SUB_ITEM));
  }

  Text _notificationMessage(String notiMsg) {
    return Text(notiMsg.trim(),
        style: TextStyle(color: ColorConstants.COLOR_NOTIFICATION_ITEM));
  }

  Text _timeStamp(String formatedDateTime) {
    return Text('$formatedDateTime',
        style: TextStyle(color: ColorConstants.COLOR_NOTIFICATION_SUB_ITEM));
  }

  Column _imageSeaPod() {
    return Column(
      children: <Widget>[
        SvgPicture.asset(
          ImagePaths.svgSeapod,
          color: ColorConstants.COLOR_NOTIFICATION_NORMAL,
          width: 40,
          height: 40,
        )
      ],
    );
  }

  Divider _dividerH4() {
    return Divider(
      height: 4,
      color: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
    );
  }

  Positioned _topBar() {
    return Positioned(
      top: ScreenUtil.statusBarHeight,
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
                    widget.showOnlyAccessRequests
                        ? AppStrings.pendingRequests
                        : AppStrings.notifications,
                    style: TextStyle(
                      color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                      fontWeight: FontWeight.normal,
                      fontSize: 60.sp,
                    ),
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

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  SliverToBoxAdapter _textNoNotification() {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No notification Found!!',
            style: TextStyle(
                fontSize: 24, color: ColorConstants.COLOR_NOTIFICATION_ITEM),
          ),
        ),
      ),
    );
  }

  goBack() {
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
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
    ServerNotification fcmNotification;
    List<ServerNotification> notifications =
        userProvider.authenticatedUser.notifications;
    int len = userProvider.authenticatedUser.notifications.length;
    for (int i = 0; i < len; i++) {
      ServerNotification noti = notifications[i];

      if (noti.data.seaPod.id != null &&
          noti.data.seaPod.id.contains(oceanBuilderId)) {
        fcmNotification = noti;
        break;
      }
    }
  }
}
