import 'package:flutter/material.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';

class DisableIcon extends StatelessWidget {
  final bool _isDisable;

  DisableIcon(this._isDisable);

  bool get isError => _isDisable;

  @override
  Widget build(BuildContext context) {
    Widget out;

    isError
        ? out = new ImageIcon(
            AssetImage(ImagePaths.icEditDisable),
            color: Color(CommonTheme.grey.value),
          )
        : out = new Icon(null);

    return out;
  }
}
