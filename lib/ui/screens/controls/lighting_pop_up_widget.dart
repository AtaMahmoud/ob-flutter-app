import 'package:flutter/material.dart';
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
import 'package:ocean_builder/ui/screens/controls/lighting_screen.dart';
import 'package:ocean_builder/ui/widgets/round_slider_trackbar.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class LightingPopupContent extends StatefulWidget {
  LightingPopupContent({Key key}) : super(key: key);

  @override
  _LightingPopupContentState createState() => _LightingPopupContentState();
}

class _LightingPopupContentState extends State<LightingPopupContent> {
  LightSceneBloc _bloc = LightSceneBloc();
  SelectedOBIdProvider _selectedOBIdProvider;
  UserProvider _userProvider;
  OceanBuilderProvider _oceanBuilderProvider;

  User _user;
  Future<SeaPod> _selectedOceanBuilder;
  OceanBuilderUser _oceanBuilderUser;
  List<Scene> _lightingScenes = [];

  bool switchOn;
  double _sliderValue;

  String _selectedSceneId;

  @override
  Widget build(BuildContext context) {
    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);
    _userProvider = Provider.of<UserProvider>(context);
    _oceanBuilderProvider = Provider.of<OceanBuilderProvider>(context);
    _user = _userProvider.authenticatedUser;

    _selectedOceanBuilder = _oceanBuilderProvider.getSeaPod(
        _selectedOBIdProvider.selectedObId, _userProvider);

