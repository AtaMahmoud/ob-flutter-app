import 'package:flutter/material.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key key, this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: sliverAppBar(scaffoldKey, isDrawer: true),
    );
  }

  static sliverAppBar(_scaffoldKey, {isDrawer = true}) {
    return SliverAppBar(
      title: //_topAppBarContent(),
          Text(
        'screnTitle',
        style: TextStyle(
            color: ColorConstants.WEATHER_MORE_ICON_COLOR,
            fontSize: 60,
            fontWeight: FontWeight.w400),
      ),
      centerTitle: false,
      leading: isDrawer //_leadingDrawerButton(),
          ? IconButton(
              icon: //Icon(Icons.close),
                  ImageIcon(
                AssetImage(ImagePaths.icSearchBarHam),
                color: Color(0xFF3A5A98),
              ),
              tooltip: 'Drawer',
              onPressed: () {
                // handle the press
                if (_scaffoldKey != null)
                  _scaffoldKey.currentState.openDrawer();
              },
              color: ColorConstants.TOP_CLIPPER_END_DARK,
            )
          : Container(),
      backgroundColor: CommonTheme.greyLightest,
      pinned: true,
      iconTheme: IconThemeData(color: ColorConstants.TOP_CLIPPER_END_DARK),
      actions: <Widget>[
        // _topBarBackButton()
        IconButton(
          icon: ImageIcon(
            AssetImage(ImagePaths.icSearchBarBell),
            color: Color(0xFF3A5A98),
          ),
          tooltip: 'Noti',
          onPressed: () {},
          color: ColorConstants.TOP_CLIPPER_END_DARK,
          // iconSize: 72,
        ),
      ],
    );
  }
}
