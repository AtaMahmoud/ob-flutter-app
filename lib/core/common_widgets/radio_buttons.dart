import 'package:flutter/material.dart';
import 'package:ocean_builder/constants/constants.dart';

enum StatusCharacter { onn, off }

class RadioButton extends StatefulWidget {
  RadioButton({Key key}) : super(key: key);

  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  StatusCharacter _character = StatusCharacter.off;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _radioButtonHorizontal('Radio Button'),
    );
  }

  _radioButtonHorizontal(String text, {String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          value: StatusCharacter.onn,
          groupValue: _character,
          onChanged: (StatusCharacter value) {
            debugPrint('radio button value is --- $value');
            setState(() {
              _character = value;
            });
          },
        ),
        // SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: ColorConstants.TOP_CLIPPER_START),
        ),
      ],
    );
  }
}
