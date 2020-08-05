import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/custom_clipper/custom_clipper.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';

class BottomClipperTitle extends StatefulWidget {
  final String leftText, rightText, title, iconPath;
  final VoidCallback callbackBack, callbackNext;
  final bool isNextEnabled;
  final AnimationController animationController;

  const BottomClipperTitle(this.title, this.iconPath, this.leftText,
      this.rightText, this.callbackBack, this.callbackNext,
      {this.isNextEnabled = true,this.animationController});

  @override
  _BottomClipperTitleState createState() => _BottomClipperTitleState();
}

class _BottomClipperTitleState extends State<BottomClipperTitle> with SingleTickerProviderStateMixin{
  double bottomClipperRatio = Platform.isIOS ? (113) / 813 : (90) / 813;
  ScreenUtil _util;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    _util = ScreenUtil();
    double startX,endX;
    
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails detailstartDetails){
        startX = detailstartDetails.localPosition.dx;
      },
      onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetails){
        // endX = detailsartDetails.globalPosition.dx;
        endX = dragUpdateDetails.localPosition.dx;
      },
      onHorizontalDragEnd: (DragEndDetails dragEndDetails){
        // swipe left and swipe right
        if(endX != null && startX != null){

          if(endX > startX) {
            widget.callbackBack();
          } else {
            widget.callbackNext();
          }

        }

      },
          child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: TitleBottomShapeClipper(),
            child: Container(
              height: Platform.isIOS ? screenSize.height * bottomClipperRatio : ScreenUtil().setHeight(280),
              decoration: BoxDecoration(
                color: Color(0xFF174295),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                _util.setWidth(32),//16.0, 
                Platform.isIOS ? ((screenSize.height * bottomClipperRatio)) / 2 : _util.setHeight(140), 
                 _util.setWidth(32), 
                0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: widget.callbackBack,
                  child: UIHelper.getBackLayout(widget.leftText, showText: false),
                ),
                AnimatedOpacity(
                  opacity: widget.animationController.value,
                  duration: Duration(seconds: 1),
                  child: _titleWithIcon(),
                ),
                widget.rightText.length > 1
                    ? InkWell(
                        onTap: widget.isNextEnabled ? widget.callbackNext : null,
                        child: UIHelper.getNextLayout(widget.rightText,
                            partiallyTransparent: !widget.isNextEnabled,
                            showText: false),
                      )
                    : Spacer()
              ],
            ),
          )
        ],
      ),
    );
  }

  _titleWithIcon() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // ImageIcon(
        //   AssetImage(widget.iconPath),
        //   size: ScreenUtil().setHeight(64),
        //   color: Colors.white,
        // ),
        SvgPicture.asset(
          widget.iconPath,
          width: _util.setWidth(78),
          height: _util.setHeight(78),
          color:  Colors.white,
        ),
        SizedBox(
          width: _util.setWidth(16),
        ),
        new Text(
          widget.title.toUpperCase(),
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: _util.setSp(64),
              color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
