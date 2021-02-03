import 'dart:math';

// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/storm_glass_data.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/models/w_weather_o_data.dart';
import 'package:ocean_builder/core/providers/drawer_state_data_provider.dart';
import 'package:ocean_builder/core/providers/fake_data_provider.dart';
import 'package:ocean_builder/core/providers/local_noti_data_provider.dart';
import 'package:ocean_builder/core/providers/storm_glass_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/providers/wow_data_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper_title.dart';
import 'package:ocean_builder/ui/screens/controls/control_screen.dart';
import 'package:ocean_builder/ui/screens/marine/marine_screen.dart';
import 'package:ocean_builder/ui/screens/notification/noti_history_screen.dart';
import 'package:ocean_builder/ui/screens/weather/weather_screen.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:ocean_builder/ui/widgets/home_appbar.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final int swiperIndex;

  const HomeScreen({this.swiperIndex});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();
  UserProvider _userProvider;
  User _user;
  // ScreenUtil _util = ScreenUtil();
  FakeDataProvider _fakeDataProvider;

  SwiperController _controller;
  SwiperDataProvider _swiperDataProvider;

  AnimationController _animationController;
  int _swipeIndex = 0;

  Future<StormGlassData> _futureWOWWeatherDataWeather;
  Future<StormGlassData> _futureWOWWeatherDataMarine;

  // FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await MethodHelper.selectOnlyOBasSelectedOB();

      // ###########################################################################

      _futureWOWWeatherDataMarine =
          Provider.of<StormGlassDataProvider>(context).fetchTodayWeatherData();
      _futureWOWWeatherDataWeather =
          Provider.of<StormGlassDataProvider>(context).fetchTodayWeatherData();
    });
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
    _controller = GlobalContext.swiperController;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    // _animation = Animation();

    _animationController.addListener(() {
      setState(() {});
    });

    _animationController.forward();

    if (widget.swiperIndex != null)
      _swipeIndex = widget.swiperIndex;
    else
      _swipeIndex = 0;

    super.initState();

    // analytics.setCurrentScreen(screenName: "/homeView");
  }

/*   Future<void> _sendAnalyticsEvent() async {
    FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    await analytics.logEvent(
      name: 'steering_click_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true,
      },
    ).then((onValue){

    });
    // setMessage('logEvent succeeded');
  } */

  @override
  void dispose() {
    super.dispose();
    GlobalContext.dashBoardBuildCount = 0;
  }


  @override
  Widget build(BuildContext context) {
    if (GlobalContext.dashBoardBuildCount == 0) {
      MethodHelper.parseNotifications(context);
      // MethodHelper.selectOnlyOBasSelectedOB();
      UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
      GlobalContext.dashBoardBuildCount++;
    }

    GlobalContext.currentScreenContext = context;
    _userProvider = Provider.of<UserProvider>(context);
    _user = _userProvider.authenticatedUser;
    _fakeDataProvider = Provider.of<FakeDataProvider>(context);
    _swiperDataProvider = Provider.of<SwiperDataProvider>(context);

    return _stackWithDrawerandBottomBar();
  }

//                 0        1         2        3       4
// order of swipe Home, Controls, Steering, Weather, Marine,
  _loadSwiper() {
    List<Widget> containerList = new List<Widget>();
    containerList.add(_mainContent());
    containerList.add(ControlScreen(
      scaffoldKey: _scaffoldKey,
    )); // 1
    containerList.add(WeatherScreen(
      scaffoldKey: _scaffoldKey,
    )); // 2
    containerList.add(MarineScreen(
      scaffoldKey: _scaffoldKey,
    )); // 3
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return containerList[index];
      },
      itemCount: containerList.length,
      controller: _controller,
      loop: true,
      onIndexChanged: (index) {
        _swipeIndex = index;
        _animationController.reset();
        Future.delayed(const Duration(milliseconds: 250), () {
          _animationController.forward();
          _swiperDataProvider.currentScreenIndex = index;
        });
      },
      index: _swipeIndex,
    );
  }

  _stackWithDrawerandBottomBar() {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: HomeDrawer(
          isSecondLevel: false,
          screenIndex: DrawerIndex.HOME,
        ),
        drawerScrimColor: AppTheme.drawerScrimColor.withOpacity(.65),
        body: Stack(
          children: <Widget>[
            _loadSwiper(), //_mainContent(),//customDrawer(_innerDrawerKey, _mainContent()),
            swiperStateConsumer()
          ],
        ),
      ),
    );
    // );
  }

  _mainContent() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.white),
          child: CustomScrollView(
            slivers: <Widget>[
              UIHelper.getTopEmptyContainer(400.h, false),
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: 16.h,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _towerOrientationWheelContainer(),
                      SizedBox(
                        height: 8.h,
                      ),
                      _slider(),
                      SizedBox(
                        height: 256.h,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        HomeAppbar(
          ScreenTitle.WELCOME,
          scaffoldKey: _scaffoldKey,
          innerDrawerKey: _innerDrawerKey,
          hasAvator: true,
        ),
        Positioned(
          top: 135.h,
          left: 0,
          right: 0,
          child: Row(
            children: <Widget>[
              Spacer(),
              notificationConsumer(),
            ],
          ),
        ),
      ],
    );
  }

