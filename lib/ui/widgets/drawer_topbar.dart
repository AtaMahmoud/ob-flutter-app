import 'package:flutter/material.dart';
import 'package:ocean_builder/ui/cleeper_ui/top_clipper_drawer.dart';

class Drawerbar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool hasAvator;

  const Drawerbar({this.scaffoldKey, this.hasAvator = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: TopClipperDrawer(
      scaffoldKey: scaffoldKey,
      hasAvator: hasAvator,
    ));
  }

  @override
  Size get preferredSize => Size.fromHeight(0);
}
