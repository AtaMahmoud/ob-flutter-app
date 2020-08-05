import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/ui/screens/menu/landing_screen.dart';
import 'package:ocean_builder/ui/screens/menu/welcome.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/registration_screen.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';

class SwiperContainerScreen extends StatefulWidget {
  static const String routeName = '/swiperContainer';

  @override
  _SwiperContainerScreenState createState() => _SwiperContainerScreenState();
}

class _SwiperContainerScreenState extends State<SwiperContainerScreen> {
  @override
  Future initState() {
    UIHelper.setStatusBarColor();
    super.initState();
  }

  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();

  var _controller = new SwiperController();

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    // return customDrawer(_innerDrawerKey, _currentScreen());
    // return _currentScreen();
    List<Widget> containerList = new List<Widget>();
    containerList.add(_currentScreen());
    containerList.add(LandingScreen());
    containerList.add(RegistrationScreen());
    containerList.add(Welcome());
    return new Swiper(
      itemBuilder: (BuildContext context, int index) {
        //new Image.network("http://via.placeholder.com/350x150",fit: BoxFit.fill,);
        // debugPrint('loading index -- '+ index.toString());
        return containerList[index];
      },
      itemCount: containerList.length,
      // pagination: new SwiperPagination(),
      // control: new SwiperControl(),
      controller: _controller,
      // autoplayDelay: 100,
      duration: 1000,
      loop: false,
    );
  }

  Widget _currentScreen() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Appbar(ScreenTitle.WELCOME),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: UIHelper.imageTextColumn(
                        ImagePaths.loginToDashboard, 'Go To Welcome screen'),
                  ),
                  onTap: () {
                    _controller.move(3, animation: true);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
