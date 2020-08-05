import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/living_room_floor_finishing_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class MasterBedroomFloorFinishingScreen extends StatefulWidget {
  static const String routeName = '/masterBedroomFloorFinishing';

  @override
  _MasterBedroomFloorFinishingScreenState createState() =>
      _MasterBedroomFloorFinishingScreenState();
}

class _MasterBedroomFloorFinishingScreenState
    extends State<MasterBedroomFloorFinishingScreen> {
  List<String> list = ListHelper.getFloorFinishing();
  List<String> price = ListHelper.getFloorFinishPricing();
  List<String> subtitle = ListHelper.getFloorFinishSubTitle();
  GenericBloc<String> _bloc =
      GenericBloc(ListHelper.getFloorFinishingColorList()[0]);
  GenericBloc<int> _colorBloc = GenericBloc<int>(ListHelper.colorList()[0]);
  GenericBloc<int> _selectedColor = GenericBloc(ListHelper.colorList()[0]);

  String _floorFinishingColor; // = ListHelper.colorList()[0].toString();

  String
      _floorFinishingMaterial; // = ListHelper.getFloorFinishingColorList()[0];

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

    if (designDataProvider.oceanBuilder.masterBedroomfloorFinishing != null) {
      if (designDataProvider.oceanBuilder.masterBedroomfloorFinishing
              .compareTo(ListHelper.getFloorFinishingColorList()[0]) ==
          0) {
        _bloc.sink
            .add(designDataProvider.oceanBuilder.masterBedroomfloorFinishing);
        _floorFinishingMaterial =
            designDataProvider.oceanBuilder.masterBedroomfloorFinishing;
      } else {
        List<String> splits = designDataProvider
            .oceanBuilder.masterBedroomfloorFinishing
            .split(',');
        if (splits.length == 2) {
          // debugPrint('cached values '+ splits[0] + ' '+ splits[1]);
          _bloc.sink.add(splits[0]);
          _selectedColor.sink.add(int.parse(splits[1]));
          _floorFinishingMaterial = splits[0];
          _floorFinishingColor = splits[1];

          if (splits[0].contains(list[1])) {
            _colorBloc.sink.add(50);
          } else if (splits[0].contains(list[2])) {
            _colorBloc.sink.add(10);
          }
        }
      }
    }

    return Container(
      decoration: BoxDecoration(gradient: blueBackgroundGradient),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: [
                UIHelper.getTopEmptyContainer(
                    MediaQuery.of(context).size.height / 2, true),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 8.0),
                  sliver: SliverToBoxAdapter(
                      child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () => _bloc.sink.add(list[0]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: UIHelper.getCustomRadioButtonHorizontal(
                              _bloc.stream, list[0], price[0],
                              subtitle: subtitle[0]),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _bloc.sink.add(list[1]);
                          _colorBloc.sink.add(50);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: UIHelper.getCustomRadioButtonHorizontal(
                              _bloc.stream, list[1], price[1],
                              subtitle: subtitle[1]),
                        ),
                      )
                    ],
                  )),
                ),
                StreamBuilder<String>(
                    stream: _bloc.stream,
                    builder: (context, snapshot) {
                      return snapshot.data == list[1]
                          ? UIHelper.getSliverGridColor(_colorBloc.stream,
                              _selectedColor.stream, (data) => selectItem(data))
                          : SliverPadding(padding: EdgeInsets.all(0.0));
                    }),
                SliverToBoxAdapter(
                    child: InkWell(
                  onTap: () {
                    _bloc.sink.add(list[2]);
                    _colorBloc.sink.add(10);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: UIHelper.getCustomRadioButtonHorizontal(
                        _bloc.stream, list[2], price[2],
                        subtitle: subtitle[2]),
                  ),
                )),
                StreamBuilder<String>(
                    stream: _bloc.stream,
                    builder: (context, snapshot) {
                      return snapshot.data == list[2]
                          ? UIHelper.getSliverGridColor(_colorBloc.stream,
                              _selectedColor.stream, (data) => selectItem(data))
                          : SliverPadding(padding: EdgeInsets.all(0.0));
                    }),
                UIHelper.getTopEmptyContainer(90, false),
              ],
            ),
            Appbar(
              ScreenTitle.MASTER_BEDROOM_FLOOR_FINISHING,
              isDesignScreen: true,
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BottomClipper(ButtonText.BACK, ButtonText.NEXT,
                    () => goBack(), () => goNext(designDataProvider)))
          ],
        ),
      ),
    );
  }

  goNext(DesignDataProvider designDataProvider) {
    if (_floorFinishingMaterial
            .compareTo(ListHelper.getFloorFinishingColorList()[0]) ==
        0) {
      designDataProvider.oceanBuilder.masterBedroomfloorFinishing =
          '$_floorFinishingMaterial';
    } else {
      designDataProvider.oceanBuilder.masterBedroomfloorFinishing =
          '$_floorFinishingMaterial,$_floorFinishingColor';
    }

    Navigator.of(context).pushNamed(LivingRoomFloorFinishingScreen.routeName);
    // debugPrint(designDataProvider.oceanBuilder.masterBedroomfloorFinishing.toString());
  }

  goBack() {
    Navigator.pop(context);
  }

  selectItem(int data) {
    _selectedColor.sink.add(data);
  }
}
