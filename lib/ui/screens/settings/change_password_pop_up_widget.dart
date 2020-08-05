import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/password_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/singletons/headers_manager.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class ChangePasswordPopupContent extends StatefulWidget {
  ChangePasswordPopupContent({Key key}) : super(key: key);

  @override
  _ChangePasswordPopupContentState createState() =>
      _ChangePasswordPopupContentState();
}

class _ChangePasswordPopupContentState
    extends State<ChangePasswordPopupContent> {
  ScreenUtil _util = ScreenUtil();
  UserProvider _userProvider;

  User _user;

  TextEditingController _passwordController, _newPasswordController;

  FocusNode _passwordNode = FocusNode();
  FocusNode _newPasswordNode = FocusNode();

  PasswordValidationBloc _bloc = PasswordValidationBloc();
  PasswordValidationBloc _bloc2 = PasswordValidationBloc();

  HeadersManager _headerManager;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: '');
    _newPasswordController = TextEditingController(text: '');
    _bloc.showPasswordChanged(false);
    _bloc2.showPasswordChanged(false);
    _headerManager = HeadersManager.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);
    // _user = _userProvider.authenticatedUser;
    _headerManager.initalizeBasicHeaders(context);
    _headerManager.initializeEssentialHeaders();
    _headerManager.initalizeAuthenticatedUserHeaders();

    return Center(
      child: SingleChildScrollView(
        child: Container(
          child: _changePasswordPopupContent(),
        ),
      ),
    );
  }

  // lighting popup

  Widget _changePasswordPopupContent() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _util.setWidth(48), vertical: _util.setHeight(16)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_util.setWidth(32)),
            color: ColorConstants.LIGHT_POPUP_BKG),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: _util.setHeight(32), left: _util.setSp(32)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppStrings.changePassword,
                        style: TextStyle(
                            fontSize: _util.setSp(48),
                            color: ColorConstants.LIGHT_POPUP_TITLE),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: _util.setWidth(16),
                      top: _util.setHeight(16),
                    ),
                    child: Image.asset(
                      ImagePaths.cross,
                      width: _util.setWidth(36),
                      height: _util.setHeight(36),
                      color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: _util.setHeight(64),
            ),
            _userProvider.isLoading
                ? CircularProgressIndicator()
                : Wrap(
                    children: <Widget>[
                      UIHelper.getPasswordTextField(
                          context,
                          _bloc.password,
                          _bloc.showPassword,
                          TextFieldHints.CURRENT_PASSWORD,
                          _passwordController,
                          null,
                          null,
                          true,
                          TextInputAction.next,
                          _passwordNode,
                          (data) => _bloc.passwordChanged(data),
                          (show) => _bloc.showPasswordChanged(show),
                          null),
                      SizedBox(
                        height: _util.setHeight(32),
                      ),
                      UIHelper.getPasswordTextField(
                          context,
                          _bloc2.password,
                          _bloc2.showPassword,
                          TextFieldHints.NEW_PASSWORD,
                          _newPasswordController,
                          null,
                          null,
                          true,
                          TextInputAction.done,
                          _newPasswordNode,
                          (data) => _bloc2.passwordChanged(data),
                          (show) => _bloc2.showPasswordChanged(show),
                          null),
                    ],
                  ),
            SizedBox(
              height: _util.setHeight(64),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    onPressed: () {
                      // Navigator.of(context).pop();
                      _changePassword(_passwordController.text,
                          _newPasswordController.text);
                    },
                    child: Text('CHANGE PASSWORD'),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            new BorderRadius.circular(_util.setWidth(48)),
                        side: BorderSide(
                          color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                        )),
                    textColor: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                    color: Colors.white),
              ],
            ),
            SizedBox(
              height: _util.setHeight(32),
            ),
          ],
        ),
      ),
    );
  }

  _changePassword(String currentPassword, String newPassword) async {
    FocusScope.of(context).unfocus();
    if (!_userProvider.isLoading && MethodHelper.isPasswordValid(currentPassword) && MethodHelper.isPasswordValid(newPassword) ) {
      // _userProvider.updateUserInfo(_user).then((responseStatus) {
      _userProvider
          .updateUserPassword(currentPassword, newPassword)
          .then((responseStatus) {
        if (responseStatus.status == 200) {
          _passwordController.text = '';
          _newPasswordController.text = '';
          Navigator.of(context).pop();
          showInfoBar('Password Updated', 'User passowrd updated', context);

           
        } else {
           Navigator.of(context).pop();
          showInfoBar(parseErrorTitle(responseStatus.code),
              responseStatus.message, context);
         
        }
      });
    } else {
      // debugPrint('is laoding ...');
    }
  }
}
