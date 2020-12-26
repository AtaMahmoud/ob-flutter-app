import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/cards.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';
import 'package:ocean_builder/core/common_widgets/search_bar.dart';
import 'package:ocean_builder/core/common_widgets/space_bar.dart';
import 'package:ocean_builder/core/common_widgets/space_item.dart';
import 'package:ocean_builder/ui/screens/rooms/room_details.dart';

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

  Widget _selectedContent;

  String _selctedItemName;

  bool _isSecondLevel = false;

  @override
  void initState() {
    super.initState();
    _searchBloc = GenericBloc.private();
    _initializeItemSet();
    _selectItemListener();
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
    _selectedContent = Container();
    _selctedItemName = 'Bedroom';
  }

  // 0 bedroom
  // 1 livingroom
  // 2 kitchen
  // 3 underwater room
  // 4 bathroom
  // 5 master bedroom

  void _selectItemListener() {
    _selectedTabBloc.stream.listen((selectedIndex) {
      switch (selectedIndex) {
        case 0:
          debugPrint('Navigate to bedroom details');
          setState(() {
            _selctedItemName = 'Bedroom';
            _selectedContent = Container();
          });
          break;
        case 1:
          debugPrint('Navigate to living room details');
          setState(() {
            _selctedItemName = 'Living room';
            _selectedContent = Container();
          });
          break;
        case 2:
          debugPrint('Navigate to kitchen details');
          setState(() {
            _selctedItemName = 'Kitchen';
            _selectedContent = Container();
          });
          break;
        case 3:
          debugPrint('Navigate to underwater room');
          setState(() {
            _selctedItemName = 'Underwater room';
            _selectedContent = Container();
          });
          break;
        case 4:
          debugPrint('Navigate to bathroom details');
          setState(() {
            _selctedItemName = 'Bathroom';
            _selectedContent = _bathRoom();
          });
          break;
        case 5:
          debugPrint('Navigate to master bedroom details');
          setState(() {
            _selctedItemName = 'Master bedroom';
            _selectedContent = Container();
          });
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CommonTheme.greyLightest,
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
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
                    child: _spaceBar(),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _selectedContent,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _spaceBar() {
    return SpaceBar(
      spaceItems: spaceItems,
      stream: _selectedTabBloc.stream,
      changed: _selectedTabBloc.changed,
    );
  }

  _bathRoom() {
    return Container(
      child: Column(
        children: [
          GenericCard(
            hasSwitch: false,
            title: 'No Preset Available',
            data: 'Click to save current settings as preset',
            onTap: () {
              _isSecondLevel = true;
            },
          ),
          GenericCard(
            hasSwitch: true,
            switchValue: true,
            title: 'Lights-Ceiling',
            dataIcon: ImagePaths.svgIcLightKnob,
            data: 'Brightness 60%',
            subData: 'My Bathroom Preset',
          ),
          GenericCard(
            hasSwitch: true,
            switchValue: false,
            title: 'Lights-floor',
            dataIcon: ImagePaths.svgIcLightKnob,
            data: 'Brightness 60%',
          ),
          GenericCard(
            hasSwitch: true,
            switchValue: true,
            title: 'Shower Temperature',
            data: '24${SymbolConstant.DEGREE}C',
            subData: '>> 75.2${SymbolConstant.DEGREE}F',
          ),
        ],
      ),
    );
  }
}