    return Container(
      child: _lightingPopupContentFuture(),
    );
  }

  Widget _lightingPopupContentFuture() {
    return FutureBuilder<SeaPod>(
        future: _selectedOceanBuilder,
        // initialData: stormGlassDataProvider.weatherDataToday,
        builder: (context, snapshot) {
          if (snapshot.hasData) _getLighitingSceneInfo(snapshot.data);
          return snapshot.hasData
              ? _lightingPopupContent() //movieGrid(snapshot.data)
              : Center(child: CircularProgressIndicator());
        });
  }

  _getLighitingSceneInfo(SeaPod selectedOceanBuilder) {
    // debugPrint('_getOceanBuilder');
    _lightingScenes.clear();

    if (selectedOceanBuilder.lightScenes != null &&
        selectedOceanBuilder.lightScenes.length > 0) {
      _lightingScenes.addAll(selectedOceanBuilder.lightScenes);
    }

    if (selectedOceanBuilder.users.length != null) {
      for (var i = 0; i < selectedOceanBuilder.users.length; i++) {
        // debugPrint('user name --- ${selectedOceanBuilder.users[i].userName}');
        // print(_user.userID);
        // print(selectedOceanBuilder.users[i].userId);

        if (selectedOceanBuilder.users[i].userId.contains(_user.userID)) {
          _oceanBuilderUser = selectedOceanBuilder.users[i];
          _selectedSceneId = _oceanBuilderUser.lighting.selectedScene;

          if (_selectedSceneId == null &&
              _oceanBuilderUser.lighting.sceneList.isNotEmpty) {
            _selectedSceneId = _oceanBuilderUser.lighting.sceneList[0].id;
            _oceanBuilderUser.lighting.selectedScene = _selectedSceneId;
            // getLightSceneById(_selectedSceneId);
          }

          // print(_oceanBuilderUser.lighting.toJson());

          if (_oceanBuilderUser != null &&
              _oceanBuilderUser.lighting.sceneList != null)
            _lightingScenes.addAll(_oceanBuilderUser.lighting.sceneList);

          switchOn = _oceanBuilderUser.lighting.isLightON;
          debugPrint('light scene on/off status ------ $switchOn');

          _sliderValue = _oceanBuilderUser.lighting.intensity != null
              ? _oceanBuilderUser.lighting.intensity
              : 50;
          if (_oceanBuilderUser.lighting.sceneList.isNotEmpty)
            _bloc.lightSceneController
                .add(getLightSceneById(_selectedSceneId).name);
        }
      }
    }
  }

  // lighting popup

  Widget _lightingPopupContent() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 16.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.w),
            color: ColorConstants.LIGHT_POPUP_BKG),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 32.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppStrings.lights,
                        style: TextStyle(
                            fontSize: 36.sp,
                            color: ColorConstants.LIGHT_POPUP_TITLE),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 16.w,
                      top: 16.h,
                    ),
                    child: Image.asset(
                      ImagePaths.cross,
                      width: 36.w,
                      height: 36.w,
                      color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 32.h, bottom: 32.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Transform.scale(
                    scale: 3.62.h,
                    child: Switch(
                      onChanged: _onSwitchChanged,
                      value: switchOn,
                      activeColor: Colors.green,
                      activeTrackColor: Colors.white,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppStrings.intensity,
                  style: TextStyle(
                      fontSize: 36.sp, color: ColorConstants.LIGHT_POPUP_TEXT),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.h, bottom: 32.h),
              child: _intesitySlider(),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 48.h,
                bottom: 48.h,
              ),
              child: _lightingScenes.isNotEmpty
                  ? _getDropdown(_lightingScenes, _bloc.lightScene,
                      _bloc.lightSceneChanged, true,
                      label: 'Select Scene')
                  : Container(),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(LightingScreen.routeName,
                    arguments: LightingScreenParams(
                        _oceanBuilderUser,
                        _userProvider,
                        _selectedOBIdProvider,
                        _selectedSceneId) //_oceanBuilderUser
                    );
              },
              child: Padding(
                padding: EdgeInsets.only(
                  top: 32.h,
                  bottom: 32.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppStrings.goTOLightingSceen,
                      style: TextStyle(
                          fontSize: 36.sp,
                          color: ColorConstants.LIGHT_POPUP_TEXT),
                    ),
                  ],
                ),
              ),
            )
          ],
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
    // setState(() {
    //   switchOn = value;
    // });
  }

  _intesitySlider() {
    debugPrint('slider value ---------- $_sliderValue ');
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: ColorConstants.LIGHT_INTENSITY_ACTIVE,
              inactiveTrackColor: ColorConstants.LIGHT_INTENSITY_INACTIVE,
              trackShape: RoundSliderTrackShape(radius: 48.h),
              trackHeight: 64.h,
              thumbColor: Colors.white,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 48.h),
              overlayColor: Colors.purple.withAlpha(32),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
            ),
            child: Slider(
              min: 0.0,
              max: 100.0,
              divisions: 100,
              value: _sliderValue.toDouble(),
              onChanged: (value) {
                _oceanBuilderUser.lighting.intensity = value;
                setState(() {
                  _sliderValue = value;
                });
              },
              onChangeEnd: (value) {
                _oceanBuilderUser.lighting.intensity = value;
                _oceanBuilderProvider
                    .updateLightSceneIntensity(
                        seapodId: _selectedOBIdProvider.selectedObId,
                        intensity: _oceanBuilderUser.lighting.intensity.toInt())
                    .then((onValue) {
                  setState(() {
                    _sliderValue = value;
                  });
                });
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '+ ',
            style: TextStyle(
                color: Colors.white,
                fontSize: 72.h,
                fontWeight: FontWeight.w900),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            ' -',
            style: TextStyle(
                color: Colors.white,
                fontSize: 72.h,
                fontWeight: FontWeight.w900),
          ),
        )
      ],
    );
  }

  Widget _getDropdown(
      List<Scene> list, Observable<String> stream, changed, bool addPadding,
      {String label = 'Label'}) {
    // debugPrint('dropdown list length ------  ${list.length}');
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return InputDecorator(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                      width: 1),
                  borderRadius: BorderRadius.circular(32.w)),
              contentPadding:
                  EdgeInsets.only(top: 16.h, bottom: 16.h, left: 32.w),
              labelText: label,
              // hintStyle: TextStyle(color: Colors.red),
              labelStyle: TextStyle(
                  color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                  fontSize: 36.sp),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  icon: Icon(Icons.arrow_drop_down,
                      size: 96.w,
                      color: snapshot.hasData
                          ? ColorConstants.ACCESS_MANAGEMENT_TITLE
                          : ColorConstants
                              .ACCESS_MANAGEMENT_SUBTITLE //ColorConstants.INVALID_TEXTFIELD,
                      ),
                  value: snapshot.hasData ? snapshot.data : list[0].name,
                  isExpanded: true,
                  underline: Container(),
                  style: TextStyle(
                    color: snapshot.hasData
                        ? ColorConstants.ACCESS_MANAGEMENT_TITLE
                        : ColorConstants
                            .ACCESS_MANAGEMENT_SUBTITLE, //ColorConstants.INVALID_TEXTFIELD,
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w400,
                    // letterSpacing: 1.2,
                    // wordSpacing: 4
                  ),
                  onChanged: (changedString) async {
                    _oceanBuilderUser.lighting.selectedScene =
                        _getLightSceneByName(changedString).id;
                    await _oceanBuilderProvider.updateSelectedLightScene(
                        seapodId: _selectedOBIdProvider.selectedObId,
                        lightSceneId: _oceanBuilderUser.lighting.selectedScene);

/*                 _oceanBuilderProvider.updateOceanBuilderUser(
                        currentUserID: _user.userID,
                        oceanBuilderID: _selectedOBIdProvider.selectedObId,
                        oceanBuilderUser: _oceanBuilderUser); */
                    changed(changedString);
                  },
                  items: list.map((data) {
                    return DropdownMenuItem(
                        value: data.name,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            data.source != null &&
                                    data.source.compareTo('seapod') == 0
                                ? Text('${data.name} [seapod]')
                                : Text('${data.name} [my scenes]'),
                          ],
                        ));
                  }).toList(),
                ),
              ),
            ),
          );
        });
  }

  Scene _getLightSceneByName(String changedString) {
    Scene selectedScene;
    _lightingScenes.map((f) {
      if (f.name.contains(changedString)) {
        selectedScene = f;
      }
    }).toList();

    _selectedSceneId = selectedScene.id;
    // debugPrint('_selectedSceneId ----------- ${_selectedSceneId} ---------- name -----  ${ selectedScene.name}  ');
    return selectedScene;
  }

  Scene getLightSceneById(String lightingSceneId) {
    Scene lightScene;

    _lightingScenes.map((f) {
      // debugPrint('---f.id-- ${f.id} -===========- lightingSceneId- $lightingSceneId');
      if (f.id.compareTo(lightingSceneId) == 0) lightScene = f;
    }).toList();

    return lightScene;
  }
}
