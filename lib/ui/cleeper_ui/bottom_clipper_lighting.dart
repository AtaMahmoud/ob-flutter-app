import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/custom_clipper/custom_clipper.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';

class BottomClipperLighting extends StatefulWidget {
  final String leftText, rightText;
  final VoidCallback callbackBack, callback;
  final bool partiallyTransparent;

  const BottomClipperLighting(this.leftText, this.rightText,
      this.partiallyTransparent, this.callbackBack, this.callback);

  @override
  _BottomClipperLightingState createState() => _BottomClipperLightingState();
}

class _BottomClipperLightingState extends State<BottomClipperLighting> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomBottomProfileShapeClipper(),
          child: Container(
            height: 250.h,
            color: Color(0xFFEDF2FD),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Padding(
            padding: EdgeInsets.all(16.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 96.h,
                  child: RaisedButton(
                    padding: EdgeInsets.only(
                      left: 128.w,
                      right: 128.w,
                    ),
                    onPressed: widget.callbackBack,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(64.w)),
                    color: ColorConstants.LIGHTING_BOTTOM_CLIPER_BUTTON_BKG,
                    child: Text(
                      widget.leftText,
                      style: TextStyle(color: Colors.white, fontSize: 38.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
