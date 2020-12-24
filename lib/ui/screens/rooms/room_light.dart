import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/core/common_widgets/search_bar.dart';

class RoomLight extends StatefulWidget {
  RoomLight({Key key}) : super(key: key);

  @override
  _RoomLightState createState() => _RoomLightState();
}

class _RoomLightState extends State<RoomLight> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GenericBloc<String> _searchBloc;
  TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
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
        ],
      ),
    );
  }
}
