import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';

gridRowItemSVG(
    {String iconImagePath,
    String itemName,
    String value,
    GestureTapCallback onTap}) {
  // ScreenUtil _util = ScreenUtil();

  return Container(
    padding: EdgeInsets.all(32.h),
    child: InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.h),
            child: SvgPicture.asset(
              iconImagePath,
              fit: BoxFit.scaleDown,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.h),
            child: Text(
              itemName.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorConstants.MARINE_ITEM_TEXT_COLOR,
                  fontSize: 22.sp),
            ),
          ),
          _customDivider(),
          Padding(
            padding: EdgeInsets.all(8.h),
            child: Text(
              value,
              style: TextStyle(
                  color: ColorConstants.MARINE_ITEM_TEXT_COLOR,
                  fontSize: 46.5.sp),
            ),
          ),
        ],
      ),
    ),
  );
}

_customDivider() {
  return SizedBox(
    // height: util.setHeight(16),
    child: new Center(
        child: SvgPicture.asset(
      ImagePaths.svgMarineDividerLine,
      fit: BoxFit.cover,
    )),
  );
}
