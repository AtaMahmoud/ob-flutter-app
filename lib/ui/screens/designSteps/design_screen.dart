import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/ocean_builder.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper_2.dart';
import 'package:ocean_builder/ui/screens/designSteps/exterior_finish_screen.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
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
    // TODO: implement initState
    super.initState();
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ColorConstants.BKG_GRADIENT),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Appbar(
              ScreenTitle.DESIGN,
              isDesignScreen: true,
            ),
            // Spacer(),
            Text(
              AppStrings.designMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: Fonts.fontVarela,
                  fontSize: ScreenUtil().setSp(48),
                  color: ColorConstants.TEXT_COLOR),
            ),
            SizedBox(height: 16.h),
            Container(
              child: Image.asset(ImagePaths.deckImage,
                  fit: BoxFit.cover,
                  // width: MediaQuery.of(context).size.width * 2 / 3
                  ),
            ),
            SizedBox(height: 16.h),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     InkWell(
            //       onTap: () {
            //         //  PopUpHelpers.showPopup(context, DesignNamePopupContent(),'Continue Design');
            //         PopUpHelpers.showPopup(context,
            //             SaveYourSeaPodPopupContent(), 'Save Your SeaPod');
            //       },
            //       child: Padding(
            //         padding: EdgeInsets.all(ScreenUtil().setSp(16)),
            //         child: Text(
            //           'CONTINUE PREVIOUS DESIGN',
            //           style: TextStyle(
            //               fontWeight: FontWeight.w900,
            //               color: ColorConstants.PROFILE_BKG_1),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // Spacer(),
            BottomClipper(ButtonText.BACK, AppStrings.startCustomization,
                 goBack, goToNext)
          ],
        ),
      ),
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
