import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/buttons.dart';
import 'package:ocean_builder/core/common_widgets/cards.dart';
import 'package:ocean_builder/ui/screens/rooms/room_details.dart';
import 'package:ocean_builder/ui/screens/rooms/rooms.dart';
import 'package:rxdart/src/observables/observable.dart';
import 'package:ocean_builder/core/models/lighting.dart';
import 'package:ocean_builder/core/common_widgets/select_button.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/core/common_widgets/sliders.dart';

class RoomLight extends StatefulWidget {
  RoomLight(
      {Key key,
      this.room,
      this.lights,
      this.stream,
      this.changed,
      this.selectedContentChanged,
      this.roomHeaderChanged})
      : super(key: key);
  final Room room;
  final List<Light> lights;
  final Observable<Light> stream;
  final Function changed;
  final Function roomHeaderChanged;
  final Function selectedContentChanged;
  @override
  _RoomLightState createState() => _RoomLightState();
}

class _RoomLightState extends State<RoomLight> {
  bool _isExpanded = false;
  List<Light> _lights;
  Light _selectedLight = Light();

  @override
  void initState() {
    super.initState();
    _lights = widget.lights;
    _selectedLight = _lights[0];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // widget.roomHeaderChanged(new Text('Seapod/roomname'));
    return Container(
      child: StreamBuilder<Light>(
          stream: widget.stream,
          initialData: widget.lights[0],
          builder: (context, snapshot) {
            return Column(
              children: [
                _lightControl(),
                _lightSelection(snapshot.data),
                _brightness(snapshot.data),
                _backButton()
              ],
            );
          }),
    );
  }

  Widget _lightControl() {
    return GenericCard(
      hasSwitch: true,
      switchValue: true,
      title: 'Lights',
      showOnOff: true,
      // dataIcon: ImagePaths.svgIcLightKnob,
      onControllPressed: (value) {
        print('Pressed switch -- $value');
      },
      // data: 'Brightness ${snapshot.data.brightness}%',
      // subData: 'My Bathroom Preset',
      // onTap: () {
      //   widget.selectedContentChanged(Text('Modal for color picker'));
      // },
    );
  }

  _lightSelection(Light light) {
    return Container(
        child: Column(
      children: [
        _lightColor(_selectedLight, false),
        if (!_isExpanded)
          Container()
        else
          ..._lights.map((data) => _lightColor(data, true)).toList(),
      ],
    ));
  }

  _lightColor(Light light, bool isSelectable) {
    return InkWell(
      onTap: () {
        if (isSelectable) {
          setState(() {
            _selectedLight = light;
            _isExpanded = !_isExpanded;
            widget.changed(light);
          });
        } else {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        }
      },
      child: isSelectable
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              color: isSelectable &&
                      light.lightName.compareTo(_selectedLight.lightName) == 0
                  ? CommonTheme.primaryLightest
                  : CommonTheme.white,
              child: _ligtColorContent(light, isSelectable),
            )
          : Card(
              // elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: CommonTheme.white,
              semanticContainer: false,
              child: _ligtColorContent(light, isSelectable),
            ),
    );
  }

  _ligtColorContent(Light light, bool isSelectable) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              '${light.lightName ?? ''}',
              style: CommonTheme.tsBodyExtraSmall.apply(
                  color: isSelectable &&
                          light.lightName.compareTo(_selectedLight.lightName) ==
                              0
                      ? CommonTheme.greyDark
                      : CommonTheme.primary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SvgPicture.asset(
              ImagePaths.svgIcLightKnob,
              fit: BoxFit.scaleDown,
              color: Color(int.parse(light.lightColor)),
              // width: 12,
              // height: 12,
            ),
          )
        ],
      ),
    );
  }

  _brightness(Light light) {
    return Card(
      // elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: CommonTheme.white,
      semanticContainer: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: CommonSlider(
          key: Key('$light'),
          sliderValue: light.brightness.toDouble(),
          hasSliderLabel: true,
          isDarkBg: false,
          sliderLabel: '${light.lightName}',
          onChangedMethod: (value) {
            setState(() {
              light.brightness = value.toInt();
            });
          },
        ),
      ),
    );
  }

  _backButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        PrimaryButton(
          isDestructive: false,
          isEnabled: true,
          isNaked: true,
          isOutlined: false,
          label: '« Back',
          onPressed: () {
            Widget sc = RoomDetails(
                name: widget.room.roomName,
                room: widget.room,
                selectedContentChanged: widget.selectedContentChanged);
            widget.selectedContentChanged(sc);
            // widget.roomHeaderChanged(
            //     context.findAncestorStateOfType<RoomsState>().spaceBar());
          },
        )
      ],
    );
  }
}
