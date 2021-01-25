import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/login_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/connection_status_provider.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/core/providers/user_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/singletons/headers_manager.dart';
import 'package:ocean_builder/helper/custom_behaviour.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/email_verification_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/forgot_password_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/request_access_screen.dart';
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  final String sourceScreen;
  const LoginScreen({Key key, this.sourceScreen}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                _startSpace(height),
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
                            _inputEmail(context),
                            SpaceH48(),
                            _inputPassword(context),
                            _buttonForgetPassword(),
                          ],
                        )
                ])),
                _endSpace(),
              ],
            ),
          ),
        ),
        _topBar(),
        _bottomBar(userProvider)
      ],
    ));
  }

  Positioned _bottomBar(UserProvider userProvider) {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: StreamBuilder<bool>(
            stream: _bloc.loginCheck,
            builder: (context, snapshot) {
              return BottomClipper(
                  ButtonText.BACK,
                  widget.sourceScreen.contains(ScreenTitle.YOUR_INFO)
                      ? ButtonText.SUBMIT_ORDER
                      : ButtonText.NEXT,
                  () => onBackPressed(userProvider),
                  () => onLoginEvent(userProvider),
                  isNextEnabled: snapshot.hasData && snapshot.data);
            }));
  }

  Positioned _topBar() =>
      Positioned(top: 0, left: 0, right: 0, child: Appbar(ScreenTitle.LOGIN));

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  Container _buttonForgetPassword() {
    return Container(
      padding: EdgeInsets.only(
          top: 48.0, //util.setHeight(64),
          right: 16.0,
          bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {
              goToForgotPasswordScreen();
            },
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
              child: Text(
                'Forgot password ?',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.PROFILE_BKG_1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputPassword(BuildContext context) {
    return UIHelper.getPasswordTextField(
        context,
        _bloc.password,
        _bloc.showPassword,
        TextFieldHints.PASSWORD,
        _passwordController,
        null,
        null,
        true,
        TextInputAction.done,
        _passwordNode,
        (data) => _bloc.passwordChanged(data),
        (show) => _bloc.showPasswordChanged(show),
        null);
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

  _startSpace(double height) =>
      UIHelper.getTopEmptyContainer(height + 20, false);

  goToForgotPasswordScreen() {
    Navigator.of(context).pushNamed(ForgotPasswordScreen.routeName);
  }

  onBackPressed(UserProvider userProvider) {
    if (userProvider.isLoading) return;
    Navigator.pop(context);
  }

  onLoginEvent(UserProvider userProvider) async {
    if (userProvider.isLoading) return;
    if (_emailController == null || _passwordController == null) return;
    bool internetStatus = await DataConnectionChecker().hasConnection;
    if (!internetStatus) {
      displayInternetInfoBar(context, AppStrings.noInternetConnectionTryAgain);
      return;
    }
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email != null && password != null)
      userProvider.logIn(email, password).then((status) async {
        if (status.status == 200) {
          if (userProvider.authenticatedUser.isVerified) {
            MethodHelper.parseNotifications(context);
            if (widget.sourceScreen.contains(ScreenTitle.REGISTER)) {
              _userDataProvider.user.firstName =
                  userProvider.authenticatedUser.firstName;
              _userDataProvider.user.lastName =
                  userProvider.authenticatedUser.lastName;
              _userDataProvider.user.email =
                  userProvider.authenticatedUser.email;
              _userDataProvider.user.country =
                  userProvider.authenticatedUser.country;
              _userDataProvider.user.phone =
                  userProvider.authenticatedUser.phone;
              Navigator.of(context).pushNamed(RequestAccessScreen.routeName);
            } else if (widget.sourceScreen.contains(ScreenTitle.YOUR_INFO)) {
              _createNewObForExistingUser(userProvider);
            } else {
              await MethodHelper.selectOnlyOBasSelectedOB();
              if (userProvider.authenticatedUser.userOceanBuilder == null ||
                  userProvider.authenticatedUser.userOceanBuilder.length > 1) {
                Navigator.of(context)
                    .pushReplacementNamed(HomeScreen.routeName);
              } else if (userProvider
                      .authenticatedUser.userOceanBuilder.length <=
                  1) {
                Navigator.of(context)
                    .pushReplacementNamed(HomeScreen.routeName);
              }
            }
          } else {
            Navigator.of(context).pushReplacementNamed(
                EmailVerificationScreen.routeName,
                arguments: EmailVerificationData(isDeepLinkData: false));
          }
        }else if(status.status == 401){
            Navigator.of(context).pushReplacementNamed(
                EmailVerificationScreen.routeName,
                arguments: EmailVerificationData(isDeepLinkData: false));
        }else {
          _passwordController.text = '';
          _bloc.passwordChanged('');
          String title = parseErrorTitle(status.code);
          showInfoBar(title, status.message, context);
        }
      });
    else {}
  }

  _createNewObForExistingUser(UserProvider userProvider) {
    String existingUserId = userProvider.authenticatedUser.userID;
    DesignDataProvider designDataProvider =
        Provider.of<DesignDataProvider>(context);

    userProvider
        .createSeaPod(designDataProvider.oceanBuilder)
        .then((responseStatus) {
      if (responseStatus.status == 200) {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } else {
        showInfoBar(parseErrorTitle(responseStatus.code),
            responseStatus.message, context);
      }
    });
  }
}
