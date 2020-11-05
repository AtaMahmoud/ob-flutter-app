import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/bloc/manage_permission_screen_data_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/permission.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/screens/permission/create_permission_screen.dart';
import 'package:ocean_builder/ui/screens/permission/edit_permission_screen.dart';
import 'package:ocean_builder/ui/shared/drop_downs.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/progress_indicator.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class ManagePermissionScreen extends StatefulWidget {
  static const String routeName = '/managePermissionScreen';

  // final OceanBuilderUser oceanBuilderUser;

  const ManagePermissionScreen();

  @override
  _ManagePermissionScreenState createState() => _ManagePermissionScreenState();
}

class _ManagePermissionScreenState extends State<ManagePermissionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ManagePermissionScreenDataBloc _bloc = ManagePermissionScreenDataBloc();

  String permissionSet;

  OceanBuilderProvider _oceanBuilderProvider;
  SelectedOBIdProvider _selectedOBIdProvider;

  UserProvider _userProvider;

  Future<SeaPod> _oceanBuildeFuture;

  User _user;

  @override
  void initState() {
    super.initState();
    _bloc.selectedSeapodController.listen((onData) {});
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);
    _oceanBuilderProvider = Provider.of<OceanBuilderProvider>(context);
    _userProvider = Provider.of<UserProvider>(context);
    _user = _userProvider.authenticatedUser;

    _oceanBuildeFuture = _oceanBuilderProvider.getSeaPod(
        _selectedOBIdProvider.selectedObId, _userProvider);

    if (!mounted)
      MethodHelper.parseNotifications(GlobalContext.currentScreenContext);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        // resizeToAvoidBottomPadding: true,
        drawer: HomeDrawer(
          isSecondLevel: true,
          screenIndex: DrawerIndex.ACCESS_MANAGEMENT,
        ),
        drawerScrimColor: AppTheme.drawerScrimColor.withOpacity(.65),
        body: Stack(
          children: [
            _mainContent(userProvider),
            _oceanBuilderProvider.isLoading ? _progressIndicator() : Container()
          ],
        ),
      ),
    );
  }

  CustomScrollView _mainContent(UserProvider userProvider) {
    return CustomScrollView(
      slivers: <Widget>[
        _topBar(),
        _dropDownSeaPod(),
        userProvider.isLoading
            ? ProgressIndicatorBoxAdapter()
            : _permissionSetItemsFuture(),
        _buttonCreate(),
        _endSpace(),
      ],
    );
  }

  Positioned _progressIndicator() {
    return Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        bottom: 0.0,
        child: Center(
          child: CircularProgressIndicator(),
        ));
  }

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  SliverToBoxAdapter _buttonCreate() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 32.w,
        vertical: 32.h,
      ),
      child: _createNewButtonWidget(),
    ));
  }

  SliverPadding _dropDownSeaPod() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 64.h),
      sliver: SliverToBoxAdapter(
        child: getDropdown(getSeaPodList(), _bloc.selectedSeaPodId,
            _bloc.selectedSeaPodIdChanged, true,
            label: 'SeaPods'),
      ),
    );
  }

  _topBar() {
    UIHelper.defaultSliverAppbar(_scaffoldKey, goBack,
        screnTitle: ScreenTitle.MANAGE_PERMISSIONS);
  }

  _permissionSetItemsFuture() {
    return FutureBuilder<SeaPod>(
        future: _oceanBuildeFuture,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _obPermissionListWidget(snapshot.data)
              : SliverList(
                  delegate: new SliverChildBuilderDelegate(
                    (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 32.h,
                        ),
                        child: Text(
                          'Loading ...',
                          style: TextStyle(
                              fontSize: 32.sp,
                              color:
                                  ColorConstants.ACCESS_MANAGEMENT_LIST_TITLE),
                        ),
                      );
                    },
                    childCount: 1,
                  ),
                );
        });
  }

  _obPermissionListWidget(SeaPod ob) {
    return new SliverList(
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final int itemIndex = index ~/ 2;
          if (index.isEven) {
            PermissionSet pemissionSet = ob.permissionSets[
                itemIndex]; //ListHelper.getPermissionList()[itemIndex];
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 32.w,
                vertical: 64.h,
              ),
              child: _permissionItem(pemissionSet, ob),
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 32.w,
            ),
            child: Divider(
              height: 0,
              color: ColorConstants.WEATHER_BKG_CIRCLE,
              thickness: 1,
            ),
          );
        },
        semanticIndexCallback: (Widget widget, int localIndex) {
          if (localIndex.isEven) {
            return localIndex ~/ 2;
          }
          return null;
        },
        childCount: math.max(0, ob.permissionSets.length * 2 - 1),
      ),
    );
  }

  _permissionItem(PermissionSet permissionSet, SeaPod oceanBuilder) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 8.w,
            ),
            Container(
              child: Expanded(
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).pushNamed(
                    //     EditPermissionScreen.routeName,
                    //     arguments: permissionSet);
                    _goToEditPermissionScreen(permissionSet);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: Text(
                      permissionSet.permissionSetName,
                      style: TextStyle(
                          fontSize: 42.sp,
                          color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
                    ),
                  ),
                ),
              ),
            ),
            UIHelper.getButton('DELETE', () {
              // on tap
              _oceanBuilderProvider
                  .deletePermission(
                      _selectedOBIdProvider.selectedObId, permissionSet.id)
                  .then((responseStatus) {
                if (responseStatus.status == 200) {
                  _userProvider.autoLogin().then((value) {
                    setState(() {
                      print('reload screen after successful delete');
                    });
                  });
                } else {
                  showInfoBar(
                      'Delete Permission', responseStatus.message, context);
                }
              });
            }, w: 256.w, fontSize: 42.sp, borderRadius: 96.h, gradientColors: [
              ColorConstants.TOP_CLIPPER_END_DARK,
              ColorConstants.TOP_CLIPPER_END_DARK
            ])
          ],
        ),
      ],
    );
  }

  _createNewButtonWidget() {
    return InkWell(
      onTap: () {
        // Navigator.of(context).pushNamed(CreatePermissionScreen.routeName);

        _goToCreatePermissionScreen();
      },
      child: Container(
        // height: h,
        // width: MediaQuery.of(context).size.width * .4,
        padding: EdgeInsets.symmetric(
          horizontal: 32.w,
          vertical: 32.h,
        ),
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(72.w),
            color: ColorConstants.TOP_CLIPPER_END_DARK),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ImageIcon(
              AssetImage(ImagePaths.icAdd),
              color: Colors.white,
            ),
            SizedBox(
              width: 8.w,
            ),
            Text(
              'CREATE NEW',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 36.sp),
            ),
          ],
        )),
      ),
    );
  }

  goBack() {
    Navigator.pop(context);
  }

  void _goToCreatePermissionScreen() async {
    var result = await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => new CreatePermissionScreen(),
          fullscreenDialog: true,
        ));

    debugPrint(
        '------------------------- come back from creat permission screen  new permission created $result ------------------------------');
    if (result) {
      setState(() {
        print(
            'reload manager permission screen with newcly created permission');
      });
    }
  }

  void _goToEditPermissionScreen(PermissionSet permissionSet) async {
    var result = await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) =>
              new EditPermissionScreen(permissionSet: permissionSet),
          fullscreenDialog: true,
        ));

    debugPrint(
        '------------------------- come back from edit permission screen permission edited $result ------------------------------');
    if (result) {
      setState(() {
        print(
            'reload manager permission screen with newcly updated permission');
      });
    }
  }

  Widget _horizontalLine() {
    return SvgPicture.asset(
      ImagePaths.svgWeatherInfoDividerLine,
      fit: BoxFit.fitWidth,
      color: ColorConstants.WEATHER_BKG_CIRCLE,
      width: MediaQuery.of(context).size.width * .95,
    );
  }

  List<String> getSeaPodList() {
    List<String> seapodList = [];

    _user.userOceanBuilder.map((ob) {
      // debugPrint('ob type --- ${ob.userType}');
      if (ob.userType.toLowerCase().compareTo('owner') == 0) {
        seapodList.add(ob.oceanBuilderName);
      }
    }).toList();
    return seapodList;
  }
}
