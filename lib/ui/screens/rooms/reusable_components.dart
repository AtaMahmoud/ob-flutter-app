import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';
import 'package:ocean_builder/core/common_widgets/search_bar.dart';
import 'package:ocean_builder/core/common_widgets/space_item.dart';

class Rooms extends StatefulWidget {
  static const String routeName = '/rooms';
  Rooms({Key key}) : super(key: key);

  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GenericBloc<String> _searchBloc;
  TextEditingController _searchController;

  TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    SpaceItem(
      label: 'Overview',
      hasWarning: false,
      isSelected: true,
      onPressed: () {
        debugPrint('pressed Overview');
      },
    ),
    SpaceItem(
      label: 'Overview',
      hasWarning: false,
      isSelected: false,
      onPressed: () {
        debugPrint('pressed Overview');
      },
    ),
    SpaceItem(
      label: 'Overview',
      hasWarning: true,
      isSelected: false,
      onPressed: () {
        debugPrint('pressed Overview');
      },
    ),
    SpaceItem(
      label: 'Overview',
      hasWarning: true,
      isSelected: false,
      onPressed: () {
        debugPrint('pressed Overview');
      },
    ),
    SpaceItem(
      label: 'Overview',
      hasWarning: true,
      isSelected: false,
      onPressed: () {
        debugPrint('pressed Overview');
      },
    ),
    SpaceItem(
      label: 'Overview',
      hasWarning: true,
      isSelected: false,
      onPressed: () {
        debugPrint('pressed Overview');
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchBloc = GenericBloc.private();
    _searchController = TextEditingController();
    // Create TabController for getting the index of current tab
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      print("Selected Index: " + _controller.index.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CommonTheme.greyLightest,
      body: Center(
        child: CustomScrollView(
          slivers: [
            // UIHelper.getTopEmptyContainer(8, false),
            SearchBar(
              scaffoldKey: _scaffoldKey,
              searchTextController: _searchController,
              stream: _searchBloc.stream,
              textChanged: (value) {
                debugPrint('Changed Search text is --- $value');
              },
              onSubmitted: (value) {
                debugPrint('Submitted Search text is --- $value');
              },
            ),
            SliverToBoxAdapter(
              child: _placeHolderScrollBar(),
            )
          ],
        ),
      ),
    );
  }

  _placeHolderScrollBar() {
    return TabBar(
      controller: _controller,
      tabs: list,
      isScrollable: true,
      indicator: ,

    );
    return SingleChildScrollView(
      clipBehavior: Clip.antiAlias,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          SpaceItem(
            label: 'Overview',
            hasWarning: false,
            isSelected: true,
            onPressed: () {
              debugPrint('pressed Overview');
            },
          ),
          SpaceItem(
            label: 'Overview',
            hasWarning: false,
            isSelected: false,
            onPressed: () {
              debugPrint('pressed Overview');
            },
          ),
          SpaceItem(
            label: 'Overview',
            hasWarning: true,
            isSelected: false,
            onPressed: () {
              debugPrint('pressed Overview');
            },
          ),
          SpaceItem(
            label: 'Overview',
            hasWarning: true,
            isSelected: false,
            onPressed: () {
              debugPrint('pressed Overview');
            },
          ),
          SpaceItem(
            label: 'Overview',
            hasWarning: true,
            isSelected: false,
            onPressed: () {
              debugPrint('pressed Overview');
            },
          ),
          SpaceItem(
            label: 'Overview',
            hasWarning: true,
            isSelected: false,
            onPressed: () {
              debugPrint('pressed Overview');
            },
          ),
        ],
      ),
    );
  }
}
