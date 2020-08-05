import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:ocean_builder/ui/cleeper_ui/top_clipper.dart';
import 'package:ocean_builder/ui/cleeper_ui/top_clipper_home.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  final bool hasAvator;

  const HomeAppbar(this.title,{this.scaffoldKey,this.hasAvator=false,this.innerDrawerKey});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: TopClipperHome(title,scaffoldKey: scaffoldKey,innerDrawerKey: innerDrawerKey, hasAvator: hasAvator,));
  }

  @override
  Size get preferredSize => Size.fromHeight(0);
}
