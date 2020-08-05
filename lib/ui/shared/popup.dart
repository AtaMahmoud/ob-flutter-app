import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';

class PopupLayout extends ModalRoute {
  double top;
  double bottom;
  double left;
  double right;
  Color bgColor;
  final Widget child;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor =>
      bgColor == null ? Colors.black.withOpacity(0.5) : bgColor;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => false;

  PopupLayout(
      {Key key,
      this.bgColor,
      @required this.child,
      this.top,
      this.bottom,
      this.left,
      this.right});

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    if (top == null) this.top = 10;
    if (bottom == null) this.bottom = 20;
    if (left == null) this.left = 20;
    if (right == null) this.right = 20;

    return GestureDetector(
      onTap: () {
        // call this method here to hide soft keyboard
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Material(
        // This makes sure that text and other content follows the material style
        type: MaterialType.transparency,
        //type: MaterialType.canvas,
        // make sure that the overlay content is not cut off
        child: SafeArea(
          bottom: true,
          child: _buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: this.bottom,
          left: this.left,
          right: this.right,
          top: this.top),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class PopUpHelpers {

  static showPopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext,
      double paddingTop,
      double paddingLeft, 
      double paddingright, 
      double paddingBottom
      }
      ) {
    Navigator.push(
      context,
      PopupLayout(
        top: paddingTop ==null ? ScreenUtil().setHeight(32) : paddingTop,
        left: paddingLeft ==null ? ScreenUtil().setHeight(32) : paddingLeft,
        right: paddingright ==null ? ScreenUtil().setHeight(32) : paddingright,
        bottom: paddingBottom ==null ? ScreenUtil().setHeight(32) : paddingBottom,
        child: widget,
      ),
    );
  }

  static showChartPopup(BuildContext context, Widget widget,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: ScreenUtil().setHeight(32),//12,
        left: ScreenUtil().setWidth(32),//12,
        right: ScreenUtil().setWidth(32),//12,
        bottom: ScreenUtil().setHeight(32),//12,
        child: widget,
      ),
    );
  }

  static Widget popUpTitle(BuildContext context, String title,
      String iconImagePath, String valueNow) {
    var util = ScreenUtil();
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(util.setHeight(16)),
                  child: iconImagePath.contains('svg')
                      ? SvgPicture.asset(
                          iconImagePath,
                          fit: BoxFit.scaleDown,
                          color: ColorConstants.TOP_CLIPPER_END_DARK,
                        )
                      : ImageIcon(
                          AssetImage(iconImagePath),
                          // size: util.setHeight(200),
                          color: ColorConstants.MARINE_ITEM_COLOR,
                        ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(util.setHeight(8)),
                      child: Text(
                        title,
                        style: TextStyle(
                            color: ColorConstants.MARINE_ITEM_TEXT_COLOR,
                            fontSize: util.setSp(32)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(util.setHeight(8)),
                      child: Text(
                        valueNow.toUpperCase(),
                        style: TextStyle(
                            color: ColorConstants.MARINE_ITEM_TEXT_COLOR,
                            fontSize: util.setSp(40)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                  child: Image.asset(
                    ImagePaths.cross,
                    color: ColorConstants.MARINE_ITEM_COLOR,
                    width: util.setWidth(48),
                    height: util.setHeight(48),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
