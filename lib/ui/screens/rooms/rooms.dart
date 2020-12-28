import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/cards.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';
import 'package:ocean_builder/core/common_widgets/search_bar.dart';
import 'package:ocean_builder/core/common_widgets/space_bar.dart';
import 'package:ocean_builder/core/common_widgets/space_item.dart';
import 'package:ocean_builder/core/models/lighting.dart';
import 'package:ocean_builder/ui/screens/rooms/room_details.dart';

class Rooms extends StatefulWidget {
  static const String routeName = '/rooms';
  Rooms({Key key}) : super(key: key);

  @override
  RoomsState createState() => RoomsState();
}

class RoomsState extends State<Rooms> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GenericBloc<String> _searchBloc;
  TextEditingController _searchController;

  List<SpaceItemData> spaceItems = [];

  GenericBloc<int> _selectedTabBloc = GenericBloc.private();
  GenericBloc<Widget> _selectedContentBloc = GenericBloc.private();
  GenericBloc<Widget> _headerContentBloc = GenericBloc.private();

  Widget _selectedContent;

  String _selctedItemName;

  List<Room> _demorooms;

  int _selctedIndex;

  @override
  void initState() {
    super.initState();
    _searchBloc = GenericBloc.private();
    _initializeItemSet();
    _selectItemListener();
  }

  @override
  void dispose() {
    super.dispose();
    _selectedTabBloc.dispose();
    _selectedContentBloc.dispose();
    _headerContentBloc.dispose();
  }

  _initializeItemSet() {
    _demorooms = _getRooms();
    for (var i = 0; i < _demorooms.length; i++) {
      spaceItems.add(SpaceItemData(
          index: i,
          label: _demorooms[i].roomName,
          hasWarning: true,
          isSelected: false));
    }
    spaceItems[0].isSelected = true;
    _selectedContent = Container();
    // _selectedContentBloc.changed(_selectedContent);
    _selectedContentBloc = GenericBloc(_selectedContent);
    _selctedItemName = 'Bedroom';
    _selctedIndex = 0;
  }

  // 0 bedroom
  // 1 livingroom
  // 2 kitchen
  // 3 underwater room
  // 4 bathroom
  // 5 master bedroom

  void _selectItemListener() {
    _selectedTabBloc.stream.listen((selectedIndex) {
      _selctedIndex = selectedIndex;
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
            _selectedContent = RoomDetails(
                name: _selctedItemName,
                room: _demorooms[selectedIndex],
                roomHeaderChanged: _headerContentBloc.changed,
                selectedContentChanged:
                    _selectedContentBloc.changed); //_bathRoom();
            _selectedContentBloc.changed(_selectedContent);
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
                    child: StreamBuilder<Widget>(
                        stream: _headerContentBloc.stream,
                        initialData: spaceBar(),
                        builder: (context, snapshot) {
                          return snapshot.data;
                        }),
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
                    child: StreamBuilder<Widget>(
                        stream: _selectedContentBloc.stream,
                        builder: (context, snapshot) {
                          return snapshot.hasData ? snapshot.data : Container();
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  spaceBar() {
    return SpaceBar(
      spaceItems: spaceItems,
      stream: _selectedTabBloc.stream,
      changed: _selectedTabBloc.changed,
      initialIndex: _selctedIndex,
    );
  }

  // demo room data
  _getRooms() {
    List<Light> _lightsBedroom = [
      new Light(
          lightName: 'Lightstrip 1',
          lightColor: '0xFF959B1B',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Lightstrip 2',
          lightColor: '0xFF1322FF',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Ligh 3',
          lightColor: '0xFFFF1EEE',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Counter 4',
          lightColor: '0xFFFFBE93',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Ocerhead 3',
          lightColor: '0xFFC1FFE5',
          status: true,
          brightness: 100)
    ];

    List<Light> _lightsLivingRoom = [
      new Light(
          lightName: 'Lightstrip 1',
          lightColor: '0xFF959B1B',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Lightstrip 2',
          lightColor: '0xFF1322FF',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Ligh 3',
          lightColor: '0xFFFF1EEE',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Counter 4',
          lightColor: '0xFFFFBE93',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Ocerhead 3',
          lightColor: '0xFFC1FFE5',
          status: true,
          brightness: 100)
    ];

    List<Light> _lightsKitchen = [
      new Light(
          lightName: 'Lightstrip 1',
          lightColor: '0xFF959B1B',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Lightstrip 2',
          lightColor: '0xFF1322FF',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Ligh 3',
          lightColor: '0xFFFF1EEE',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Counter 4',
          lightColor: '0xFFFFBE93',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Ocerhead 3',
          lightColor: '0xFFC1FFE5',
          status: true,
          brightness: 100)
    ];

    List<Light> _lightsUnderWaterRoom = [
      new Light(
          lightName: 'Lightstrip 1',
          lightColor: '0xFF959B1B',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Lightstrip 2',
          lightColor: '0xFF1322FF',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Ligh 3',
          lightColor: '0xFFFF1EEE',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Counter 4',
          lightColor: '0xFFFFBE93',
          status: true,
          brightness: 100),
      new Light(
          lightName: 'Ocerhead 3',
          lightColor: '0xFFC1FFE5',
          status: true,
          brightness: 100)
    ];

    List<Room> rooms = [
      new Room(
          roomName: 'Bedroom',
          // light: _lightsBedroom[0],
          lightModes: _lightsBedroom),
      new Room(
          roomName: 'Livingroom',
          // light: _lightsLivingRoom[1],
          lightModes: _lightsLivingRoom),
      new Room(
          roomName: 'Kitchen',
          // light: _lightsKitchen[2],
          lightModes: _lightsKitchen),
      new Room(
          roomName: 'UnderWaterRoom',
          // light: _lightsUnderWaterRoom[3],
          lightModes: _lightsUnderWaterRoom),
      new Room(roomName: 'Bathroom', lightModes: _lightsUnderWaterRoom),
      new Room(roomName: 'Master Bedroom', lightModes: _lightsBedroom)
    ];

    return rooms;
  }
}
