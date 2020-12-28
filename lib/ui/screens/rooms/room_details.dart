import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/cards.dart';
import 'package:ocean_builder/core/models/lighting.dart';
import 'package:ocean_builder/ui/screens/rooms/room_light.dart';

class RoomDetails extends StatefulWidget {
  RoomDetails(
      {Key key,
      this.name,
      this.room,
      this.selectedContentChanged,
      this.roomHeaderChanged})
      : super(key: key);
  final String name;
  final Room room;
  final Function selectedContentChanged;
  final Function roomHeaderChanged;

  @override
  _RoomDetailsState createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  GenericBloc<Room> _roomBloc = GenericBloc.private();
  GenericBloc<Light> _lightBloc = GenericBloc.private();

  @override
  void initState() {
    super.initState();
    // _roomBloc = GenericBloc(widget.room);
  }

  @override
  Widget build(BuildContext context) {
    return _roomDetails(widget.room);
  }

  Widget _roomDetails(Room room) {
    return StreamBuilder<Room>(
        stream: _roomBloc.stream,
        initialData: widget.room,
        builder: (context, snapshot) {
          return Container(
            child: Column(
              children: [
                GenericCard(
                  hasSwitch: false,
                  title: 'No Preset Available for ${room.roomName}',
                  data: 'Click to save current settings as preset',
                  onTap: () {},
                ),
                _lightCard(snapshot.data.lightModes),
                GenericCard(
                  hasSwitch: true,
                  switchValue: false,
                  title: 'Lights-floor',
                  dataIcon: ImagePaths.svgIcLightKnob,
                  data: 'Brightness 60%',
                ),
                GenericCard(
                  hasSwitch: true,
                  switchValue: true,
                  title: 'Shower Temperature',
                  data: '24${SymbolConstant.DEGREE}C',
                  subData: '>> 75.2${SymbolConstant.DEGREE}F',
                ),
              ],
            ),
          );
        });
  }

  Widget _lightCard(List<Light> lights) {
    return StreamBuilder<Light>(
        stream: _lightBloc.stream,
        initialData: lights[0],
        builder: (context, snapshot) {
          return GenericCard(
            hasSwitch: true,
            switchValue: true,
            title: snapshot.data.lightName, //'Lights-Ceiling',
            dataIcon: ImagePaths.svgIcLightKnob,
            data: 'Brightness ${snapshot.data.brightness}%',
            // subData: 'My Bathroom Preset',
            onTap: () {
              // _selectedLightBloc = GenericBloc(widget.room.lightModes[0]);
              Widget sc = RoomLight(
                  room: widget.room,
                  lights: lights,
                  stream: _lightBloc.stream,
                  changed: _lightBloc.changed,
                  roomHeaderChanged: widget.roomHeaderChanged,
                  selectedContentChanged: widget.selectedContentChanged);
              // got to room light screen with light data stream and changed method.

              widget.selectedContentChanged(sc);
            },
          );
        });
  }
}
