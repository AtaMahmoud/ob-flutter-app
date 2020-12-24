import 'package:flutter/material.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/cards.dart';

class RoomDetails extends StatefulWidget {
  RoomDetails({Key key}) : super(key: key);

  @override
  _RoomDetailsState createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GenericCard(
            hasSwitch: false,
            title: 'No Preset Available',
            data: 'Click to save current settings as preset',
          ),
          GenericCard(
            hasSwitch: true,
            switchValue: true,
            title: 'Lights-Ceiling',
            dataIcon: ImagePaths.svgIcLightKnob,
            data: 'Brightness 60%',
            subData: 'My Bathroom Preset',
          ),
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
  }
}
