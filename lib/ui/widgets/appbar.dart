import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:ocean_builder/ui/cleeper_ui/top_clipper.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  final bool hasAvator;
  final bool isMarine;
  final bool enableSkipLogin;
  final bool isDesignScreen;

  const Appbar(this.title,{this.scaffoldKey,this.hasAvator=false,this.innerDrawerKey,this.isMarine,this.enableSkipLogin = false,this.isDesignScreen = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: TopClipper(title,scaffoldKey: scaffoldKey,innerDrawerKey: innerDrawerKey, hasAvator: hasAvator,isMarine: this.isMarine,enableSkipLogin: this.enableSkipLogin,isDesignScreen: this.isDesignScreen,));
  }

  @override
  Size get preferredSize => Size.fromHeight(0);

}
