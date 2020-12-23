import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';

class SpaceItem extends StatefulWidget {
  SpaceItem(
      {Key key,
      this.index,
      this.isSelected,
      this.hasWarning,
      this.label,
      this.onPressed})
      : super(key: key);
  final label;
  final bool isSelected;
  final bool hasWarning;
  final VoidCallback onPressed;
  final int index;

  @override
  _SpaceItemState createState() => _SpaceItemState();
}

class _SpaceItemState extends State<SpaceItem> {
  Color _color, _textColor, _hoverColor, _disabledColor;
  bool _isSelected = false;
  bool _hasWarning = false;

  @override
  void initState() {
    _isSelected = widget.isSelected;
    _hasWarning = widget.hasWarning;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isSelected) {
      _textColor = CommonTheme.white;
      _color = CommonTheme.primary;
    } else {
      _textColor = CommonTheme.primary;
      _color = CommonTheme.white;
    }

    _hoverColor = CommonTheme.primaryLight;
    _disabledColor = CommonTheme.greyLightest;

    return ClipPath(
      clipper: SpaceClipper(isSelected: _isSelected),
      child: MaterialButton(
        onPressed: () {
          // setState(() {
          //   _isSelected = !_isSelected;
          // });
          widget.onPressed.call();
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), side: BorderSide.none),
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 4, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _hasWarning
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SvgPicture.asset(
                        ImagePaths.svgIcWarning,
                        fit: BoxFit.scaleDown,
                      ),
                    )
                  : Container(),
              Text(
                widget.label,
                style: CommonTheme.tsBodySmall.apply(
                  color: _textColor,
                ),
              ),
            ],
          ),
        ),
        color: _color,
        disabledColor: _disabledColor,
        hoverColor: _hoverColor,
      ),
    );
  }


  @override
  void didUpdateWidget(covariant SpaceItem oldWidget) {
     super.didUpdateWidget(oldWidget);
    _isSelected = widget.isSelected;
    _hasWarning = widget.hasWarning;
   
  }
}

class SpaceClipper extends CustomClipper<Path> {
  bool isSelected = false;

  SpaceClipper({Key key, this.isSelected});

  @override
  getClip(Size size) {
    Path path = Path();
    double h = size.height * .9;
    double w = size.width;
    if (isSelected) {
      path.addRRect(RRect.fromLTRBR(0, 0, w, h * .85, Radius.circular(6)));
      path.moveTo(w * .45, h * .85);
      path.lineTo(w / 2, h);
      path.lineTo(w * .55, h * .85);
    } else {
      path.addRRect(RRect.fromLTRBR(0, 0, w, h * .85, Radius.circular(6)));
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class SpaceItemData {
  // SpaceItem spaceItem = SpaceItem(label: 'Overview',hasWarning: true,isSelected: false,onPressed: ,)
  int index;
  bool isSelected;
  String label;
  bool hasWarning;

  SpaceItemData({this.index, this.isSelected, this.label, this.hasWarning});
}
