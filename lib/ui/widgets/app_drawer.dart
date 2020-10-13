import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/ocean_builder.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/screens/controls/control_screen.dart';
import 'package:ocean_builder/ui/screens/marine/marine_screen.dart';
import 'package:ocean_builder/ui/screens/menu/landing_screen.dart';
import 'package:ocean_builder/ui/screens/notification/noti_history_screen.dart';
import 'package:ocean_builder/ui/screens/profile/profile_screen.dart';
import 'package:ocean_builder/ui/screens/seapod_selection/ob_selection_widget_screen.dart';
import 'package:ocean_builder/ui/screens/settings/settings_screen.dart';
import 'package:ocean_builder/ui/screens/weather/weather_screen.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:ocean_builder/ui/shared/shared_pref_data.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  UserProvider _userProvider;
  User _user;
  final Gradient gradient;

  AppDrawer({this.gradient});

  Future<SeaPod> _oceanBuilderFuture;

  Future<File> _profileImageFile;

  SelectedOBIdProvider _selectedOBIdProvider;

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _userProvider = Provider.of<UserProvider>(context);
    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(_context);
    OceanBuilderProvider oceanBuilderProvider =
        Provider.of<OceanBuilderProvider>(context);
    _user = _userProvider.authenticatedUser;
    if (_user != null &&
        _user.userOceanBuilder != null &&
        _user.userOceanBuilder.length >= 1) {
      // if(_selectedOBIdProvider.selectedObId.length>3)
      if (!(_selectedOBIdProvider.selectedObId
              .compareTo(AppStrings.selectOceanBuilder) ==
          0))
        _oceanBuilderFuture = oceanBuilderProvider.getSeaPod(
            _selectedOBIdProvider.selectedObId, _userProvider);
      // else
      // _oceanBuilderFuture = oceanBuilderProvider.getOceanBuilder(_user.userOceanBuilder[0].oceanBuilderId);
    }

    _profileImageFile = _getProfilePicture();

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  _profilePicFuture(), //_createHeader(context),
                  _obNameFuture(),
                  _creteDivider(),
                  _drawerItemControls(context),
                  _drawerItemMarine(context),
                  _drawerItemWeather(context),
                  _drawerItemSteering(),
                  _drawerItemNotificationHistory(context),
                  _drawerItemAccessRequest(context),
                  _drawerItemSettings(context),
                  _drawerItemProfile(context),
                ],
              ),
            ),
            _drawerFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _drawerFooter(BuildContext context) {
    return _createDrawerFooter(onTap: () {
      _userProvider.signOut().then((onValue) {
        // Navigator.of(context).pushReplacementNamed(LandingScreen.routeName);
        _selectedOBIdProvider.selectedObId = AppStrings.selectOceanBuilder;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LandingScreen(),
              settings: RouteSettings(name: LandingScreen.routeName)),
          (Route<dynamic> route) => false,
        );
      });
    });
  }

  Widget _drawerItemProfile(BuildContext context) {
    return _createDrawerItem(
        iconPath: ImagePaths.icProfile,
        text: AppStrings.profile,
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(ProfileScreen.routeName);
        });
  }

  Widget _drawerItemSettings(BuildContext context) {
    return _createDrawerItem(
        iconPath: ImagePaths.icSettings,
        text: AppStrings.settings,
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(SettingsWidget.routeName);
        });
  }

  Widget _drawerItemAccessRequest(BuildContext context) {
    return _createDrawerItem(
      iconPath: ImagePaths.icAccessRequest,
      text: AppStrings.accessRequests,
      onTap: () {
        Navigator.of(context).pop();
        _showNotificationHistoryPopup(
            context,
            NotificationHistoryScreenWidget(
              showOnlyAccessRequests: true,
            ),
            ScreenTitle.OB_ACCESS_REQUESTS);
      },
      isInactive: _selectedOBIdProvider.selectedObId
              .compareTo(AppStrings.selectOceanBuilder) ==
          0,
    );
  }

  Widget _drawerItemNotificationHistory(BuildContext context) {
    return _createDrawerItem(
      iconPath: ImagePaths.icNotificationHistory,
      text: AppStrings.notiHistory,
      onTap: () {
        Navigator.of(context).pop();
        _showNotificationHistoryPopup(
            context, NotificationHistoryScreenWidget(), ScreenTitle.OB_EVENTS);
      },
    );
  }

  Widget _drawerItemSteering() {
    return _createDrawerItem(
      iconPath: ImagePaths.icSteering,
      text: AppStrings.steering,
      isInactive: _selectedOBIdProvider.selectedObId
              .compareTo(AppStrings.selectOceanBuilder) ==
          0,
    );
  }

  Widget _drawerItemWeather(BuildContext context) {
    return _createDrawerItem(
      iconPath: ImagePaths.icWeather,
      text: AppStrings.weather,
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(WeatherScreen.routeName);
      },
      isInactive: _selectedOBIdProvider.selectedObId
              .compareTo(AppStrings.selectOceanBuilder) ==
          0,
    );
  }

  Widget _drawerItemMarine(BuildContext context) {
    return _createDrawerItem(
      iconPath: ImagePaths.icMarine,
      text: AppStrings.marine,
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(MarineScreen.routeName);
      },
      isInactive: _selectedOBIdProvider.selectedObId
              .compareTo(AppStrings.selectOceanBuilder) ==
          0,
    );
  }

  Widget _drawerItemControls(BuildContext context) {
    return _createDrawerItem(
      iconPath: ImagePaths.icControls,
      text: AppStrings.controls,
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(ControlScreen.routeName);
      },
      isInactive: _selectedOBIdProvider.selectedObId
              .compareTo(AppStrings.selectOceanBuilder) ==
          0,
    );
  }

  Widget _obNameFuture() {
    return FutureBuilder(
      future: _oceanBuilderFuture,
      builder: (context, snapshot) {
        OceanBuilder oceanBuilder;
        if (snapshot.hasData) {
          oceanBuilder = snapshot.data;
          // debugPrint('ocean builder ---n ${oceanBuilder.obName}');
        }
        // debugPrint('selected id  - ${_selectedOBIdProvider.selectedObId}');
        return snapshot.hasData
            ? _createDrawerItemWithTitle(
                icon: Icons.person,
                text: oceanBuilder.obName,
                title: 'Currently managing (tap to switch)',
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                      OBSelectionScreenWidgetModal.routeName);
                }) //movieGrid(snapshot.data)
            : _createDrawerItemWithTitle(
                icon: Icons.person,
                text: _selectedOBIdProvider.selectedObId
                            .compareTo(AppStrings.selectOceanBuilder) ==
                        0
                    ? AppStrings.selectOceanBuilder
                    : MethodHelper.getVesselCode(
                        _selectedOBIdProvider.selectedObId), //'Select One',
                title: 'Currently managing (tap to select)',
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                      OBSelectionScreenWidgetModal.routeName);
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

  _showNotificationHistoryPopup(
      BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 12,
        left: 12,
        right: 12,
        bottom: 12,
        child: widget,
      ),
    );
  }

  Widget _creteDivider() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Divider(
        color: Colors.blueGrey,
        height: 2,
      ),
    );
  }

  Widget _createHeader(BuildContext context, {File imageFile}) {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          gradient: gradient != null
              ? gradient
              : LinearGradient(colors: [
                  ColorConstants.TOP_CLIPPER_START,
                  ColorConstants.TOP_CLIPPER_END
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 16.0,
              left: 16.0,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(ProfileScreen.routeName);
                },
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 100.w,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 100.w,
                        backgroundImage: imageFile != null
                            ? FileImage(
                                imageFile,
                              )
                            : AssetImage(
                                ImagePaths.icProfile,
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                        _user != null
                            ? '${_user.firstName} ${_user.lastName}'
                            : ' ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 64.sp,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              )),
        ]));
  }

  Future<File> _getProfilePicture() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String path = prefs.getString(SharedPreferanceKeys.KEY_PROFILE_PIC);

    String path = await SharedPrefHelper.getProfilePicFilePath();

    if (path != null) {
      final File imageFile = File(path);
      if (await imageFile.exists()) {
        // Use the cached images if it exists
        return imageFile;
      }
    }
  }

  Widget _createDrawerFooter({GestureTapCallback onTap}) {
    return Container(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
                child: Column(
              children: <Widget>[
                ListTile(
                  leading: ImageIcon(
                    AssetImage(ImagePaths.icLogout),
                    size: 96.w,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    AppStrings.logout,
                    style: TextStyle(
                        fontSize: 48.sp,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w700),
                  ),
                  onTap: onTap,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/logo_new version.png',
                      fit: BoxFit.scaleDown,
                    )
                  ],
                )
              ],
            ))));
  }

  Widget _createDrawerItem(
      {String iconPath,
      String text,
      GestureTapCallback onTap,
      bool isInactive = false}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          ImageIcon(
            AssetImage(iconPath),
            size: 96.w,
            color: ColorConstants.TOP_CLIPPER_START,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 48.sp,
                    color: isInactive
                        ? ColorConstants.CONTROL_END
                        : ColorConstants.TOP_CLIPPER_END),
              ),
            ),
          )
        ],
      ),
      onTap: isInactive
          ? () {
              showInfoBar(
                'Select an SeaPod',
                'Currently you are not managing any SeaPod,please select one.',
                _context,
              );
            }
          : onTap,
    );
  }

  Widget _createDrawerItemWithTitle(
      {IconData icon, String text, String title, GestureTapCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 48.sp),
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  ImagePaths.svgSeapod,
                  color: ColorConstants.TOP_CLIPPER_START,
                  width: 128.h,
                  height: 128.h,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 64.sp, color: ColorConstants.TOP_CLIPPER_START),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
