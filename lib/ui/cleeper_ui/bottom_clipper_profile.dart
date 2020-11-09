import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/custom_clipper/custom_clipper.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';

class BottomClipperProfile extends StatefulWidget {
  final String leftText, rightText;
  final VoidCallback callbackBack, callback;
  final bool partiallyTransparent;

  const BottomClipperProfile(this.leftText, this.rightText,
      this.partiallyTransparent, this.callbackBack, this.callback);

  @override
  _BottomClipperProfileState createState() => _BottomClipperProfileState();
}

class _BottomClipperProfileState extends State<BottomClipperProfile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomBottomProfileShapeClipper(),
          child: Container(
            height: 300.h,
            color: Colors.white,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Padding(
            padding: EdgeInsets.all(24.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: widget.callbackBack,
                  child: UIHelper.getBackLayout(
                    widget.leftText,
                    iconColor: ColorConstants.TOP_CLIPPER_START,
                    textColor: ColorConstants.TOP_CLIPPER_START,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    child: UIHelper.getInvertedNextLayout(
                      widget.rightText,
                      partiallyTransparent: widget.partiallyTransparent,
                      iconColor: ColorConstants.TOP_CLIPPER_START,
                      textColor: ColorConstants.TOP_CLIPPER_START,
                      icon: Icons.check,
                    ),
                    onTap:
                        !widget.partiallyTransparent ? widget.callback : null,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
