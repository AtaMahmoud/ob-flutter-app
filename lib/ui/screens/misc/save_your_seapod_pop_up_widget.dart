import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/save_seapod_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/singletons/headers_manager.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class SaveYourSeaPodPopupContent extends StatefulWidget {
  SaveYourSeaPodPopupContent({Key key}) : super(key: key);

  @override
  _SaveYourSeaPodPopupContentState createState() =>
      _SaveYourSeaPodPopupContentState();
}

class _SaveYourSeaPodPopupContentState
    extends State<SaveYourSeaPodPopupContent> {
  ScreenUtil _util = ScreenUtil();
  UserProvider _userProvider;

  User _user;

  TextEditingController _seaPodNameController;
  TextEditingController _emailController;

  FocusNode _emailNode = FocusNode();
  FocusNode _seaPodNameNode = FocusNode();

  SaveSeaPodValidationBloc _bloc = SaveSeaPodValidationBloc();

  HeadersManager _headerManager;

  bool showLoadingIndicator = false;

  @override
  void initState() {
    super.initState();
    _seaPodNameController = TextEditingController(text: '');
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
          child: _saveYourSeaPodPopupContent(),
        ),
      ),
    );
  }

  // lighting popup

  Widget _saveYourSeaPodPopupContent() {
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
                Spacer(),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    AppStrings.saveYourSeaPodTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: _util.setSp(48),
                        color: ColorConstants.LIGHT_POPUP_TITLE),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: _util.setHeight(64),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: _util.setWidth(65.535)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text(
                      AppStrings.saveYourSeaPod,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: _util.setSp(42),
                          color: ColorConstants.LIGHT_POPUP_TITLE),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _util.setHeight(64),
            ),
            _userProvider.isLoading
                ? Padding(
                    padding: EdgeInsets.all(_util.setWidth(8)),
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: <Widget>[
                      UIHelper.getRegistrationTextField(
                          context,
                          _bloc.seaPodName,
                          _bloc.seaPodNameChanged,
                          TextFieldHints.NAME_YOUR_SEAPOD,
                          _seaPodNameController,
                          TextInputType.text,
                          null,
                          true,
                          TextInputAction.next,
                          _emailNode,
                          null),
                      SizedBox(
                        height: _util.setHeight(32),
                      ),
                      UIHelper.getRegistrationTextField(
                          context,
                          _bloc.email,
                          _bloc.emailChanged,
                          'EMAIL ADDRESS',
                          _emailController,
                          InputTypes.EMAIL,
                          null,
                          true,
                          TextInputAction.done,
                          _seaPodNameNode,
                          null),
                    ],
                  ),
            SizedBox(
              height: _util.setHeight(64),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: _util.setWidth(65.535)),
                    child: RaisedButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          _saveYourSeaPod(_seaPodNameController.text);
                        },
                        child: Text('SAVE'),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                new BorderRadius.circular(_util.setWidth(48)),
                            side: BorderSide(
                              color:
                                  ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                            )),
                        textColor: Colors.white,
                        color: ColorConstants.TOP_CLIPPER_START),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: _util.setHeight(64),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _util.setWidth(65.535)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      debugPrint('remind me later clicked');
                    },
                    child: Text(
                      AppStrings.remindMeLater,
                      style: TextStyle(
                          fontSize: _util.setSp(42),
                          color: ColorConstants.LIGHT_POPUP_TITLE),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      debugPrint('no thanks clicked');
                    },
                    child: Text(
                      AppStrings.noThanks,
                      style: TextStyle(
                          fontSize: _util.setSp(42),
                          color: ColorConstants.LIGHT_POPUP_TITLE),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _util.setHeight(64),
            ),
          ],
        ),
      ),
    );
  }

  _saveYourSeaPod(String newEmail) async {
    FocusScope.of(context).unfocus();
    showLoadingIndicator = true;
    
    Navigator.of(context).pop();
    _showLinearIndicator();
    // PopUpHelpers.showPopup(context, SeaPodSavedPopupContent(), 'SeaPod Saved');
  }

  _showLinearIndicator(){

    double bottom = MediaQuery.of(context).size.height - _util.setHeight(100);

        Navigator.push(
      context,
      PopupLayout(
        top: 0.0 ,
        left: 0.0,
        right: 0.0,
        bottom: MediaQuery.of(context).size.height * 0.8 > bottom ? bottom : MediaQuery.of(context).size.height * 0.85,
        child:LinearProgressIndicator(
                  backgroundColor: ColorConstants.TOP_CLIPPER_START,
                  valueColor: AlwaysStoppedAnimation(Colors.lightGreen),
                ),
      ),
    );
  }

  
}
