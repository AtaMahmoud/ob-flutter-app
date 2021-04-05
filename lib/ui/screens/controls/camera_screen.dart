import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/ui/shared/shared_pref_data.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  static const String routeName = '/cameraScreen';

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserProvider userProvider;
  // ScreenUtil _util;

  File _profileImageFile;

  CAMERA currentlySelectedCameraIndex = CAMERA.BEDROOM;
  int selectedCamIndex = 1;

  @override
  void initState() {
    UIHelper.setStatusBarColor(color: Colors.white);
    _getProfilePicture();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    userProvider = Provider.of<UserProvider>(context);
    return _mainContent();
  }

  _mainContent() {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: HomeDrawer(
          isSecondLevel: true,
          screenIndex: DrawerIndex.CONTROLS,
        ),
        drawerScrimColor: AppTheme.drawerScrimColor.withOpacity(.65),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  UIHelper.getTopEmptyContainerWithColor(
                      ScreenUtil().statusBarHeight * 3, Colors.white),
                  _selectRoomText(),
                  _cameraSlider(),
                  _camerasRow(),
                  _cameraPreview()
                ],
              ),
              _topBar()
            ],
          ),
        ),
      ),
    );
  }

  Positioned _topBar() {
    return Positioned(
      top: ScreenUtil().statusBarHeight,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      32.w,
                      32.h,
                      32.w,
                      32.h,
                    ),
                    child: ImageIcon(
                      AssetImage(ImagePaths.icHamburger),
                      color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 48.w,
                    top: 32.h,
                    bottom: 32.h,
                  ),
                  child: Text(
                    AppStrings.cameras,
                    style: TextStyle(
                        color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                        fontWeight: FontWeight.normal,
                        fontSize: 22),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    goBack();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 48.w,
                      top: 32.h,
                      bottom: 32.h,
                    ),
                    child: Image.asset(
                      ImagePaths.cross,
                      width: 48.w,
                      height: 48.h,
                      color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _cameraPreview() {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).size.height * .622,
        padding: EdgeInsets.symmetric(
            // vertical: util.setHeight(32),
            horizontal: 32.w),
        child: Image.asset(
          ImagePaths.cameraPreview,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  SliverToBoxAdapter _camerasRow() {
    return SliverToBoxAdapter(
        child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 48.w,
        vertical: 32.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          __camItem(1),
          __camItem(2),
          __camItem(3),
        ],
      ),
    ));
  }

  SliverToBoxAdapter _cameraSlider() {
    return SliverToBoxAdapter(
        child: Container(
      height: 235.h,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          __horizontalSliderItem(CAMERA.BEDROOM),
          __horizontalSliderItem(CAMERA.KITCHEN),
          __horizontalSliderItem(CAMERA.LIVING_ROOM),
          __horizontalSliderItem(CAMERA.UNDERWATER_ROOM)
        ],
      ),
    ));
  }

  SliverToBoxAdapter _selectRoomText() {
    return SliverToBoxAdapter(
      child: Padding(
        // color: ColorConstants.MODAL_BKG.withOpacity(.375),
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
        child: Text('Select Room',
            style: TextStyle(
                color: ColorConstants.CAMERA_TITLE,
                fontWeight: FontWeight.normal,
                fontSize: 36.sp)),
      ),
    );
  }

  Widget _horizontalLine() {
    return SvgPicture.asset(
      ImagePaths.svgWeatherInfoDividerLine,
      fit: BoxFit.fitWidth,
      color: ColorConstants.TOP_CLIPPER_END,
      // width: MediaQuery.of(context).size.width*.95,
    );
  }

  __camItem(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedCamIndex = index;
        });
      },
      child: Container(
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              ImagePaths.svgCamera,
              fit: BoxFit.fitWidth,
              color: selectedCamIndex == index
                  ? ColorConstants.CAMERA_TITLE
                  : ColorConstants.CAMERA_ITEM_INACTIVE,
              // width: MediaQuery.of(context).size.width*.95,
            ),
            SizedBox(
              width: 8.w,
            ),
            Text(
              'Cam $index',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: selectedCamIndex == index
                      ? ColorConstants.CAMERA_TITLE
                      : ColorConstants.CAMERA_ITEM_INACTIVE,
                  fontWeight: FontWeight.normal,
                  fontSize: 38.22.sp),
            )
          ],
        ),
      ),
    );
  }

  Widget __horizontalSliderItem(CAMERA cameraIndex) {
    // debugPrint('cmaraIndex --------- ' + cameraIndex.index.toString());
    String title = 'BEDROOM';
    String imagePath = ImagePaths.svgBedRoom;
    switch (cameraIndex) {
      case CAMERA.BEDROOM:
        title = 'BEDROOM';
        imagePath = ImagePaths.svgBedRoom;
        break;
      case CAMERA.KITCHEN:
        title = 'KITCHEN';
        imagePath = ImagePaths.svgKitchen;
        break;
      case CAMERA.LIVING_ROOM:
        title = 'LIVING_ROOM';
        imagePath = ImagePaths.svgLivingRoom;
        break;
      case CAMERA.UNDERWATER_ROOM:
        title = 'UNDERWATER ROOM';
        imagePath = ImagePaths.svgUnderWaterRoom;
        break;
      default:
    }
    return InkWell(
      onTap: () {
        setState(() {
          currentlySelectedCameraIndex = cameraIndex;
        });
      }, //onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.w),
          color: currentlySelectedCameraIndex == cameraIndex
              ? ColorConstants.CAMERA_TITLE
              : ColorConstants.CAMERA_SLIDER_ITEM_BKG,
        ),
        margin: EdgeInsets.all(10.w),

        width: 405.w, //MediaQuery.of(context).size.width/3,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SvgPicture.asset(
                      imagePath,
                      fit: BoxFit.fitWidth,
                      color: currentlySelectedCameraIndex == cameraIndex
                          ? ColorConstants.CAMERA_SLIDER_ITEM_SELECTED
                          : ColorConstants.CAMERA_SLIDER_ITEM,
                    ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: currentlySelectedCameraIndex == cameraIndex
                              ? ColorConstants.CAMERA_SLIDER_ITEM_SELECTED
                              : ColorConstants.CAMERA_SLIDER_ITEM,
                          fontWeight: FontWeight.normal,
                          fontSize: 38.22.sp),
                    )
                  ],
                ),
              ),
            ),
            cameraIndex == CAMERA.KITCHEN
                ? Positioned(
                    left: 16.w,
                    bottom: 16.h,
                    child: SvgPicture.asset(
                      ImagePaths.svgMovement,
                      fit: BoxFit.fitWidth,
                      color: currentlySelectedCameraIndex == cameraIndex
                          ? ColorConstants.CAMERA_SLIDER_MOVEMENT
                          : ColorConstants.CAMERA_SLIDER_MOVEMENT,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  goBack() {
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
    Navigator.of(context).pop();
  }

  _getProfilePicture() async {
    String path = await SharedPrefHelper.getProfilePicFilePath();
    if (path != null) {
      final File imageFile = File(path);
      if (await imageFile.exists()) {
        setState(() {
          _profileImageFile = imageFile;
        });
      }
    }
  }
}

enum CAMERA { BEDROOM, KITCHEN, LIVING_ROOM, UNDERWATER_ROOM }
