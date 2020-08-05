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
    ScreenUtil _util = ScreenUtil();
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomBottomProfileShapeClipper(),
          child: Container(
            height: _util.setHeight(250),
            color: Color(0xFFEDF2FD),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Padding(
            padding: EdgeInsets.all(_util.setHeight(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: _util.setHeight(96),
                  child: RaisedButton(
                    padding: EdgeInsets.only(
                      left: _util.setWidth(128),
                      right: _util.setWidth(128),
                      // top: util.setHeight(8),
                      // bottom: util.setHeight(8)
                    ),
                    onPressed: widget.callbackBack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        _util.setWidth(64)
                      )
                    ),
                    color: ColorConstants.LIGHTING_BOTTOM_CLIPER_BUTTON_BKG,
                    child: Text(
                      widget.leftText,
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: _util.setSp(38)
                        ),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: util.setHeight(32),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     bottom:util.setHeight(8)
                //     ),
                //   child: InkWell(
                //     child: Text(
                //       widget.rightText,
                //       style: TextStyle(
                //         color: ColorConstants.LIGHTING_HEXCODE,
                //         fontSize: util.setSp(38)
                //         ),
                //     ),
                //     onTap: !widget.partiallyTransparent ? widget.callback : null,
                //   ),
                // )
              ],
            ),
          ),
        )
      ],
    );
  }
}
