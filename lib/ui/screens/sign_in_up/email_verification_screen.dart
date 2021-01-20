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
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  static const String routeName = '/emailVerification';

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

  @override
  void initState() {
    super.initState();
    _setUserDataListener();

    _phoneNode.addListener(() {
      if (_phoneNode.hasFocus) {
        _controller.animateTo(250,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    });

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
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;

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
                  _emailConfirmationText1(),
                  SpaceH48(),
                  _emailConfirmationText2(),
                  SpaceH48(),
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
}
