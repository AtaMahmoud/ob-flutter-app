import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';

gridRowItemSVG(
    {String iconImagePath,
    String itemName,
    String value,
    GestureTapCallback onTap}) {
  ScreenUtil _util = ScreenUtil();

  return Container(
    padding: EdgeInsets.all(_util.setHeight(32)),
    child: InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(_util.setHeight(8)),
            child: SvgPicture.asset(
              iconImagePath,
              fit: BoxFit.scaleDown,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(_util.setHeight(8)),
            child: Text(
              itemName.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorConstants.MARINE_ITEM_TEXT_COLOR,
                  fontSize: _util.setSp(22)),
            ),
          ),
          _customDivider(),
          Padding(
            padding: EdgeInsets.all(_util.setHeight(8)),
            child: Text(
              value,
              style: TextStyle(
                  color: ColorConstants.MARINE_ITEM_TEXT_COLOR,
                  fontSize: _util.setSp(46.5)),
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
