import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:ocean_builder/core/models/storm_glass_data.dart';
import 'package:ocean_builder/core/models/w_weather_o_data.dart';
import 'package:ocean_builder/ui/cleeper_ui/top_clipper_marine.dart';

class AppbarMarine extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  final Future<StormGlassData> futureWOWWeatherData;

  const AppbarMarine(this.title,
      {this.scaffoldKey, this.innerDrawerKey, this.futureWOWWeatherData});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: TopClipperMarine(
      title,
      scaffoldKey: scaffoldKey,
      innerDrawerKey: innerDrawerKey,
      futureWOWWeatherData: futureWOWWeatherData,
    ));
  }

  @override
  Size get preferredSize => Size.fromHeight(0);
}
