import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/custom_clipper/custom_clipper.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';

class BottomClipper extends StatefulWidget {
  final String leftText, rightText;
  final VoidCallback callbackBack, callbackNext;
  final bool isNextEnabled;

  const BottomClipper(
      this.leftText, this.rightText, this.callbackBack, this.callbackNext,
      {this.isNextEnabled = true});

  @override
  _BottomClipperState createState() => _BottomClipperState();
}

class _BottomClipperState extends State<BottomClipper> {
  double bottomClipperRatio = Platform.isIOS ? (113) / 813 : (90) / 813;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomBottomShapeClipper(),
          child: Container(
            // height: screenSize.height * bottomClipperRatio -17,
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
                // padding: EdgeInsets.symmetric(vertical: 72.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: widget.callbackBack,
                      child: UIHelper.getBackLayout(widget.leftText),
                    ),
                    widget.rightText.length > 1
                        ? InkWell(
                            onTap: widget.isNextEnabled
                                ? widget.callbackNext
                                : null,
                            child: UIHelper.getNextLayout(widget.rightText,
                                partiallyTransparent: !widget.isNextEnabled),
                          )
                        : Spacer()
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
