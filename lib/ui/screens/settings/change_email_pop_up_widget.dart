import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/login_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/singletons/headers_manager.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class ChangeEmailPopupContent extends StatefulWidget {
  ChangeEmailPopupContent({Key key}) : super(key: key);

  @override
  _ChangeEmailPopupContentState createState() =>
      _ChangeEmailPopupContentState();
}

class _ChangeEmailPopupContentState extends State<ChangeEmailPopupContent> {
  UserProvider _userProvider;

  User _user;

  TextEditingController _emailController;

  FocusNode _emailNode = FocusNode();

  LoginValidationBloc _bloc = LoginValidationBloc();

  HeadersManager _headerManager;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: '');
    _headerManager = HeadersManager.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);
    _user = _userProvider.authenticatedUser;
    _headerManager.initalizeBasicHeaders(context);
    _headerManager.initializeEssentialHeaders();
    _headerManager.initalizeAuthenticatedUserHeaders();

    return Center(
      child: SingleChildScrollView(
        child: Container(
          child: _changeEmailPopupContent(),
        ),
      ),
    );
  }

  Widget _changeEmailPopupContent() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 16.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.w),
            color: ColorConstants.LIGHT_POPUP_BKG),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[_textChangeMail(), _buttonCross()],
            ),
            SpaceH64(),
            _userProvider.isLoading ? _progressIndicator() : _inputEmail(),
            SpaceH64(),
            _buttonChangeMail(),
            SpaceH32(),
          ],
        ),
      ),
    );
  }

  Padding _progressIndicator() {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: CircularProgressIndicator(),
    );
  }

  Widget _inputEmail() {
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
        null);
  }

  Row _buttonChangeMail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
            onPressed: () {
              // Navigator.of(context).pop();
              _changeEmail(_emailController.text);
            },
            child: Text('CHANGE EMAIL'),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(48.w),
                side: BorderSide(
                  color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                )),
            textColor: ColorConstants.ACCESS_MANAGEMENT_TITLE,
            color: Colors.white),
      ],
    );
  }

  InkWell _buttonCross() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: EdgeInsets.only(
          right: 16.w,
          top: 16.h,
        ),
        child: Image.asset(
          ImagePaths.cross,
          width: 36.w,
          height: 36.h,
          color: ColorConstants.WEATHER_MORE_ICON_COLOR,
        ),
      ),
    );
  }

  Padding _textChangeMail() {
    return Padding(
      padding: EdgeInsets.only(top: 32.h, left: 32.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.changeEmail,
            style: TextStyle(
                fontSize: 48.sp, color: ColorConstants.LIGHT_POPUP_TITLE),
          ),
        ],
      ),
    );
  }

  _changeEmail(String newEmail) async {
    FocusScope.of(context).unfocus();
    if (!_userProvider.isLoading && MethodHelper.isEmailValid(newEmail)) {
      _user.email = newEmail;
      _emailController.text = '';
      _userProvider.updateUserProfile(_user).then((responseStatus) {
        if (responseStatus.status == 200) {
          showInfoBar('Email Updated', 'Email address updated', context);
        } else {
          showInfoBar(parseErrorTitle(responseStatus.code),
              responseStatus.message, context);
        }
      });
    } else {}
  }
}
