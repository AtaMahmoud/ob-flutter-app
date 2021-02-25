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
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Material(
        type: MaterialType.transparency,
        child: // _buildOverlayContent(context)
            SafeArea(
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
      // padding: EdgeInsets.all(24),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
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
      double paddingBottom}) {
    Navigator.push(
      context,
      PopupLayout(
        top: paddingTop == null ? 32.h : paddingTop,
        left: paddingLeft == null ? 32.w : paddingLeft,
        right: paddingright == null ? 32.w : paddingright,
        bottom: paddingBottom == null ? 32.h : paddingBottom,
        child: widget,
      ),
    );
  }

  static showChartPopup(BuildContext context, Widget widget,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 32.h,
        left: 32.w,
        right: 32.w,
        bottom: 32.h,
        child: widget,
      ),
    );
  }

  static Widget popUpTitle(BuildContext context, String title,
      String iconImagePath, String valueNow) {
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
                  padding: EdgeInsets.all(16.h),
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
                      padding: EdgeInsets.all(8.h),
                      child: Text(
                        title,
                        style: TextStyle(
                            color: ColorConstants.MARINE_ITEM_TEXT_COLOR,
                            fontSize: 32.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.h),
                      child: Text(
                        valueNow.toUpperCase(),
                        style: TextStyle(
                            color: ColorConstants.MARINE_ITEM_TEXT_COLOR,
                            fontSize: 40.sp),
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
                    width: 48.w,
                    height: 48.h,
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
