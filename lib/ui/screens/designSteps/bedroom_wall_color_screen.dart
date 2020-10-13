import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/deck_floor_finish_material_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class InteriorBedRoomWallColorScreen extends StatefulWidget {
  static const String routeName = '/interiorBedroomWallColor';

  @override
  _InteriorBedRoomWallColorScreenState createState() =>
      _InteriorBedRoomWallColorScreenState();
}

class _InteriorBedRoomWallColorScreenState
    extends State<InteriorBedRoomWallColorScreen> {
  List<String> list = ListHelper.getWallColorList();
  List<String> price = ListHelper.getWallColorPricingList();
  List<String> subtitle = ListHelper.getWallColorSubtitle();
  GenericBloc<String> _bloc = GenericBloc(ListHelper.getWallColorList()[0]);

  GenericBloc<int> _colorBloc = GenericBloc<int>(ListHelper.colorList()[0]);
  GenericBloc<int> _selectedColor = GenericBloc(ListHelper.colorList()[0]);

  String _wallColor = ListHelper.getWallColorList()[0];
  String _wallColorCustom = ListHelper.colorList()[0].toString();

  @override
  void initState() {
    super.initState();
    _bloc.controller.listen((onData) {
      _wallColor = onData;
    });

    _selectedColor.controller.listen((onData) {
      Color color = new Color(onData);
      String valueString = color.toString().split('(')[1].split(')')[0];
      _wallColorCustom = valueString;
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    _colorBloc.dispose();
    _selectedColor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    final DesignDataProvider designDataProvider =
        Provider.of<DesignDataProvider>(context);

    if (designDataProvider.oceanBuilder.interiorBedroomWallColor != null) {
      if (designDataProvider.oceanBuilder.interiorBedroomWallColor
              .compareTo(ListHelper.getWallColorList()[0]) ==
          0)
        _bloc.sink
            .add(designDataProvider.oceanBuilder.interiorBedroomWallColor);
      else {
        _bloc.sink.add(list[1]);
        _selectedColor.sink.add(int.parse(
            designDataProvider.oceanBuilder.interiorBedroomWallColor));
        _colorBloc.sink.add(50);
      }
    }

    return Container(
      decoration: BoxDecoration(gradient: blueBackgroundGradient),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _mainContent(context),
            _titleBar(),
            _bottomBar(designDataProvider)
          ],
        ),
      ),
    );
  }

  CustomScrollView _mainContent(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        UIHelper.getTopEmptyContainer(
            MediaQuery.of(context).size.height / 2, true),
        SliverPadding(
          padding: const EdgeInsets.only(top: 8.0),
          sliver: SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _whiteColorRadioButton(),
                _customColorRadioButton()
              ],
            ),
          ),
        ),
        _colorGrid(),
        _bottomSpace(),
      ],
    );
  }

  InkWell _customColorRadioButton() {
    return InkWell(
      onTap: () {
        _bloc.sink.add(list[1]);
        _colorBloc.sink.add(50);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: UIHelper.getCustomRadioButtonHorizontal(
            _bloc.stream, list[1], price[1],
            subtitle: subtitle[1]),
      ),
    );
  }

  InkWell _whiteColorRadioButton() {
    return InkWell(
      onTap: () {
        _bloc.sink.add(list[0]);
        _colorBloc.sink.add(0);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: UIHelper.getCustomRadioButtonHorizontal(
            _bloc.stream, list[0], price[0],
            subtitle: subtitle[0]),
      ),
    );
  }

  _bottomSpace() => UIHelper.getTopEmptyContainer(90, false);

  StreamBuilder<String> _colorGrid() {
    return StreamBuilder<String>(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          return snapshot.data == list[1]
              ? UIHelper.getSliverGridColor(_colorBloc.stream,
                  _selectedColor.stream, (data) => selectItem(data))
              : SliverPadding(padding: EdgeInsets.all(0.0));
        });
  }

  Appbar _titleBar() => Appbar(
        ScreenTitle.INTERIOR_BEDROOM_WALL_COLOR,
        isDesignScreen: true,
      );

  Positioned _bottomBar(DesignDataProvider designDataProvider) {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: BottomClipper(ButtonText.BACK, ButtonText.NEXT, () => goBack(),
            () => goNext(designDataProvider)));
  }

  goNext(DesignDataProvider designDataProvider) {
    if (_wallColor.compareTo(ListHelper.getWallColorList()[0]) == 0) {
      designDataProvider.oceanBuilder.interiorBedroomWallColor =
          '0xffffffff'; //_wallColor;
    } else {
      designDataProvider.oceanBuilder.interiorBedroomWallColor =
          _wallColorCustom;
    }

    Navigator.of(context).pushNamed(DeckFloorFinishMaterialsScreen.routeName);
    // debugPrint(designDataProvider.oceanBuilder.interiorBedroomWallColor.toString());
  }

  goBack() {
    Navigator.pop(context);
  }

  selectItem(int data) {
    _selectedColor.sink.add(data);
  }
}
