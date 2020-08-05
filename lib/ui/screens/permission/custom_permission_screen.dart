import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/create_permission_data_bloc.dart';
import 'package:ocean_builder/bloc/permission_edit_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/permission.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/cleeper_ui/permission_dropdown.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

class CustomPermissionScreen extends StatefulWidget {
  static const String routeName = '/customPermissionScreen';

  final PermissionSet permissionSet;

  const CustomPermissionScreen({this.permissionSet});

  @override
  _CustomPermissionScreenState createState() => _CustomPermissionScreenState();
}

class _CustomPermissionScreenState extends State<CustomPermissionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CreatePermissionDataBloc _bloc = CreatePermissionDataBloc();

  String permissionSet;

  ScreenUtil _util;

  OceanBuilderProvider _oceanBuilderProvider;
  SelectedOBIdProvider _selectedOBIdProvider;

  UserProvider _userProvider;

  Future<SeaPod> _oceanBuildeFuture;

  FocusNode _permissionSetNode;

  TextEditingController _permissionSetNameController;

  ScrollController _scrollController;

  PermissionEditBloc _editBloc = PermissionEditBloc();

  // UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _permissionSetNameController = TextEditingController(
        text: widget.permissionSet
            .permissionSetName); //.text = widget.permissionSet.permissionSetName;
    _bloc.permissionSetNameChanged(widget.permissionSet.permissionSetName);

    _bloc.permissionSetNameController.listen((onData) {
      permissionSet = onData;
    });

    _editBloc.permissionEditController.listen((onData) {
      _permissionSetNameController.text =
          'Custom for ${_userProvider.authenticatedUser.lastName}';
      _bloc.permissionSetNameChanged(
          'Custom for ${_userProvider.authenticatedUser.lastName}');
    });
  }

  @override
  void dispose() {
    _editBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    // userProvider = Provider.of<UserProvider>(context);

    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);
    _oceanBuilderProvider = Provider.of<OceanBuilderProvider>(context);
    _userProvider = Provider.of<UserProvider>(context);

    _oceanBuildeFuture = _oceanBuilderProvider.getSeaPod(
        _selectedOBIdProvider.selectedObId, _userProvider);

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
        body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            CustomScrollView(
              controller: _scrollController,
              shrinkWrap: true,
              slivers: <Widget>[
                // UIHelper.getTopEmptyContainer(height * .9, false),
                UIHelper.defaultSliverAppbar(_scaffoldKey, goBack,
                    screnTitle: ScreenTitle.CUSTOMIZE_PERMISSION),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _util.setWidth(32),
                    vertical: _util.setHeight(32),
                  ),
                  child: _permissionSetNameContainer(),
                )),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _util.setWidth(32),
                    vertical: _util.setHeight(32),
                  ),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate(
                          // [
                          widget.permissionSet.permissionGroups
                              .map((permissionGroup) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: _util.setHeight(16),
                      ),
                      child: PermissionDropdown(
                          permissionGroup, _scrollController,
                          editBloc: _editBloc),
                    );
                  }).toList()

                          // PermissionDropdown('title', TempPermissionData.mainControllPermissionSet, _scrollController),
                          // ]
                          )),
                ),
                // userProvider.isLoading
                //     ? SliverToBoxAdapter(
                //         child: Padding(
                //           padding: const EdgeInsets.all(16.0),
                //           child: Center(
                //             child: CircularProgressIndicator(),
                //           ),
                //         ),
                //       )
                //     : Container(),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _util.setWidth(32),
                    vertical: _util.setHeight(32),
                  ),
                  child: _updatePermissionButtonWidget(),
                )),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _util.setWidth(32),
                    vertical: _util.setHeight(32),
                  ),
                  child: _saveWithNewNameButtonWidget(),
                )),
                UIHelper.getTopEmptyContainer(90, false),
              ],
            ),
            // Positioned(
            //   top: ScreenUtil.statusBarHeight,
            //   left: 0,
            //   right: 0,
            //   child: Container(
            //     // color: Colors.white,
            //     // padding: EdgeInsets.only(top: 8.0, right: 12.0),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: <Widget>[
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: <Widget>[
            //             Row(
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: <Widget>[
            //                 InkWell(
            //                   onTap: () {
            //                     _scaffoldKey.currentState.openDrawer();
            //                     // _innerDrawerKey.currentState.toggle();
            //                   },
            //                   child: Padding(
            //                     padding: EdgeInsets.only(
            //                       left: _util.setWidth(32),
            //                       right: _util.setWidth(32),
            //                       top: _util.setHeight(32),
            //                       bottom: _util.setHeight(32),
            //                     ),
            //                     child: ImageIcon(
            //                       AssetImage(ImagePaths.icHamburger),
            //                       color: ColorConstants.WEATHER_MORE_ICON_COLOR,
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: EdgeInsets.fromLTRB(
            //                       _util.setWidth(32),
            //                       _util.setHeight(32),
            //                       0.0, //_util.setWidth(32),
            //                       _util.setHeight(32)),
            //                   child: Text(
            //                     ScreenTitle.CUSTOMIZE_PERMISSION,
            //                     style: TextStyle(
            //                         color:
            //                             ColorConstants.WEATHER_MORE_ICON_COLOR,
            //                         fontSize: ScreenUtil().setSp(64),
            //                         fontWeight: FontWeight.w400),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             InkWell(
            //               onTap: () {
            //                 Navigator.of(context).pop();
            //               },
            //               child: Padding(
            //                 padding: EdgeInsets.only(
            //                   left: _util.setWidth(32),
            //                   right: _util.setWidth(32),
            //                   top: _util.setHeight(32),
            //                   bottom: _util.setHeight(32),
            //                 ),
            //                 child: Image.asset(
            //                   ImagePaths.cross,
            //                   width: _util.setWidth(48),
            //                   height: _util.setHeight(48),
            //                   color: ColorConstants.WEATHER_MORE_ICON_COLOR,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // OB24sP6
          ],
        ),
      ),
    );
  }

  Widget _permissionSetNameContainer() {
    return Container(
        // margin: EdgeInsets.symmetric(horizontal: util.setWidth(32)),
        child: TextField(
      autofocus: false,
      controller: _permissionSetNameController,
      onChanged: _bloc.permissionSetNameChanged,
      keyboardType: null,
      keyboardAppearance: Brightness.light,
      textAlign: TextAlign.end,
      textAlignVertical: TextAlignVertical.top,
      scrollPadding: EdgeInsets.only(bottom: 100),
      textInputAction: TextInputAction.done,
      focusNode: _permissionSetNode,
      onEditingComplete: () => FocusScope.of(context).unfocus(),
      maxLines: 1,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER, width: 1),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER, width: 1),
          ),
          labelText: 'Permission Set Name',
          labelStyle: TextStyle(
              color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
              fontSize: _util.setSp(48)),
          hintText: 'PLEASE NAME YOUR PERMISSION SET',
          hintStyle: TextStyle(
              color: ColorConstants.ACCESS_MANAGEMENT_SUBTITLE,
              fontSize: _util.setSp(40)),
          floatingLabelBehavior: FloatingLabelBehavior.always),
      style: TextStyle(
        fontSize: _util.setSp(48),
        fontWeight: FontWeight.w400,
        color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
      ),
      inputFormatters: [
        new LengthLimitingTextInputFormatter(100),
      ],
    ));
  }

  _updatePermissionButtonWidget() {
    return InkWell(
      onTap: () {},
      child: Container(
        // height: h,
        // width: MediaQuery.of(context).size.width * .4,
        padding: EdgeInsets.symmetric(
          horizontal: _util.setWidth(32),
          vertical: _util.setHeight(32),
        ),
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(ScreenUtil().setWidth(72)),
            color: ColorConstants.TOP_CLIPPER_END_DARK),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'SAVE CUSTOM PERMISSIONS',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(48)),
            ),
          ],
        )),
      ),
    );
  }

  _saveWithNewNameButtonWidget() {
    return InkWell(
      onTap: () {},
      child: Container(
        // height: h,
        // width: MediaQuery.of(context).size.width * .4,
        padding: EdgeInsets.symmetric(
          horizontal: _util.setWidth(32),
          vertical: _util.setHeight(32),
        ),
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(ScreenUtil().setWidth(72)),
            color: ColorConstants.TOP_CLIPPER_END_DARK),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'SAVE WITH NEW PERMISSION NAME',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(48)),
            ),
          ],
        )),
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
