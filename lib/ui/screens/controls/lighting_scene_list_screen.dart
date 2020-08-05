import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/light_scene_list_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/lighting.dart';
import 'package:ocean_builder/core/models/ocean_builder_user.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper_lighting.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LightingSceneListScreen extends StatefulWidget {
  static const String routeName = '/lightingSceneListScreen';

  LightingSceneListScreen({Key key}) : super(key: key);

  @override
  _LightingSceneListScreenState createState() =>
      _LightingSceneListScreenState();
}

class _LightingSceneListScreenState extends State<LightingSceneListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserProvider userProvider;
  ScreenUtil _util = ScreenUtil();
  LightSceneBloc _bloc = LightSceneBloc();
  TextEditingController _renameTextController = TextEditingController();
  List<String> _userScenerows;
  List<String> _seaPodSceneRows;

  SelectedOBIdProvider _selectedOBIdProvider;
  UserProvider _userProvider;
  OceanBuilderProvider _oceanBuilderProvider;

  User _user;
  Future<SeaPod> _selectedSeaPod;
  Future<SeaPod> _selectedSeaPodSource;
  OceanBuilderUser _oceanBuilderUser;

  bool needToFetchSceneList = true;
  bool needToFetchSceneListOfSeaPod = true;
  bool showProgressCircle = false;

  List<Scene> _seaPodScenes = [];
  List<Scene> _userScenes = [];

  String _oldName;

  bool isOwner = false;

  bool _userSceneChanged = false;

  bool _seaPodSceneChanged = false;
  // zox
  void _onUserSceneReorder(int oldIndex, int newIndex) {
    setState(() {
      String row = _userScenerows.removeAt(oldIndex);
      _userScenerows.insert(newIndex, row);

      // reorder _oceanBuilderUser Scene
      Scene sceneElement = _userScenes.removeAt(oldIndex);
      // _user.lightiningScenes.insert(newIndex, sceneElement);
      _userScenes.insert(newIndex, sceneElement);
      _userSceneChanged = true;
    });
  }

  void _onSeaPodScenesReorder(int oldIndex, int newIndex) {
    setState(() {
      String row = _seaPodSceneRows.removeAt(oldIndex);
      _seaPodSceneRows.insert(newIndex, row);

      // reorder _oceanBuilderUser Scene
      Scene sceneElement = _seaPodScenes.removeAt(oldIndex);
      _seaPodScenes.insert(newIndex, sceneElement);
      _seaPodSceneChanged = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _renameTextController.text = ListHelper.getlightSceneList()[0];
    // _rows = ListHelper.getlightSceneList();
    _setDataListener();
    super.initState();

    Future.delayed(Duration.zero).then((_) {
      _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);
      _userProvider = Provider.of<UserProvider>(context);
      _oceanBuilderProvider = Provider.of<OceanBuilderProvider>(context);
      _user = _userProvider.authenticatedUser;

      _selectedSeaPod = _oceanBuilderProvider.getSeaPod(
          _selectedOBIdProvider.selectedObId, _userProvider);

      _selectedSeaPodSource = _oceanBuilderProvider.getSeaPod(
          _selectedOBIdProvider.selectedObId, _userProvider);

      // debugPrint('calling fetch ob ');

      _selectedSeaPod.whenComplete(() {
        setState(() {
          // debugPrint('calling fetch ob end ');
        });
      });
    });
  }

  _setDataListener() {
    _bloc.lightSceneController.listen((onData) {
      _renameTextController.text = onData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _mainContent();
  }

  _mainContent() {
    // Make sure there is a scroll controller attached to the scroll view that contains ReorderableSliverList.
    // Otherwise an error will be thrown.
    ScrollController _scrollController =
        PrimaryScrollController.of(context) ?? ScrollController();

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
                controller: _scrollController,
                slivers: <Widget>[
                  UIHelper.getTopEmptyContainerWithColor(
                      ScreenUtil.statusBarHeight + _util.setHeight(160),
                      Colors.white),
                  SliverToBoxAdapter(
                      child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: _util.setHeight(32),
                      horizontal: _util.setWidth(32),
                    ),
                    child: _sceneSourceTitle('My Scenes'),
                  )),

                  _userLightingSceneListContentFuture(),

                  SliverToBoxAdapter(
                      child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: _util.setHeight(32),
                      horizontal: _util.setWidth(32),
                    ),
                    child: _sceneSourceTitle('SeaPod Scenes'),
                  )),

                  _seaPodlightingSceneListContentFuture(),
                  /*                   ReorderableSliverList(
                                      // delegate: ReorderableSliverChildListDelegate(
                                      //       _rows
                  
                                      //       ),
                                      // or use ReorderableSliverChildBuilderDelegate if needed
                                      delegate: ReorderableSliverChildBuilderDelegate(
                                        
                                          (BuildContext context, int index) => Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: _rowItem(index) ,
                                                ),
                                              ),
                                          childCount: _rows.length //ListHelper.getlightSceneList().length//
                                          ),
                                      onReorder: _onReorder,
                                    ), */
                  // SliverToBoxAdapter(
                  //   child:
                  // ),

                  UIHelper.getTopEmptyContainer(90, false),
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
                              AppStrings.lightingSceneList,
                              style: TextStyle(
                                  color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 22),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              ApplicationStatics.oceanBuilderUser =
                                  _oceanBuilderUser;
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
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: 0,
                child: showProgressCircle
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child:
                    BottomClipperLighting(ButtonText.SAVE_SCENE, '', false, () {
                  _saveSCeneList();
                }, () {
                  // _showRenameDeteletDialog();
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  _rowItem(int index) {
    // return _rows[index];
    return Padding(
      padding: EdgeInsets.only(
        left: _util.setWidth(32),
        right: _util.setWidth(32),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: _util.setWidth(32)),
                      child: Image.asset(
                        ImagePaths.icVerticalDots,
                        color: ColorConstants.LIGHTING_CHIP_LABEL,
                      ),
                    ),
                    SizedBox(
                      width: _util.setWidth(32),
                    ),
                    Text(
                      _userScenerows[
                          index], //ListHelper.getlightSceneList()[index],
                      style: TextStyle(
                          fontSize: _util.setSp(38),
                          color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _renameTextController.text = _userScenerows[index];
                        _oldName = _renameTextController.text;
                        _showRenameDialog();
                      },
                      child: Text(
                        'RENAME',
                        style: TextStyle(
                            fontSize: _util.setSp(38), color: Colors.green),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _renameTextController.text = _userScenerows[index];
                        _showDeteletDialog();
                      },
                      child: Text(
                        'DELETE',
                        style: TextStyle(
                            fontSize: _util.setSp(38), color: Colors.red),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: _util.setHeight(32),
          ),
          Divider(
            // height: 2,
            thickness: 1,
            color: ColorConstants.ACCESS_MANAGEMENT_SUBTITLE,
          )
        ],
      ),
    );
  }

  _seaPodRowItem(int index) {
    // return _rows[index];
    return Padding(
      padding: EdgeInsets.only(
        left: _util.setWidth(32),
        right: _util.setWidth(32),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: _util.setWidth(32)),
                      child: Image.asset(
                        ImagePaths.icVerticalDots,
                        color: ColorConstants.LIGHTING_CHIP_LABEL,
                      ),
                    ),
                    SizedBox(
                      width: _util.setWidth(32),
                    ),
                    Text(
                      _seaPodSceneRows[
                          index], //ListHelper.getlightSceneList()[index],
                      style: TextStyle(
                          fontSize: _util.setSp(38),
                          color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
                    )
                  ],
                ),
              ),
              Expanded(
                child: isOwner
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              _renameTextController.text =
                                  _seaPodSceneRows[index];
                              _oldName = _renameTextController.text;
                              _showRenameDialog();
                            },
                            child: Text(
                              'RENAME',
                              style: TextStyle(
                                  fontSize: _util.setSp(38),
                                  color: Colors.green),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _renameTextController.text =
                                  _seaPodSceneRows[index];
                              _showDeteletDialog();
                            },
                            child: Text(
                              'DELETE',
                              style: TextStyle(
                                  fontSize: _util.setSp(38), color: Colors.red),
                            ),
                          )
                        ],
                      )
                    : Container(),
              )
            ],
          ),
          SizedBox(
            height: _util.setHeight(32),
          ),
          Divider(
            // height: 2,
            thickness: 1,
            color: ColorConstants.ACCESS_MANAGEMENT_SUBTITLE,
          )
        ],
      ),
    );
  }

  // Future widget

  Widget _userLightingSceneListContentFuture() {
    return FutureBuilder<SeaPod>(
        future: _selectedSeaPod,
        // initialData: stormGlassDataProvider.weatherDataToday,
        builder: (context, snapshot) {
          // debugPrint('_lightingSceneListContentFuture .. ${snapshot.hasData}');
          if (snapshot.hasData && needToFetchSceneList)
            _getUserLightingScenes(snapshot.data);
          return snapshot.hasData
              ? _lightingScenePopupContent() //movieGrid(snapshot.data)
              : SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
        });
  }

  Widget _seaPodlightingSceneListContentFuture() {
    return FutureBuilder<SeaPod>(
        future: _selectedSeaPodSource,
        // initialData: stormGlassDataProvider.weatherDataToday,
        builder: (context, snapshot) {
          // debugPrint('_lightingSceneListContentFuture .. ${snapshot.hasData}');
          if (snapshot.hasData && needToFetchSceneListOfSeaPod)
            _getSeaPodLightingScenes(snapshot.data);
          return snapshot.hasData
              ? isOwner
                  ? _seaPodlightingScenePopupContent()
                  : _seaPodlightingScenePopupContentForNonOwner() //movieGrid(snapshot.data)
              : SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
        });
  }

  _getUserLightingScenes(selectedOceanBuilder) {
    if (selectedOceanBuilder.users.length != null) {
      for (var i = 0; i < selectedOceanBuilder.users.length; i++) {
        if (selectedOceanBuilder.users[i].userId.contains(_user.userID)) {
          _oceanBuilderUser = selectedOceanBuilder.users[i];
          _userScenerows = _oceanBuilderUser.lighting.sceneList.map((f) {
            _userScenes.add(f);
            return f.name;
          }).toList();
          needToFetchSceneList = false;
          // debugPrint('scene list fethced -- ${_rows.toString()}');
        }
      }
    }
  }

  _getSeaPodLightingScenes(SeaPod selectedOceanBuilder) {
    if (selectedOceanBuilder.activeUser.userId.contains(_user.userID))
      isOwner = true;
    else
      isOwner = false;

    _seaPodSceneRows = selectedOceanBuilder.lightScenes.map((f) {
      _seaPodScenes.add(f);
      return f.name;
    }).toList();

    needToFetchSceneListOfSeaPod = false;
  }

  _lightingScenePopupContent() {
    return ReorderableSliverList(
      delegate: ReorderableSliverChildBuilderDelegate(
          (BuildContext context, int index) => Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(_util.setWidth(12)),
                  child: _rowItem(index),
                ),
              ),
          childCount:
              _userScenerows.length //ListHelper.getlightSceneList().length//
          ),
      onReorder: _onUserSceneReorder,
    );
  }

  _seaPodlightingScenePopupContent() {
    return ReorderableSliverList(
      delegate: ReorderableSliverChildBuilderDelegate(
          (BuildContext context, int index) => Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(_util.setWidth(12)),
                  child: _seaPodRowItem(index),
                ),
              ),
          childCount:
              _seaPodSceneRows.length //ListHelper.getlightSceneList().length//
          ),
      onReorder: _onSeaPodScenesReorder,
    );
  }

  _seaPodlightingScenePopupContentForNonOwner() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(_util.setWidth(12)),
                  child: _seaPodRowItem(index),
                ),
              ),
          childCount:
              _seaPodSceneRows.length //ListHelper.getlightSceneList().length//
          ),
    );
  }

  // ------------ grant access Alert -----------------------------
  _showRenameDialog() async {
    var alertStyle = AlertStyle(
      isCloseButton: false,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(
          color: ColorConstants.TOP_CLIPPER_START,
          fontWeight: FontWeight.normal,
          fontSize: 2),
      backgroundColor: ColorConstants.LIGHTING_POP_UP_BKG,

      // buttonAreaPadding: EdgeInsets.only(
      //   left: _util.setWidth(32),
      //   right: _util.setWidth(32),
      //   bottom: _util.setHeight(48),
      // )
    );
    Alert(
        context: context,
        title: '', //'Grant new access',
        style: alertStyle,
        closeFunction: () {
          //  Navigator.of(context).pop();
        },
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // SizedBox(
            //   height: 16.0,
            // ),
            Container(
              margin: EdgeInsets.only(
                bottom: _util.setHeight(32),
              ),
              child: TextField(
                autofocus: false,
                controller: _renameTextController,
                keyboardType: null,
                keyboardAppearance: Brightness.light,
                textAlign: TextAlign.end,
                textAlignVertical: TextAlignVertical.center,
                scrollPadding: EdgeInsets.only(bottom: 100),
                textInputAction: TextInputAction.done,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                // maxLines: 6,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                          width: 1),
                      borderRadius: BorderRadius.circular(_util.setWidth(16))),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                          width: 1),
                      borderRadius: BorderRadius.circular(_util.setWidth(16))),
                  labelText: 'Rename Scene',
                  labelStyle: TextStyle(
                      color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                      fontSize: _util.setSp(38)),
                ),
                style: TextStyle(
                  fontSize: _util.setSp(38),
                  fontWeight: FontWeight.w400,
                  color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                ),
                inputFormatters: [
                  new LengthLimitingTextInputFormatter(300),
                ],
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    _renameScene(_oldName, _renameTextController.text);
                  },
                  // padding: EdgeInsets.only(
                  //   left: _util.setWidth(128),
                  //   right:  _util.setWidth(128)
                  // ),
                  child: Text(
                    'RENAME SCENE',
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          new BorderRadius.circular(_util.setWidth(16)),
                      side: BorderSide(
                        color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                      )),
                  textColor: ColorConstants.ACCESS_MANAGEMENT_BUTTON,
                  color: Colors.white, //ColorConstants.TOP_CLIPPER_END
                )
              ],
            )
          ],
        ),
        buttons: []).show();
  }

  _showDeteletDialog() async {
    var alertStyle = AlertStyle(
      titleStyle: TextStyle(
          color: ColorConstants.TOP_CLIPPER_START,
          fontWeight: FontWeight.normal,
          fontSize: 2),
      backgroundColor: ColorConstants.LIGHTING_POP_UP_BKG,

      // buttonAreaPadding: EdgeInsets.only(
      //   left: _util.setWidth(32),
      //   right: _util.setWidth(32),
      //   bottom: _util.setHeight(48),
      // )
    );
    Alert(
        context: context,
        title: '', //'Grant new access',
        style: alertStyle,
        closeFunction: () {
          //  Navigator.of(context).pop();
        },
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // SizedBox(
            //   height: 16.0,
            // ),
            Container(
              margin: EdgeInsets.only(
                bottom: _util.setHeight(32),
              ),
              child: Text(
                'Are you sure you want to delete the scene ?',
                textAlign: TextAlign.center,
                style: TextStyle(color: ColorConstants.LIGHT_POPUP_TITLE),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    _removeScene(_renameTextController.text);
                  },
                  // padding: EdgeInsets.only(
                  //   left: _util.setWidth(128),
                  //   right:  _util.setWidth(128)
                  // ),
                  child: Text(
                    'DELETE SCENE',
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          new BorderRadius.circular(_util.setWidth(16)),
                      side: BorderSide(
                        color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                      )),
                  textColor: ColorConstants.ACCESS_MANAGEMENT_BUTTON,
                  color: Colors.white, //ColorConstants.TOP_CLIPPER_END
                )
              ],
            )
          ],
        ),
        buttons: []).show();
  }

  Future<void> _saveSCeneList() async {
    setState(() {
      showProgressCircle = true;
    });

    String seaPodId = _selectedOBIdProvider.selectedObId;
    SeaPod oceanBuilder =
        await _oceanBuilderProvider.getSeaPod(seaPodId, _userProvider);

    if (_userSceneChanged) {
      _userProvider
          .updateAllLightingScene(_userScenes, oceanBuilder.id, 'user')
          .then((f) {
        if (f.status == 200) {
          _userProvider.autoLogin();
          showInfoBarWithDissmissCallback('UPDATE LIGHT SCENE ORDER',
              'User light scenes order changed', context, () {
            setState(() {
              _getUserLightingScenes(oceanBuilder);
              showProgressCircle = false;
            });
          });
        } else {
          _userProvider.autoLogin();
          showInfoBarWithDissmissCallback(
              parseErrorTitle(f.code), f.message, context, () {
            setState(() {
              showProgressCircle = false;
            });
          });
        }
      });
    }

    if (_seaPodSceneChanged) {
      _userProvider
          .updateAllLightingScene(_seaPodScenes, oceanBuilder.id, 'seapod')
          .then((f) {
        if (f.status == 200) {
          _userProvider.autoLogin();
          showInfoBarWithDissmissCallback('UPDATE LIGHT SCENE ORDER',
              'SeaPod light scenes order changed', context, () {
            setState(() {
              _getUserLightingScenes(oceanBuilder);
              showProgressCircle = false;
            });
          });
        } else {
          _userProvider.autoLogin();
          showInfoBarWithDissmissCallback(
              parseErrorTitle(f.code), f.message, context, () {
            setState(() {
              showProgressCircle = false;
            });
          });
        }
      });
    }
  }

  Future<void> _renameScene(String oldName, String newName) async {
    setState(() {
      showProgressCircle = true;
    });
    Scene selectedScene = _getSceneByName(oldName);
    selectedScene.name = newName;

    String seaPodId = _selectedOBIdProvider.selectedObId;
    SeaPod oceanBuilder =
        await _oceanBuilderProvider.getSeaPod(seaPodId, _userProvider);
    _userProvider.updateLightingScene(seaPodId, selectedScene).then((f) {
      if (f.status == 200) {
        _userProvider.autoLogin();
        showInfoBarWithDissmissCallback(
            'RENAME LIGHT SCENE', 'Light scene renamed', context, () {
          setState(() {
            _getUserLightingScenes(oceanBuilder);
            showProgressCircle = false;
          });
        });
      } else {
        _userProvider.autoLogin();
        showInfoBarWithDissmissCallback(
            parseErrorTitle(f.code), f.message, context, () {
          setState(() {
            showProgressCircle = false;
          });
        });
      }
    });

    // _oceanBuilderProvider
    //     .updateOceanBuilderUser(
    //         currentUserID: _user.userID,
    //         oceanBuilderID: _selectedOBIdProvider.selectedObId,
    //         oceanBuilderUser: _oceanBuilderUser)
    //     .then((onValue) {
    //   _oceanBuilderProvider
    //       .getOceanBuilder(_selectedOBIdProvider.selectedObId)
    //       .then((oceanBuilder) {
    //     setState(() {
    //       // needToFetchSceneList = true;
    //       _getOceanBuilder(oceanBuilder);
    //       showProgressCircle = false;
    //     });
    //   });
    // });
  }

  Future<void> _removeScene(String sceneName) async {
    setState(() {
      showProgressCircle = true;
    });

    String seaPodId = _selectedOBIdProvider.selectedObId;

    Scene selectedScene = _getSceneByName(sceneName);

    _userProvider.deleteLightingScene(selectedScene.id).then((response) {
      if (response.status == 200) {
        _userProvider.autoLogin().then((_) async {
          _user = _userProvider.authenticatedUser;

          _selectedSeaPod = _oceanBuilderProvider.getSeaPod(
              _selectedOBIdProvider.selectedObId, _userProvider);
          SeaPod oceanBuilder =
              await _oceanBuilderProvider.getSeaPod(seaPodId, _userProvider);

          _oceanBuilderUser.lighting.sceneList.remove(selectedScene);
          showInfoBarWithDissmissCallback(
              'DELETE LIGHT SCENE', 'Light scene deleted', context, () {
            setState(() {
              _getUserLightingScenes(oceanBuilder);
              _getSeaPodLightingScenes(oceanBuilder);
              showProgressCircle = false;
            });
          });
        });
      } else {
        _userProvider.autoLogin();
        showInfoBarWithDissmissCallback(
            parseErrorTitle(response.code), response.message, context, () {
          setState(() {
            showProgressCircle = false;
          });
        });
      }
    });
  }

  Scene _getSceneByName(String changedString) {
    Scene selectedScene;
    _userScenes.map((f) {
      if (f.name.contains(changedString)) {
        selectedScene = f;
      }
    }).toList();
    if (selectedScene == null) {
      _seaPodScenes.map((f) {
        if (f.name.contains(changedString)) {
          selectedScene = f;
        }
      }).toList();
    }
    return selectedScene;
  }

  Scene getLightScene(String lightingSceneId) {
    Scene lightScene;

    _userScenes.map((f) {
      if (f.id.compareTo(lightingSceneId) == 0) lightScene = f;
    }).toList();

    if (lightScene == null) {
      _seaPodScenes.map((f) {
        if (f.id.contains(lightingSceneId)) {
          lightScene = f;
        }
      }).toList();
    }

    return lightScene;
  }

  _sceneSourceTitle(String sourceName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          '$sourceName',
          style: TextStyle(
              fontSize: _util.setHeight(48),
              color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
        )
      ],
    );
  }
}
