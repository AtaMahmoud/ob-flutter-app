import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/singletons/headers_manager.dart';
import 'package:provider/provider.dart';

class SeaPodSavedPopupContent extends StatefulWidget {
  SeaPodSavedPopupContent({Key key}) : super(key: key);

  @override
  _SeaPodSavedPopupContentState createState() =>
      _SeaPodSavedPopupContentState();
}

class _SeaPodSavedPopupContentState
    extends State<SeaPodSavedPopupContent> {
  ScreenUtil _util = ScreenUtil();
  UserProvider _userProvider;

  User _user;

  HeadersManager _headerManager;

  @override
  void initState() {
    super.initState();
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
          child: _seaPodSavedPopupContent(),
        ),
      ),
    );
  }

  // lighting popup

  Widget _seaPodSavedPopupContent() {
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
                    AppStrings.seaPodSavedTitle,
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
                      AppStrings.seaPodSavedInfo,
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
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: _util.setWidth(65.535)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text(
                      AppStrings.seaPodSaved,
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
            )
          ],
        ),
      ),
    );
  }

}
