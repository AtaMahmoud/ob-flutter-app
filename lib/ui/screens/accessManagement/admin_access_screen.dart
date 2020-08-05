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
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class AdminAccessScreen extends StatefulWidget {
  static const String routeName = '/adminAccessScreen';

  final OceanBuilderUser oceanBuilderUser;

  const AdminAccessScreen({this.oceanBuilderUser});

  @override
  _AdminAccessScreenState createState() => _AdminAccessScreenState();
}

class _AdminAccessScreenState extends State<AdminAccessScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AccessScreenDataBloc _bloc = AccessScreenDataBloc();

  String permissionSet;

  ScreenUtil _util;

  File _avatarImageFile;

  @override
  void initState() {
    super.initState();

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
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          slivers: <Widget>[
            // UIHelper.getTopEmptyContainer(height * .9, false),
            UIHelper.defaultSliverAppbar(_scaffoldKey, goBack,
                screnTitle: ScreenTitle.ADMINISTRATION_ACCESS),
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
                    SizedBox(height: _util.setHeight(48)),
                    _avatarWidget(),
                    SizedBox(height: _util.setHeight(48)),
                    _nameWidget(),
                    SizedBox(height: _util.setHeight(48)),
                    _accessNameWidget(),
                    SizedBox(height: _util.setHeight(64)),
                    _permissionSetRow(),
                    SizedBox(height: _util.setHeight(64)),
                    _editPermissionRow(),
                    SizedBox(height: _util.setHeight(64)),
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
                fontSize: _util.setSp(72),
                color: ColorConstants.TOP_CLIPPER_END_DARK))
      ],
    );
  }

  _accessNameWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Administrator Access',
            style: TextStyle(
                fontSize: _util.setSp(48),
                color: ColorConstants.TOP_CLIPPER_END_DARK))
      ],
    );
  }

  _avatarWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            child: Image.asset(
          ImagePaths.admin_avatar,
        )),
      ],
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
/*     if (userProvider.authenticatedUser == null)
      await userProvider
          .resetAuthenticatedUser(widget.fcmNotification.data.ownerID); */
    // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }
}
