import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/light_scene_list_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/colorpicker/flutter_hsvcolor_picker.dart';
import 'package:ocean_builder/core/models/lighting.dart';
import 'package:ocean_builder/core/models/ocean_builder_user.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/color_picker_data_provider.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper_lighting.dart';
import 'package:ocean_builder/ui/screens/controls/lighting_scene_list_screen.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rxdart/rxdart.dart';

class LightingScreenParams {
  final OceanBuilderUser obUser;
  final UserProvider userProvider;
  final SelectedOBIdProvider selectedOBIdProvider;
  final String selectedSceneId;

  LightingScreenParams(this.obUser, this.userProvider,
      this.selectedOBIdProvider, this.selectedSceneId);
}

class LightingScreen extends StatefulWidget {
  static const String routeName = '/lightingScreen';
  final OceanBuilderUser oceanBuilderUser;
  final UserProvider userProvider;
  final SelectedOBIdProvider selectedOBIdProvider;
  final String selectedLightSceneIdFromPopup;

  LightingScreen(
      {Key key,
      this.userProvider,
      this.selectedOBIdProvider,
      this.oceanBuilderUser,
      this.selectedLightSceneIdFromPopup})
      : super(key: key);

  @override
  _LightingScreenState createState() => _LightingScreenState();
}

