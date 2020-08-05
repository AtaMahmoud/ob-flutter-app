import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/entry_stairs_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class WeatherStationScreen extends StatefulWidget {
  static const String routeName = '/weatherStation';

  @override
  _WeatherStationScreenState createState() => _WeatherStationScreenState();
}

class _WeatherStationScreenState extends State<WeatherStationScreen> {
  List<String> selectedList = List();

  List<String> list = ListHelper.getWeatherStationList();
  List<String> price = ListHelper.getWeatherStationPricingList();
  GenericBloc<List<String>> _bloc = GenericBloc(null);

  List<String> _weatherStations = [];

  @override
  void initState() {
    super.initState();
    _bloc.controller.listen((onData) {
      _weatherStations = onData;
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;

    final DesignDataProvider designDataProvider =
        Provider.of<DesignDataProvider>(context);

    if (designDataProvider.oceanBuilder.weatherStation != null) {
      _bloc.sink.add(designDataProvider.oceanBuilder.weatherStation);
      _weatherStations = designDataProvider.oceanBuilder.weatherStation;
    }

    return Container(
      decoration: BoxDecoration(gradient: blueBackgroundGradient),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                UIHelper.getTopEmptyContainer(
                    MediaQuery.of(context).size.height / 2, true),
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  return InkWell(
                    onTap: () => selectItem(list[index]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 32.0),
                      child: UIHelper.getCustomCheckbox(
                          _bloc.stream, list[index], price[index],
                          isVertical: true),
                    ),
                  );
                }, childCount: list.length)),
                UIHelper.getTopEmptyContainer(90, false),
              ],
            ),
            Appbar(
              ScreenTitle.WEATHER_STATION,
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
    designDataProvider.oceanBuilder.weatherStation = _weatherStations;
    if (designDataProvider.oceanBuilder.weatherStation == null) {
      designDataProvider.oceanBuilder.weatherStation = [];
    }
    Navigator.of(context).pushNamed(EntryStairsScreen.routeName);
    // debugPrint(designDataProvider.oceanBuilder.weatherStation.toString());
  }

  goBack() {
    Navigator.pop(context);
  }

  selectItem(String data) {
    selectedList.contains(data)
        ? selectedList.remove(data)
        : selectedList.add(data);
    _bloc.sink.add(selectedList);
  }
}
