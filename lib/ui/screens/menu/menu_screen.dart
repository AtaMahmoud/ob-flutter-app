import 'package:flutter/material.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/login_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/registration_screen.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';

class MenuScreen extends StatefulWidget {
  static const String routeName = '/menu';

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Appbar(ScreenTitle.WELCOME),
              Spacer(),
              UIHelper.getButton('Login', () {
                Navigator.of(context).pushNamed(LoginScreen.routeName,arguments: ScreenTitle.WELCOME);
              }),
              SizedBox(height: 24.0),
              UIHelper.getButton('Register', () {
                Navigator.of(context).pushNamed(RegistrationScreen.routeName);
              }),
              SizedBox(height: 56),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
