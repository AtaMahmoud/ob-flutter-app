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

class VisitorAccessScreen extends StatefulWidget {
  static const String routeName = '/visitorAccessScreen';

  final OceanBuilderUser oceanBuilderUser;

  const VisitorAccessScreen({this.oceanBuilderUser});

  @override
  _VisitorAccessScreenState createState() => _VisitorAccessScreenState();
}

class _VisitorAccessScreenState extends State<VisitorAccessScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AccessScreenDataBloc _bloc = AccessScreenDataBloc();

  String permissionSet;

  // ScreenUtil _util;

  File _avatarImageFile;

  @override
  void initState() {
    super.initState();

    _bloc.permissionChanged(ListHelper.getPermissionList()[1]);
    permissionSet = ListHelper.getPermissionList()[0];
    _bloc.permissionController.listen((onData) {
      permissionSet = onData;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    // _util = ScreenUtil();

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
                screnTitle: ScreenTitle.VISITOR_ACCESS),
            userProvider.isLoading
                ? ProgressIndicatorBoxAdapter()
                : SliverList(
                    delegate: SliverChildListDelegate([
                    SpaceH48(),
                    _avatarWidget(),
                    SpaceH48(),
                    _nameWidget(),
                    SpaceH48(),
                    _accessNameWidget(),
                    SpaceH48(),
                    _permissionSetRow(),
                    SpaceH48(),
                    _editPermissionRow(),
                    SpaceH48(),
                  ])),
            UIHelper.getTopEmptyContainer(90, false),
          ],
        ),
      ),
    );
  }

  _nameWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(widget.oceanBuilderUser.userName,
            style: TextStyle(
                fontSize: 72.sp, color: ColorConstants.TOP_CLIPPER_END_DARK))
      ],
    );
  }

  _accessNameWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Visitor Access',
            style: TextStyle(
                fontSize: 48.sp, color: ColorConstants.TOP_CLIPPER_END_DARK))
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

  _permissionSetRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
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

  _editPermissionRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
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
                      fontSize: 48.sp,
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
