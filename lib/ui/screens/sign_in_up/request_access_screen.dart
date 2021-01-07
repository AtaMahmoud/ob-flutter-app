import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
import 'package:ocean_builder/ui/screens/sign_in_up/your_obs_screen.dart';
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/shared/shared_pref_data.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/progress_indicator.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class RequestAccessScreen extends StatefulWidget {
  static const String routeName = '/request_access';
  final String qrCode;

  const RequestAccessScreen({Key key, this.qrCode}) : super(key: key);

  @override
  _RequestAccessScreenState createState() => _RequestAccessScreenState();
}

class _RequestAccessScreenState extends State<RequestAccessScreen> {
  RegistrationValidationBloc _bloc = RegistrationValidationBloc();
  TextEditingController _codeController = TextEditingController(text: '');
  User _user;
  String _vessleCode;
  UserProvider _userProvider;
  QrCodeDataProvider _qrCodeDataProvider;
  DateTime _pickedDate; //  = DateTime.now();
  bool _isMemberSelected = false;

  bool _isGuestSelected = false;

  @override
  void initState() {
    super.initState();
    if (widget.qrCode != null) {
      _codeController.text = widget.qrCode;
      _bloc.vasselCodeChanged(widget.qrCode);
    }

    _setUserDataListener();
  }

  _setUserDataListener() {
    _bloc.requestAccessAsController.listen((onData) {
      // SHORT VISIT (VISITOR ACCESS)
      if (onData.compareTo(ListHelper.getAccessForList()[1]) == 0) {
        _user.userType = ListHelper.getAccessAsList()[3];
        _bloc.requestAccessTimeChanged(ListHelper.getAccessTimeList()[1]);
        if (_isGuestSelected)
          setState(() {
            _isGuestSelected = false;
          });
      } else if (onData.compareTo(ListHelper.getAccessForList()[2]) == 0) {
        // STAY (GUEST ACCESS)
        _user.userType = ListHelper.getAccessAsList()[2];
        if (!_isGuestSelected)
          setState(() {
            _isGuestSelected = true;
          });
      } else if (onData.compareTo(ListHelper.getAccessForList()[3]) == 0) {
        // MOVE IN PERMANENTLY (MEMBER ACCESS)
        _user.userType = ListHelper.getAccessAsList()[3];
        _bloc.requestAccessTimeChanged(ListHelper.getAccessTimeList()[8]);
        setState(() {
          _isGuestSelected = false;
          if (!_isMemberSelected) _isMemberSelected = true;
        });
      } else {
        setState(() {
          _isGuestSelected = false;
        });
      }
    });
    _bloc.requestAccessTimeController.listen((onData) {
      _user.requestAccessTime = onData;
    });
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
    UIHelper.setStatusBarColor();
    GlobalContext.currentScreenContext = context;

    final UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context);

    _qrCodeDataProvider = Provider.of<QrCodeDataProvider>(context);

    _userProvider = Provider.of<UserProvider>(context);

    _user = userDataProvider.user;

    if (_user != null) {
      if (_user.userType != null) {}
      if (_user.requestAccessTime != null) {
        _bloc.requestAccessTimeController.add(_user.requestAccessTime);
        _bloc.requestAccessTimeChanged(_user.requestAccessTime);
      }
      if (_user.checkInDate != null) {
        _pickedDate = _user.checkInDate;
        _bloc.checkInChanged(DateFormat('yMMMMd').format(_pickedDate));
      }
    }

