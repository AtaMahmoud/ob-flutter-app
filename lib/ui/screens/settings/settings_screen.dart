import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/ui/screens/settings/change_email_pop_up_widget.dart';
import 'package:ocean_builder/ui/screens/settings/change_password_pop_up_widget.dart';
import 'package:ocean_builder/ui/screens/settings/notification_settings.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:ocean_builder/ui/shared/shared_pref_data.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class SettingsWidget extends StatefulWidget {
  static const String routeName = '/settingsWidget';

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserProvider userProvider;
  ScreenUtil _util;
  
  File _profileImageFile;

  @override
  void initState() {
    UIHelper.setStatusBarColor(color: Colors.white);
    // Future.delayed(Duration.zero).then((_) {

    // });
    _getProfilePicture();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    GlobalContext.currentScreenContext = context;
    
    userProvider = Provider.of<UserProvider>(context);

    _util = ScreenUtil();

    return _mainContent();//customDrawer(_innerDrawerKey, _mainContent());

  }

  _mainContent(){
        return WillPopScope(
           onWillPop: () async => false,
                  child: Scaffold(
      key: _scaffoldKey,
      drawer: HomeDrawer(isSecondLevel: true,screenIndex: DrawerIndex.SETTINGS,),
      drawerScrimColor: AppTheme.drawerScrimColor.withOpacity(.65),
      body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(8)
          ),
          
          child: Stack(
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  UIHelper.getTopEmptyContainerWithColor(
                      ScreenUtil().setHeight(256),//ScreenUtil.statusBarHeight * 3, 
                      Colors.white
                      ),
                  SliverToBoxAdapter(
                    child: Container(
                      // color: ColorConstants.MODAL_BKG.withOpacity(.375),
                      // padding: EdgeInsets.only(top: 16.0),
                      child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: _util.setWidth(256),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: _profileImageFile != null ? _util.setWidth(256) : _util.setWidth(128),
                                backgroundImage: _profileImageFile != null
                                    ? FileImage(
                                        _profileImageFile,
                                      )
                                    : AssetImage(
                                        ImagePaths.icAvatar,
                                        
                                      ),
                              ),
                            ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                        vertical: _util.setHeight(48), horizontal: 8.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // _next7DaysweatherDataFuture()
                            _horizontalLine(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: (){
                              PopUpHelpers.showPopup(context, ChangeEmailPopupContent(),'Change Email');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Change Email',
                                    style: TextStyle(
                                        color: ColorConstants.TOP_CLIPPER_END,
                                        fontWeight: FontWeight.normal,
                                        fontSize: _util.setSp(64))),
                                ImageIcon(
                                  AssetImage(
                                    ImagePaths.icMail
                                  ),
                                  size: _util.setWidth(64),
                                  color: ColorConstants.TOP_CLIPPER_END,

                                )        
                              ],
                            ),
                          ),
                        ),


                    _horizontalLine(),

                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: (){
                              PopUpHelpers.showPopup(context, ChangePasswordPopupContent(),'Change Password');
                            },
                                                    child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Change Password',
                                    style: TextStyle(
                                        color: ColorConstants.TOP_CLIPPER_END,
                                        fontWeight: FontWeight.normal,
                                        fontSize: _util.setSp(64))),       
                              ],
                            ),
                          ),
                        ),

                        _horizontalLine(),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: (){
                               Navigator.of(context).pushNamed(NotificationSettingsWidget.routeName);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Notifications Settings',
                                    style: TextStyle(
                                        color: ColorConstants.TOP_CLIPPER_END,
                                        fontWeight: FontWeight.normal,
                                        fontSize: _util.setSp(64))),      
                              ],
                            ),
                          ),
                        ),

                        _horizontalLine(),


                      ]),
                    ),
                  ),
                  // SliverToBoxAdapter(
                  //   child:
                  // ),

                  // UIHelper.getTopEmptyContainer(90, false),
                ],
              ),
              // Appbar(ScreenTitle.OB_SELECTION),
              Positioned(
                top: ScreenUtil.statusBarHeight,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  // padding: EdgeInsets.only(top: 8.0, right: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              _scaffoldKey.currentState.openDrawer();
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                      _util.setWidth(32),
                                      _util.setHeight(32),
                                      _util.setWidth(32),
                                      _util.setHeight(32),
                                    ),
                              child: ImageIcon(
                                AssetImage(ImagePaths.icHamburger),
                                size: _util.setWidth(50),
                                color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: _util.setWidth(48),
                              top: _util.setHeight(32),
                              bottom: _util.setHeight(32),
                            ),
                            child: Text(
                                    'Settings',
                                    style: TextStyle(
                                        color:
                                            ColorConstants.WEATHER_MORE_ICON_COLOR,
                                        fontWeight: FontWeight.normal,
                                        fontSize: _util.setSp(60)
                                        ),
                                  ),
                          ),
                                Spacer(),
                          InkWell(
                            onTap: () {
                              goBack();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                              right: _util.setWidth(48),
                              top: _util.setHeight(32),
                              bottom: _util.setHeight(32),
                                ),
                              child: Image.asset(
                                ImagePaths.cross,
                                width: _util.setWidth(58),
                                height: _util.setHeight(58),
                                color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
      ),
    ),
        );
  }

    Widget _horizontalLine() {
    return SvgPicture.asset(
      ImagePaths.svgWeatherInfoDividerLine,
      fit: BoxFit.fitWidth,
      color: ColorConstants.TOP_CLIPPER_END,
      // width: MediaQuery.of(context).size.width*.95,
    );
  }

    goBack() {
      UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
    // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    Navigator.of(context).pop();
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //     LandingScreen.routeName, (Route<dynamic> route) => false);
  }

    _getProfilePicture() async {
    
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String path = prefs.getString(SharedPreferanceKeys.KEY_PROFILE_PIC);

    String path =  await SharedPrefHelper.getProfilePicFilePath();

    if(path!=null){
    final File imageFile = File(path);
    if (await imageFile.exists()) {
      // Use the cached images if it exists
      setState(() {
        _profileImageFile = imageFile;
      });
    }

    }


  }

}