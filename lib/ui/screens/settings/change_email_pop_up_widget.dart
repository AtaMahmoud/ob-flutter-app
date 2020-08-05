import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/login_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/singletons/headers_manager.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class ChangeEmailPopupContent extends StatefulWidget {
  ChangeEmailPopupContent({Key key}) : super(key: key);

  @override
  _ChangeEmailPopupContentState createState() =>
      _ChangeEmailPopupContentState();
}

class _ChangeEmailPopupContentState extends State<ChangeEmailPopupContent> {
  ScreenUtil _util = ScreenUtil();
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

  // lighting popup

  Widget _changeEmailPopupContent() {
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
                        AppStrings.changeEmail,
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
                        ? Padding(
                            padding: EdgeInsets.all(_util.setWidth(8)),
                            child: CircularProgressIndicator(),
                          )
                        : UIHelper.getRegistrationTextField(
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
                null),
            SizedBox(
              height: _util.setHeight(64),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    onPressed: () {
                      // Navigator.of(context).pop();
                      _changeEmail(_emailController.text);
                    },
                    child:Text('CHANGE EMAIL'),
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

  _changeEmail(String newEmail) async {
    FocusScope.of(context).unfocus();
    if (!_userProvider.isLoading && MethodHelper.isEmailValid(newEmail)) {
      _user.email = newEmail;
      _emailController.text = '';
      _userProvider.updateUserProfile(_user).then((responseStatus) {
        if (responseStatus.status == 200) {
          // _userProvider.resetAuthenticatedUser(_user.userID);
          showInfoBar('Email Updated', 'Email address updated', context);
        } else {
          showInfoBar(parseErrorTitle(responseStatus.code),
              responseStatus.message, context);
        }
      });
    } else {
      // debugPrint('is laoding ...');
    }
  }
}