    _bloc.vasselCodeController.listen((onData) {
      _vessleCode = onData;
      _qrCodeDataProvider.qrCodeData = _vessleCode;
    });

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
                _userProvider.isLoading
                    ? ProgressIndicatorBoxAdapter()
                    : _mainContent(context),
                _endSpace(),
              ],
            ),
          ),
        ),
        _topBar(),
        _bottomBar(userDataProvider)
      ],
    ));
  }

  SliverPadding _mainContent(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 64.w),
      sliver: SliverList(
          delegate: SliverChildListDelegate([
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1),
          child: Row(
            children: <Widget>[
              _inputVesselcode(context),
              _buttonScanBarcode(context),
            ],
          ),
        ),
        SpaceH32(),
        _dropdownAccessType(),
        SpaceH32(),
        _isGuestSelected ? _dropdownAccessTime() : Container(),
        SpaceH32(),
        checkInDatePicker(),
      ])),
    );
  }

  Positioned _bottomBar(UserDataProvider userDataProvider) {
    return Positioned(
        bottom: 0, left: 0, right: 0, child: registerButton(userDataProvider));
  }

  Positioned _topBar() {
    return Positioned(
        top: 0, left: 0, right: 0, child: Appbar(ScreenTitle.REQUEST_ACCESS));
  }

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  Widget _dropdownAccessTime() {
    return UIHelper.getUnderlinedDropdown(ListHelper.getStayForTimeList(),
        _bloc.requestAccessTime, _bloc.requestAccessTimeChanged, false);
  }

  Widget _dropdownAccessType() {
    return UIHelper.getUnderlinedDropdown(ListHelper.getAccessForList(),
        _bloc.requestAccessAs, _bloc.requestAccessAsChanged, false);
  }

  InkWell _buttonScanBarcode(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushReplacementNamed(
          QRcodeScreen.routeName,
          arguments: RequestAccessScreen.routeName),
      child: SvgPicture.asset(
        ImagePaths.barcodeImage,
        width: 96.w,
        height: 96.w,
      ),
    );
  }

  Expanded _inputVesselcode(BuildContext context) {
    return Expanded(
      child: UIHelper.getRegistrationTextField(
          context,
          _bloc.vasselCode,
          _bloc.vasselCodeChanged,
          TextFieldHints.VASSEL_CODE_OR_QR_CODE,
          _codeController,
          null,
          null,
          false,
          TextInputAction.done,
          null,
          null,
          addContentPadding: true),
    );
  }

  _startSpace(double height) =>
      UIHelper.getTopEmptyContainer(height + 48.h, false);

  // SOF7C6C

  Widget checkInDatePicker() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: SizedBox(
        width: double.maxFinite,
        child: InkWell(
          onTap: () {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime.now(), //DateTime(2018, 3, 5),
                // maxTime: DateTime(2019, 12, 7),
                theme: DatePickerTheme(
                    backgroundColor:
                        Colors.white, //ColorConstants.PROFILE_BKG_1,
                    // containerHeight: ScreenUtil().setHeight(512),
                    cancelStyle: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.TOP_CLIPPER_START),
                    itemStyle: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.TOP_CLIPPER_START),
                    doneStyle: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.TOP_CLIPPER_START)),
                onChanged: (date) {
              // // print('change $date in time zone ' +
              // date.timeZoneOffset.inHours.toString());
            }, onConfirm: (date) {
              // print('confirm $date');
              setState(() {
                _pickedDate = date;
                _user.checkInDate = _pickedDate;
                _bloc.checkInChanged(DateFormat('yMMMMd').format(_pickedDate));
              });
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'CHECK IN: ',
                style: TextStyle(
                    fontSize: 43.69.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorConstants.TOP_CLIPPER_START),
              ),
              Text(
                _pickedDate == null
                    ? 'Tap to change'
                    : DateFormat('yMMMMd').format(_pickedDate),
                style: TextStyle(
                    fontSize: 43.69.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorConstants.TOP_CLIPPER_START),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget registerButton(UserDataProvider userDataProvider) {
    return StreamBuilder<bool>(
      stream: _isGuestSelected
          ? _bloc.requestAccessCheckWithAccesstime
          : _bloc.requestAccessCheck,
      builder: (context, snapshot) {
        return BottomClipper2(
            ButtonText.BACK,
            _userProvider.isLoading ? ButtonText.CHECKING : ButtonText.NEXT,
            !snapshot.hasData || !snapshot.data,
            () => goBack(),
            () => goNext(userDataProvider));
      },
    );
  }

  goBack() {
    if (_userProvider.authenticatedUser != null) {
      // debugPrint('navigating to dashboard screen');
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

    String vesselCode = _qrCodeDataProvider.qrCodeData;
    _user.checkInDate = _pickedDate;
    userDataProvider.user = _user;

    String authToken = await SharedPrefHelper.getAuthKey();

    // debugPrint('authToken is goNext of request access screen -------- '  + authToken);

    if (_userProvider.isAuthenticatedUser && authToken.length > 1) {
      _userProvider
          .sendAccessReq(userDataProvider.user, vesselCode)
          .then((responseStatus) {
        if (responseStatus.status == 200) {
          Navigator.of(context).pushNamed(YourObsScreen.routeName);
        } else {
          // debugPrint('Signup as guest failed');
          showInfoBar(parseErrorTitle(responseStatus.code),
              responseStatus.message, context);
        }
      });
    } else {
      // debugPrint('going to password screen');
      Navigator.of(context)
          .pushNamed(PasswordScreen.routeName, arguments: false);
    }
  }

  goToQrCodeScanner() {
    Navigator.of(context).pushNamed(PasswordScreen.routeName,
        arguments: RequestAccessScreen.routeName);
  }
}