//                 0        1         _        2       3
// order of swipe Home, Controls, Steering, Weather, Marine,
  _slider() {
    List<int> numbers = [1, 2, 3];

    return Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height * .27,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: numbers.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                width: MediaQuery.of(context).size.width * 0.33,
                child: _sliderItem(numbers[index]));
          },
        ));
  }

  _sliderItem(int index) {
    // Control

    if (index == 1) {
      // Control
      return InkWell(
        onTap: () {
          if (_swiperDataProvider.currentScreenIndex == 0)
            _controller.next(animation: true);
          else if (_swiperDataProvider.currentScreenIndex == 2)
            _controller.previous(animation: true);
          else
            _controller.move(NavigationContext.CONTROL, animation: true);
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: 8.w,
            right: 8.w,
          ),
          child: Container(
            decoration: BoxDecoration(
              image: new DecorationImage(
                  image: AssetImage(ImagePaths.bkgControl), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(
                48.w,
              ),
            ),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24.w,
                      ),
                      child: Text(
                        ScreenTitle.CONTROLS.toUpperCase(),
                        style: TextStyle(fontSize: 48.sp, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
                      child: Container(
                        color: Colors.white,
                        height: 2,
                      ),
                    ),
                  ],
                ),
                _titleandValueWithIcon(
                    ImagePaths.icDrinkingWaterLevels, 'DRINKING\nWATER', '50L'),
                _titleandValueWithIcon(ImagePaths.icInsideTemperature,
                    'TEMPERATURE\nINSIDE', '19${SymbolConstant.DEGREE}c'),
                _titleandValueWithIcon(
                    ImagePaths.icSolarBattery, 'BATTERY', '30%'),
              ],
            )),
          ),
        ),
      );
    } /* else if (index == 2) {
      // steering
      return InkWell(
        onTap: () {
        // _sendAnalyticsEvent();
          // _controller.move(NavigationContext.CONTROL,animation: true);
          Navigator.of(context).pushNamed(WebViewDarksky.routeName);

          // Navigator.of(context).pushNamed(EarthStationScreen.routeName);

        },
        child: Padding(
          padding: EdgeInsets.only(
            left: util.setWidth(8),
            right: util.setWidth(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              image: new DecorationImage(
                  image: AssetImage(ImagePaths.bkgSteering), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(
                util.setWidth(48),
              ),
            ),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        left: util.setWidth(24),
                        top: util.setHeight(32)
                      ),
                      child: Text(
                        ScreenTitle.STEERING.toUpperCase(),
                        style: TextStyle(
                            fontSize: util.setSp(48), color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: util.setHeight(16),
                          left: util.setWidth(16),
                          right: util.setWidth(16)),
                      child: Container(
                        color: Colors.white,
                        height: 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: util.setHeight(64),
                ),
                Center(
                  child:Padding(
                    padding: EdgeInsets.all(
                      util.setWidth(16)
                    ),
                    child: Text(
                          AppStrings.notAvailableRightNow,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: util.setSp(48), color: Colors.white),
                        ),
                  ),
                  )
              ],
            )),
          ),
        ),
      );
    } */
    else if (index == 2) {
      // weather
      return InkWell(
        onTap: () {
          _controller.move(NavigationContext.WEATHER, animation: true);
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: 8.w,
            right: 8.w,
          ),
          child: FutureBuilder<StormGlassData>(
              future: _futureWOWWeatherDataWeather,
              // initialData: stormGlassDataProvider.weatherDataToday,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? _weatherSliderItemData(
                        snapshot.data) //movieGrid(snapshot.data)
                    : Container(
                        decoration: BoxDecoration(
                          color: ColorConstants.TOP_CLIPPER_START,
                          borderRadius: BorderRadius.circular(
                            48.w,
                          ),
                        ),
                        child: Center(

                            // child: CircularProgressIndicator()
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 24.h,
                                    left: 24.w,
                                  ),
                                  child: Text(
                                    ScreenTitle.WEATHER.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 48.sp, color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 16.h, left: 16.w, right: 16.w),
                                  child: Container(
                                    color: Colors.white,
                                    height: 2,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 64.h,
                            ),
                            Center(child: CircularProgressIndicator())
                          ],
                        )));
              }),
        ),
      );
    } else if (index == 3) {
      return InkWell(
        onTap: () {
          _controller.move(NavigationContext.MARINE, animation: true);
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: 8.w,
            right: 8.w,
          ),
          child: Container(
            decoration: BoxDecoration(
              image: new DecorationImage(
                  image: AssetImage(ImagePaths.bkgMarine), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(
                48.w,
              ),
            ),
            child: Center(
                child: FutureBuilder<StormGlassData>(
                    future: _futureWOWWeatherDataMarine,
                    // initialData: stormGlassDataProvider.weatherDataToday,
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? _marineSliderItemData(
                              snapshot.data) //movieGrid(snapshot.data)
                          : Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 24.h,
                                        left: 24.w,
                                      ),
                                      child: Text(
                                        ScreenTitle.MARINE.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 48.sp,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 16.h, left: 16.w, right: 16.w),
                                      child: Container(
                                        color: Colors.white,
                                        height: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                SpaceH64(),
                                Center(child: CircularProgressIndicator())
                              ],
                            ));
                    })),
          ),
        ),
      );
    }
  }

  _titleandValueWithIcon(String iconPath, String title, String value,
      {bool isSvg = false}) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              right: 16.w,
            ),
            child: isSvg
                ? SvgPicture.asset(
                    iconPath,
                    color: Colors.white,
                    fit: BoxFit.scaleDown,
                    width: 64.w,
                    height: 64.w,
                  )
                : ImageIcon(
                    AssetImage(iconPath),
                    size: ScreenUtil().setWidth(64),
                    color: Colors.white,
                  ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  title,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  style: new TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24.sp,
                      color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                new Text(
                  value,
                  style: new TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 36.sp,
                      color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _towerOrientationWheelContainer() {
    double bkgRad =
        MediaQuery.of(context).size.height * 0.38; // util.setWidth(690);
    double movementRad = bkgRad * 0.70;

    var initTime = Random().nextInt(288);
    var endTime = Random().nextInt(288);
    return Container(
      // padding: EdgeInsets.all(8.0),
      color: Colors.white,
      // height: util.setHeight(200),
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: bkgRad,
              height: bkgRad,
              decoration: BoxDecoration(
                  image: new DecorationImage(
                      image: AssetImage(ImagePaths.bkgTowerOrientationWithDir),
                      fit: BoxFit.cover),
                  shape: BoxShape.rectangle),
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  // tower direction  ----------------------
                  Positioned(
                    top: 0.0,
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Transform.rotate(
                      angle: math.pi,
                      child: Container(
                        child: SingleCircularSlider(
                          90,
                          _fakeDataProvider.fakeData.insideTemperature != null
                              ? _fakeDataProvider.fakeData.insideTemperature
                              : 35,
                          primarySectors: 0,
                          secondarySectors: 0,
                          baseColor: Color(0xFFB4BFD6).withOpacity(.26),
                          selectionColor: Color(0xFFB4BFD6).withOpacity(.01),
                          handlerColor: Color(0xFF4A8CB8),
                          handlerRadius: 48.w,
                          handlerOutterRadius: 64.w,
                          onSelectionChange: _updateLabels,
                          showRoundedCapInSelection: true,
                          showHandlerOutter: false,
                          sliderStrokeWidth: 38.w,
                          child: Transform.rotate(
                            angle: math.pi,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    ' ${_fakeDataProvider.fakeData.insideTemperature}${SymbolConstant.DEGREE}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 172.sp,
                                      letterSpacing: 1.0,
                                      color: Color(0xFF08619D),
                                    ),
                                  ),
                                  Text(
                                    'NE',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 64.sp,
                                      letterSpacing: 0.0,
                                      color: Color(0xFF08619D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          shouldCountLaps: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateLabels(int init, int end, int laps) {
    setState(() {
      _fakeDataProvider.fakeData.insideTemperature = end;
    });
  }

  Widget notificationConsumer() {
    return Consumer<LocalNotiDataProvider>(
      builder: (context, localNotiDataProvider, child) {
        // notification count

        int notiNo =
            localNotiDataProvider.localNotification.unreadNotificationCount;
        bool isUnread = localNotiDataProvider.localNotification.isUnread;

        // // debugPrint("notificationConsumer  Total noti: $notiNo --- isUnread -- $isUnread");
        if (notiNo == null) notiNo = 0;
        // if (isUnread == null) isUnread = false;
        isUnread = false;
        return notificationWidget(context, notiNo, isUnread);
      },
    );
  }

  Widget swiperStateConsumer() {
    return Consumer<SwiperDataProvider>(
      builder: (context, swiperStateDataProvider, child) {
        String screnTitle = ScreenTitle.HOME, iconPath = ImagePaths.svgHomeIcon;
        switch (swiperStateDataProvider.currentScreenIndex) {
          case NavigationContext.HOME:
            screnTitle = ScreenTitle.HOME;
            iconPath = ImagePaths.svgHomeIcon;
            break;
          case NavigationContext.CONTROL:
            screnTitle = ScreenTitle.CONTROLS;
            iconPath = ImagePaths.svgControlIcon;
            break;
          case NavigationContext.WEATHER:
            screnTitle = ScreenTitle.WEATHER;
            iconPath = ImagePaths.svgWeatherIcon;
            break;
          case NavigationContext.MARINE:
            screnTitle = ScreenTitle.MARINE;
            iconPath = ImagePaths.svgMarineIcon;
            break;
          default:
        }
        return swiperStateDataProvider.currentScreenIndex == null
            ? Container()
            : _bottomBarWithTitle(screnTitle, iconPath);
      },
    );
  }

  Positioned _bottomBarWithTitle(String screnTitle, String iconPath) {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: BottomClipperTitle(
          screnTitle,
          iconPath,
          ButtonText.BACK,
          ButtonText.NEXT,
          () {
            _controller.previous(animation: true);
          },
          () {
            _controller.next(animation: true);
          },
          animationController: _animationController,
        ));
  }

  notificationWidget(BuildContext context, int notiNo, bool isUnread) {
    return InkWell(
      onTap: () {
        showNotificationHistoryPopup(
            context,
            NotificationHistoryScreenWidget(
              showOnlyUnreadNotifications: true,
            ),
            ScreenTitle.OB_EVENTS);
      },
      child: Container(
        // margin: EdgeInsets.only(right: 10.0),
        padding: EdgeInsets.all(24.h),
        decoration: BoxDecoration(
            color: isUnread ? Colors.red : ColorConstants.TOP_CLIPPER_START,
            shape: BoxShape.circle),
        child: Container(
          // width: 10.0,
          // height: 10.0,
          padding: EdgeInsets.all(16.h),
          alignment: Alignment.center,
          child: Text(
            notiNo.toString(),
            style: TextStyle(
                fontSize: ScreenUtil().setSp(48),
                color: Colors.white,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  showNotificationHistoryPopup(
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

  _marineSliderItemData(StormGlassData data) {
    if (data.hours == null)
      return Container(
        child: Center(
          child: Text(
            AppStrings.noData,
            style: TextStyle(
                fontSize: 48.w, color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
          ),
        ),
      );

    String _significantWave, _visibility, _tideHeight;

    for (var f in data.hours) {
      var date1 = DateTime.parse(f.time);

      var dDate = DateFormat('yMd').format(date1);
      var currentDate = DateFormat('yMd').format(DateTime.now());
      int currentHour = DateTime.now().hour;

      // if (f.hours.length < currentHour) currentHour = f.hours.length - 1;

      if (dDate.compareTo(currentDate) == 0) {
        // debugPrint('hours length -- ' +
        // f.hours.length.toString() +
        // ' -- current hour -- ' +
        // currentHour.toString());

        _significantWave = f.significantWaveList.attributeDataList[0].value
            .toString(); //f.hours[currentHour].significantWave;
        _visibility = f.visiblityList.attributeDataList[0].value
            .toString(); //f.hours[currentHour].visibility;

        _tideHeight = f.waveHeightList.attributeDataList[0].value.toString();
      } else {
        // debugPrint(' marine data  ------------   current date ---- $currentDate  ------------  ddate ------------ $dDate');
      }
    }

    if (_significantWave == null) {
      _significantWave = data
          .hours[0].significantWaveList.attributeDataList[0].value
          .toString();
      _visibility =
          data.hours[0].visiblityList.attributeDataList[0].value.toString();
      _tideHeight =
          data.hours[0].waveHeightList.attributeDataList[0].value.toString();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 24.w,
              ),
              child: Text(
                ScreenTitle.MARINE.toUpperCase(),
                style: TextStyle(fontSize: 48.sp, color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
              child: Container(
                color: Colors.white,
                height: 2,
              ),
            ),
          ],
        ),
        _titleandValueWithIcon(ImagePaths.icSignificantWave, 'SIGNIFICANT WAVE',
            '$_significantWave M'),
        _titleandValueWithIcon(
            ImagePaths.icVisibility, 'VISIBILITY', '$_visibility M'),
        _titleandValueWithIcon(
            ImagePaths.icSignificantWave, 'TIDE HEIGHT', '$_tideHeight M'),
      ],
    );
  }

  _weatherSliderItemData(StormGlassData data) {
    if (data.hours == null) {
      return Container(
        child: Center(
          child: Text(
            AppStrings.noData,
            style: TextStyle(
                fontSize: ScreenUtil().setWidth(48),
                color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
          ),
        ),
      );
    }

    String _weatherCondition,
        _weatherIconUrl,
        _temperature,
        _windSpeed,
        _biometricPressure,
        _weatherCode;

    for (var f in data.hours) {
      var date1 = DateTime.parse(f.time);

      var dDate = DateFormat('yMd').format(date1);
      var currentDate = DateFormat('yMd').format(DateTime.now());
      int currentHour = DateTime.now().hour;

      if (dDate.compareTo(currentDate) == 0) {
        _weatherCode = '113'; //f.hours[0].weatherCode;
        _weatherIconUrl = WeatherDescMap.weatherCodeMap[_weatherCode].last;
        _weatherCondition = WeatherDescMap.weatherCodeMap[_weatherCode].first;
        _windSpeed = f.windSpeedList.attributeDataList[0].value
            .toString(); //f.hours[0].windspeedKmph;
        _biometricPressure = f.barometricPressureList.attributeDataList[0].value
            .toString(); //f.hours[0].pressureInches;
        _temperature = f.airTemperatureList.attributeDataList[0].value
            .toString(); // //f.hours[0].tempC;
      }
    }

    if (_weatherCode == null) {
      _weatherCode = '113';
      _weatherIconUrl = WeatherDescMap.weatherCodeMap[_weatherCode].last;
      _weatherCondition = WeatherDescMap.weatherCodeMap[_weatherCode].first;
      _windSpeed =
          data.hours[0].windSpeedList.attributeDataList[0].value.toString();
      _biometricPressure = data
          .hours[0].barometricPressureList.attributeDataList[0].value
          .toString();
      _temperature = data.hours[0].airTemperatureList.attributeDataList[0].value
          .toString();
    }

    String wetherItemBkgImagePath = ImagePaths.bkgWeatherRainy;

    if (WeatherDescMap.stormyWeatherCodes.contains(_weatherCode)) {
      wetherItemBkgImagePath = ImagePaths.bkgWeatherStormy;
    } else if (WeatherDescMap.rainyWeatherCodes.contains(_weatherCode)) {
      wetherItemBkgImagePath = ImagePaths.bkgWeatherRainy;
    } else if (WeatherDescMap.stormyWeatherCodes.contains(_weatherCode)) {
      wetherItemBkgImagePath = ImagePaths.bkgWeatherCloudy;
    } else if (WeatherDescMap.foggyWeatherCodes.contains(_weatherCode)) {
      wetherItemBkgImagePath = ImagePaths.bkgWeatherFoggy;
    } else if (WeatherDescMap.sunnyCloudyWeatherCodes.contains(_weatherCode)) {
      wetherItemBkgImagePath = ImagePaths.bkgWeatherSunnyCloudy;
    } else if (WeatherDescMap.sunnyWeatherCodes.contains(_weatherCode)) {
      wetherItemBkgImagePath = ImagePaths.bkgWeatherBkgSunny;
    } else {
      wetherItemBkgImagePath = ImagePaths.bkgWeatherBkgSunny;
    }

    // debugPrint('_weatherCondition --- $_weatherCondition  ------  path   ' +
    // wetherItemBkgImagePath);

    return Container(
      decoration: BoxDecoration(
        image: new DecorationImage(
            image: AssetImage(wetherItemBkgImagePath), fit: BoxFit.fill),
        borderRadius: BorderRadius.circular(
          48.w,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 24.w,
                  ),
                  child: Text(
                    ScreenTitle.WEATHER.toUpperCase(),
                    style: TextStyle(fontSize: 48.sp, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
                  child: Container(
                    color: Colors.white,
                    height: 2,
                  ),
                ),
              ],
            ),
            _titleandValueWithIcon(_weatherIconUrl, '$_weatherCondition',
                '$_temperature ${SymbolConstant.DEGREE}c',
                isSvg: true),
            _titleandValueWithIcon(
                ImagePaths.icWind, 'WIND', '$_windSpeed KM/H'),
            _titleandValueWithIcon(
                ImagePaths.icPressure, 'PRESSURE', '$_biometricPressure'),
          ],
        ),
      ),
    );
  }
}
