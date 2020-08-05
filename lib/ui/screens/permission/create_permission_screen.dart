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
import 'package:ocean_builder/ui/cleeper_ui/permission_dropdown.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class CreatePermissionScreen extends StatefulWidget {
  static const String routeName = '/createPermissionScreen';

  // final OceanBuilderUser oceanBuilderUser;

  const CreatePermissionScreen();

  @override
  _CreatePermissionScreenState createState() => _CreatePermissionScreenState();
}

class _CreatePermissionScreenState extends State<CreatePermissionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CreatePermissionDataBloc _bloc = CreatePermissionDataBloc();

  String permissionSet;

  ScreenUtil _util;

  OceanBuilderProvider _oceanBuilderProvider;
  SelectedOBIdProvider _selectedOBIdProvider;

  UserProvider _userProvider;

  FocusNode _permissionSetNode;

  TextEditingController _permissionSetNameController;

  ScrollController _scrollController;

  PermissionSet _permissionSet = new PermissionSet();

  bool isNewPermissionCreated = false;

  @override
  void initState() {
    super.initState();

    _permissionSet.permissionGroups =  TempPermissionData.permissions;
    _scrollController = ScrollController();

    _bloc.permissionSetNameController.listen((onData) {
      permissionSet = onData;
      _permissionSet.permissionSetName = permissionSet;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;

    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);
    _oceanBuilderProvider = Provider.of<OceanBuilderProvider>(context);
    _userProvider = Provider.of<UserProvider>(context);

    _util = ScreenUtil();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        drawer: HomeDrawer(
          isSecondLevel: true,
          screenIndex: DrawerIndex.ACCESS_MANAGEMENT,
        ),
        drawerScrimColor: AppTheme.drawerScrimColor.withOpacity(.65),
        body: CustomScrollView(
          controller: _scrollController,
          // shrinkWrap: true,
          slivers: <Widget>[
            UIHelper.defaultSliverAppbar(_scaffoldKey, goBack,
                screnTitle: ScreenTitle.CREATE_PERMISSION),
            SliverToBoxAdapter(
                child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 32.w,
                vertical: 32.h,
              ),
              child: _permissionSetNameContainer(),
            )),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: 32.w,
                vertical: 32.h,
              ),
              sliver: SliverList(
                  delegate: SliverChildListDelegate(
                      // [
                      _permissionSet.permissionGroups.map((f) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: 16.h,
                  ),
                  child: PermissionDropdown(f, _scrollController),
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
              child: _userProvider.isLoading || _oceanBuilderProvider.isLoading ? Center(child: CircularProgressIndicator())  : _saveButtonWidget(),
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

  _saveButtonWidget() {
    return InkWell(
      onTap: () {
        String selectedSeaPodId = _selectedOBIdProvider.selectedObId;

        if(permissionSet != null && permissionSet.length > 0){
          // _userProvider
          _oceanBuilderProvider.createPermission(selectedSeaPodId, _permissionSet).then((responseStatus) {

            if(responseStatus.status==200)
            {
              _userProvider.autoLogin().then((value) => showInfoBar('Create Permission', 'Permission Created ', context));
              isNewPermissionCreated = true;
              
              }
            else{

                    showInfoBar('Create Permission', responseStatus.message, context);

            }

          });
        }else {

           showInfoBar('Create Permission', 'Please input a permission set name', context);
        
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
            borderRadius: new BorderRadius.circular(
                ScreenUtil().setWidth(72)),
            color: ColorConstants.CREATE_PERMISSION_COLOR_BKG),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'SAVE',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                  fontSize: ScreenUtil().setSp(48)),
            ),
          ],
        )),
      ),
    );
  }

  goBack() {
    Navigator.pop(context,isNewPermissionCreated);
  }
}
