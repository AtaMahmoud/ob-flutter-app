import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/access_request.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/models/user_ocean_builder.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/screens/notification/guest_request_response_screen.dart';
import 'package:ocean_builder/ui/screens/notification/invitation_response_screen.dart';
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class NotificationHistoryScreenWidget extends StatefulWidget {
  static const String routeName = '/notificationhistorywidget';
  final bool showOnlyAccessRequests;
  final bool showOnlyUnreadNotifications;

  NotificationHistoryScreenWidget(
      {this.showOnlyAccessRequests = false,
      this.showOnlyUnreadNotifications = false});

  @override
  _NotificationHistoryScreenWidgetState createState() =>
      _NotificationHistoryScreenWidgetState();
}

class _NotificationHistoryScreenWidgetState
    extends State<NotificationHistoryScreenWidget> {
  bool _updatingNotification = false;
  int parseNotificationsCallCout = 0;

  @override
  void initState() {
    UIHelper.setStatusBarColor(color: Colors.white);
    Future.delayed(Duration.zero).then((_) {
      UserProvider userProvider = Provider.of<UserProvider>(context);
      userProvider.getNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // GlobalContext.currentScreenContext = context;
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    //         if (userProvider.authenticatedUser != null) {
    // userProvider.resetAuthenticatedUser(userProvider.authenticatedUser.userID);
    //     }

    int len = userProvider?.authenticatedUser?.notifications?.length ?? 0;
    List<ServerNotification> notificationList = [];

    if (len > 0) {
      // notificationList =  userProvider.authenticatedUser.notifications.reversed.toList();

      notificationList = new List<ServerNotification>.from(
          userProvider.authenticatedUser.notifications);

      if (widget.showOnlyAccessRequests) {
        notificationList.retainWhere((noti) {
          String currentUserID = userProvider.authenticatedUser.userID;
          return noti.message.compareTo(NotificationConstants.request) == 0 &&
              noti.data.status.compareTo(NotificationConstants.initiated) ==
                  0 &&
              noti.data.user.id.contains(currentUserID);
        });
        len = notificationList.length;
      } else if (widget.showOnlyUnreadNotifications) {
        notificationList.retainWhere((noti) {
          return noti.seen == null || noti.seen == false;
        });
        len = notificationList.length;
      }

      // notificationList = notificationList.reversed.toList();
    }

    // debugPrint('parseNotificationsCallCout $parseNotificationsCallCout');
    if (parseNotificationsCallCout == 0) {
      MethodHelper.parseNotifications(context);
      parseNotificationsCallCout++;
    }

    return Container(
        decoration: BoxDecoration(
            // gradient: profileGradient,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)),
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                _startSpace(),
                len > 0
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          ServerNotification fcmNotification =
                              notificationList[index];

                          String notiMsg = fcmNotification.title;
                          String requestStatus = fcmNotification.data.status;
                          String notificationType = fcmNotification.message;

                          String ownerID = fcmNotification.data.user.id;

                          String currentUserID =
                              userProvider.authenticatedUser.userID;

                          String oceanBuilderId =
                              fcmNotification.data.seaPod.id;

                          String oceanBuilderName =
                              fcmNotification.data.seaPod.name;
                          List<UserOceanBuilder> uobList =
                              new List<UserOceanBuilder>.from(userProvider
                                  .authenticatedUser.userOceanBuilder);
                          bool _isUobExists = false;
                          if (oceanBuilderId != null) {
                            uobList.retainWhere((uob) {
                              return uob.oceanBuilderId
                                  .contains(oceanBuilderId);
                            });
                            _isUobExists = uobList.length == 1 &&
                                uobList[0]
                                    .reqStatus
                                    .contains(NotificationConstants.initiated);
                          }

                          DateTime dateTime =
                              new DateTime.fromMicrosecondsSinceEpoch(
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
                                _showCancelAlert(userProvider, oceanBuilderId,
                                    oceanBuilderName);
                                fcmNotification.seen = true;
                                await userProvider.updateNotificationReadStatus(
                                    fcmNotification.id);
                                // await userProvider.autoLogin();
                                MethodHelper.parseNotifications(context);
                              } else if (notificationType
                                  .contains(NotificationConstants.request)) {
                                fcmNotification.seen = true;
                                debugPrint(
                                    'reqeusting notification seen status --- ${fcmNotification.toJson().toString()}');
                                await userProvider.updateNotificationReadStatus(
                                    fcmNotification.id);
                                // await userProvider.autoLogin();
                                MethodHelper.parseNotifications(context);

                                userProvider
                                    .getAccessRequest(fcmNotification.data.id)
                                    .then((accessRequest) {
                                  if (accessRequest != null) {
                                    accessRequest.reqMessage =
                                        fcmNotification.title;

                                    accessRequest.accesEventType =
                                        'Access Request';
                                    // debugPrint('access request fetched from server -==------------------------------------ ${accessRequest.id}');

                                    Navigator.of(
                                            GlobalContext.currentScreenContext)
                                        .pushNamed(
                                            GuestRequestResponseScreen
                                                .routeName,
                                            arguments: accessRequest);
                                  }
                                });
                              } else if (notificationType
                                  .contains(NotificationConstants.invitation)) {
                                fcmNotification.seen = true;
                                // await userProvider.updateNotificationReadStatus(
                                //     fcmNotification.id);
                                // await userProvider.resetAuthenticatedUser(userProvider.authenticatedUser.userID);
                                //  await userProvider.autoLogin();
                                // MethodHelper.parseNotifications(context);

                                /* userProvider
                                    .getAccessRequest(fcmNotification.data.id)
                                    .then((accessRequest) {
                                  if (accessRequest != null) {
                                    accessRequest.reqMessage =
                                        fcmNotification.title;

                                    accessRequest.accesEventType =
                                        'Access Invitation';

                                    // debugPrint('access request fetched from server -==------------------------------------ ${accessRequest.id}');

                                    Navigator.of(
                                            GlobalContext.currentScreenContext)
                                        .pushNamed(
                                            InvitationResponseScreen.routeName,
                                            arguments: accessRequest);
                                  }
                                }); */

                                AccessEvent _accessEvent = new AccessEvent();
                                _accessEvent.notificationId =
                                    fcmNotification.id;
                                _accessEvent.id = fcmNotification.data.id;
                                _accessEvent.reqMessage = fcmNotification.title;

                                Navigator.of(GlobalContext.currentScreenContext)
                                    .pushNamed(
                                        InvitationResponseScreen.routeName,
                                        arguments: _accessEvent);

                                // Navigator.of(context).pushNamed(
                                //     InvitationResponseScreen.routeName,
                                //     arguments: fcmNotification);

                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8),
                              // decoration: UIHelper.customDecoration(
                              // 2, 12, ColorConstants.TOP_CLIPPER_END.withOpacity(.4),bkgColor: ColorConstants.TOP_CLIPPER_START),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[_imageSeapod()],
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8, bottom: 8),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: _timeStamp(
                                                        formatedDateTime),
                                                  ),
                                                  InkWell(
                                                      onTap: () async {
                                                        if (_updatingNotification)
                                                          return;
                                                        bool internetStatus =
                                                            await DataConnectionChecker()
                                                                .hasConnection;
                                                        if (!internetStatus) {
                                                          displayInternetInfoBar(
                                                              context,
                                                              AppStrings
                                                                  .noInternetConnectionTryAgain);
                                                          return;
                                                        }

                                                        _updatingNotification =
                                                            true;
                                                        // debugPrint(
                                                        // '_updatingNotification -- $_updatingNotification');
                                                        // debugPrint(
                                                        // 'read/unread');
                                                        // await userProvider
                                                        //     .autoLogin();

                                                        await userProvider
                                                            .updateNotificationReadStatus(
                                                                fcmNotification
                                                                    .id);

                                                        MethodHelper
                                                            .parseNotifications(
                                                                context);
                                                        if (mounted) {
                                                          setState(() {
                                                            _updatingNotification =
                                                                false;
                                                            // debugPrint(
                                                            // '_updatingNotification -- $_updatingNotification');
                                                            // debugPrint(
                                                            // 'rebuild noti history widget');
                                                          });
                                                        }
                                                      },
                                                      child: ImageIcon(
                                                        AssetImage(fcmNotification
                                                                        .seen !=
                                                                    null &&
                                                                fcmNotification
                                                                    .seen
                                                            ? ImagePaths.icRead
                                                            : ImagePaths
                                                                .icUnread),
                                                        color: _updatingNotification
                                                            ? Colors.grey
                                                            : ColorConstants
                                                                .COLOR_NOTIFICATION_BUBBLE, //Color(0xFF064390),
                                                        size: 15.0,
                                                      )),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              _notiMesssage(notiMsg),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              _notiType(notificationType),
                                              // Text('Status: $requestStatus'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  _dividerH4()
                                ],
                              ),
                            ),
                          );
                        }, childCount: len),
                      )
                    : _textNoNotification(),
                _endSpace(),
              ],
            ),
            _topBar()
          ],
        )
        // ),
        );
  }

  Positioned _topBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                onTap: () {
                  // debugPrint(
                  // '_updatingNotification -- $_updatingNotification');
                  if (!_updatingNotification) goBack();
                },
                child: Padding(
                  padding: EdgeInsets.all(24.h),
                  child: Image.asset(
                    ImagePaths.cross,
                    width: 48.h,
                    height: 48.h,
                    color: ColorConstants.COLOR_NOTIFICATION_ITEM,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                widget.showOnlyAccessRequests
                    ? AppStrings.pendingRequests
                    : 'Notifications'.toUpperCase(),
                style: TextStyle(
                    color: ColorConstants.COLOR_NOTIFICATION_TITLE,
                    fontWeight: FontWeight.w400,
                    fontSize: ScreenUtil().setSp(60)),
              ),
            ],
          )
        ],
      ),
    );
  }

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  SliverToBoxAdapter _textNoNotification() {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(48.h),
          child: Text(
            'No notification Found!!',
            style: TextStyle(
                fontSize: 48.sp, color: ColorConstants.COLOR_NOTIFICATION_ITEM),
          ),
        ),
      ),
    );
  }

  Divider _dividerH4() {
    return Divider(
      height: 4,
      color: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
    );
  }

  Text _notiType(String notificationType) {
    return Text('SEAPOD ACCESS ${notificationType.toUpperCase()}',
        style: TextStyle(color: ColorConstants.COLOR_NOTIFICATION_SUB_ITEM));
  }

  Text _notiMesssage(String notiMsg) {
    return Text(notiMsg,
        style: TextStyle(color: ColorConstants.COLOR_NOTIFICATION_ITEM));
  }

  Text _timeStamp(String formatedDateTime) {
    return Text('$formatedDateTime',
        style: TextStyle(color: ColorConstants.COLOR_NOTIFICATION_SUB_ITEM));
  }

  SvgPicture _imageSeapod() {
    return SvgPicture.asset(
      ImagePaths.svgSeapod,
      color: ColorConstants.COLOR_NOTIFICATION_NORMAL,
      width: 40,
      height: 40,
    );
  }

  _startSpace() => UIHelper.getTopEmptyContainer(200.h, false);

  goBack() {
    // Navigator.of(context).pushNamedAndRemoveUntil(
    // LandingScreen.routeName, (Route<dynamic> route) => false);
    //  Navigator.of(context).setState((){

    //  });
    // Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
    // UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
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
    // debugPrint('noti to cancel ' + fcmNotification.data.id);
    // User requestedBy =
    //     await userProvider.getAuthUserProfile(fcmNotification.data.user.id);

    // User owner =
    //     await userProvider.getAuthUserProfile(fcmNotification.data.user.id);

    // String notificationId = fcmNotification.data.id;

    // userProvider
    //     .updateNotificationStatus(
    //         notificationId, NotificationConstants.canceled, owner.userID)
    //     .then((onValue) {
    //   userProvider
    //       .deleteOceanBuilderFromUser(
    //           userId: requestedBy.userID,
    //           oceanBuilderId: fcmNotification.data.seaPod.id)
    //       .then((onValue) {
    //     // Navigator.of(context).pushReplacementNamed(OBEventScreen.routeName);
    //     userProvider.autoLogin().then((onValue) {
    //       setState(() {
    //         cancelling = false;
    //         alertButtonText = 'Cancel';
    //        Navigator.of(context, rootNavigator: true).pop();
    //         showInfoBar('Cancel Request', 'Access request canceled', context);
    //       });
    //     });
    //   }
    //   );

    // });
  }
}
