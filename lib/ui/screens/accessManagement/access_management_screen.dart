import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/bloc/grant_access_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/access_events.dart';
import 'package:ocean_builder/core/models/access_request.dart';
import 'package:ocean_builder/core/models/ocean_builder_user.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/models/user_ocean_builder.dart';
import 'package:ocean_builder/core/providers/local_noti_data_provider.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/ui/screens/accessManagement/access_event_screen.dart';
import 'package:ocean_builder/ui/screens/accessManagement/admin_access_screen.dart';
import 'package:ocean_builder/ui/screens/accessManagement/grant_access_screen.dart';
import 'package:ocean_builder/ui/screens/accessManagement/guest_access_screen.dart';
import 'package:ocean_builder/ui/screens/accessManagement/visitor_access_screen.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/screens/permission/manage_permission_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/request_access_screen.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ocean_builder/helper/string_apis.dart';
import 'dart:math' as math;

class AccessManagementScreen extends StatefulWidget {
  static const String routeName = '/accessManagement';

  @override
  _AccessManagementScreenState createState() => _AccessManagementScreenState();
}

enum AccessType {
  SENT_INVITATION,
  SENT_REQUEST,
  RECEIVED_REQUEST,
  RECEIVED_INVITATION
}

class AccessEventsScreenParams {
  final AccessType accessType;
  final AccessEvents accessEvents;

  AccessEventsScreenParams(this.accessType, this.accessEvents);
}

