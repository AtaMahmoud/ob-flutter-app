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
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class PasswordScreen extends StatefulWidget {
  static const String routeName = '/password';
  final bool isNewUser;

  const PasswordScreen({Key key, this.isNewUser}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: '');
    _confirmPasswordController = TextEditingController(text: '');
    _bloc.showPasswordChanged(false);
    _bloc.showConfirmPasswordChanged(false);
    _setUserDataListener();
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
                UIHelper.getTopEmptyContainer(height + 20, false),
                userProvider.isLoading
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate([
                        SizedBox(height: sizedBoxHeight),
                        UIHelper.getPasswordTextField(
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
                            () => FocusScope.of(context)
                                .requestFocus(_confirmPasswordNode)),
                        SizedBox(height: 32),
                        UIHelper.getPasswordTextField(
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
                            null),
                      ])),
                UIHelper.getTopEmptyContainer(90, false),
              ],
            ),
          ),
        ),
        Positioned(
            top: 0, left: 0, right: 0, child: Appbar(ScreenTitle.CREATE_ACCOUNT)),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: setSubmitOrderButton(userDataProvider, designDataProvider,
                userProvider, qrCodeDataProvider))
      ],
    ));
  }

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
            ButtonText.SUBMIT_ORDER,
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
      // showInfoBar('NO INTERNET', AppStrings.noInternetConnection, context);
      return;
    }

    if (_password.compareTo(_confirmPassword) == 0) {
      userDataProvider.user.password = _password;
    }

    if (widget.isNewUser) {
      // designDataProvider.oceanBuilder//
     // designDataProvider.oceanBuilder//
     // debugPrint('new user data - ${userDataProvider.user.toJson()}');
      userProvider
      .registrationWithSeaPodCreation(userDataProvider.user, designDataProvider.oceanBuilder)
          // .signUpAndCreateNewOB(userDataProvider.user.toJson(), designDataProvider.oceanBuilder)
          .then((responseStatus) {
        if (responseStatus.status == 200) {
          MethodHelper.selectOnlyOBasSelectedOB();
          Navigator.of(context).pushNamed(HomeScreen.routeName);
        } else {
          // debugPrint('Signup as new user failed');
          showInfoBar(parseErrorTitle(responseStatus.code),
              responseStatus.message, context);
        }
      });
    } else {
      // debugPrint(
          // 'guest user with access permission ---------------- ${_selectedOBIdProvider.selectedObId}');
      // this should come from scanning the QR code
      String oceanBuilderId =
          qrCodeDataProvider.qrCodeData; //'-LhmsP9Mc-E_VREoTYfV';
      userProvider
          .sendAccessReqForNewuser(userDataProvider.user, oceanBuilderId)
          .then((responseStatus) {
        if (responseStatus.status == 200) {
          MethodHelper.selectOnlyOBasSelectedOB();

          if (!(_selectedOBIdProvider.selectedObId
                  .compareTo(AppStrings.selectOceanBuilder) ==
              0)) {
            Navigator.of(context).pushNamed(HomeScreen.routeName);
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen(),settings: RouteSettings(name: ProfileScreen.routeName)),
              (Route<dynamic> route) => false,
            );
          }
        } else {
          // debugPrint('Signup as guest failed');
          showInfoBar(parseErrorTitle(responseStatus.code),
              responseStatus.message, context);
        }
      });
    }

  }
}
