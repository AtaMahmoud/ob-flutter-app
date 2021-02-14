import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/drawer_state_data_provider.dart';
import 'package:ocean_builder/core/providers/local_noti_data_provider.dart';
import 'package:ocean_builder/core/providers/selected_search_history_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/search/appSearchScreen.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/ui/screens/accessManagement/access_management_screen.dart';
import 'package:ocean_builder/ui/screens/controls/control_screen.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/screens/marine/marine_screen.dart';
import 'package:ocean_builder/ui/screens/menu/landing_screen.dart';
import 'package:ocean_builder/ui/screens/notification/noti_history_screen_with_drawer.dart';
import 'package:ocean_builder/ui/screens/profile/profile_screen.dart';
import 'package:ocean_builder/ui/screens/settings/settings_screen.dart';
import 'package:ocean_builder/ui/screens/weather/weather_screen.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:ocean_builder/ui/widgets/drawer_topbar.dart';
import 'package:provider/provider.dart';
import 'package:ocean_builder/core/models/search_item.dart';

class HomeDrawer extends StatefulWidget {
  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;
  final bool isSecondLevel;
  HomeDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex,
      this.isSecondLevel})
      : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserProvider _userProvider;
  SelectedOBIdProvider _selectedOBIdProvider;
  SwiperDataProvider _swiperDataProvider;

  User _user;

  List<DrawerList> drawerList;
  List<DrawerList> drawerList2;

  bool _expandAccessManagement = false;

  // ---------------------------

  @override
  void initState() {
    super.initState();

    setdDrawerListArray();
    // UIHelper.setStatusBarColor(color:ColorConstants.TOP_CLIPPER_START_DARK);

    // currentlySelectedDrawerIndex = widget.screenIndex;
    // debugPrint('current drawer index --------------------------------------------------------------------- ${ApplicationStatics.selectedScreenIndex}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  //----------------------------

  void setdDrawerListArray() {
    drawerList = [
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: AppStrings.home,
        isAssetsImage: true,
        imageName: ImagePaths.svgHomeIcon,
      ),
      DrawerList(
        index: DrawerIndex.CONTROLS,
        labelName: AppStrings.controls,
        isAssetsImage: true,
        imageName: ImagePaths.svgIcDrawerControls,
      ),
      DrawerList(
        index: DrawerIndex.STEERING,
        labelName: AppStrings.steering,
        isAssetsImage: true,
        imageName: ImagePaths.svgIcDrawerSteering,
      ),
      DrawerList(
        index: DrawerIndex.WEATHER,
        labelName: AppStrings.weather,
        isAssetsImage: true,
        imageName: ImagePaths.svgIcDrawerWeather,
      ),
      DrawerList(
        index: DrawerIndex.MARINE,
        labelName: AppStrings.marine,
        isAssetsImage: true,
        imageName: ImagePaths.svgIcDrawerMarine,
      ),

      // divider
      DrawerList(
        index: DrawerIndex.NOTIFICATIONS,
        labelName: AppStrings.notifications,
        isAssetsImage: true,
        imageName: ImagePaths.svgIcDrawerNotiHistory,
      ),
      DrawerList(
        index: DrawerIndex.ACCESS_MANAGEMENT,
        labelName: AppStrings.seapodManagement,
        isAssetsImage: true,
        imageName: ImagePaths.svgIcDrawerManagement,
      ),
      DrawerList(
        index: DrawerIndex.SETTINGS,
        labelName: AppStrings.settings,
        isAssetsImage: true,
        imageName: ImagePaths.svgIcDrawerSettings,
      ),
      DrawerList(
        index: DrawerIndex.PROFILE,
        labelName: AppStrings.profile,
        isAssetsImage: true,
        imageName: ImagePaths.svgIcDrawerProfile,
      ),
      DrawerList(
        index: DrawerIndex.LOGOUT,
        labelName: AppStrings.logout,
        isAssetsImage: true,
        imageName: ImagePaths.svgIcDrawerLogout,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);
    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);
    _swiperDataProvider = Provider.of<SwiperDataProvider>(context);
    _user = _userProvider.authenticatedUser;

    var _selectedAppItemDb =
        Provider.of<SelectedAppItemProvider>(context, listen: false);
    _selectedAppItemDb.getItem();

    return SizedBox(
      width: MediaQuery.of(context).size.width * .80,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppTheme.notWhite,
        resizeToAvoidBottomInset: false, //.withOpacity(0.85),
        body: _drawerContent(),
      ),
    );
  }

  Column _drawerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Drawerbar(
                  scaffoldKey: _scaffoldKey,
                  hasAvator: true,
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                // top: ScreenUtil().setHeight(8),
                right: ScreenUtil().setWidth(48),
              ),
              child: Text(
                _user != null ? '${_user.firstName} ${_user.lastName}' : ' ',
                style: TextStyle(
                  color: Color(0xFF0C48A4),
                  fontSize: ScreenUtil().setSp(48), //20.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        _searchButton(),
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 16.h),
            itemCount: drawerList.length,
            itemBuilder: (context, index) {
              if (index == 4) {
                return Column(
                  children: <Widget>[
                    inkwell(index),
                    Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(48),
                        right: ScreenUtil().setWidth(48),
                        // top:ScreenUtil().setHeight(72),
                        // bottom:ScreenUtil().setHeight(72)
                      ),
                      child: Container(
                        height: ScreenUtil().setHeight(4),
                        color: AppTheme.divider,
                      ),
                    )
                  ],
                );
              }
              return inkwell(index);
            },
          ),
        ),
      ],
    );
  }

  Widget inkwell(int index) {
    DrawerList listData = drawerList[index];
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          if (!(_selectedOBIdProvider.selectedObId
                      .compareTo(AppStrings.selectOceanBuilder) ==
                  0 &&
              index < 5)) {
            ApplicationStatics.selectedScreenIndex = listData.index;
            if (listData.index != DrawerIndex.ACCESS_MANAGEMENT)
              navigationtoScreen(listData.index);
          }
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(18),
                bottom: ScreenUtil().setHeight(18),
              ),
              child: listData.index == DrawerIndex.ACCESS_MANAGEMENT
                  ? Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (_expandAccessManagement)
                                _expandAccessManagement = false;
                              else
                                _expandAccessManagement = true;
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 6.0,
                                height: ScreenUtil().setHeight(96),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setWidth(16)),
                              ),
                              listData.isAssetsImage
                                  ? Container(
                                      width: ScreenUtil().setWidth(72),
                                      height: ScreenUtil().setWidth(72),
                                      child: SvgPicture.asset(
                                          listData.imageName,
                                          color: ApplicationStatics
                                                      .selectedScreenIndex ==
                                                  listData.index
                                              ? ColorConstants
                                                  .TOP_CLIPPER_END_DARK
                                              : AppTheme.listItem))
                                  : new Icon(listData.icon.icon,
                                      color: ApplicationStatics
                                                  .selectedScreenIndex ==
                                              listData.index
                                          ? ColorConstants.TOP_CLIPPER_END_DARK
                                          : AppTheme.listItem),
                              Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setWidth(16)),
                              ),
                              (listData.index == DrawerIndex.NOTIFICATIONS) ||
                                      (listData.index ==
                                          DrawerIndex.ACCESS_MANAGEMENT)
                                  ? notificationConsumer(listData)
                                  : Text(
                                      listData.labelName,
                                      style: new TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(36),
                                        color: ApplicationStatics
                                                    .selectedScreenIndex ==
                                                listData.index
                                            ? (_selectedOBIdProvider
                                                            .selectedObId
                                                            .compareTo(AppStrings
                                                                .selectOceanBuilder) ==
                                                        0 &&
                                                    index < 5)
                                                ? Colors.grey
                                                : ColorConstants
                                                    .TOP_CLIPPER_END_DARK
                                            : (_selectedOBIdProvider
                                                            .selectedObId
                                                            .compareTo(AppStrings
                                                                .selectOceanBuilder) ==
                                                        0 &&
                                                    index < 5)
                                                ? Colors.grey
                                                : AppTheme.listItem,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                            ],
                          ),
                        ),
                        // expanded access management
                        _expandAccessManagement
                            ? Padding(
                                padding: EdgeInsets.only(left: 16.w),
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        navigationtoScreen(listData.index);
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: ScreenUtil().setWidth(72),
                                            height: ScreenUtil().setHeight(72),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setWidth(16)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setWidth(16)),
                                          ),
                                          Text(
                                            'Access management'.toUpperCase(),
                                            style: new TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: ScreenUtil().setSp(32),
                                              color: ApplicationStatics
                                                          .selectedScreenIndex ==
                                                      listData.index
                                                  ? (_selectedOBIdProvider
                                                                  .selectedObId
                                                                  .compareTo(
                                                                      AppStrings
                                                                          .selectOceanBuilder) ==
                                                              0 &&
                                                          index < 5)
                                                      ? Colors.grey
                                                      : ColorConstants
                                                          .TOP_CLIPPER_END_DARK
                                                  : (_selectedOBIdProvider
                                                                  .selectedObId
                                                                  .compareTo(
                                                                      AppStrings
                                                                          .selectOceanBuilder) ==
                                                              0 &&
                                                          index < 5)
                                                      ? Colors.grey
                                                      : AppTheme.listItem,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: ScreenUtil().setWidth(72),
                                            height: ScreenUtil().setHeight(72),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setWidth(16)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setWidth(16)),
                                          ),
                                          Text(
                                            'Seapod Condition'.toUpperCase(),
                                            style: new TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: ScreenUtil().setSp(32),
                                              color: ApplicationStatics
                                                          .selectedScreenIndex ==
                                                      listData.index
                                                  ? (_selectedOBIdProvider
                                                                  .selectedObId
                                                                  .compareTo(
                                                                      AppStrings
                                                                          .selectOceanBuilder) ==
                                                              0 &&
                                                          index < 5)
                                                      ? Colors.grey
                                                      : ColorConstants
                                                          .TOP_CLIPPER_END_DARK
                                                  : (_selectedOBIdProvider
                                                                  .selectedObId
                                                                  .compareTo(
                                                                      AppStrings
                                                                          .selectOceanBuilder) ==
                                                              0 &&
                                                          index < 5)
                                                      ? Colors.grey
                                                      : AppTheme.listItem,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: ScreenUtil().setWidth(72),
                                            height: ScreenUtil().setHeight(72),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setWidth(16)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setWidth(16)),
                                          ),
                                          Text(
                                            'Bookkeeping'.toUpperCase(),
                                            style: new TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: ScreenUtil().setSp(32),
                                              color: ApplicationStatics
                                                          .selectedScreenIndex ==
                                                      listData.index
                                                  ? (_selectedOBIdProvider
                                                                  .selectedObId
                                                                  .compareTo(
                                                                      AppStrings
                                                                          .selectOceanBuilder) ==
                                                              0 &&
                                                          index < 5)
                                                      ? Colors.grey
                                                      : ColorConstants
                                                          .TOP_CLIPPER_END_DARK
                                                  : (_selectedOBIdProvider
                                                                  .selectedObId
                                                                  .compareTo(
                                                                      AppStrings
                                                                          .selectOceanBuilder) ==
                                                              0 &&
                                                          index < 5)
                                                      ? Colors.grey
                                                      : AppTheme.listItem,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(), // if not expanded
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        Container(
                          width: 6.0,
                          height: ScreenUtil().setHeight(96),
                        ),
                        Padding(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                        ),
                        listData.isAssetsImage
                            ? Container(
                                width: ScreenUtil().setWidth(72),
                                height: ScreenUtil().setWidth(72),
                                child: SvgPicture.asset(listData.imageName,
                                    color: ApplicationStatics
                                                .selectedScreenIndex ==
                                            listData.index
                                        ? ColorConstants.TOP_CLIPPER_END_DARK
                                        : AppTheme.listItem),
                              )
                            : new Icon(listData.icon.icon,
                                color: ApplicationStatics.selectedScreenIndex ==
                                        listData.index
                                    ? ColorConstants.TOP_CLIPPER_END_DARK
                                    : AppTheme.listItem),
                        Padding(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                        ),
                        (listData.index == DrawerIndex.NOTIFICATIONS) ||
                                (listData.index ==
                                    DrawerIndex.ACCESS_MANAGEMENT)
                            ? notificationConsumer(listData)
                            : Text(
                                listData.labelName,
                                style: new TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: ScreenUtil().setSp(36),
                                  color: ApplicationStatics
                                              .selectedScreenIndex ==
                                          listData.index
                                      ? (_selectedOBIdProvider.selectedObId
                                                      .compareTo(AppStrings
                                                          .selectOceanBuilder) ==
                                                  0 &&
                                              index < 5)
                                          ? Colors.grey
                                          : ColorConstants.TOP_CLIPPER_END_DARK
                                      : (_selectedOBIdProvider.selectedObId
                                                      .compareTo(AppStrings
                                                          .selectOceanBuilder) ==
                                                  0 &&
                                              index < 5)
                                          ? Colors.grey
                                          : AppTheme.listItem,
                                ),
                                textAlign: TextAlign.left,
                              ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget notificationConsumer(DrawerList listData) {
    return Consumer<LocalNotiDataProvider>(
      builder: (context, localNotiDataProvider, child) {
        // notification count

        int notiNo =
            localNotiDataProvider.localNotification.unreadNotificationCount ??
                0;
        int unreadAccessReqNo =
            localNotiDataProvider.localNotification.unreadAccessRequestCount ??
                0;
        bool isUnread =
            localNotiDataProvider.localNotification.isUnread ?? false;

        if (notiNo == null) notiNo = 0;
        if (isUnread == null) isUnread = false;
        return listData.index == DrawerIndex.NOTIFICATIONS
            ? Text(
                '${listData.labelName} ($notiNo)',
                style: new TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: ScreenUtil().setSp(36),
                  color: isUnread
                      ? Color(0xFFCC3B3B)
                      : ApplicationStatics.selectedScreenIndex == listData.index
                          ? ColorConstants.TOP_CLIPPER_END_DARK
                          : AppTheme.listItem,
                ),
                textAlign: TextAlign.left,
              )
            : Text(
                '${listData.labelName} ($unreadAccessReqNo)',
                style: new TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: ScreenUtil().setSp(36),
                  color: unreadAccessReqNo > 0
                      ? Color(0xFFCC3B3B)
                      : ApplicationStatics.selectedScreenIndex == listData.index
                          ? ColorConstants.TOP_CLIPPER_END_DARK
                          : AppTheme.listItem,
                ),
                textAlign: TextAlign.left,
              );
      },
    );
  }

  void navigationtoScreen(DrawerIndex drawerIndexdata) async {
    DrawerIndex drawerIndex = drawerIndexdata;
    if (drawerIndex == DrawerIndex.HOME) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
    if (drawerIndex == DrawerIndex.CONTROLS) {
      if (widget.isSecondLevel) {
        _swiperDataProvider.currentScreenIndex = 1;
        Navigator.of(context)
            .pushReplacementNamed(HomeScreen.routeName, arguments: 1);
      } else {
        Navigator.of(context).pop();
        GlobalContext.swiperController
            .move(NavigationContext.CONTROL, animation: false);
      }
    } else if (drawerIndex == DrawerIndex.WEATHER) {
      if (widget.isSecondLevel) {
        _swiperDataProvider.currentScreenIndex = 3;
        Navigator.of(context)
            .pushReplacementNamed(HomeScreen.routeName, arguments: 3);
      } else {
        Navigator.of(context).pop();
        GlobalContext.swiperController
            .move(NavigationContext.WEATHER, animation: false);
      }
    } else if (drawerIndex == DrawerIndex.MARINE) {
      if (widget.isSecondLevel) {
        _swiperDataProvider.currentScreenIndex = 2;
        Navigator.of(context)
            .pushReplacementNamed(HomeScreen.routeName, arguments: 2);
      } else {
        Navigator.of(context).pop();
        GlobalContext.swiperController
            .move(NavigationContext.MARINE, animation: false);
      }
    } else if (drawerIndex == DrawerIndex.ACCESS_MANAGEMENT) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(AccessManagementScreen.routeName);
    } else if (drawerIndex == DrawerIndex.NOTIFICATIONS) {
      Navigator.of(context).pop();
      Navigator.of(context)
          .pushNamed(NotificationHistoryScreen.routeName, arguments: false);
    } else if (drawerIndex == DrawerIndex.SETTINGS) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(SettingsWidget.routeName);
    } else if (drawerIndex == DrawerIndex.PROFILE) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(ProfileScreen.routeName);
    } else if (drawerIndex == DrawerIndex.LOGOUT) {
      _userProvider.signOut().then((onValue) {
        _selectedOBIdProvider.selectedObId = AppStrings.selectOceanBuilder;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LandingScreen(),
              settings: RouteSettings(name: LandingScreen.routeName)),
          (Route<dynamic> route) => false,
        );
      });
    }
  }
  // }

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

  _searchButton() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 48.w, vertical: 24.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(64.w),
            border:
                Border.all(color: ColorConstants.COLOR_NOTIFICATION_DIVIDER),
            color: AppTheme.notWhite),
        child: InkWell(
          onTap: () async {
            // Navigator.of(context).pop();
            var result =
                await Navigator.pushNamed(context, AppSearchScreen.routeName);
            print('result ---------- $result');
            SearchItem s = result;
            if (s != null) {
              if (s.routeName.compareTo(ControlScreen.routeName) == 0) {
                Navigator.pop(context);
                navigationtoScreen(DrawerIndex.CONTROLS);
                // Navigator.of(context)
                // .pushReplacementNamed(HomeScreen.routeName, arguments: 1);
              } else if (s.routeName.compareTo(WeatherScreen.routeName) == 0) {
                navigationtoScreen(DrawerIndex.WEATHER);

                // Navigator.of(context)
                //     .pushReplacementNamed(HomeScreen.routeName, arguments: 2);
              } else if (s.routeName.compareTo(MarineScreen.routeName) == 0) {
                navigationtoScreen(DrawerIndex.MARINE);
                // Navigator.of(context)
                // .pushReplacementNamed(HomeScreen.routeName, arguments: 3);
              } else
                Navigator.pushNamed(context, s.routeName);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 36.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Search",
                    style: Theme.of(context).textTheme.button.apply(
                          color: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
                        )),
                Icon(
                  Icons.search,
                  color: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
                ),
              ],
            ),
          ),
        )
        // ListTile(
        //   dense: true,
        //   title: Text("Search",
        //       style: Theme.of(context).textTheme.button.apply(
        //             color: ColorConstants.TOP_CLIPPER_END_DARK,
        //           )),
        //   trailing: const Icon(Icons.search),
        //   onTap: () {
        //     // Navigator.of(context).pop();
        //     Navigator.pushNamed(context, AppSearchScreen.routeName);
        //   },
        // ),
        );
  }
}

enum DrawerIndex {
  HOME,
  CONTROLS,
  MARINE,
  WEATHER,
  STEERING,
  NOTIFICATIONS,
  ACCESS_MANAGEMENT,
  SETTINGS,
  PROFILE,
  LOGOUT
}

class DrawerList {
  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;

  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });
}