class _AccessManagementScreenState extends State<AccessManagementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GrantAccessValidationBloc _bloc = GrantAccessValidationBloc();
  User _user;
  User _invitedUser = new User();

  TextEditingController _firstNameController;
  TextEditingController _emailController;

  bool _isMemberSelected = false;

  ScreenUtil _util;

  OceanBuilderProvider _oceanBuilderProvider;

  Future<AccessEvents> _accessEventsFuture;

  @override
  void initState() {
    UIHelper.setStatusBarColor(color: AppTheme.nearlyWhite);
    // Future.delayed(Duration.zero).then((_) {
    //   _accessEventsFuture =
    //       Provider.of<UserProvider>(context).getAccessEvents();
    // });
    super.initState();
    _firstNameController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _setUserDataListener();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  _setUserDataListener() {
    _bloc.firstNameController.listen((onData) {
      _invitedUser.firstName = onData;
    });

    _bloc.emailController.listen((onData) {
      _invitedUser.email = onData;
    });

    //-----
    _bloc.requestAccessAsController.listen((onData) {
      if (onData.compareTo(ListHelper.getAccessAsList()[1]) == 0) {
        _invitedUser.userType = ListHelper.getAccessAsList()[1];
        // // debugPrint(_user.userType.toString());

        if (!_isMemberSelected)
          setState(() {
            _isMemberSelected = true;
            _invitedUser.requestAccessTime = ListHelper.getAccessTimeList()[9];
          });
      } else if (onData.compareTo(ListHelper.getAccessAsList()[2]) == 0) {
        _invitedUser.userType = ListHelper.getAccessAsList()[2];
        // // debugPrint(_user.userType.toString());

        if (_isMemberSelected)
          setState(() {
            _isMemberSelected = false;
          });
      }
    });
    _bloc.requestAccessTimeController.listen((onData) {
      _invitedUser.requestAccessTime = onData;
    });

    //-----
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    _oceanBuilderProvider = Provider.of<OceanBuilderProvider>(context);

    final UserProvider userProvider = Provider.of<UserProvider>(context);
    _accessEventsFuture = userProvider.getAccessEvents();
/*     if (userProvider.authenticatedUser != null) {
      userProvider
          .resetAuthenticatedUser(userProvider.authenticatedUser.userID);
    } */

    _user = userProvider.authenticatedUser;
    _util = ScreenUtil();
    return _mainContent();
  }

  _mainContent() {
    List<Widget> slivers = new List<Widget>();
    slivers.add(UIHelper.defaultSliverAppbar(_scaffoldKey, goBack,
        screnTitle: ScreenTitle.ACCESS_MANAGEMENT));
    slivers.add(_accessControlWidgets());
    slivers.addAll(_accessorList());

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: HomeDrawer(
          isSecondLevel: true,
          screenIndex: DrawerIndex.ACCESS_MANAGEMENT,
        ),
        drawerScrimColor: AppTheme.drawerScrimColor.withOpacity(.65),
        body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(8)
            ),
            child: CustomScrollView(
              slivers: slivers,
            )),
      ),
    );
  }

  _accessControlWidgets() {
    AccessEvents _accessEvents = AccessEvents();
    return FutureBuilder(
        future: _accessEventsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _accessEvents = snapshot.data;
          }

          return SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 48.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _sentInvitations(_accessEvents, context),
                  SpaceH32(),
                  _receivedInvitaitons(_accessEvents, context),
                  SpaceH32(),
                  _sentRequests(_accessEvents, context),
                  SpaceH32(),
                  _receivedRequests(_accessEvents, context),
                  SpaceH32(),
                  _accessButtons(context),
                  SpaceH32(),
                  _managePermissionsButton(context)
                ],
              ),
            ),
          );
        });
  }

  Row _managePermissionsButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(ManagePermissionScreen.routeName);
          },
          child: Container(
            // height: h,
            width: MediaQuery.of(context).size.width - 72.w,
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(72.w),
                color: ColorConstants.TOP_CLIPPER_END_DARK),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'MANAGE PERMISSIONS',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 36.sp),
                ),
              ],
            )),
          ),
        )
      ],
    );
  }

  Row _accessButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(RequestAccessScreen.routeName);
          },
          child: Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(72.w),
                color: ColorConstants.TOP_CLIPPER_END_DARK),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  ImagePaths.svgPlus,
                  color: Colors.white,
                  height: 48.h,
                  width: 48.h,
                ),
                SizedBox(
                  width: 16.w,
                ),
                Text(
                  'REQUEST ACCESS',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 36.sp),
                ),
              ],
            )),
          ),
        ),
        InkWell(
          onTap: () {
            if (_user.userOceanBuilder.length > 0) {
              showGrantAccessPopup(context, GrantAccessScreenWidget(), " ");
            }
          },
          child: Container(
            // height: h,
            // width: MediaQuery.of(context).size.width * .4,
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(72.w),
                color: ColorConstants.TOP_CLIPPER_END_DARK),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  ImagePaths.svgPlus,
                  color: Colors.white,
                  height: 48.h,
                  width: 48.h,
                ),
                SizedBox(
                  width: 16.w,
                ),
                Text(
                  'GRANT ACCESS',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 36.sp),
                ),
              ],
            )),
          ),
        ),
      ],
    );
  }

  InkWell _receivedRequests(AccessEvents _accessEvents, BuildContext context) {
    return InkWell(
      onTap: () {
        AccessEventsScreenParams accessEventsScreenParams =
            AccessEventsScreenParams(
                AccessType.RECEIVED_REQUEST, _accessEvents);
        Navigator.of(context).pushNamed(AccessEventScreen.routeName,
            arguments: accessEventsScreenParams);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.w),
          color: ColorConstants.COLOR_PENDING_REQUEST,
        ),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(
          32.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 96.w),
            SvgPicture.asset(
              ImagePaths.svgRequsetReceived,
              width: 80.w,
              height: 80.w,
            ),
            SizedBox(width: 32.w),
            _pendingRequestConsumer(
                AccessType.RECEIVED_REQUEST,
                _accessEvents.receivedRequests != null
                    ? _accessEvents.receivedRequests.length
                    : 0),
          ],
        ),
      ),
    );
  }

  InkWell _sentRequests(AccessEvents _accessEvents, BuildContext context) {
    return InkWell(
      onTap: () {
        AccessEventsScreenParams accessEventsScreenParams =
            AccessEventsScreenParams(AccessType.SENT_REQUEST, _accessEvents);
        Navigator.of(context).pushNamed(AccessEventScreen.routeName,
            arguments: accessEventsScreenParams);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.w),
          color: ColorConstants.COLOR_PENDING_REQUEST,
        ),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(
          _util.setWidth(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 96.w),
            SvgPicture.asset(
              ImagePaths.svgRequestSent,
              width: 80.w,
              height: 80.w,
            ),
            SizedBox(width: 32.w),
            _pendingRequestConsumer(
                AccessType.SENT_REQUEST,
                _accessEvents.sentRequests != null
                    ? _accessEvents.sentRequests.length
                    : 0),
          ],
        ),
      ),
    );
  }

  InkWell _receivedInvitaitons(
      AccessEvents _accessEvents, BuildContext context) {
    return InkWell(
      onTap: () {
        AccessEventsScreenParams accessEventsScreenParams =
            AccessEventsScreenParams(
                AccessType.RECEIVED_INVITATION, _accessEvents);
        Navigator.of(context).pushNamed(AccessEventScreen.routeName,
            arguments: accessEventsScreenParams);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.w),
          color: ColorConstants.COLOR_PENDING_REQUEST,
        ),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(
          _util.setWidth(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: ScreenUtil().setWidth(96)),
            SvgPicture.asset(
              ImagePaths.svgInvitationReceived,
              width: ScreenUtil().setWidth(80),
              height: ScreenUtil().setWidth(80),
            ),
            SizedBox(width: ScreenUtil().setWidth(32)),
            _pendingRequestConsumer(
                AccessType.RECEIVED_INVITATION,
                _accessEvents.receivedInvitations != null
                    ? _accessEvents.receivedInvitations.length
                    : 0),
          ],
        ),
      ),
    );
  }

  InkWell _sentInvitations(AccessEvents _accessEvents, BuildContext context) {
    return InkWell(
      onTap: () {
        AccessEventsScreenParams accessEventsScreenParams =
            AccessEventsScreenParams(AccessType.SENT_INVITATION, _accessEvents);
        Navigator.of(context).pushNamed(AccessEventScreen.routeName,
            arguments: accessEventsScreenParams);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.w),
          color: ColorConstants.COLOR_PENDING_REQUEST,
        ),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(
          _util.setWidth(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: ScreenUtil().setWidth(96)),
            SvgPicture.asset(
              ImagePaths.svgInvitationSent,
              width: ScreenUtil().setWidth(80),
              height: ScreenUtil().setWidth(80),
            ),
            SizedBox(width: ScreenUtil().setWidth(32)),
            _pendingRequestConsumer(
                AccessType.SENT_INVITATION,
                _accessEvents.sentInvitations != null
                    ? _accessEvents.sentInvitations.length
                    : 0),
          ],
        ),
      ),
    );
  }

  Widget _pendingRequestConsumer(AccessType accessType, int accessEventCount) {
    String accessTypString;
    if (accessType == AccessType.SENT_INVITATION) {
      accessTypString = '${AppStrings.sentInvitations}      ';
    } else if (accessType == AccessType.SENT_REQUEST) {
      accessTypString = '${AppStrings.sentRequests}        ';
    } else if (accessType == AccessType.RECEIVED_INVITATION) {
      accessTypString = AppStrings.receivedInvitations;
    } else if (accessType == AccessType.RECEIVED_REQUEST) {
      accessTypString = '${AppStrings.receivedRequests} ';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$accessTypString (${accessEventCount != null ? accessEventCount : 0})',
          style: new TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: ScreenUtil().setSp(38),
            color: ColorConstants.TEXT_COLOR,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  _accessorList() {
    List<UserOceanBuilder> ownerObList = [];
    _user.userOceanBuilder.map((f) {
      if (f.userType.toLowerCase().compareTo('owner') == 0) ownerObList.add(f);
    }).toList();

    int count = ownerObList.length;
    return List.generate(count, (sliverIndex) {
      // sliverIndex += firstIndex;
      UserOceanBuilder ob = ownerObList[sliverIndex];
      return new SliverStickyHeader(
          header: _buildHeader(sliverIndex,
              text: 'ACCESS TO ${ob.oceanBuilderName.toUpperCase()}'),
          sliver: ObAccessorListWidget(
            obId: ob.oceanBuilderId,
          ));
    });
  }

  showPendingRequestListPopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 12,
        left: 12,
        right: 12,
        bottom: 12,
        child: widget,
      ),
    );
  }

  showGrantAccessPopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 32.h,
        left: 48.w,
        right: 48.w,
        bottom: 32.h,
        child: widget,
      ),
    );
  }

  goBack() {
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
    Navigator.of(context).pop();
  }

  goNext() {
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  List<Widget> _buildLists(BuildContext context, int firstIndex, int count) {
    return List.generate(count, (sliverIndex) {
      sliverIndex += firstIndex;
      return new SliverStickyHeader(
        header: _buildHeader(sliverIndex),
        sliver: new SliverList(
          delegate: new SliverChildBuilderDelegate(
            (context, i) => new ListTile(
              leading: new CircleAvatar(
                child: new Text('$sliverIndex'),
              ),
              title: new Text('List tile #$i'),
            ),
            childCount: 4,
          ),
        ),
      );
    });
  }

  Widget _buildHeader(int index, {String text}) {
    return new Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 128.h, left: 32.w, right: 32.w),
      alignment: Alignment.centerLeft,
      child: new Text(
        text ?? 'Header #$index',
        style: TextStyle(
            fontSize: _util.setSp(48),
            color: ColorConstants.ACCESS_MANAGEMENT_LIST_TITLE),
      ),
    );
  }
}

