import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class PrimaryButton extends StatefulWidget {
  PrimaryButton({Key key}) : super(key: key);

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isEnabled = true;
  @override
  Widget build(BuildContext context) {
    return Container(
       child: MaterialButton(
         onPressed:(){},
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(16),
           side: _isEnabled ? BorderSide.none : BorderSide(
             color:Color(0xFFD4D4D4)
             )
           ),
         
         child: Text(
           'Button',
          //  textScaleFactor: 1.0,
          style: TextStyle(
            color:_isEnabled ? Colors.white :Color(0xFFD4D4D4),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.0
            ),
         ),
         color: Color(0xFF2D68BF),
         disabledColor:  Color(0xFFF7F7F7),
         enableFeedback: false,
         hoverColor:Color(0xFF649FF8),
         ),
    );
  }
}