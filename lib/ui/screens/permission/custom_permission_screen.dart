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

  OceanBuilderProvider _oceanBuilderProvider;
  SelectedOBIdProvider _selectedOBIdProvider;

  UserProvider _userProvider;

  Future<SeaPod> _oceanBuildeFuture;

  FocusNode _permissionSetNode;

  TextEditingController _permissionSetNameController;

  ScrollController _scrollController;

  PermissionEditBloc _editBloc = PermissionEditBloc();

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

    if (!mounted)
      MethodHelper.parseNotifications(GlobalContext.currentScreenContext);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        drawer: HomeDrawer(
          isSecondLevel: true,
          screenIndex: DrawerIndex.NOTIFICATIONS,
        ),
        drawerScrimColor: AppTheme.drawerScrimColor.withOpacity(.65),
        body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            _mainContent(),
          ],
        ),
      ),
    );
  }

  CustomScrollView _mainContent() {
    return CustomScrollView(
      controller: _scrollController,
      shrinkWrap: true,
      slivers: <Widget>[
        _topBar(),
        _inputPermissionSetName(),
        _listOfPermission(),
        _buttonUpdate(),
        _buttonSaveWithName(),
        _endSpace(),
      ],
    );
  }

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  SliverToBoxAdapter _buttonSaveWithName() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 32.w,
        vertical: 32.h,
      ),
      child: _saveWithNewNameButtonWidget(),
    ));
  }

  SliverToBoxAdapter _buttonUpdate() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 32.w,
        vertical: 32.h,
      ),
      child: _updatePermissionButtonWidget(),
    ));
  }

  SliverPadding _listOfPermission() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 32.w,
        vertical: 32.h,
      ),
      sliver: SliverList(
          delegate: SliverChildListDelegate(
              widget.permissionSet.permissionGroups.map((permissionGroup) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: 16.h,
          ),
          child: PermissionDropdown(permissionGroup, _scrollController,
              editBloc: _editBloc),
        );
      }).toList())),
    );
  }

  SliverToBoxAdapter _inputPermissionSetName() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 32.w,
        vertical: 32.h,
      ),
      child: _permissionSetNameContainer(),
    ));
  }

  _topBar() {
    return UIHelper.defaultSliverAppbar(_scaffoldKey, goBack,
        screnTitle: ScreenTitle.CUSTOMIZE_PERMISSION);
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
            fontSize: 48.sp,
          ),
          hintText: 'PLEASE NAME YOUR PERMISSION SET',
          hintStyle: TextStyle(
              color: ColorConstants.ACCESS_MANAGEMENT_SUBTITLE,
              fontSize: 40.sp),
          floatingLabelBehavior: FloatingLabelBehavior.always),
      style: TextStyle(
        fontSize: 48.sp,
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
          horizontal: 32.w,
          vertical: 32.h,
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
          horizontal: 32.w,
          vertical: 32.h,
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
  }
}
