import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/drawer_state_data_provider.dart';
import 'package:ocean_builder/core/providers/local_noti_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/ui/screens/accessManagement/access_management_screen.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/screens/menu/landing_screen.dart';
import 'package:ocean_builder/ui/screens/notification/noti_history_screen_with_drawer.dart';
import 'package:ocean_builder/ui/screens/profile/profile_screen.dart';
import 'package:ocean_builder/ui/screens/settings/settings_screen.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:ocean_builder/ui/widgets/drawer_topbar.dart';
import 'package:provider/provider.dart';

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

  // searchbar

  FloatingSearchBarController controller;

  static const historyLength = 50;

// The "raw" history that we don't access from the UI, prefilled with values
  List<String> _searchHistory = [
    'fuchsia',
    'flutter',
    'widgets',
    'resocoder',
  ];
// The filtered & ordered history that's accessed from the UI
  List<String> filteredSearchHistory;

// The currently searched-for term
  String selectedTerm;

  List<String> filterSearchTerms({
    @required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      // Reversed because we want the last added items to appear first in the UI
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      // This method will be implemented soon
      putSearchTermFirst(term);
      return;
    }
    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
    // Changes in _searchHistory mean that we have to update the filteredSearchHistory
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  @override
  void initState() {
    super.initState();
    setdDrawerListArray();
    // UIHelper.setStatusBarColor(color:ColorConstants.TOP_CLIPPER_START_DARK);

    // currentlySelectedDrawerIndex = widget.screenIndex;
    // debugPrint('current drawer index --------------------------------------------------------------------- ${ApplicationStatics.selectedScreenIndex}');
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
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

    return SizedBox(
      width: MediaQuery.of(context).size.width * .80,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppTheme.notWhite, 
        resizeToAvoidBottomInset: false,//.withOpacity(0.85),
        body: Stack(
          
          children: [_drawerContent(),buildFloatingSearchBar()]
          ), 
      ),
    );
  }
    Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
        margins: EdgeInsets.only(top:564.h,left: 48.w,right: 48.w),
        controller: controller,
        automaticallyImplyBackButton: false,
        closeOnBackdropTap: false,
        clearQueryOnClose: true,
        backgroundColor: AppTheme.notWhite,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: BorderSide(color: Color(0xFF84A4D3)),
        elevation: 0.0,
        // body: FloatingSearchBarScrollNotifier(
        //   child:SearchResultsListView(
        //     searchTerm: selectedTerm,
        //   ),
        // ),
        transition: CircularFloatingSearchBarTransition(),
// Bouncing physics for the search history
        physics: BouncingScrollPhysics(),
// Title is displayed on an unopened (inactive) search bar
        title: Text(
          selectedTerm ?? 'Search',
          style: Theme.of(context).textTheme.headline6.apply(color:ColorConstants
                                                  .TOP_CLIPPER_END_DARK ),
        ),
// Hint gets displayed once the search bar is tapped and opened
        hint: 'Type to Search in app',
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        // maxWidth: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) {
          // Call your model, bloc, controller here.
          setState(() {
            filteredSearchHistory = filterSearchTerms(filter: query);
          });
        },
        onSubmitted: (query) {
          setState(() {
            addSearchTerm(query);
            selectedTerm = query;
          });
          controller.close();
        },
        // Specify a custom transition to be used for
        // animating between opened and closed stated.
        actions: [
          // FloatingSearchBarAction(
          //   showIfOpened: false,
          //   child: CircularButton(
          //     icon: const Icon(Icons.place),
          //     onPressed: () {},
          //   ),
          // ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: true,
            color: ColorConstants.TOP_CLIPPER_END_DARK,
          ),
        ],
        // leadingActions: [
        //             CircularButton(
        //   tooltip: 'Back',
        //   size: 24,
        //   icon: Icon(Icons.arrow_back, color: Colors.black, size: 24),
        //   onPressed: () {
        //       setState(() {
        //         selectedTerm = null;
        //         controller.close();
        //       });
        //   },
        // )
        // ],
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(
                builder: (context) {
                  if (filteredSearchHistory.isEmpty &&
                      controller.query.isEmpty) {
                    return Container(
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Start searching',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    );
                  } else if (filteredSearchHistory.isEmpty) {
                    return ListTile(
                      title: Text(controller.query),
                      leading: const Icon(Icons.search),
                      onTap: () {
                        setState(() {
                          addSearchTerm(controller.query);
                          selectedTerm = controller.query;
                        });
                        controller.close();
                      },
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: filteredSearchHistory
                          .map(
                            (term) => ListTile(
                              title: Text(
                                term,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: const Icon(Icons.history),
                              trailing: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    deleteSearchTerm(term);
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  putSearchTermFirst(term);
                                  selectedTerm = term;
                                });
                                controller.close();
                              },
                            ),
                          )
                          .toList(),
                    );
                  }
                },
              ),
            ),
          );
        });
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
                  right: ScreenUtil().setWidth(32),
                ),
                child: Text(
                  _user != null
                      ? '${_user.firstName} ${_user.lastName}'
                      : ' ',
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
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(top:128.h),
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

class SearchResultsListView extends StatelessWidget {
   String searchTerm;

  SearchResultsListView({this.searchTerm});

  @override
  Widget build(BuildContext context) {
    final fsb = FloatingSearchBar.of(context);

    return searchTerm != null ? SizedBox(
      height: 200,
      child:Container(
        color: Colors.amber,
        child: Column(
          children: [
            Text("----nasdfasdf----",style: TextStyle(color: Colors.black),)
          ],
        ),
      )
      //  ListView(
      //   padding: EdgeInsets.only(top: fsb.height + fsb.margins.vertical),
        
      //   children: List.generate(
      //     5,
      //     (index) => ListTile(
      //       title: Text('$searchTerm search result'),
      //       subtitle: Text(index.toString()),
      //     ),
      //   ),
      // ),
    )
    :Container();
  }
}
