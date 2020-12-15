import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:rxdart/rxdart.dart';

class SearchBar extends StatefulWidget {
  const SearchBar(
      {Key key,
      this.scaffoldKey,
      this.searchTextController,
      this.stream,
      this.textChanged,
      this.onSubmitted})
      : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;
  final TextEditingController searchTextController;
  final Observable<String> stream;
  final Function textChanged;
  final Function onSubmitted;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return _sliverAppBar(widget.scaffoldKey, isDrawer: true);
  }

  _sliverAppBar(_scaffoldKey, {isDrawer = true}) {
    return SliverAppBar(
      title: _searchBar(),
      automaticallyImplyLeading: false,
      elevation: 0,
      titleSpacing: 0.0,
      leading: isDrawer //_leadingDrawerButton(),
          ? IconButton(
              icon: ImageIcon(
                AssetImage(ImagePaths.icSearchBarHam),
                color: CommonTheme.primary,
              ),
              tooltip: 'Drawer',
              onPressed: () {
                // handle the press
                if (_scaffoldKey != null)
                  _scaffoldKey.currentState.openDrawer();
              },
              color: CommonTheme.primary,
            )
          : Container(),
      backgroundColor: CommonTheme.white,
      pinned: true,
      iconTheme: IconThemeData(color: ColorConstants.TOP_CLIPPER_END_DARK),
      actions: <Widget>[
        IconButton(
          icon: ImageIcon(
            AssetImage(ImagePaths.icSearchBarBell),
            color: CommonTheme.primary,
          ),
          tooltip: 'Notification',
          onPressed: () {},
          color: CommonTheme.primary,
          // iconSize: 72,
        ),
      ],
    );
  }

  _searchBar() {
    return Container(
      height: kToolbarHeight / 1.75,
      decoration: BoxDecoration(
        color: CommonTheme.primaryLightest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                widget.onSubmitted.call(widget.searchTextController.text);
              }, //_setfilter,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: SvgPicture.asset(
                  ImagePaths.svgIcSearchBarSearch,
                  color: CommonTheme.primaryLight,
                  fit: BoxFit.cover,
                  height: kToolbarHeight / 4,
                ),
              ),
            ),
            Flexible(
              child: TextField(
                controller: widget.searchTextController,
                onChanged: widget.textChanged,
                onSubmitted: (value) {
                  widget.onSubmitted.call(value);
                }, //_onSubmitted,
                keyboardAppearance: Brightness.light,
                textAlignVertical: TextAlignVertical.bottom,
                style: CommonTheme.tsBodySmall
                    .apply(color: CommonTheme.primaryDark),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search the app',
                  hintStyle: CommonTheme.tsBodySmall.apply(
                    color: CommonTheme.primaryLighter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
