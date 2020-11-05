import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/weather_station_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class KitchenFloorFinishingScreen extends StatefulWidget {
  static const String routeName = '/kitchenFloorFinishing';

  @override
  _KitchenFloorFinishingScreenState createState() =>
      _KitchenFloorFinishingScreenState();
}

class _KitchenFloorFinishingScreenState
    extends State<KitchenFloorFinishingScreen> {
  List<String> list = ListHelper.getFloorFinishing();
  List<String> price = ListHelper.getFloorFinishPricing();
  List<String> subtitle = ListHelper.getFloorFinishSubTitle();
  GenericBloc<String> _bloc =
      GenericBloc(ListHelper.getFloorFinishingColorList()[0]);
  GenericBloc<int> _colorBloc = GenericBloc<int>(ListHelper.colorList()[0]);
  GenericBloc<int> _selectedColor = GenericBloc(ListHelper.colorList()[0]);

  String _floorFinishingColor = ListHelper.colorList()[0].toString();

  String _floorFinishingMaterial = ListHelper.getFloorFinishingColorList()[0];

  @override
  void initState() {
    super.initState();
    _selectedColor.controller.listen((onData) {
      Color color = new Color(onData);
      String valueString = color.toString().split('(')[1].split(')')[0];
      _floorFinishingColor = valueString;
    });
    _bloc.controller.listen((onData) {
      _floorFinishingMaterial = onData;
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

    if (designDataProvider.oceanBuilder.kitchenfloorFinishing != null) {
      if (designDataProvider.oceanBuilder.kitchenfloorFinishing
              .compareTo(ListHelper.getFloorFinishingColorList()[0]) ==
          0) {
        _bloc.sink.add(designDataProvider.oceanBuilder.kitchenfloorFinishing);
        _floorFinishingMaterial =
            designDataProvider.oceanBuilder.kitchenfloorFinishing;
      } else {
        List<String> splits =
            designDataProvider.oceanBuilder.kitchenfloorFinishing.split(',');
        if (splits.length == 2) {
          // debugPrint('cached values '+ splits[0] + ' '+ splits[1]);
          _bloc.sink.add(splits[0]);
          _selectedColor.sink.add(int.parse(splits[1]));
          _floorFinishingMaterial = splits[0];
          _floorFinishingColor = splits[1];
        }

        if (splits[0].contains(list[1])) {
          _colorBloc.sink.add(50);
        } else if (splits[0].contains(list[2])) {
          _colorBloc.sink.add(10);
        }
      }
    }

    return Container(
      decoration: BoxDecoration(gradient: blueBackgroundGradient),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _mainContent(context),
            _topBar(),
            _bottomBar(designDataProvider)
          ],
        ),
      ),
    );
  }

  CustomScrollView _mainContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _startSpace(context),
        SliverPadding(
          padding: const EdgeInsets.only(top: 8.0),
          sliver: SliverToBoxAdapter(
              child: Column(
            children: <Widget>[_radioButtonCarbonFiber(), _radioButtonTile()],
          )),
        ),
        _colorGridTile(),
        _radioButtonWood(),
        _colorGridWood(),
        _endSpace(),
      ],
    );
  }

  StreamBuilder<String> _colorGridWood() {
    return StreamBuilder<String>(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          return snapshot.data == list[2]
              ? UIHelper.getSliverGridColor(_colorBloc.stream,
                  _selectedColor.stream, (data) => selectItem(data))
              : SliverPadding(padding: EdgeInsets.all(0.0));
        });
  }

  SliverToBoxAdapter _radioButtonWood() {
    return SliverToBoxAdapter(
        child: InkWell(
      onTap: () {
        _bloc.sink.add(list[2]);
        _colorBloc.sink.add(10);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: UIHelper.getCustomRadioButtonHorizontal(
            _bloc.stream, list[2], price[2],
            subtitle: subtitle[2]),
      ),
    ));
  }

  StreamBuilder<String> _colorGridTile() {
    return StreamBuilder<String>(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          return snapshot.data == list[1]
              ? UIHelper.getSliverGridColor(_colorBloc.stream,
                  _selectedColor.stream, (data) => selectItem(data))
              : SliverPadding(padding: EdgeInsets.all(0.0));
        });
  }

  InkWell _radioButtonTile() {
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

  InkWell _radioButtonCarbonFiber() {
    return InkWell(
      onTap: () => _bloc.sink.add(list[0]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: UIHelper.getCustomRadioButtonHorizontal(
            _bloc.stream, list[0], price[0],
            subtitle: subtitle[0]),
      ),
    );
  }

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  Positioned _bottomBar(DesignDataProvider designDataProvider) {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: BottomClipper(ButtonText.BACK, ButtonText.NEXT, () => goBack(),
            () => goNext(designDataProvider)));
  }

  Appbar _topBar() {
    return Appbar(
      ScreenTitle.KITCHEN_FLOOR_FINISHING,
      isDesignScreen: true,
    );
  }

  _startSpace(BuildContext context) {
    return UIHelper.getTopEmptyContainer(MediaQuery.of(context).size.height / 2, true);
  }

  goNext(DesignDataProvider designDataProvider) {
    if (_floorFinishingMaterial
            .compareTo(ListHelper.getFloorFinishingColorList()[0]) ==
        0) {
      designDataProvider.oceanBuilder.kitchenfloorFinishing =
          '$_floorFinishingMaterial';
    } else {
      designDataProvider.oceanBuilder.kitchenfloorFinishing =
          '$_floorFinishingMaterial,$_floorFinishingColor';
    }

    Navigator.of(context).pushNamed(WeatherStationScreen.routeName);
    // debugPrint(designDataProvider.oceanBuilder
    // .kitchenfloorFinishing
    // .toString());
  }

  goBack() {
    Navigator.pop(context);
  }

  selectItem(int data) {
    _selectedColor.sink.add(data);
  }
}
