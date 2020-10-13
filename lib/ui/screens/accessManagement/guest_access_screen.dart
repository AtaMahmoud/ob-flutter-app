import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/bloc/access_screen_data_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/ocean_builder_user.dart';
import 'package:ocean_builder/core/models/permission.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/screens/permission/edit_permission_screen.dart';
import 'package:ocean_builder/ui/shared/drop_downs.dart';
import 'package:ocean_builder/ui/widgets/progress_indicator.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GuestAccessScreen extends StatefulWidget {
  static const String routeName = '/guestAccessScreen';

  final OceanBuilderUser oceanBuilderUser;

  const GuestAccessScreen({this.oceanBuilderUser});

  @override
  _GuestAccessScreenState createState() => _GuestAccessScreenState();
}

class _GuestAccessScreenState extends State<GuestAccessScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AccessScreenDataBloc _bloc = AccessScreenDataBloc();

  String accessTime;
  String accesAs;
  String permissionSet;

  ScreenUtil _util;

  bool isFromNotificationTray = false;

  File _avatarImageFile;

  @override
  void initState() {
    super.initState();
    Duration d;
    if (widget.oceanBuilderUser.accessTime == null) {
      d = Duration(days: 1800);
    } else {
      d = Duration(
          milliseconds: widget.oceanBuilderUser.accessTime.inMilliseconds);
    }
    debugPrint('acces reques t time in days-- ' + d.inDays.toString());
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
    } else {
      accessFor = '3 MONTHS';
    }
    int index = ListHelper.getAccessTimeList().indexOf(accessFor);
    // debugPrint('index   ' + index.toString());
    _bloc.accessTimeChanged(ListHelper.getAccessTimeList()[index]);
    accessTime = accessFor;
    _bloc.accessTimeController.listen((onData) {
      accessTime = onData;
    });

    _bloc.accessAsChanged(ListHelper.getAccessAsList()[2]);
    accesAs = ListHelper.getAccessAsList()[2];
    _bloc.accessAsController.listen((onData) {
      accesAs = onData;
    });

    _bloc.permissionChanged(ListHelper.getPermissionList()[0]);
    permissionSet = ListHelper.getPermissionList()[0];
    _bloc.permissionController.listen((onData) {
      permissionSet = onData;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    _util = ScreenUtil();

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
        body: CustomScrollView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          slivers: <Widget>[
            // UIHelper.getTopEmptyContainer(height * .9, false),
            UIHelper.defaultSliverAppbar(_scaffoldKey, goBack,
                screnTitle: ScreenTitle.Guest_ACCESS),
            userProvider.isLoading
                ? ProgressIndicatorBoxAdapter()
                : SliverList(
                    delegate: SliverChildListDelegate([
                    SpaceH64(),
                    _avatarWidget(),
                    SpaceH64(),
                    _nameWidget(),
                    SpaceH64(),
                    _accessAsRow(),
                    SpaceH64(),
                    _accessFromRow(),
                    SpaceH64(),
                    _expireDateWidget(),
                    SpaceH64(),
                    _permissionSetRow(),
                    SpaceH64(),
                    _editPermissionRow(),
                    SpaceH64(),
                  ])),
            UIHelper.getTopEmptyContainer(90, false),
          ],
        ),
      ),
    );
  }

  _accessFromRow() {
    _accessRow('Access From', DateFormat('dd/MM/yyyy').format(DateTime.now()),
        ' Access For', 'accessForValue');
  }

  _nameWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(widget.oceanBuilderUser.userName,
            style: TextStyle(
                fontSize: _util.setSp(72),
                color: ColorConstants.TOP_CLIPPER_END_DARK))
      ],
    );
  }

  _avatarWidget() {
    return CircleAvatar(
      backgroundColor: Colors.blueGrey[100],
      radius: 196.h,
      child: CircleAvatar(
        backgroundColor: Colors.blueGrey[100],
        radius: _avatarImageFile != null ? 196.h : 100.h,
        backgroundImage: _avatarImageFile != null
            ? FileImage(
                _avatarImageFile,
              )
            : AssetImage(
                ImagePaths.icAvatar,
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
                      color: ColorConstants.COLOR_NOTIFICATION_ITEM,
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
            child: getDropdown(ListHelper.getGrantAccessTimeList(),
                _bloc.accessTime, _bloc.accessTimeChanged, false,
                label: 'Access for'),
          )
        ],
      ),
    );
  }

  _accessAsRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _util.setWidth(48)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: getDropdown(ListHelper.getAccessAsList().sublist(1),
                _bloc.accessAs, _bloc.accessAsChanged, false,
                label: 'Access As'),
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

  _expireDateWidget() {
    String timeText;

    DateTime now = DateTime.now();
    DateTime checkInDate = DateTime.now();
    DateTime checkOutDate = DateTime.now().add(Duration(days: 30));
    Duration remainingDays = checkOutDate.difference(now);
    if (checkInDate.isAfter(DateTime.now())) {
      timeText =
          'Expires in ${remainingDays.inDays} days ( ${DateFormat('yMMMMd').format(checkOutDate)} )';
    } else {
      timeText = 'Check in ${DateFormat('yMMMMd').format(checkInDate)}';
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _util.setWidth(48)),
      child: Wrap(
        children: <Widget>[
          Text(
            timeText,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(48),
                color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }

  _editPermissionRow() {
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
                  .pushNamed(EditPermissionScreen.routeName, arguments: ps);
            },
            child: Row(
              children: <Widget>[
                SvgPicture.asset(ImagePaths.svgEdit),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  'EDIT PERMISSIONS',
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

  goBack() async {
    Navigator.pop(context);
  }
}
