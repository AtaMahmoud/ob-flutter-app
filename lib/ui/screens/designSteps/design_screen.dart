import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/ocean_builder.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/exterior_finish_screen.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class DesignScreen extends StatefulWidget {
  static const String routeName = '/design';

  @override
  _DesignScreenState createState() => _DesignScreenState();
}

class _DesignScreenState extends State<DesignScreen> {
  @override
  void initState() {
    super.initState();
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    return Scaffold(
      body: Stack(
        children: [_mainContent(), _bottomBar()],
      ),
    );
  }

  Container _mainContent() {
    return Container(
      decoration: BoxDecoration(gradient: ColorConstants.BKG_GRADIENT),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _topBar(),
          _designMessage(),
          SpaceH32(),
          _deckImage(),
          SpaceH32(),
        ],
      ),
    );
  }

  Container _deckImage() {
    return Container(
      child: Image.asset(
        ImagePaths.deckImage,
        fit: BoxFit.cover,
        // width: MediaQuery.of(context).size.width * 2 / 3
      ),
    );
  }

  Positioned _bottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: BottomClipper(
          ButtonText.BACK, AppStrings.startCustomization, goBack, goToNext),
    );
  }

  Text _designMessage() {
    return Text(
      AppStrings.designMessage,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: Fonts.fontVarela,
          fontSize: ScreenUtil().setSp(48),
          color: ColorConstants.TEXT_COLOR),
    );
  }

  Appbar _topBar() {
    return Appbar(
      ScreenTitle.DESIGN,
      isDesignScreen: true,
    );
  }

  goBack() {
    Navigator.pop(context);
  }

  goToNext() {
    final DesignDataProvider designDataProvider =
        Provider.of<DesignDataProvider>(context);
    designDataProvider.oceanBuilder = new OceanBuilder();
    Navigator.of(context).pushNamed(ExteriorFinishScreen.routeName);
  }
}
