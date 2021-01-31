import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/registration_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/user_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper_2.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/accept_invitation_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/login_screen.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class RegistrationScreenAcceptInvitation extends StatefulWidget {
  static const String routeName = '/registrationHomeAccessInvitation';

  @override
  _RegistrationScreenAcceptInvitationState createState() =>
      _RegistrationScreenAcceptInvitationState();
}

class _RegistrationScreenAcceptInvitationState
    extends State<RegistrationScreenAcceptInvitation> {
  UserProvider _userProvider;

  TextEditingController _firstNameController,
      _lastNameController,
      _emailController,
      _phoneController;

  ScrollController _controller = ScrollController();

  FocusNode _firstNameNode = FocusNode();
  FocusNode _lastNameNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _phoneNode = FocusNode();

  RegistrationValidationBloc _bloc = RegistrationValidationBloc();

  User _user = User();
  ScreenUtil _util = ScreenUtil();

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController(text: '');
    _lastNameController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _phoneController = TextEditingController(text: '');
    _setUserDataListener();
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    _emailNode.dispose();
    _phoneNode.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;

    final UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context);

    _userProvider = Provider.of<UserProvider>(context);

    // double sizedBoxHeight = 30;

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: CustomScrollView(
              shrinkWrap: true,
              controller: _controller,
              slivers: <Widget>[
                _startSpace(),
                _mainContent(context),
                _buttonAlreadyMember(),
                _endSpace(),
              ],
            ),
          ),
          _appBar(),
          _bottomBar(userDataProvider)
        ],
      ),
    );
  }

  SliverList _mainContent(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate([
      _inputFirstName(context),
      SpaceH32(),
      _inputLastName(context),
      SpaceH64(),
      _dropdownCountry(),
      SpaceH32(),
      _inputPhone(context),
    ]));
  }

  _endSpace() => UIHelper.getTopEmptyContainer(_util.setHeight(330), false);

  Positioned _bottomBar(UserDataProvider userDataProvider) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: registerButton(userDataProvider),
    );
  }

  Positioned _appBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Appbar(ScreenTitle.HOME_ACCESS_INVITATION),
    );
  }

  SliverToBoxAdapter _buttonAlreadyMember() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(
            top: 48.0, //util.setHeight(64),
            right: 16.0,
            bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              onTap: () {
                _goToLogInPageFromRegistraion();
              },
              child: Text(
                'ALREADY A MEMBER ?',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: ColorConstants.PROFILE_BKG_1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputPhone(BuildContext context) {
    return UIHelper.getRegistrationTextField(
        context,
        _bloc.phone,
        _bloc.phoneChanged,
        TextFieldHints.PHONE,
        _phoneController,
        InputTypes.PHONE,
        null,
        true,
        TextInputAction.done,
        _phoneNode,
        null);
  }

  Widget _dropdownCountry() {
    return UIHelper.getCountryDropdown(
        ListHelper.getCountryList(), _bloc.country, _bloc.countryChanged, true);
  }

  Widget _inputLastName(BuildContext context) {
    return UIHelper.getRegistrationTextField(
        context,
        _bloc.lastName,
        _bloc.lastNameChanged,
        TextFieldHints.LAST_NAME,
        _lastNameController,
        null,
        30,
        true,
        TextInputAction.next,
        _lastNameNode,
        () => FocusScope.of(context).requestFocus(_emailNode));
  }

  Widget _inputFirstName(BuildContext context) {
    return UIHelper.getRegistrationTextField(
        context,
        _bloc.firstName,
        _bloc.firstNameChanged,
        TextFieldHints.FIRST_NAME,
        _firstNameController,
        null,
        30,
        true,
        TextInputAction.next,
        _firstNameNode,
        () => FocusScope.of(context).requestFocus(_lastNameNode));
  }

  _startSpace() => UIHelper.getTopEmptyContainer(_util.setHeight(500), false);

  Widget registerButton(UserDataProvider userDataProvider) {
    return StreamBuilder<bool>(
      stream: _bloc.invitationRegistrationCheck,
      builder: (context, snapshot) {
        return BottomClipper2(
            ButtonText.BACK,
            ButtonText.NEXT,
            !snapshot.hasData || !snapshot.data,
            () => _goBack(),
            () => _goNext(userDataProvider));
      },
    );
  }

  _goToLogInPageFromRegistraion() {
    Navigator.of(context)
        .pushNamed(LoginScreen.routeName, arguments: ScreenTitle.REGISTER);
  }

  _goBack() {
    Navigator.pop(context);
  }

  _goNext(UserDataProvider userDataProvider) async {
    String existingUserId = '';
    if (existingUserId.length > 1) {
      showInfoBar(ErrorConstants.TITLE_USER_ALREADY_EXISTS,
          ErrorConstants.USER_ALREADY_EXISTS_USE_ALREADY_BUTTON, context);
    } else {
      userDataProvider.user = _user;
      Navigator.of(context).pushNamed(AcceptInvitationScreen.routeName);
    }
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

    _bloc.requestAccessAsController.listen((onData) {
      if (onData.compareTo(ListHelper.getAccessAsList()[1]) == 0) {
        debugPrint(_user.toJson().toString());
        _user.userType = ListHelper.getAccessAsList()[1];
      } else if (onData.compareTo(ListHelper.getAccessAsList()[2]) == 0) {
        _user.userType = ListHelper.getAccessAsList()[2];
      }
    });
    _bloc.requestAccessTimeController.listen((onData) {
      _user.requestAccessTime = onData;
    });
  }
}
