import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_clipper/custom_clipper.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/screens/profile/profile_screen.dart';
import 'package:ocean_builder/ui/screens/seapod_selection/ob_selection_widget_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:provider/provider.dart';

class TopClipperDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool hasAvator;

  const TopClipperDrawer({this.scaffoldKey, this.hasAvator});

  @override
  _TopClipperDrawerState createState() => _TopClipperDrawerState();
}

class _TopClipperDrawerState extends State<TopClipperDrawer> {
  final ScreenUtil _util = ScreenUtil();
  UserProvider _userProvider;
  User _user;

  Future<SeaPod> _seaPodFuture;

  Future<File> _profileImageFile;

  SelectedOBIdProvider _selectedOBIdProvider;
  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);
    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);
    OceanBuilderProvider oceanBuilderProvider =
        Provider.of<OceanBuilderProvider>(context);
    _user = _userProvider.authenticatedUser;
    if (_user != null &&
        _user.userOceanBuilder != null &&
        _user.userOceanBuilder.length >= 1) {
      // if(_selectedOBIdProvider.selectedObId.length>3)
      if (!(_selectedOBIdProvider.selectedObId
              .compareTo(AppStrings.selectOceanBuilder) ==
          0)) {
        // debugPrint('Selected OB ID =============================== ${_selectedOBIdProvider.selectedObId}');
        _seaPodFuture = oceanBuilderProvider.getSeaPod(
            _selectedOBIdProvider.selectedObId, _userProvider);
      }
      // else
      // _oceanBuilderFuture = oceanBuilderProvider.getOceanBuilder(_user.userOceanBuilder[0].oceanBuilderId);
    }

    _profileImageFile = MethodHelper.getProfilePicture();

    return Stack(
      children: <Widget>[
        ClipPath(clipper: DrawerTopShapeClipper(), child: _customContainer()),
        Positioned(
          right: ScreenUtil().setWidth(32),
          top: ScreenUtil().setHeight(175),
          child: _profilePicFuture(),
        ),
      ],
    );
  }

  _customContainer() {
    return Container(
      height: ScreenUtil().setHeight(450),
      decoration: BoxDecoration(gradient: topGradientDark),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
        child: widget.scaffoldKey != null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[_obNameFuture()],
                  ),
                ],
              )
            : Container(),
      ),
    );
  }

  Widget _obNameFuture() {
    return FutureBuilder(
      future: _seaPodFuture,
      builder: (context, snapshot) {
        SeaPod seaPod;
        if (snapshot.hasData) {
          seaPod = snapshot.data;
          // debugPrint('ocean builder ---n ${seaPod.obName}');
        }
        //  // debugPrint('selected id  - ${_selectedOBIdProvider.selectedObId}');
        return snapshot.hasData
            ? _createDrawerItemWithTitle(
                icon: Icons.person,
                text: seaPod.obName,
                title: 'tap to switch/\nrequest access'.toUpperCase(),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushNamed(OBSelectionScreenWidgetModal.routeName);
                }) //movieGrid(snapshot.data)
            : _createDrawerItemWithTitle(
                icon: Icons.person,
                text: _selectedOBIdProvider.selectedObId
                            .compareTo(AppStrings.selectOceanBuilder) ==
                        0
                    ? AppStrings.selectOceanBuilder
                    : 'Select One',
                title: 'tap to switch/\nrequest access'.toUpperCase(),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushNamed(OBSelectionScreenWidgetModal.routeName);
                });
      },
    );
  }

  Widget _profilePicFuture() {
    return FutureBuilder(
      future: _profileImageFile,
      builder: (context, snapshot) {
        File imageFile;
        if (snapshot.hasData) imageFile = snapshot.data;
        return snapshot.hasData
            ? _createHeader(context,
                imageFile: imageFile) //movieGrid(snapshot.data)
            : _createHeader(
                context); // Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _createHeader(BuildContext context, {File imageFile}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(ProfileScreen.routeName);
      },
      child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(
              ImagePaths.avatarBkg,
            ),
            radius: 72.h,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: imageFile != null ? 72.h : 48.h,
              backgroundImage: imageFile != null
                  ? FileImage(
                      imageFile,
                    )
                  : AssetImage(
                      ImagePaths.icAvatar,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItemWithTitle(
      {IconData icon, String text, String title, GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(
                  _util.setHeight(16),
                ),
                child: SvgPicture.asset(
                  ImagePaths.svgHomeIcon,
                  color: Colors.white,
                  width: _util.setHeight(128),
                  height: _util.setHeight(128),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  text,
                  style:
                      TextStyle(fontSize: _util.setSp(48), color: Colors.white),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                  fontSize: _util.setSp(32),
                  color: ColorConstants.MARINE_ITEM_COLOR),
            ),
          ),
        ],
      ),
    );
  }
}
