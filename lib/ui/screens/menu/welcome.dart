import 'package:flutter/material.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/ui/cleeper_ui/top_clipper.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {

    GlobalContext.currentScreenContext = context;
    
    return Scaffold(
      body: Column(
        children: <Widget>[
          Appbar(ScreenTitle.WELCOME),
          Spacer(),
          UIHelper.getImageTextColumn(
              'images/phone.png', 'SCAN HOME QR CODE', 200, () => () {}),
          Spacer(),
          UIHelper.getImageTextColumn('images/default_icon.png',
              'DESIGN YOUR SEAPOD', 150, () => () {})
        ],
      ),
    );
  }
}
