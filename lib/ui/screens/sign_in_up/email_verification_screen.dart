import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/registration_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/core/providers/user_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper_2.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/login_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/set_password_screen.dart';
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  static const String routeName = '/emailVerification';
  final EmailVerificationData emailVerificationData;

  EmailVerificationScreen({this.emailVerificationData});

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  ScrollController _controller = ScrollController();

  FocusNode _phoneNode = FocusNode();

  RegistrationValidationBloc _bloc = RegistrationValidationBloc();
  User _user = User();
  UserProvider userProvider;
  DesignDataProvider designDataProvider;

  final formKey = GlobalKey<FormState>();
  bool hasError = false;

  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType> errorController;

  String currentText = "";

  bool isEmailVerified = false;
  bool isLoading;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      if (widget.emailVerificationData.isDeepLinkData) {
        isLoading = true;
        _verifyEmailCode(widget.emailVerificationData.verificationCode);
      }
    });

    _setUserDataListener();

    _phoneNode.addListener(() {
      if (_phoneNode.hasFocus) {
        _controller.animateTo(250,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    });

    errorController = StreamController<ErrorAnimationType>();
  }

  _setUserDataListener() {
    _bloc.firstNameController.listen((onData) {
      _user.firstName = onData;
    });

    _bloc.lastNameController.listen((onData) {
      _user.lastName = onData;
    });

    _bloc.emailController.listen((onData) {
      _user.email = onData;
    });

    _bloc.phoneController.listen((onData) {
      _user.phone = onData;
    });

    _bloc.countryController.listen((onData) {
      _user.country = onData;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _phoneNode.dispose();
    _controller.dispose();
    _bloc.dispose();
    errorController.close();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;

    if (widget.emailVerificationData == null) {}

    final UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context);

    designDataProvider = Provider.of<DesignDataProvider>(context);
    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: CustomScrollView(
              shrinkWrap: true,
              controller: _controller,
              slivers: <Widget>[
                _startSpace(),
                SliverList(
                    delegate: SliverChildListDelegate([
                  SpaceH48(),
                  _title(),
                  SpaceH48(),
                  Provider.of<UserProvider>(context).isLoading
                      ? CircularProgressIndicator()
                      : widget.emailVerificationData.isDeepLinkData
                          ? Container()
                          : _emailConfirmationManual(),
                ])),
                _endSpace(),
              ],
            ),
          ),
          _topBar(),
          _bottomBar(userDataProvider)
        ],
      ),
    );
  }

  _emailConfirmationManual() {
    return Column(
      children: [
        _emailConfirmationText1(),
        SpaceH48(),
        _emailConfirmationText2(),
        SpaceH48(),
        _authenticationCode(),
        _resendButton()
      ],
    );
  }

  Positioned _bottomBar(UserDataProvider userDataProvider) {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: setPasswordButton(userDataProvider));
  }

  Positioned _topBar() {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Appbar(ScreenTitle.EMAIL_CONFIRMATION));
  }

  _endSpace() => UIHelper.getTopEmptyContainer(330.h, false);

  _startSpace() => UIHelper.getTopEmptyContainer(500.h, false);

  goToLogInPageFromInfo() {
    Navigator.of(context)
        .pushNamed(LoginScreen.routeName, arguments: ScreenTitle.YOUR_INFO);
  }

  Widget setPasswordButton(UserDataProvider userDataProvider) {
    return StreamBuilder(
      stream: _bloc.infoCheck,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return BottomClipper2(
            ButtonText.BACK,
            userProvider.isLoading
                ? ButtonText.CHECKING
                : ButtonText.SET_PASSWORD,
            !snapshot.hasData,
            () => goBack(),
            () => goNext(userDataProvider));
      },
    );
  }

  goBack() {
    Navigator.pop(context);
  }

  goNext(UserDataProvider userDataProvider) async {
    bool internetStatus = await DataConnectionChecker().hasConnection;
    if (!internetStatus) {
      displayInternetInfoBar(context, AppStrings.noInternetConnectionTryAgain);
      // showInfoBar('NO INTERNET', AppStrings.noInternetConnection, context);
      return;
    } else {
      userDataProvider.user = _user;
      Navigator.of(context)
          .pushNamed(PasswordScreen.routeName, arguments: true);
    }
  }

  _title() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: Text(
        AppStrings.checkYourInbox,
        style: TextStyle(
            color: ColorConstants.WEATHER_MORE_ICON_COLOR, fontSize: 48.sp),
      ),
    );
  }

  _emailConfirmationText1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: Text(
        AppStrings.confirmEmailText1,
        style: TextStyle(
            color: ColorConstants.WEATHER_MORE_ICON_COLOR, fontSize: 40.sp),
      ),
    );
  }

  _emailConfirmationText2() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: Text(
        AppStrings.confirmEmailText2,
        style: TextStyle(
            color: ColorConstants.WEATHER_MORE_ICON_COLOR, fontSize: 40.sp),
      ),
    );
  }

  _authenticationCode() {
    return Form(
      key: formKey,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 128.w),
          child: PinCodeTextField(
            appContext: context,
            pastedTextStyle: TextStyle(
              color: ColorConstants.BCKG_COLOR_END,
              fontWeight: FontWeight.bold,
            ),
            length: 4,
            obscureText: false,
            obscuringCharacter: '*',
            animationType: AnimationType.fade,
            // validator: (v) {
            //   if (v.length < 3) {
            //     return "I'm from validator";
            //   } else {
            //     return null;
            //   }
            // },
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 70,
                fieldWidth: 60,
                activeColor: ColorConstants.ACCESS_MANAGEMENT_HINT,
                activeFillColor: hasError ? Colors.red : Colors.white,
                inactiveColor: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                inactiveFillColor: Colors.white,
                selectedColor: ColorConstants.ACCESS_MANAGEMENT_LIST_TITLE,
                selectedFillColor: Colors.white,
                // borderWidth: 4,
                disabledColor: Colors.grey),
            cursorColor: ColorConstants.ACCESS_MANAGEMENT_HINT,
            animationDuration: Duration(milliseconds: 300),
            textStyle: TextStyle(
              fontSize: 48,
            ),
            backgroundColor: Color(0xFFFEFEFE),
            enableActiveFill: true,
            errorAnimationController: errorController,
            controller: textEditingController,
            keyboardType: TextInputType.text,
            // boxShadows: [
            //   BoxShadow(
            //     offset: Offset(0, 1),
            //     color: Colors.black12,
            //     blurRadius: 10,
            //   )
            // ],
            onCompleted: (v) {
              print("Completed");
              _verifyEmailCode(v);
            },
            // onTap: () {
            //   print("Pressed");
            // },
            onChanged: (value) {
              print(value);
              setState(() {
                currentText = value;
              });
            },
            beforeTextPaste: (text) {
              print("Allowing to paste $text");
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
          )),
    );
  }

  _verifyEmailCode(String token) async {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isLoading) return;
    bool internetStatus = await DataConnectionChecker().hasConnection;
    if (!internetStatus) {
      displayInternetInfoBar(context, AppStrings.noInternetConnectionTryAgain);
      return;
    }

    if (token != null)
      userProvider.confirmEmail(token).then((status) async {
        if (status.status == 200) {
          showInfoBarWithDissmissCallback('Email Confirmation',
              'Your account is verified now, sign in to continue', context, () {
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
          });
        } else {
          String title = parseErrorTitle(status.code);
          showInfoBar(title, status.message, context);
        }
      });
    else {
      showInfoBar('Email confirmation', "Token is not valid", context);
    }
  }

  _resendButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 128.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              _resendCode();
            },
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.w),
                  gradient: ColorConstants.BKG_GRADIENT),
              child: Text(
                'Resend',
                style: TextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _resendCode() {}
}

class EmailVerificationData {
  String token;
  String verificationCode;
  bool isDeepLinkData;
  EmailVerificationData(
      {this.token, this.verificationCode, this.isDeepLinkData});
}
