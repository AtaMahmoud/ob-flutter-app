import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_clipper/custom_clipper.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/screens/profile/profile_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:provider/provider.dart';

class TopClipperHome extends StatefulWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  final bool hasAvator;

  const TopClipperHome(this.title,
      {this.scaffoldKey, this.innerDrawerKey, this.hasAvator});

  @override
  _TopClipperHomeState createState() => _TopClipperHomeState();
}

class _TopClipperHomeState extends State<TopClipperHome> {
  UserProvider _userProvider;
  SelectedOBIdProvider _selectedOBIdProvider;
  Future<SeaPod> _seaPodFuture;

  Future<File> _profileImageFile;

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);

    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);
    OceanBuilderProvider oceanBuilderProvider =
        Provider.of<OceanBuilderProvider>(context);

    if (!(_selectedOBIdProvider.selectedObId
            .compareTo(AppStrings.selectOceanBuilder) ==
        0)) {
      _seaPodFuture = oceanBuilderProvider.getSeaPod(
          _selectedOBIdProvider.selectedObId, _userProvider);
    }

    _profileImageFile = MethodHelper.getProfilePicture();

    return Stack(
      children: <Widget>[
        ClipPath(
            clipper: CustomTopShapeClipperHome(),
            child: widget.hasAvator ? _customContainer() : _defaultContainer()),
        widget.hasAvator
            ? Positioned(right: 64.w, top: 120.h, child: _profilePicFuture())
            : Container(),
      ],
    );
  }

  _defaultContainer() {
    return Container(
      height: 400.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          ColorConstants.TOP_CLIPPER_START,
          ColorConstants.TOP_CLIPPER_END
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.fromLTRB(32.w, 32.h, 0.0, 32.h),
          child: widget.scaffoldKey != null
              ? Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        widget.scaffoldKey.currentState.openDrawer();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 32.w,
                          right: 32.w,
                          top: 32.h,
                          bottom: 32.h,
                        ),
                        child: Icon(
                          Icons.sort,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 70.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )
              : Text(
                  widget.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 70.sp,
                      fontWeight: FontWeight.w400),
                ),
        ),
      ),
    );
  }

  _customContainer() {
    return Container(
      height: 400.h,
      decoration: BoxDecoration(gradient: topGradientDark),
      child: Padding(
        padding: EdgeInsets.fromLTRB(32.w, 32.h, 0.0, 32.h),
        child: widget.scaffoldKey != null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      widget.scaffoldKey.currentState.openDrawer();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 32.w,
                        bottom: 32.h,
                      ),
                      child: ImageIcon(
                        AssetImage(ImagePaths.icHamburger),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 64.w,
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _userProvider.authenticatedUser != null
                                ? 'Welcome ${_userProvider.authenticatedUser.firstName} ${_userProvider.authenticatedUser.lastName}'
                                : 'Welcome',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 60.sp,
                                fontWeight: FontWeight.w400),
                          ),
                          _obNameFuture(),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            : Text(
                widget.title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 70.sp,
                    fontWeight: FontWeight.w400),
              ),
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
          // debugPrint('top clipper ocean builder ---n ${seaPod.obName}');
        }
        //  // debugPrint('selected id  - ${_selectedOBIdProvider.selectedObId}');
        return snapshot.hasData
            ? Text(
                _userProvider.authenticatedUser != null &&
                        _userProvider.authenticatedUser.userOceanBuilder !=
                            null &&
                        _userProvider
                                .authenticatedUser.userOceanBuilder.length >=
                            1
                    ? seaPod.obName.toUpperCase()
                    : '',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 60.sp,
                    fontWeight: FontWeight.w400),
              )
            : Container();
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
            ? _createAvatar(context,
                imageFile: imageFile) //movieGrid(snapshot.data)
            : _createAvatar(
                context); // Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _createAvatar(BuildContext context, {File imageFile}) {
    return InkWell(
      onTap: () {
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
}