class ObAccessorListWidget extends StatefulWidget {
  final String obId;
  ObAccessorListWidget({Key key, this.obId}) : super(key: key);

  @override
  _ObAccessorListWidgetState createState() => _ObAccessorListWidgetState();
}

class _ObAccessorListWidgetState extends State<ObAccessorListWidget> {
  Future<SeaPod> _oceanBuildeFuture;
  OceanBuilderProvider _oceanBuilderProvider;

  UserProvider _userProvider;

  @override
  Widget build(BuildContext context) {
    _oceanBuilderProvider = Provider.of<OceanBuilderProvider>(context);
    _userProvider = Provider.of<UserProvider>(context);

    _oceanBuildeFuture =
        _oceanBuilderProvider.getSeaPod(widget.obId, _userProvider);

    return _accessorItemsFuture();
  }

  _accessorItemsFuture() {
    return FutureBuilder<SeaPod>(
        future: _oceanBuildeFuture,
        builder: (context, snapshot) {
          // if (snapshot.hasData)
          // debugPrint('FutureBuilder<SeaPod> -- ${snapshot.data.obName}');
          // else
          // debugPrint('FutureBuilder<SeaPod> -- ${snapshot.hasData}');
          return snapshot.hasData
              ? _obUserListWidget(snapshot.data)
              :
              // CircularProgressIndicator();
              SliverList(
                  delegate: new SliverChildBuilderDelegate(
                    (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 32.h,
                        ),
                        child: Text(
                          'Loading ...',
                          style: TextStyle(
                              fontSize: 24.sp,
                              color:
                                  ColorConstants.ACCESS_MANAGEMENT_LIST_TITLE),
                        ),
                      );
                    },
                    childCount: 1,
                  ),
                );
        });
  }

  _obUserListWidget(SeaPod ob) {
    // debugPrint('oceanbuilder ------ -- ${ob.obName}');
    return new SliverList(
      delegate: new SliverChildBuilderDelegate(
        (context, index) {
          int itemIndex = index ~/ 2;
          if (index.isEven) {
            OceanBuilderUser obUser;
            if (itemIndex == 0) {
              obUser = OceanBuilderUser();
              obUser.userName = 'Ocean Builders Team';
              obUser.userType = 'Administration';
            } else {
              itemIndex = itemIndex - 1;
              obUser = ob.users[itemIndex];
            }

            return InkWell(
              onTap: () {
                if (obUser.userType.toLowerCase().compareTo('guest') == 0) {
                  Navigator.of(context).pushNamed(GuestAccessScreen.routeName,
                      arguments: obUser);
                } else if (obUser.userType
                        .toLowerCase()
                        .compareTo('administration') ==
                    0) {
                  Navigator.of(context).pushNamed(AdminAccessScreen.routeName,
                      arguments: obUser);
                } else {
                  Navigator.of(context).pushNamed(VisitorAccessScreen.routeName,
                      arguments: obUser);
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 32.w,
                  vertical: 32.h,
                ),
                child: _accesorItem(obUser, ob),
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 32.w,
            ),
            child: Divider(
              height: 0,
              color: ColorConstants.WEATHER_BKG_CIRCLE,
              thickness: 1,
            ),
          );
        },
        semanticIndexCallback: (widget, localIndex) {
          if (localIndex.isEven) {
            return localIndex ~/ 2;
          }
          return null;
        },
        childCount:
            math.max(0, (ob.users.length + 1) * 2), //ob.users.length + 1,
      ),
    );
  }

  _accesorItem(OceanBuilderUser ob, SeaPod oceanBuilder) {
    debugPrint(
        'oceanbuilderuser item -- ${ob.toJson()} -- oceanbuilder name --- ${oceanBuilder.obName}------Logged in user --- ${_userProvider.authenticatedUser.userID}');

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  _createAvatar(context),
                  SizedBox(
                    width: 8.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        ob.userName.toUpperCase(),
                        style: TextStyle(
                            fontSize: 32.sp,
                            color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      _typeAndTimeWidget(ob),
                      _permissionWidget(ob),
                      SizedBox(
                        height: 16.h,
                      ),
                    ],
                  ),
                ],
              ),
              (ob.userId != null &&
                          ob.userId.compareTo(
                                  _userProvider.authenticatedUser.userID) ==
                              0) ||
                      ob.userType.toLowerCase().contains('owner') ||
                      ob.userType.toLowerCase().contains('administration')
                  ? Container()
                  : UIHelper.getButton(
                      'REMOVE',
                      () {
                        _showDeleteAccessDialog(ob, oceanBuilder,
                            cancelInvitaion: false);
                      },
                      w: 250.w,
                      h: 200.h,
                      fontSize: 32.sp,
                      borderRadius: 24,
                    )
            ],
          ),
        ],
      ),
    );
  }

  _permissionWidget(OceanBuilderUser uob) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          ImagePaths.svgIcLock,
          fit: BoxFit.fill,
          color: ColorConstants.WEATHER_BKG_CIRCLE,
        ),
        SizedBox(
          width: 16.w,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: Text(
            'Full Permissions',
            style: TextStyle(
                fontSize: 32.sp,
                color: ColorConstants.ACCESS_MANAGEMENT_SUBTITLE),
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }

  _typeAndTimeWidget(OceanBuilderUser uob) {
    String timeText = '';
    if (!uob.userType.toLowerCase().contains('guest')) {
      return Text(
        '${uob.userType.capitalize()}',
        style: TextStyle(
            fontSize: 32.sp, color: ColorConstants.ACCESS_MANAGEMENT_SUBTITLE),
      );
    } else if (uob.userType.toLowerCase().contains('guest') &&
        uob.checkInDate != null) {
      DateTime now = DateTime.now();
      DateTime checkInDate = uob.checkInDate;
      DateTime checkOutDate = checkInDate.add(uob.accessTime);
      Duration remainingDays = checkOutDate.difference(now);
      // Check in Date
      // N days remaining.
      if (uob.checkInDate.isAfter(DateTime.now())) {
        timeText =
            '${uob.userType.capitalize()} - Expires in ${remainingDays.inDays} days';
      } else {
        timeText =
            '${uob.userType.capitalize()} - Check in ${DateFormat('yMMMMd').format(checkInDate)}';
      }
      return Wrap(
        children: <Widget>[
          Text(
            timeText,
            style: TextStyle(
                fontSize: 32.sp,
                color: ColorConstants.ACCESS_MANAGEMENT_SUBTITLE),
            overflow: TextOverflow.clip,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _createAvatar(BuildContext context, {File imageFile}) {
    return CircleAvatar(
      backgroundColor: ColorConstants.COLOR_PENDING_REQUEST,
      radius: 80.w,
      child: CircleAvatar(
        backgroundColor: ColorConstants.COLOR_PENDING_REQUEST,
        radius: imageFile != null ? 60.w : 40.w,
        backgroundImage: imageFile != null
            ? FileImage(
                imageFile,
              )
            : AssetImage(
                ImagePaths.icAvatar,
              ),
      ),
    );
  }

  _showDeleteAccessDialog(OceanBuilderUser ob, SeaPod oceanBuilder,
      {bool cancelInvitaion}) async {
    var alertStyle = AlertStyle(
      isCloseButton: false,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(
          color: ColorConstants.TOP_CLIPPER_START,
          fontWeight: FontWeight.normal,
          fontSize: 2),
    );
    Alert(
        context: context,
        title: '', //'Grant new access',
        style: alertStyle,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // SizedBox(
            //   height: 16.0,
            // ),
            Container(
              margin: EdgeInsets.only(
                bottom: 32.h,
              ),
              child: Text(
                cancelInvitaion ? 'Cancel Invitation' : 'Delete access',
                style: TextStyle(
                    color: ColorConstants.COLOR_NOTIFICATION_TITLE,
                    fontWeight: FontWeight.w400,
                    fontSize: 60.sp),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: 256.h,
                // top: _util.setHeight(64)
              ),
              child: Text(
                cancelInvitaion
                    ? 'Do you really want to cancel access invitaion to user ${ob.userName}?'
                    : 'Do you really want to remove access to user ${ob.userName}?',
                style: TextStyle(
                    color: ColorConstants.ACCESS_MANAGEMENT_SUBTITLE,
                    fontWeight: FontWeight.w400,
                    fontSize: 48.sp),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(
                        'CANCEL',
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(48.w),
                          side: BorderSide(
                            color:
                                ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                          )),
                      textColor: Colors.white,
                      color: ColorConstants
                          .ACCESS_MANAGEMENT_BUTTON //ColorConstants.TOP_CLIPPER_END
                      ),
                ),
                SizedBox(
                  width: 24.w,
                ),
                Expanded(
                  child: RaisedButton(
                      onPressed: () {
                        if (cancelInvitaion == true) {
                          _cancelInvitaion(ob, oceanBuilder);
                        } else {
                          _removeAccess(ob, oceanBuilder);
                        }
                      },
                      child: Text('CONFIRM'),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(48.w),
                          side: BorderSide(
                            color:
                                ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                          )),
                      textColor: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                      color: Colors.white),
                )
              ],
            )
          ],
        ),
        buttons: []).show();
  }

  Widget _horizontalLine() {
    return SvgPicture.asset(
      ImagePaths.svgWeatherInfoDividerLine,
      fit: BoxFit.fitWidth,
      color: ColorConstants.WEATHER_BKG_CIRCLE,
      width: MediaQuery.of(context).size.width * .95,
    );
  }

  Future<void> _cancelInvitaion(OceanBuilderUser ob, SeaPod seaPod) async {
    ServerNotification fcmNotification;
    List<ServerNotification> notifications =
        _userProvider.authenticatedUser.notifications;
    int len = _userProvider.authenticatedUser.notifications.length;
    for (int i = 0; i < len; i++) {
      ServerNotification noti = notifications[i];
      if (noti.data.seaPod.id != null &&
          noti.data.seaPod.id.contains(seaPod.id) &&
          noti.data.status.compareTo(NotificationConstants.initiated) == 0) {
        fcmNotification = noti;
        break;
      }
    }
  }

  Future<void> _removeAccess(OceanBuilderUser ob, SeaPod oceanBuilder) async {
    // debugPrint(
    // '_remove Access_------------______________-----------__________-----------');

    String seaPodId = oceanBuilder.id;
    String userId = ob.userId;

    _userProvider
        .removeMemberFromSeapod(seaPodId, userId)
        .then((responseStatus) {
      if (responseStatus.status == 200) {
        _userProvider.autoLogin().then((onValue) {
          Navigator.of(context, rootNavigator: true).pop();
          // debugPrint('----- remove user from seapod');
          if (this.mounted) {
            showInfoBarWithDissmissCallback(
                'REMOVE MEMBER', 'User is removed from seapod', context, () {
              setState(() {});
            });
          }
        });
      } else {
        // debugPrint('----- remove user from seapod failed');
        Navigator.of(context, rootNavigator: true).pop();
        showInfoBar(parseErrorTitle(responseStatus.code),
            responseStatus.message, context);
      }
    });
  }
}
