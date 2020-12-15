import 'package:flutter/material.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';

class ErrorIcon extends StatelessWidget {
  final bool _isError;

  ErrorIcon(this._isError);

  bool get isError => _isError;

  @override
  Widget build(BuildContext context) {
    Widget out;

    isError
        ? out = new ImageIcon(
            AssetImage(ImagePaths.icEditError),
            color: Color(CommonTheme.danger.value),
          )
        : out = new Icon(null);

    return out;
  }
}
