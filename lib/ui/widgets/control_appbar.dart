import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:ocean_builder/core/models/control_data.dart';
import 'package:ocean_builder/ui/cleeper_ui/top_clipper_control.dart';

class AppbarControl extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  // final Future<WorldWeatherOnlineData> futureWOWWeatherData;
  final ControlData controlData;

  const AppbarControl(this.title,
      {this.scaffoldKey, this.innerDrawerKey, this.controlData});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: TopClipperControl(
      title,
      scaffoldKey: scaffoldKey,
      innerDrawerKey: innerDrawerKey,
      controlData: controlData,
    ));
  }

  @override
  Size get preferredSize => Size.fromHeight(0);
}
