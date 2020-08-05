import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/login_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/connection_status_provider.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/user_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/singletons/headers_manager.dart';
import 'package:ocean_builder/helper/custom_behaviour.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/menu/landing_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/request_access_screen.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgotPassword';
  final String sourceScreen;
  const ForgotPasswordScreen({Key key, this.sourceScreen}) : super(key: key);
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  UserDataProvider _userDataProvider;
  TextEditingController _emailController, _passwordController;

  FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();

  LoginValidationBloc _bloc = LoginValidationBloc();

  ConnectionStatusProvider _connectionStatusProvider;

  // StreamSubscription _connectionChangeStream;

  SelectedOBIdProvider _selectedOBIdProvider;

  bool _isNextButtonTapped = false;

  HeadersManager _headerManager;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
    _bloc.showPasswordChanged(false);
    _headerManager = HeadersManager.getInstance();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    _bloc.dispose();
    // _connectionChangeStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    _connectionStatusProvider = Provider.of<ConnectionStatusProvider>(context);
    _userDataProvider = Provider.of<UserDataProvider>(context);
    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);

    _headerManager.initalizeBasicHeaders(context);
    _headerManager.initializeEssentialHeaders();
    _headerManager.initalizeAuthenticatedUserHeaders();

    double sizedBoxHeight = 30;
    double topClipperRatio =
        Platform.isIOS ? (153.5) / 813 : (153.5 + 16) / 813;
    double height = MediaQuery.of(context).size.height * topClipperRatio;

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: ScrollConfiguration(
            behavior: CustomBehaviour(),
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: <Widget>[
                UIHelper.getTopEmptyContainer(height + 20, false),
                SliverList(
                    delegate: SliverChildListDelegate([
                  userProvider.isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(64),
                                right: ScreenUtil().setWidth(64),
                                left: ScreenUtil().setWidth(64),
                                bottom: ScreenUtil().setHeight(64),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          'Please enter the email address you used to create the account.',
                                          style: TextStyle(
                                              color: ColorConstants
                                                  .TOP_CLIPPER_END_DARK,
                                              fontSize: ScreenUtil().setSp(48)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(48),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          'We will email you with a link that will allow you to enter a new password',
                                          style: TextStyle(
                                              color: ColorConstants
                                                  .TOP_CLIPPER_END_DARK,
                                              fontSize: ScreenUtil().setSp(48)),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            UIHelper.getRegistrationTextField(
                                context,
                                _bloc.email,
                                _bloc.emailChanged,
                                TextFieldHints.EMAIL,
                                _emailController,
                                InputTypes.EMAIL,
                                null,
                                true,
                                TextInputAction.next,
                                _emailNode,
                                () => FocusScope.of(context)
                                    .requestFocus(_passwordNode)),
                            SizedBox(
                              height: sizedBoxHeight,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(64),
                                right: ScreenUtil().setWidth(64),
                                left: ScreenUtil().setWidth(64),
                                bottom: ScreenUtil().setHeight(64),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  StreamBuilder<bool>(
                                      stream: _bloc.emailCheck,
                                      builder: (context, snapshot) {
                                        return InkWell(
                                          onTap: () {
                                            if (snapshot.hasData &&
                                                snapshot.data)
                                              showAlertWithOneButton(
                                                  title: 'CHECK YOUR INBOX',
                                                  desc:
                                                      'We have sent an email to ${_emailController.text}, please check your email inbox.',
                                                  buttonCallback: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LandingScreen()),
                                                      (Route<dynamic> route) =>
                                                          false,
                                                    );
                                                  },
                                                  buttonText: 'Ok',
                                                  context: GlobalContext
                                                      .currentScreenContext);
                                          },
                                          child: Container(
                                            // height: h,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                ScreenUtil().setWidth(128),
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setWidth(32)),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        ScreenUtil()
                                                            .setWidth(72)),
                                                color: ColorConstants
                                                    .TOP_CLIPPER_END_DARK),
                                            child: Center(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'SEND PASSWORD RECOVERY EMAIL',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: ScreenUtil()
                                                          .setSp(42)),
                                                ),
                                              ],
                                            )),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ],
                        )
                ])),
                UIHelper.getTopEmptyContainer(90, false),
              ],
            ),
          ),
        ),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Appbar(ScreenTitle.FORGOT_PASSWORD)),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: BottomClipper(ButtonText.BACK, '', () {
            onBackPressed(userProvider);
          }, () {}, isNextEnabled: false),
        )
      ],
    ));
  }

  loginField(TextEditingController controller, String label, bool isPassword) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: TextField(
        autofocus: false,
        controller: controller,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: ColorConstants.TOP_CLIPPER_START),
        decoration: InputDecoration(
            hintText: label,
            enabledBorder: new UnderlineInputBorder(
                borderSide:
                    new BorderSide(color: ColorConstants.TOP_CLIPPER_START)),
            hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: ColorConstants.TOP_CLIPPER_START)),
      ),
    );
  }

  goToForgotPasswordScreen() {
    Navigator.of(context).pushNamed(RequestAccessScreen.routeName);
  }

  onBackPressed(UserProvider userProvider) {
    if (userProvider.isLoading) return;
    Navigator.pop(context);
  }
}