class _LightingScreenState extends State<LightingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // UserProvider userProvider;
  ScreenUtil _util = ScreenUtil();
  LightSceneBloc _bloc = LightSceneBloc();
  TextEditingController _renameTextController = TextEditingController();

  UserProvider _userProvider;
  OceanBuilderProvider _oceanBuilderProvider;
  SelectedOBIdProvider _selectedOBIdProvider;

  User _user;
  OceanBuilderUser _oceanBuilderUser;

  bool switchOn;

  Scene _selectedScene;
  Room _selectedRoom;

  ColorPicker _colorPicker;
  ColorPickerDataProvider _colorPickerDataProvider;

  bool _isNewScene = false;

  bool _newSceneAddedToList = false;

  bool _isLoading = false;

  Scene _predefinedNewScene;

  var isSeaPodSourceSelected = true;
  var isMySceneSourceSelected = false;

  List<Scene> _allLightScenes = [];

  @override
  void initState() {
    _predefinedNewScene = _getNewScene();

    _oceanBuilderUser = widget.oceanBuilderUser;
    _userProvider = widget.userProvider;
    _selectedOBIdProvider = widget.selectedOBIdProvider;
    _user = _userProvider.authenticatedUser;

    if (_oceanBuilderUser.lighting.sceneList != null &&
        _oceanBuilderUser.lighting.sceneList.isNotEmpty) {
      _allLightScenes.addAll(_oceanBuilderUser.lighting.sceneList);
    }

    // if (_user.lightiningScenes != null && _user.lightiningScenes.isNotEmpty) {
    //   _allLightScenes.addAll(_user.lightiningScenes);
    // }

    SeaPod seaPod =
        _getSeaPodInfo(_selectedOBIdProvider.selectedObId, _userProvider);
    if (seaPod != null) {
      seaPod.lightScenes.map((lc) {
        _allLightScenes.add(lc);
      }).toList();
    }
    switchOn = _oceanBuilderUser.lighting.isLightON;

    if (widget.selectedLightSceneIdFromPopup != null) {
      // debugPrint('widget.selectedLightSceneIdFromPopup --------- ');
      // print(widget.selectedLightSceneIdFromPopup);
      _renameTextController.text =
          getLightScene(widget.selectedLightSceneIdFromPopup).name;
      _selectedScene = getLightScene(widget.selectedLightSceneIdFromPopup);
      _selectedRoom = _selectedScene.rooms[0];
      selectedLight = _selectedRoom.lightModes[0];

      _bloc.lightSceneChanged(_selectedScene.name);
    } else {
      _renameTextController.text =
          _predefinedNewScene.name; // PredefinedLightData.scenes[0].name;
      _selectedScene = _predefinedNewScene; // PredefinedLightData.scenes[0];
      _selectedRoom = _selectedScene.rooms[0];
      selectedLight = _selectedRoom.lightModes[0];

      _bloc.lightSceneChanged(_selectedScene.name);
      _isNewScene = true;
    }

    _setDataListener();
    super.initState();
  }

  _setDataListener() {
    _bloc.lightSceneController.listen((onData) {
      _renameTextController.text = onData;
    });
  }

  SeaPod _getSeaPodInfo(String obId, UserProvider userProvider) {
    // // debugPrint('get SeaPod info for  ' + obId);
    SeaPod seapod;

    userProvider.authenticatedUser.seaPods.map((f) {
      // // debugPrint('comparing with -- ${f.id}');
      if (f.id.compareTo(obId) == 0) {
        seapod = f;
      }
    }).toList();
    // // print("got SeaPod  =====================================================");
    // // print(seapod.toJson());
    return seapod;
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    _colorPickerDataProvider = Provider.of<ColorPickerDataProvider>(context);
    // _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);
    _oceanBuilderProvider = Provider.of<OceanBuilderProvider>(context);

    _user = _userProvider.authenticatedUser;

    if (ApplicationStatics.oceanBuilderUser != null) {
      _oceanBuilderUser = ApplicationStatics.oceanBuilderUser;
      ApplicationStatics.oceanBuilderUser = null;
    }
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
            // borderRadius: BorderRadius.circular(8)
          ),
          child: Stack(
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  UIHelper.getTopEmptyContainerWithColor(
                      ScreenUtil.statusBarHeight + _util.setHeight(160),
                      Colors.white),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      top: _util.setHeight(8),
                      bottom: _util.setHeight(350),
                      left: _util.setWidth(32),
                      right: _util.setWidth(32),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: EdgeInsets.only(
                              // top: util.setHeight(32),
                              bottom: _util.setHeight(32)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Transform.scale(
                                scale: 1.5,
                                child: Switch(
                                  onChanged: _onSwitchChanged,
                                  value: switchOn,
                                  activeColor: Colors.green,
                                  activeTrackColor:
                                      ColorConstants.LIGHT_POPUP_BKG,
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor:
                                      ColorConstants.LIGHT_POPUP_BKG,
                                  // activeThumbImage: Image.asset(
                                  //   ImagePaths.icAdd
                                  // ).image,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: _util.setHeight(32),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: _util.setHeight(16),
                            bottom: _util.setHeight(32),
                          ),
                          child: _getLightSceneDropdown(
                            _allLightScenes,
                            _bloc.lightScene,
                            _bloc.lightSceneChanged,
                            true,
                            label: 'Select Scene',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: _util.setHeight(16),
                            bottom: _util.setHeight(16),
                          ),
                          child: _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : InkWell(
                                  onTap: () {
                                    _renameTextController.text = _predefinedNewScene
                                        .name; // PredefinedLightData.scenes[0].name;
                                    _selectedScene =
                                        _predefinedNewScene; // PredefinedLightData.scenes[0];
                                    _selectedRoom = _selectedScene.rooms[0];
                                    selectedLight = _selectedRoom.lightModes[0];
                                    _bloc
                                        .lightSceneChanged(_selectedScene.name);

                                    Navigator.of(context).pushNamed(
                                        LightingSceneListScreen.routeName);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        AppStrings.viewAllTheScenes,
                                        style: TextStyle(
                                            fontSize: _util.setSp(36),
                                            color: ColorConstants
                                                .LIGHT_POPUP_TEXT),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: _util.setHeight(32),
                            bottom: _util.setHeight(32),
                          ),
                          child: _getDropdown(
                              _selectedScene != null
                                  ? _selectedScene.rooms.map((f) {
                                      return f.roomName;
                                    }).toList()
                                  : _predefinedNewScene.rooms.map((f) {
                                      return f.roomName;
                                    }).toList(),
                              _bloc.lightRoom,
                              _bloc.lightRoomChanged,
                              true,
                              label: 'Select Room',
                              dropdownType: 'room'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: _util.setHeight(16),
                            bottom: _util.setHeight(16),
                          ),
                          child: InkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  AppStrings.slectLight,
                                  style: TextStyle(
                                      fontSize: _util.setSp(36),
                                      color: ColorConstants.LIGHT_POPUP_TEXT),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                            child: MultiSelectChip(
                                // _user.lights,
                                _selectedRoom != null
                                    ? _selectedRoom.lightModes
                                    : _selectedScene.rooms[0].lightModes,
                                this)),
                        // color picker
                        _colorPickerWidget()
                      ]),
                    ),
                  ),
                  // SliverToBoxAdapter(
                  //   child:
                  // ),

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
                              AppStrings.lighting,
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
                child: BottomClipperLighting(ButtonText.SAVE_SCENE,
                    ButtonText.RENAME_DELETE_SCENE, false, () {
                  _showSaveAsDialog();
                }, () {
                  if (_isNewScene == null || !_isNewScene)
                    _showRenameDeteletDialog();
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onSwitchChanged(bool value) {
    _oceanBuilderUser.lighting.isLightON = value;
    _oceanBuilderProvider
        .toogleLightSceneStatus(
      seapodId: _selectedOBIdProvider.selectedObId,
    )
        .then((onValue) {
      setState(() {
        switchOn = value;
      });
    });
  }

  _colorPickerWidget() {
    // // debugPrint('Color picker widget rebuilding');
    return Container(
      child: ColorPicker(
        color: _colorPickerDataProvider
            .initialColor, //Color(0xffffed27), //Color(0xFF2741D3),
        onChanged: (value) {
          // // debugPrint('Selected color -- ' + value.toString().substring(10,16).toUpperCase());
          setState(() {
            selectedColor = value;
            selectedLight.lightColor =
                value.toString().substring(6, 16).toUpperCase();

            Light light;
            _selectedRoom.lightModes.map((f) {
              if (f.lightName.compareTo(selectedLight.lightName) == 0) {
                light = f;
              }
            }).toList();

            int lightIndex = _selectedRoom.lightModes.indexOf(light);
            _selectedRoom.lightModes.elementAt(lightIndex).lightColor =
                selectedLight.lightColor;

            Room room;
            _selectedScene.rooms.map((f) {
              if (f.roomName.compareTo(_selectedRoom.roomName) == 0) {
                room = f;
              }
            }).toList();

            int roomIndex = _selectedScene.rooms.indexOf(room);

            _selectedScene.rooms.elementAt(roomIndex).lightModes =
                _selectedRoom.lightModes;
          });
        },
      ),
    );
  }

  Scene getLightScene(String lightingSceneId) {
    Scene lightScene;
    // print('getLightScene');
    // print(lightingSceneId);
    // _user.lightiningScenes.map((f) {
    _allLightScenes.map((f) {
      if (f.id != null && f.id.compareTo(lightingSceneId) == 0) lightScene = f;
    }).toList();

    return lightScene;
  }

// RA Code RN: 900183492248595

  Scene _getSceneByName(String changedString) {
    Scene selectedScene;
    // _user.lightiningScenes.map((f) {
    _allLightScenes.map((f) {
      if (f.name.compareTo(changedString) == 0) {
        selectedScene = f;
      }
    }).toList();

    if (selectedScene == null) {
      selectedScene = _predefinedNewScene; // PredefinedLightData.scenes[0];
      // selectedScene.rooms = List<Room>.from(PredefinedLightData.scenes[0].rooms);
      // _user.lightiningScenes.add(selectedScene);
      // _newSceneAddedToList = true;
      debugPrint(
          '---------light color ----------${selectedScene.rooms[0].lightModes[0].lightColor}');
    }

    debugPrint(
        'selected scene is ---------------------- ${selectedScene.name} ');

    return selectedScene;
  }

  Widget _getDropdown(
      List<String> list, Observable<String> stream, changed, bool addPadding,
      {String label = 'Label', String dropdownType}) {
    if (dropdownType.contains('scene')) {
      if (!_newSceneAddedToList) list.add('New Scene');
    }

    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return InputDecorator(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                      width: 1),
                  borderRadius: BorderRadius.circular(_util.setWidth(32))),
              contentPadding: EdgeInsets.only(
                left: 48.w,
                top: _util.setWidth(16),
                bottom: _util.setWidth(16),
              ),
              labelText: label,
              // hintStyle: TextStyle(color: Colors.red),
              labelStyle: TextStyle(
                  color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                  fontSize: _util.setSp(36)),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  icon: Icon(Icons.arrow_drop_down,
                      size: _util.setSp(96),
                      color: snapshot.hasData
                          ? ColorConstants.ACCESS_MANAGEMENT_TITLE
                          : ColorConstants
                              .ACCESS_MANAGEMENT_SUBTITLE //ColorConstants.INVALID_TEXTFIELD,
                      ),
                  value: snapshot.hasData ? snapshot.data : list[0],
                  isExpanded: true,
                  underline: Container(),
                  style: TextStyle(
                    color: snapshot.hasData
                        ? ColorConstants.ACCESS_MANAGEMENT_TITLE
                        : ColorConstants
                            .ACCESS_MANAGEMENT_SUBTITLE, //ColorConstants.INVALID_TEXTFIELD,
                    fontSize: _util.setSp(36),
                    fontWeight: FontWeight.w400,
                    // letterSpacing: 1.2,
                    // wordSpacing: 4
                  ),
                  onChanged: (changedValue) {
                    changed(changedValue);
                    selectedColor = null;

                    if (dropdownType.contains('scene')) {
                      _bloc.lightRoomController.add(null);

                      if (changedValue.compareTo('New Scene') == 0) {
                        _isNewScene = true;
                      } else {
                        _isNewScene = false;
                      }

                      setState(() {
                        _selectedScene = _getSceneByName(changedValue);
                        _selectedRoom = _selectedScene.rooms[0];
                      });
                    } else if (dropdownType.contains('room')) {
                      setState(() {
                        _selectedRoom = _getRoomByName(changedValue);
                        selectedLight = _selectedRoom.lightModes[0];
                        selectedIndex = 0;
                      });
                    }
                  },
                  items: list.map((data) {
                    return DropdownMenuItem(
                        value: data,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text('$data'),
                          ],
                        ));
                  }).toList(),
                ),
              ),
            ),
          );
        });
  }

  Widget _getLightSceneDropdown(
      List<Scene> list, Observable<String> stream, changed, bool addPadding,
      {String label = 'Label'}) {
    String lastSeaPodSceneId = '';
    String lastSeaPodSceneName = '';
    if (!_newSceneAddedToList) {
      if (!list.contains(_predefinedNewScene)) list.add(_predefinedNewScene);
    }

    for (var i = 0; i < list.length; i++) {
      Scene scene = list[i];
      if (scene.seapodId != null && scene.seapodId.isNotEmpty) {
        lastSeaPodSceneId = scene.id;
        lastSeaPodSceneName = scene.name;
      }
    }

    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return InputDecorator(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                      width: 1),
                  borderRadius: BorderRadius.circular(_util.setWidth(32))),
              contentPadding: EdgeInsets.only(
                left: 48.w,
                top: _util.setWidth(16),
                bottom: _util.setWidth(16),
              ),
              labelText: label,
              // hintStyle: TextStyle(color: Colors.red),
              labelStyle: TextStyle(
                  color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                  fontSize: _util.setSp(36)),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  icon: Icon(Icons.arrow_drop_down,
                      size: _util.setSp(96),
                      color: snapshot.hasData
                          ? ColorConstants.ACCESS_MANAGEMENT_TITLE
                          : ColorConstants
                              .ACCESS_MANAGEMENT_SUBTITLE //ColorConstants.INVALID_TEXTFIELD,
                      ),
                  value: snapshot.hasData ? snapshot.data : list[0].name,
                  isExpanded: true,
                  onTap: () {
                    lastSeaPodSceneName = '';
                  },
                  underline: Container(),
                  style: TextStyle(
                    color: snapshot.hasData
                        ? ColorConstants.ACCESS_MANAGEMENT_TITLE
                        : ColorConstants
                            .ACCESS_MANAGEMENT_SUBTITLE, //ColorConstants.INVALID_TEXTFIELD,
                    fontSize: _util.setSp(36),
                    fontWeight: FontWeight.w400,
                    // letterSpacing: 1.2,
                    // wordSpacing: 4
                  ),
                  onChanged: (changedValue) {
                    changed(changedValue);
                    selectedColor = null;

                    _bloc.lightRoomController.add(null);

                    if (changedValue.compareTo('New Scene') == 0) {
                      _isNewScene = true;
                    } else {
                      _isNewScene = false;
                    }

                    setState(() {
                      _selectedScene = _getSceneByName(changedValue);
                      _selectedRoom = _selectedScene.rooms[0];
                    });
                  },
                  items: list.map((data) {
                    return DropdownMenuItem(
                        value: data.name,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                data.name.compareTo('New Scene') == 0
                                    ? Text('${data.name}')
                                    : data.source != null &&
                                            data.source.compareTo('seapod') == 0
                                        ? Text('${data.name} [seapod]')
                                        : Text('${data.name} [my scenes]'),
                              ],
                            ),
                            (lastSeaPodSceneId.compareTo(data.id) == 0) &&
                                    (snapshot.data != null &&
                                        snapshot.data.compareTo(
                                                lastSeaPodSceneName) !=
                                            0)
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      top: _util.setHeight(32),
                                    ),
                                    child: Divider(
                                      color: ColorConstants
                                          .ACCESS_MANAGEMENT_DIVIDER,
                                      height: _util.setHeight(8),
                                    ),
                                  )
                                : Container(),
                          ],
                        ));
                  }).toList(),
                ),
              ),
            ),
          );
        });
  }

  _resetOceanBuilder(selectedOceanBuilder) {
    _oceanBuilderUser = null;
    if (selectedOceanBuilder.users.length != null) {
      for (var i = 0; i < selectedOceanBuilder.users.length; i++) {
        if (selectedOceanBuilder.users[i].userId.contains(_user.userID)) {
          _oceanBuilderUser = selectedOceanBuilder.users[i];
          switchOn = _oceanBuilderUser.lighting.isLightON;
        }
      }
      setState(() {
        // debugPrint('Reset oceanBuilderUser ----  $_oceanBuilderUser');
      });
    }
  }

  Room _getRoomByName(String changedString) {
    Room selectedRoom;

    _selectedScene.rooms.map((f) {
      // debugPrint('match room .... ${changedString} '+ f.roomName);
      if (f.roomName.contains(changedString)) {
        selectedRoom = f;
      }
    }).toList();
    return selectedRoom;
  }

  // ------------ grant access Alert -----------------------------
  _showRenameDeteletDialog() async {
    var alertStyle = AlertStyle(
      titleStyle: TextStyle(
          color: ColorConstants.TOP_CLIPPER_START,
          fontWeight: FontWeight.normal,
          fontSize: 2),
      backgroundColor: ColorConstants.LIGHTING_POP_UP_BKG,
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
                    Navigator.of(context).pop();
                    _bloc.lightRoomController.add(null);
                    _bloc.lightSceneController.add(null);

                    _selectedScene.name = _renameTextController.text;

                    // _oceanBuilderProvider
                    //     .updateOceanBuilderUser(
                    //         currentUserID: _user.userID,
                    //         oceanBuilderID: _selectedOBIdProvider.selectedObId,
                    //         oceanBuilderUser: _oceanBuilderUser)
                    //     .then((onValue) {
                    //   _oceanBuilderProvider
                    //       .getOceanBuilder(_selectedOBIdProvider.selectedObId)
                    //       .then((oceanBuilder) {
                    //     _resetOceanBuilder(oceanBuilder);
                    //   });
                    // });
                  },
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
                ),
                SizedBox(
                  width: _util.setHeight(32),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    _oceanBuilderUser.lighting.sceneList.remove(_selectedScene);
                    _bloc.lightRoomController.add(null);
                    _bloc.lightSceneController.add(null);

                    // _oceanBuilderProvider
                    //     .updateOceanBuilderUser(
                    //         currentUserID: _user.userID,
                    //         oceanBuilderID: _selectedOBIdProvider.selectedObId,
                    //         oceanBuilderUser: _oceanBuilderUser)
                    //     .then((onValue) {
                    //   _oceanBuilderProvider
                    //       .getOceanBuilder(_selectedOBIdProvider.selectedObId)
                    //       .then((oceanBuilder) {
                    //     _resetOceanBuilder(oceanBuilder);
                    //   });
                    // });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(_util.setWidth(32)),
                    child: Text(
                      'DELETE SCENE',
                      style: TextStyle(
                          fontSize: _util.setSp(38), color: Colors.red),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        buttons: []).show();
  }

  _showSaveAsDialog() async {
    if (_isNewScene != null && _isNewScene) {
      _renameTextController.text = "";
    }
    var alertStyle = AlertStyle(
      titleStyle: TextStyle(
          color: ColorConstants.TOP_CLIPPER_START,
          fontWeight: FontWeight.normal,
          fontSize: 2),
      backgroundColor: ColorConstants.LIGHTING_POP_UP_BKG,
      isOverlayTapDismiss: true,
      isCloseButton: false,
    );
    Alert(
        context: GlobalContext.currentScreenContext,
        title: '', //'Grant new access',
        style: alertStyle,
        closeFunction: () {
          // Navigator.pop(context);
          //  Navigator.of(context).pop();
          // Navigator.of(context, rootNavigator: true).pop();
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
                textAlign: TextAlign.end,
                textAlignVertical: TextAlignVertical.center,
                // scrollPadding: EdgeInsets.only(bottom: 100),
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
                  labelText: 'Name your scene',
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
            SizedBox(
              height: _util.setHeight(32),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Save scene in',
                    style: TextStyle(
                        color: ColorConstants.COLOR_NOTIFICATION_ITEM,
                        fontSize: _util.setSp(42)))
              ],
            ),
            SizedBox(
              height: _util.setHeight(32),
            ),
            StatefulBuilder(
                builder: (BuildContext context, StateSetter stateSetter) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: _util.setWidth(64)),
                    child: InkWell(
                      onTap: () {
                        stateSetter(() {
                          isSeaPodSourceSelected = true;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ImageIcon(
                            AssetImage(isSeaPodSourceSelected
                                ? ImagePaths.icUnread
                                : ImagePaths.icRead),
                            color: isSeaPodSourceSelected
                                ? ColorConstants.COLOR_NOTIFICATION_BUBBLE
                                : Colors.grey, //Color(0xFF064390),
                            size: _util.setWidth(36),
                          ),
                          SizedBox(
                            width: _util.setWidth(32),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'SeaPod Scenes',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color:
                                        ColorConstants.ACCESS_MANAGEMENT_TITLE,
                                    fontSize: _util.setSp(36)),
                              ),
                              Text(
                                'Anyone with acces will be able to see it',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color:
                                        ColorConstants.ACCESS_MANAGEMENT_TITLE,
                                    fontSize: _util.setSp(24)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _util.setHeight(32),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: _util.setWidth(64)),
                    child: InkWell(
                      onTap: () {
                        stateSetter(() {
                          isSeaPodSourceSelected = false;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ImageIcon(
                            AssetImage(!isSeaPodSourceSelected
                                ? ImagePaths.icUnread
                                : ImagePaths.icRead),
                            color: !isSeaPodSourceSelected
                                ? ColorConstants.COLOR_NOTIFICATION_BUBBLE
                                : Colors.grey, //Color(0xFF064390),
                            size: _util.setWidth(36),
                          ),
                          SizedBox(
                            width: _util.setWidth(32),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'My Scenes',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color:
                                        ColorConstants.ACCESS_MANAGEMENT_TITLE,
                                    fontSize: _util.setSp(36)),
                              ),
                              Text(
                                'Available only to you',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color:
                                        ColorConstants.ACCESS_MANAGEMENT_TITLE,
                                    fontSize: _util.setSp(24)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
            SizedBox(
              height: _util.setHeight(32),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
                    Navigator.of(context, rootNavigator: true).pop();
                    setState(() {
                      _isLoading = true;
                    });

                    _bloc.lightRoomController.add(null);
                    _bloc.lightSceneController.add(null);

                    if (_isNewScene != null && _isNewScene) {
                      // ------------------ create light scene -----------------
                      Scene nScene = new Scene();
                      nScene.name = _renameTextController.text;
                      nScene.rooms = _selectedScene.rooms;
                      if (isSeaPodSourceSelected) {
                        nScene.source = 'seapod';
                      } else {
                        nScene.source = 'user';
                      }
                      // if(_oceanBuilderUser.lighting.sceneList.length > 0)
                      // _oceanBuilderUser.lighting.sceneList.removeLast();
                      _newSceneAddedToList = false;
                      _isNewScene = false;

                      String seaPodId = _selectedOBIdProvider.selectedObId;
                      _userProvider
                          .createLightScene(seaPodId, nScene)
                          .then((f) {
                        if (f.status == 200 || f.status == 201) {
                          // debugPrint('newly created scene id --------------------- ${f.message}');
                          nScene.id = f.message;
                          // _user.lightiningScenes.add(nScene);
                          _allLightScenes.add(nScene);
                          _oceanBuilderUser.lighting.sceneList.add(nScene);

                          _selectedScene =
                              nScene; //PredefinedLightData.scenes[0];
                          _selectedRoom = _selectedScene.rooms[0];
                          selectedLight = _selectedRoom.lightModes[0];

                          _userProvider.autoLogin();
                          showInfoBarWithDissmissCallback('CREATE LIGHT SCENE',
                              'New light scene added', context, () {
                            setState(() {
                              // _predefinedNewScene.rooms = List<Room>.from(PredefinedLightData.scenes[0].rooms);
                              // _getSceneByName("New Scene").rooms = List<Room>.from(PredefinedLightData.scenes[0].rooms);
                              // _getSceneByName("New Scene").rooms[0].lightModes[0].lightColor = '0xFF959B1B';
                              _getSceneByName("New Scene").rooms =
                                  _getNewScene().rooms;
                              _bloc.lightSceneChanged(_selectedScene.name);
                              _bloc.lightRoomChanged(_selectedRoom.roomName);

                              _isLoading = false;
                              // debugPrint(' _user.lightiningScenes. ----------------------- ${ _user.lightiningScenes.length}');

                              // Navigator.of(context).pushNamed(
                              //   LightingScreen.routeName,
                              //   arguments:LightingScreenParams(_oceanBuilderUser,_userProvider,_selectedScene.id)  //_oceanBuilderUser
                              //   );
                            });
                          });
                        } else {
                          _getSceneByName("New Scene").rooms =
                              _getNewScene().rooms;

                          _userProvider.autoLogin();

                          showInfoBarWithDissmissCallback(
                              parseErrorTitle(f.code), f.message, context, () {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        }
                      });
                    } else {
                      // ----------------------- update light scene ------------
                      // if (_oceanBuilderUser.lighting.selectedScene.name!=null && _oceanBuilderUser.lighting.selectedScene.name
                      //         .compareTo(_selectedScene.name) ==
                      //     0) {
                      //   _selectedScene.name = _renameTextController.text;
                      //   _oceanBuilderUser.lighting.selectedScene =
                      //       _selectedScene;
                      // }

                      _selectedScene.name = _renameTextController.text;
                      int index = _allLightScenes.indexOf(
                          _selectedScene); //_user.lightiningScenes.indexOf(_selectedScene);

                      // _user.lightiningScenes.elementAt(index).rooms = _selectedScene.rooms;
                      _allLightScenes.elementAt(index).rooms =
                          _selectedScene.rooms;

                      String seaPodId = _selectedOBIdProvider.selectedObId;
                      _userProvider
                          .updateLightingScene(seaPodId, _selectedScene)
                          .then((f) {
                        if (f.status == 200) {
                          _userProvider.autoLogin();
                          showInfoBarWithDissmissCallback('UPDATE LIGHT SCENE',
                              'Light scene updated', context, () {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        } else {
                          _userProvider.autoLogin();
                          showInfoBarWithDissmissCallback(
                              parseErrorTitle(f.code), f.message, context, () {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        }
                      });
                    }
/* 
                      _oceanBuilderProvider.updateOceanBuilderUser(
                        currentUserID: _user.userID,
                        oceanBuilderID: _selectedOBIdProvider.selectedObId,
                        oceanBuilderUser: _oceanBuilderUser).then((onValue){
                          
                        _oceanBuilderProvider.getOceanBuilder(_selectedOBIdProvider.selectedObId).then((oceanBuilder){
                              _resetOceanBuilder(oceanBuilder);
                             
                          });

                        }); 
                         */
                  },
                  child: Text(
                    'SAVE SCENE',
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

  Scene _getNewScene() {
    List<Light> _lightsBedroom = [
      new Light(lightName: 'Lightstrip 1', lightColor: '0xFF959B1B'),
      new Light(lightName: 'Lightstrip 2', lightColor: '0xFF1322FF'),
      new Light(lightName: 'Ligh 3', lightColor: '0xFFFF1EEE'),
      new Light(lightName: 'Counter 4', lightColor: '0xFFFFBE93'),
      new Light(lightName: 'Ocerhead 3', lightColor: '0xFFC1FFE5')
    ];

    List<Light> _lightsLivingRoom = [
      new Light(lightName: 'Lightstrip 1', lightColor: '0xFF959B1B'),
      new Light(lightName: 'Lightstrip 2', lightColor: '0xFF1322FF'),
      new Light(lightName: 'Ligh 3', lightColor: '0xFFFF1EEE'),
      new Light(lightName: 'Counter 4', lightColor: '0xFFFFBE93'),
      new Light(lightName: 'Ocerhead 3', lightColor: '0xFFC1FFE5')
    ];

    List<Light> _lightsKitchen = [
      new Light(lightName: 'Lightstrip 1', lightColor: '0xFF959B1B'),
      new Light(lightName: 'Lightstrip 2', lightColor: '0xFF1322FF'),
      new Light(lightName: 'Ligh 3', lightColor: '0xFFFF1EEE'),
      new Light(lightName: 'Counter 4', lightColor: '0xFFFFBE93'),
      new Light(lightName: 'Ocerhead 3', lightColor: '0xFFC1FFE5')
    ];

    List<Light> _lightsUnderWaterRoom = [
      new Light(lightName: 'Lightstrip 1', lightColor: '0xFF959B1B'),
      new Light(lightName: 'Lightstrip 2', lightColor: '0xFF1322FF'),
      new Light(lightName: 'Ligh 3', lightColor: '0xFFFF1EEE'),
      new Light(lightName: 'Counter 4', lightColor: '0xFFFFBE93'),
      new Light(lightName: 'Ocerhead 3', lightColor: '0xFFC1FFE5')
    ];

    List<Room> rooms = [
      new Room(
          roomName: 'Bedroom',
          light: _lightsBedroom[0],
          lightModes: _lightsBedroom),
      new Room(
          roomName: 'Livingroom',
          light: _lightsLivingRoom[1],
          lightModes: _lightsLivingRoom),
      new Room(
          roomName: 'Kitchen',
          light: _lightsKitchen[2],
          lightModes: _lightsKitchen),
      new Room(
          roomName: 'UnderWaterRoom',
          light: _lightsUnderWaterRoom[3],
          lightModes: _lightsUnderWaterRoom),
    ];

    return new Scene(
      id: 'idNewScene',
      name: 'New Scene',
      rooms: rooms,
    );
  }
}

Color selectedColor;
Light selectedLight;
int selectedIndex = 0;

class MultiSelectChip extends StatefulWidget {
  final List<Light> lights;
  final _LightingScreenState lightingScreenState;
  MultiSelectChip(this.lights, [this.lightingScreenState]);
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  Light selectedChoice;

  ScreenUtil _util = ScreenUtil();

  ColorPickerDataProvider _colorPickerDataProvider;

  @override
  void initState() {
    // debugPrint('init stat4e called in multiselect chip state');
    super.initState();
    selectedIndex = 0;
    // selectedLight = widget.lights[selectedIndex];
  }

  // this function will build and return the choice list
  _buildChoiceList() {
    // print(widget.lights);
    // debugPrint('widget.lights in MultiSelectChip ----- ${widget.lights.length}');

    return List<Widget>.generate(
      widget.lights.length,
      (int index) {
        return _buildChoiceChip(widget.lights[index], index);
      },
    ).toList();
  }

  _buildChoiceChip(Light item, index) {
    selectedLight = widget.lights[selectedIndex];
    return Padding(
      padding: EdgeInsets.all(_util.setSp(8)),
      child: ChoiceChip(
        label: Text(item.lightName),
        labelStyle: TextStyle(
            fontSize: _util.setSp(48),
            fontWeight: FontWeight.w800,
            // letterSpacing: util.setSp(2),
            color: index == selectedIndex
                ? Colors.black
                : Colors.white //ColorConstants.LIGHTING_CHIP_LABEL
            ),
        autofocus: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_util.setWidth(64)),
            side: BorderSide(
                color: index == selectedIndex && selectedColor != null
                    ? selectedColor
                    : Color(int.parse(item.lightColor)),
                width: _util.setWidth(4))),
        selectedColor: index == selectedIndex && selectedColor != null
            ? selectedColor
            : Color(int.parse(item.lightColor)),
        elevation: _util.setWidth(8),
        pressElevation: _util.setWidth(4),
        backgroundColor: Color(int.parse(item.lightColor)),
        selected: selectedIndex == index, // selectedChoice == item,
        onSelected: (selected) {
          _colorPickerDataProvider.initialColor =
              Color(int.parse(item.lightColor));
          setState(() {
            selectedChoice = item;
            selectedIndex = index;
            selectedColor = Color(int.parse(item.lightColor));
            selectedLight = item;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _colorPickerDataProvider = Provider.of<ColorPickerDataProvider>(context);
    return Wrap(
      alignment: WrapAlignment.center,
      children: _buildChoiceList(),
    );
  }
}
