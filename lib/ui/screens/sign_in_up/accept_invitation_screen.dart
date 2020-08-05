import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ocean_builder/bloc/registration_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/qr_code_data_provider.dart';
import 'package:ocean_builder/core/providers/user_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/helper/custom_behaviour.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper_2.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/qr_code_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/set_password_screen.dart';
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class AcceptInvitationScreen extends StatefulWidget {
  static const String routeName = '/accept_invitation';
  final String qrCode;

  const AcceptInvitationScreen({Key key, this.qrCode}) : super(key: key);

  @override
  _AcceptInvitationScreenState createState() => _AcceptInvitationScreenState();
}

class _AcceptInvitationScreenState extends State<AcceptInvitationScreen> {
  RegistrationValidationBloc _bloc = RegistrationValidationBloc();
  TextEditingController _codeController = TextEditingController(text: '');
  User _user;
  String _vessleCode;
  UserProvider _userProvider;
  QrCodeDataProvider _qrCodeDataProvider;
  DateTime _pickedDate; //  = DateTime.now();
  bool _isMemberSelected = false;

  @override
  void initState() {
    super.initState();
    if (widget.qrCode != null) {
      _codeController.text = widget.qrCode;
      _bloc.vasselCodeChanged(widget.qrCode);
    }

    _setUserDataListener();
  }

  @override
  void dispose() {
    _bloc.dispose();
    _user.userType = null;
    _user.requestAccessTime = null;
    _user.checkInDate = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;

    final UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context);

    _qrCodeDataProvider = Provider.of<QrCodeDataProvider>(context);

    _userProvider = Provider.of<UserProvider>(context);

    _user = userDataProvider.user;

/*     if(_user!=null){

      // if(_vessleCode!=null){
      //   _bloc.vasselCodeController.add(_vessleCode);
      //   _codeController.text = _vessleCode;// qrCodeDataProvider.qrCodeData;
      // }

      if(_user.userType!=null){
        _bloc.requestAccessAsController.add(_user.userType);
        _bloc.requestAccessAsChanged(_user.userType);
      }

      if(_user.requestAccessTime!=null){
        _bloc.requestAccessTimeController.add(_user.requestAccessTime);
        _bloc.requestAccessTimeChanged(_user.requestAccessTime);
      }

      if(_user.checkInDate!=null){
        _pickedDate = _user.checkInDate;
        _bloc.checkInChanged(DateFormat('yMMMMd').format(_pickedDate));
      }

    } */

    _bloc.vasselCodeController.listen((onData) {
      _vessleCode = onData;
      _qrCodeDataProvider.qrCodeData = _vessleCode;
    });

