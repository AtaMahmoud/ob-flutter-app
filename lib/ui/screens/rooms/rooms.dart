import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';
import 'package:ocean_builder/core/common_widgets/search_bar.dart';
import 'package:ocean_builder/core/common_widgets/space_bar.dart';
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

  List<SpaceItemData> spaceItems = [];

  GenericBloc<int> _selectedTabBloc = GenericBloc.private();

  @override
  void initState() {
    super.initState();
    _searchBloc = GenericBloc.private();
    _initializeItemSet();
  }

  _initializeItemSet() {
    for (var i = 0; i < demorooms.length; i++) {
      spaceItems.add(SpaceItemData(
          index: i,
          label: demorooms[i].roomName,
          hasWarning: true,
          isSelected: false));
    }
    spaceItems[0].isSelected = true;
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
    return SpaceBar(
      spaceItems: spaceItems,
      stream: _selectedTabBloc.stream,
      changed: _selectedTabBloc.changed,
    );
  }
}
