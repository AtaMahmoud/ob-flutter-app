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
import 'package:ocean_builder/ui/screens/sign_in_up/email_verification_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/recover_password_verification_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/request_access_screen.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
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
  UserProvider _userProvider;
  UserDataProvider _userDataProvider;
  TextEditingController _emailController, _passwordController;

  FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();

  LoginValidationBloc _bloc = LoginValidationBloc();

  ConnectionStatusProvider _connectionStatusProvider;

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
    _userProvider = Provider.of<UserProvider>(context);
    _connectionStatusProvider = Provider.of<ConnectionStatusProvider>(context);
    _userDataProvider = Provider.of<UserDataProvider>(context);
    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);

    _headerManager.initalizeBasicHeaders(context);
    _headerManager.initializeEssentialHeaders();
    _headerManager.initalizeAuthenticatedUserHeaders();

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
                _startSpace(height),
                _mainContent(_userProvider, context),
                _endSpace(),
              ],
            ),
          ),
        ),
        _topBar(),
        _bottomBar(_userProvider)
      ],
    ));
  }

  SliverList _mainContent(UserProvider userProvider, BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate([
      Stack(
        children: [
          ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 64.h,
                  right: 64.w,
                  left: 64.w,
                  bottom: 64.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[_textTitle(), SpaceH48(), _textSubTitle()],
                ),
              ),
              _inputEmail(context),
              SpaceH48(),
              _buttonSendRecoveryMail(),
            ],
          ),
          userProvider.isLoading ? _progressIndicator() : Container()
        ],
      )
    ]));
  }

  Positioned _bottomBar(UserProvider userProvider) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: BottomClipper(ButtonText.BACK, '', () {
        onBackPressed(userProvider);
      }, () {}, isNextEnabled: false),
    );
  }

  Positioned _topBar() {
    return Positioned(
        top: 0, left: 0, right: 0, child: Appbar(ScreenTitle.FORGOT_PASSWORD));
  }

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  Container _buttonSendRecoveryMail() {
    return Container(
      padding: EdgeInsets.only(
        top: 64.h,
        right: 64.w,
        left: 64.w,
        bottom: 64.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder<bool>(
              stream: _bloc.emailCheck,
              builder: (context, snapshot) {
                
                return InkWell(

                  onTap: () {
                    if (snapshot.hasData && snapshot.data) {
                      _userProvider
                          .sendPasswordRecoveryMail(_emailController.text)
                          .then((status) {
                        if (status.status == 200) {
                          // _showEmailSentMessage();
                                      Navigator.of(context).pushReplacementNamed(
                RecoverPasswordVerificationScreen.routeName,
                arguments: EmailVerificationData(isDeepLinkData: false));

                        } else {
                          String title = parseErrorTitle(status.code);
                          showInfoBar(title, status.message, context);
                        }
                      });
                    }
                  },
                  child: Container(
                    // height: h,
                    width: MediaQuery.of(context).size.width - 128.w,
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(72.w),
                        color: ColorConstants.TOP_CLIPPER_END_DARK),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'SEND PASSWORD RECOVERY EMAIL',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.white, fontSize: 42.sp),
                        ),
                      ],
                    )),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _inputEmail(BuildContext context) {
    return UIHelper.getRegistrationTextField(
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
        () => FocusScope.of(context).requestFocus(_passwordNode));
  }

  Row _textSubTitle() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            'We will email you with a link that will allow you to enter a new password',
            style: TextStyle(
                color: ColorConstants.TOP_CLIPPER_END_DARK, fontSize: 48.sp),
          ),
        ),
      ],
    );
  }

  Row _textTitle() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            'Please enter the email address you used to create the account.',
            style: TextStyle(
                color: ColorConstants.TOP_CLIPPER_END_DARK, fontSize: 48.sp),
          ),
        ),
      ],
    );
  }

  Center _progressIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  _startSpace(double height) =>
      UIHelper.getTopEmptyContainer(height + 20, false);

  goToForgotPasswordScreen() {
    Navigator.of(context).pushNamed(RequestAccessScreen.routeName);
  }

  onBackPressed(UserProvider userProvider) {
    if (userProvider.isLoading) return;
    Navigator.pop(context);
  }

  _showEmailSentMessage() {
    showAlertWithOneButton(
        title: 'CHECK YOUR INBOX',
        desc:
            'An email has been sent to ${_emailController.text} with further instructions, please check your inbox.',
        buttonCallback: () {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LandingScreen()),
            (Route<dynamic> route) => false,
          );
        },
        buttonText: 'Ok',
        context: GlobalContext.currentScreenContext);
  }
}
