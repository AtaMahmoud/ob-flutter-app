import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ocean_builder/core/common_widgets/buttons.dart';

class WidgetShowCase extends StatefulWidget {
  static const String routeName = '/widgetShowCase';
  WidgetShowCase({Key key}) : super(key: key);
  

  @override
  _WidgetShowCaseState createState() => _WidgetShowCaseState();
}

class _WidgetShowCaseState extends State<WidgetShowCase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SingleChildScrollView(
               child:_widgetTest(),
            ),
          ),
    );
  }

   _widgetTest(){
   return Column(
     crossAxisAlignment: CrossAxisAlignment.center,
     children: [
       PrimaryButton(label: 'Primary Button',onPressed: (){},isEnabled: true,isOutlined: false,isDestructive: false, key: Key('primary_button'),),
       PrimaryButton(label: 'Primary Button',onPressed: (){},isEnabled: false,isOutlined: false,isDestructive: false, key: Key('primary_button2'),),
       PrimaryButton(label: 'Primary Button',onPressed: (){},isEnabled: true,isOutlined: true,isDestructive: false, key: Key('primary_outline_button'),),
       PrimaryButton(label: 'Primary Button',onPressed: (){},isEnabled: false,isOutlined: true,isDestructive: false, key: Key('primary_outline_button2'),),
       PrimaryButton(label: 'Primary Button',onPressed: (){},isEnabled: true,isOutlined: true,isDestructive: true, key: Key('primary_outline_button2'),),
       PrimaryButton(label: 'Primary Button',onPressed: (){},isEnabled: false,isOutlined: true,isDestructive: true, key: Key('primary_outline_button2'),)
       ]
       );
 }

}