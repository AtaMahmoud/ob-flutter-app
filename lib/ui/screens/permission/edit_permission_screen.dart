import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/create_permission_data_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/permission.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/cleeper_ui/permission_dropdown.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class EditPermissionScreen extends StatefulWidget {
  static const String routeName = '/editPermissionScreen';

  final PermissionSet permissionSet;

  const EditPermissionScreen({this.permissionSet});

  @override
  _EditPermissionScreenState createState() => _EditPermissionScreenState();
}

class _EditPermissionScreenState extends State<EditPermissionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CreatePermissionDataBloc _bloc = CreatePermissionDataBloc();

  String permissionSetName;

  ScreenUtil _util;

  OceanBuilderProvider _oceanBuilderProvider;
  SelectedOBIdProvider _selectedOBIdProvider;

  UserProvider _userProvider;

  FocusNode _permissionSetNode;

  TextEditingController _permissionSetNameController;

  ScrollController _scrollController;

  PermissionSet _permissionSet;

  bool isPermissionUpdated = false;

  @override
  void initState() {
    super.initState();
    _permissionSet = widget.permissionSet;
    _scrollController = ScrollController();

    _permissionSetNameController = TextEditingController(
        text: _permissionSet
            .permissionSetName); //.text = widget.permissionSet.permissionSetName;
    _bloc.permissionSetNameChanged(widget.permissionSet.permissionSetName);

    _bloc.permissionSetNameController.listen((onData) {
      permissionSetName = onData;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);
    _oceanBuilderProvider = Provider.of<OceanBuilderProvider>(context);
    _userProvider = Provider.of<UserProvider>(context);

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
          controller: _scrollController,
          // shrinkWrap: true,
          slivers: <Widget>[
            UIHelper.defaultSliverAppbar(_scaffoldKey, goBack,
                screnTitle: ScreenTitle.EDIT_PERMISSION),
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
                      _permissionSet.permissionGroups.map((permissionGroup) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: _util.setHeight(16),
                  ),
                  child: PermissionDropdown(permissionGroup, _scrollController),
                );
              }).toList()

                      // PermissionDropdown('title', TempPermissionData.mainControllPermissionSet, _scrollController),
                      // ]
                      )),
            ),

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
            // UIHelper.getTopEmptyContainer(90, false),
          ],
        ),
      ),
    );
  }

  Widget _permissionSetNameContainer() {
    return Container(
        // margin: EdgeInsets.symmetric(horizontal: util.setWidth(32)),
        child: TextField(
      autofocus: true,
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
      ),
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
      onTap: () {

        String selectedSeaPodId = _selectedOBIdProvider.selectedObId;

        if (permissionSetName != null && permissionSetName.length > 0) {
          // _userProvider
          _oceanBuilderProvider
              .updatePermission(selectedSeaPodId, _permissionSet)
              .then((responseStatus) {
            if (responseStatus.status == 200) {
              _userProvider.autoLogin().then((value) => showInfoBar(
                  'Update Permission', 'Permission updated ', context));
              isPermissionUpdated = true;
            } else {
              showInfoBar('Update Permission', responseStatus.message, context);
            }
          });
        } else {
          showInfoBar('Update Permission',
              'Please input a valid permission set name', context);
        }

      },
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
              'UPDATE PERMISSIONS',
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
      onTap: () {

        String selectedSeaPodId = _selectedOBIdProvider.selectedObId;

        if (permissionSetName != null && permissionSetName.length > 0) {
          // _userProvider
          _oceanBuilderProvider
              .renamePermission(selectedSeaPodId, _permissionSet.id, permissionSetName)
              .then((responseStatus) {
            if (responseStatus.status == 200) {
              _userProvider.autoLogin().then((value) => showInfoBar(
                  'Rename Permission', 'Permission renamed ', context));
              isPermissionUpdated = true;
            } else {
              showInfoBar('Rename Permission', responseStatus.message, context);
            }
          });
        } else {
          showInfoBar('Rename Permission',
              'Please input a valid permission set name', context);
        }


      },
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
              'SAVE WITH NEW NAME',
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
 Navigator.pop(context,isPermissionUpdated);
  }
}
