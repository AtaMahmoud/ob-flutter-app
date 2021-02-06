import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/password_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/core/providers/qr_code_data_provider.dart';
import 'package:ocean_builder/core/providers/user_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/helper/custom_behaviour.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper_2.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/screens/profile/profile_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/email_verification_screen.dart';
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/progress_indicator.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class PasswordScreen extends StatefulWidget {
  static const String routeName = '/password';
  final bool isNewUser;
  final bool isRecoverPassword;
  final bool isAccessRequest;
  final bool isAccessInvitaion;

  PasswordScreen({Key key, this.isNewUser,this.isRecoverPassword = false, this.isAccessRequest, this.isAccessInvitaion}) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController _passwordController, _confirmPasswordController;

  FocusNode _passwordNode = FocusNode();
  FocusNode _confirmPasswordNode = FocusNode();

  PasswordValidationBloc _bloc = PasswordValidationBloc();
  User _user = User();

  String _password = "";
  String _confirmPassword = "";

  SelectedOBIdProvider _selectedOBIdProvider;

  String _title ;
  String _nextButtonText;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: '');
    _confirmPasswordController = TextEditingController(text: '');
    _bloc.showPasswordChanged(false);
    _bloc.showConfirmPasswordChanged(false);
    _setUserDataListener();
    _setTitleandNext();
  }

    void _setTitleandNext() {
      if(widget.isNewUser){
        _title = ScreenTitle.SET_PASSWORD;
        _nextButtonText = 'Submit Order';
      }else if(widget.isRecoverPassword){
        _title = ScreenTitle.RECOVER_PASSWORD;
        _nextButtonText = ButtonText.RESET_PASSWORD;
      }else if(widget.isAccessRequest){
                _title = ScreenTitle.SET_PASSWORD;
        _nextButtonText = ButtonText.REQUEST_ACCESS;
      }else if(widget.isAccessInvitaion){
                _title = ScreenTitle.SET_PASSWORD;
        _nextButtonText = ButtonText.ACCEPT_INVITATION;
      }
    }

  _setUserDataListener() {
    _bloc.password.listen((onData) {
      _password = onData;
    });

    _bloc.confirmPassword.listen((onData) {
      _confirmPassword = onData;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordNode.dispose();
    _confirmPasswordNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;

    final UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context);
    final DesignDataProvider designDataProvider =
        Provider.of<DesignDataProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    final QrCodeDataProvider qrCodeDataProvider =
        Provider.of<QrCodeDataProvider>(context);

    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);

    double sizedBoxHeight = 30;
    double topClipperRatio =
        Platform.isIOS ? (153.5) / 813 : (153.5 + 16) / 813;
    double height = MediaQuery.of(context).size.height * topClipperRatio;

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: ScrollConfiguration(
            behavior: CustomBehaviour(),
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: <Widget>[
                _startSpace(height),
                userProvider.isLoading
                    ? ProgressIndicatorBoxAdapter()
                    : SliverList(
                        delegate: SliverChildListDelegate([
                        SizedBox(height: sizedBoxHeight),
                        _inputPassword(context),
                        SpaceH32(),
                        _inputConfirmPassword(context),
                      ])),
                _endSpace(),
              ],
            ),
          ),
        ),
        _topBar(),
        _bottomBar(userDataProvider, designDataProvider, userProvider,
            qrCodeDataProvider)
      ],
    ));
  }

  Positioned _bottomBar(
      UserDataProvider userDataProvider,
      DesignDataProvider designDataProvider,
      UserProvider userProvider,
      QrCodeDataProvider qrCodeDataProvider) {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: setSubmitOrderButton(userDataProvider, designDataProvider,
            userProvider, qrCodeDataProvider));
  }

  Positioned _topBar() {
    return Positioned(
        top: 0, left: 0, right: 0, child: Appbar(_title));
  }

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  Widget _inputConfirmPassword(BuildContext context) {
    return UIHelper.getPasswordTextField(
        context,
        _bloc.confirmPassword,
        _bloc.showConfirmPassword,
        TextFieldHints.CONFIRM_PASSWORD,
        _confirmPasswordController,
        null,
        null,
        true,
        TextInputAction.done,
        _confirmPasswordNode,
        (data) => _bloc.confirmPasswordChanged(data),
        (show) => _bloc.showConfirmPasswordChanged(show),
        null);
  }

  Widget _inputPassword(BuildContext context) {
    return UIHelper.getPasswordTextField(
        context,
        _bloc.password,
        _bloc.showPassword,
        TextFieldHints.ENTER_PASSWORD,
        _passwordController,
        null,
        null,
        true,
        TextInputAction.next,
        _passwordNode,
        (data) => _bloc.passwordChanged(data),
        (show) => _bloc.showPasswordChanged(show),
        () => FocusScope.of(context).requestFocus(_confirmPasswordNode));
  }

  _startSpace(double height) =>
      UIHelper.getTopEmptyContainer(height + 20, false);

  Widget setSubmitOrderButton(
      UserDataProvider userDataProvider,
      DesignDataProvider designDataProvider,
      UserProvider userProvider,
      QrCodeDataProvider qrCodeDataProvider) {
    return StreamBuilder<bool>(
      stream: _bloc.passwordCheck,
      builder: (context, snapshot) {
        return BottomClipper2(
            ButtonText.BACK,
            _nextButtonText,
            !snapshot.hasData || !snapshot.data,
            () => goBack(),
            () => goNext(userDataProvider, designDataProvider, userProvider,
                qrCodeDataProvider));
      },
    );
  }

  goBack() {
    Navigator.pop(context);
  }

  goNext(
      UserDataProvider userDataProvider,
      DesignDataProvider designDataProvider,
      UserProvider userProvider,
      QrCodeDataProvider qrCodeDataProvider) async {
    bool internetStatus = await DataConnectionChecker().hasConnection;
    if (!internetStatus) {
      displayInternetInfoBar(context, AppStrings.noInternetConnectionTryAgain);
      return;
    }

    if (_password.compareTo(_confirmPassword) == 0) {
      userDataProvider.user.password = _password;
    }

    // Navigator.of(context).pushNamed(EmailVerificationScreen.routeName,
    //     arguments: EmailVerificationData(
    //         verificationCode: 'Asad', isDeepLinkData: false));

    if (widget.isNewUser) {
      userProvider
          .registrationWithSeaPodCreation(
              userDataProvider.user, designDataProvider.oceanBuilder)
          .then((responseStatus) async {
        if (responseStatus.status == 200) {
          // await MethodHelper.selectOnlyOBasSelectedOB();
          // Navigator.of(context).pushNamed(HomeScreen.routeName);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => EmailVerificationScreen(emailVerificationData: EmailVerificationData(
            verificationCode: 'Asad', isDeepLinkData: false)),
                settings:
                    RouteSettings(name: EmailVerificationScreen.routeName)),
            (Route<dynamic> route) => false,
          );

        } else {
          showInfoBar(parseErrorTitle(responseStatus.code),
              responseStatus.message, context);
        }
      });
    } else if(widget.isAccessRequest) {
      String oceanBuilderId =
          qrCodeDataProvider.qrCodeData; //'-LhmsP9Mc-E_VREoTYfV';
      userProvider
          .sendAccessReqForNewuser(userDataProvider.user, oceanBuilderId)
          .then((responseStatus) async {
        if (responseStatus.status == 200) {


            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => EmailVerificationScreen(emailVerificationData: EmailVerificationData(
            verificationCode: 'Asad', isDeepLinkData: false),),
                  settings:
                      RouteSettings(name: EmailVerificationScreen.routeName)),
              (Route<dynamic> route) => false,
            );





          // await MethodHelper.selectOnlyOBasSelectedOB();



          // if (!(_selectedOBIdProvider.selectedObId
          //         .compareTo(AppStrings.selectOceanBuilder) ==
          //     0)) {
          //   Navigator.of(context).pushNamed(HomeScreen.routeName);
          // } else {
          //   // Navigator.pushAndRemoveUntil(
          //   //   context,
          //   //   MaterialPageRoute(
          //   //       builder: (context) => ProfileScreen(),
          //   //       settings: RouteSettings(name: ProfileScreen.routeName)),
          //   //   (Route<dynamic> route) => false,
          //   // );

          //   Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => EmailVerificationScreen(emailVerificationData: EmailVerificationData(
          //   verificationCode: 'Asad', isDeepLinkData: false),),
          //         settings:
          //             RouteSettings(name: EmailVerificationScreen.routeName)),
          //     (Route<dynamic> route) => false,
          //   );
          // }
        } else {
          showInfoBar(parseErrorTitle(responseStatus.code),
              responseStatus.message, context);
        }
      });
    } else if(widget.isAccessInvitaion) {
      // call create new user with access invitation and on success navigate to login screen
    }else if(widget.isRecoverPassword){
      // call recover password api and on success navigate to login screen
    }
  }


}