    //     _codeController.text = qrCodeDataProvider.qrCodeData;
    //         _bloc.vasselCodeChanged(qrCodeDataProvider.qrCodeData);

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
                _userProvider.isLoading
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
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: UIHelper.getRegistrationTextField(
                                  context,
                                  _bloc.vasselCode,
                                  _bloc.vasselCodeChanged,
                                  TextFieldHints.VASSEL_CODE_OR_QR_CODE,
                                  _codeController,
                                  null,
                                  null,
                                  true,
                                  TextInputAction.done,
                                  null,
                                  null),
                            ),
                            InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushReplacementNamed(QRcodeScreen.routeName,
                                      arguments:
                                          AcceptInvitationScreen.routeName),
                              child: SvgPicture.asset(
                                ImagePaths.barcodeImage,
                                width: 60,
                                height: 60,
                              ),
                            ),
                            SizedBox(width: 16)
                          ],
                        ),
                        SizedBox(height: 24),
                        /*                UIHelper.getRegistrationDropdown(
                      ListHelper.getAccessAsList(),
                      _bloc.requestAccessAs,
                      _bloc.requestAccessAsChanged,
                      true),
                  SizedBox(height: 24),
                 _isMemberSelected ? Container()
                 :UIHelper.getRegistrationDropdown(
                      ListHelper.getAccessTimeList().sublist(0,9),
                      _bloc.requestAccessTime,
                      _bloc.requestAccessTimeChanged,
                      true),
                  SizedBox(height: 24),
                  checkInDatePicker(), */
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
            child: Appbar(ScreenTitle.ACCEPT_INVITATION)),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: registerButton(userDataProvider))
      ],
    ));
  }

  Widget registerButton(UserDataProvider userDataProvider) {
    return StreamBuilder<bool>(
      stream: _bloc.acceptInvitationCheck,
      builder: (context, snapshot) {
        return BottomClipper2(
            ButtonText.BACK,
            _userProvider.isLoading ? ButtonText.CHECKING : ButtonText.NEXT,
            !snapshot.hasData || snapshot.data,
            () => goBack(),
            () => goNext(userDataProvider));
      },
    );
  }

  goBack() {
    if (_userProvider.authenticatedUser != null) {
      debugPrint('navigating to dashboard screen');
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      // Navigator.of(context)
      // .pushReplacementNamed(NavigationHomeScreen.routeName);
    } else {
      Navigator.pop(context);
    }
  }

  goNext(UserDataProvider userDataProvider) async {
    bool internetStatus = await DataConnectionChecker().hasConnection;
    if (!internetStatus) {
      displayInternetInfoBar(context, AppStrings.noInternetConnectionTryAgain);
      // showInfoBar('NO INTERNET', AppStrings.noInternetConnection, context);
      return;
    }

    // String vesselCode = _qrCodeDataProvider.qrCodeData;
    // bool isVesselcCodeValid = await _userProvider.isVesselCodeValid(vesselCode);

    // if (!isVesselcCodeValid) {
    //   showInfoBar(ErrorConstants.TITLE_INVALID_VESSELCODE,
    //       ErrorConstants.INVALID_VESSELCODE, context);
    //   return;
    // }

    // _user.checkInDate = _pickedDate;

    // String existingUserId =
    //     await _userProvider.checkForEmailAlreadyExist(_user.email);
    // if (existingUserId.length > 1) {
    //   _user.userID = existingUserId;
    //   userDataProvider.user = _user;
    //   // _userProvider
    //   //     .sendRequestToAccessOB(userDataProvider.user, vesselCode)
    //   //     .then((responseStatus) {
    //   //   if (responseStatus.status == 200) {
    //   //     Navigator.of(context).pushNamed(YourObsScreen.routeName);
    //   //   } else {
    //   //     debugPrint('Signup as guest failed');
    //   //     showInfoBar(parseErrorTitle(responseStatus.code),
    //   //         responseStatus.message, context);
    //   //   }
    //   // });
    // } else {
    //   Navigator.of(context)
    //       .pushNamed(PasswordScreen.routeName, arguments: false);
    // }
  }

  goToQrCodeScanner() {
    Navigator.of(context).pushNamed(PasswordScreen.routeName,
        arguments: AcceptInvitationScreen.routeName);
  }

  _setUserDataListener() {
    _bloc.requestAccessAsController.listen((onData) {
      if (onData.compareTo(ListHelper.getAccessAsList()[1]) == 0) {
        _user.userType = ListHelper.getAccessAsList()[1];
        // debugPrint(_user.userType.toString());

        if (!_isMemberSelected)
          setState(() {
            _isMemberSelected = true;
            _user.requestAccessTime = ListHelper.getAccessTimeList()[9];
          });
      } else if (onData.compareTo(ListHelper.getAccessAsList()[2]) == 0) {
        _user.userType = ListHelper.getAccessAsList()[2];
        // debugPrint(_user.userType.toString());

        if (_isMemberSelected)
          setState(() {
            _isMemberSelected = false;
            _user.requestAccessTime = ListHelper.getAccessTimeList()[1];
          });
      }
    });
    _bloc.requestAccessTimeController.listen((onData) {
      _user.requestAccessTime = onData;
    });
  }
}
