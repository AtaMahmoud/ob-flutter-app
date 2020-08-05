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
  ScreenUtil _util;

  File _profileImageFile;

  CAMERA currentlySelectedCameraIndex = CAMERA.BEDROOM;
  int selectedCamIndex = 1;

  @override
  void initState() {
    UIHelper.setStatusBarColor(color: Colors.white);
    // Future.delayed(Duration.zero).then((_) {

    // });
    _util = ScreenUtil();
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

    return _mainContent(); //customDrawer(_innerDrawerKey, _mainContent());
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
            // borderRadius: BorderRadius.circular(8)
          ),
          child: Stack(
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  UIHelper.getTopEmptyContainerWithColor(
                      ScreenUtil.statusBarHeight * 3, Colors.white),
                  SliverToBoxAdapter(
                    child: Padding(
                      // color: ColorConstants.MODAL_BKG.withOpacity(.375),
                      padding: EdgeInsets.symmetric(
                          horizontal: _util.setWidth(32),
                          vertical: _util.setHeight(32)),
                      child: Text('Select Room',
                          style: TextStyle(
                              color: ColorConstants.CAMERA_TITLE,
                              fontWeight: FontWeight.normal,
                              fontSize: _util.setSp(36))),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: Container(
                    height: _util.setHeight(235),
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(horizontal: _util.setWidth(8)),
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        __horizontalSliderItem(CAMERA.BEDROOM),
                        __horizontalSliderItem(CAMERA.KITCHEN),
                        __horizontalSliderItem(CAMERA.LIVING_ROOM),
                        __horizontalSliderItem(CAMERA.UNDERWATER_ROOM)
                      ],
                    ),
                  )),
                  SliverToBoxAdapter(
                      child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: _util.setWidth(48),
                        vertical: _util.setHeight(32)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        __camItem(1),
                        __camItem(2),
                        __camItem(3),
                      ],
                    ),
                  )),
                  SliverToBoxAdapter(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .622,
                      padding: EdgeInsets.symmetric(
                          // vertical: util.setHeight(32),
                          horizontal: _util.setWidth(32)),
                      child: Image.asset(
                        ImagePaths.cameraPreview,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )

                  // UIHelper.getTopEmptyContainer(90, false),
                ],
              ),
              // Appbar(ScreenTitle.OB_SELECTION),
              Positioned(
                top: ScreenUtil.statusBarHeight,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  // padding: EdgeInsets.only(top: 8.0, right: 12.0),
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
                                _util.setWidth(32),
                                _util.setHeight(32),
                                _util.setWidth(32),
                                _util.setHeight(32),
                              ),
                              child: ImageIcon(
                                AssetImage(ImagePaths.icHamburger),
                                color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: _util.setWidth(48),
                              top: _util.setHeight(32),
                              bottom: _util.setHeight(32),
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
                                right: _util.setWidth(48),
                                top: _util.setHeight(32),
                                bottom: _util.setHeight(32),
                              ),
                              child: Image.asset(
                                ImagePaths.cross,
                                width: _util.setWidth(48),
                                height: _util.setHeight(48),
                                color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
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
              width: _util.setWidth(8),
            ),
            Text(
              'Cam $index',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: selectedCamIndex == index
                      ? ColorConstants.CAMERA_TITLE
                      : ColorConstants.CAMERA_ITEM_INACTIVE,
                  fontWeight: FontWeight.normal,
                  fontSize: _util.setSp(38.22)),
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
          // debugPrint('currentlySelectedCameraIndex 1--- ' +
          // currentlySelectedCameraIndex.index.toString());
          currentlySelectedCameraIndex = cameraIndex;
          // debugPrint('currentlySelectedCameraIndex --- ' +
          // currentlySelectedCameraIndex.index.toString());
        });
      }, //onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_util.setWidth(16)),
          color: currentlySelectedCameraIndex == cameraIndex
              ? ColorConstants.CAMERA_TITLE
              : ColorConstants.CAMERA_SLIDER_ITEM_BKG,
        ),
        margin: EdgeInsets.all(_util.setWidth(10)),

        width: _util.setWidth(405), //MediaQuery.of(context).size.width/3,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(_util.setWidth(16)),
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
                      // width: MediaQuery.of(context).size.width*.95,
                    ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: currentlySelectedCameraIndex == cameraIndex
                              ? ColorConstants.CAMERA_SLIDER_ITEM_SELECTED
                              : ColorConstants.CAMERA_SLIDER_ITEM,
                          fontWeight: FontWeight.normal,
                          fontSize: _util.setSp(38.22)),
                    )
                  ],
                ),
              ),
            ),
            cameraIndex == CAMERA.KITCHEN
                ? Positioned(
                    left: _util.setWidth(16),
                    bottom: _util.setHeight(16),
                    child: SvgPicture.asset(
                      ImagePaths.svgMovement,
                      fit: BoxFit.fitWidth,
                      color: currentlySelectedCameraIndex == cameraIndex
                          ? ColorConstants.CAMERA_SLIDER_MOVEMENT
                          : ColorConstants.CAMERA_SLIDER_MOVEMENT,
                      // width: MediaQuery.of(context).size.width*.95,
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
    // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    Navigator.of(context).pop();
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //     LandingScreen.routeName, (Route<dynamic> route) => false);
  }

  _getProfilePicture() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String path = prefs.getString(SharedPreferanceKeys.KEY_PROFILE_PIC);

    String path = await SharedPrefHelper.getProfilePicFilePath();

    if (path != null) {
      final File imageFile = File(path);
      if (await imageFile.exists()) {
        // Use the cached images if it exists
        setState(() {
          _profileImageFile = imageFile;
        });
      }
    }
  }
}

enum CAMERA { BEDROOM, KITCHEN, LIVING_ROOM, UNDERWATER_ROOM }
