import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/custom_clipper/custom_clipper.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';

class BottomClipper2 extends StatefulWidget {
  final String leftText, rightText;
  final VoidCallback callbackBack, callback;
  final bool partiallyTransparent;

  const BottomClipper2(this.leftText, this.rightText,this.partiallyTransparent,this.callbackBack, this.callback);

  @override
  _BottomClipper2State createState() => _BottomClipper2State();
}

class _BottomClipper2State extends State<BottomClipper2> {
 double bottomClipperRatio = Platform.isIOS ? (113) / 813 : (90) / 813;
  ScreenUtil _util = ScreenUtil();

  @override
  Widget build(BuildContext context) {
  Size screenSize = MediaQuery.of(context).size;
    return ClipPath(
      clipper: CustomBottomShapeClipper(),
      child: Container(
        // padding: EdgeInsets.only(top: _util.setHeight(48)),
        // height: _util.setHeight(270),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            ColorConstants.BOTTOM_CLIPPER_START,
            ColorConstants.BOTTOM_CLIPPER_END
          ], begin: Alignment.topRight, end: Alignment.bottomLeft),
        ),
        child: IntrinsicHeight(
          child: Padding(
                          padding: EdgeInsets.fromLTRB(
                    0.0, ((screenSize.height * bottomClipperRatio) - 15) / 2, 0.0, 48.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: widget.callbackBack,
                  child: UIHelper.getBackLayout(widget.leftText),
                ),
                InkWell(
                  child: UIHelper.getNextLayout(widget.rightText,partiallyTransparent: widget.partiallyTransparent),
                  onTap: !widget.partiallyTransparent ? widget.callback : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
