import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/sound_system_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class UnderwaterWindowsScreen extends StatefulWidget {
  static const String routeName = '/underwaterWindows';

  @override
  _UnderwaterWindowsScreenState createState() =>
      _UnderwaterWindowsScreenState();
}

class _UnderwaterWindowsScreenState extends State<UnderwaterWindowsScreen> {
  List<String> list = ListHelper.getUnderwaterWindowsList();
  List<String> price = ListHelper.getUnderWaterWindowsPricingList();
  GenericBloc<String> _bloc =
      GenericBloc(ListHelper.getUnderwaterWindowsList()[0]);

  String _underWaterWindows = ListHelper.getUnderwaterWindowsList()[0];

  @override
  void initState() {
    super.initState();
    _bloc.controller.add(ListHelper.getUnderwaterWindowsList()[0]);
    _bloc.controller.listen((onData) {
      _underWaterWindows = onData;
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

    if (designDataProvider.oceanBuilder.underWaterWindows != null) {
      _bloc.sink.add(designDataProvider.oceanBuilder.underWaterWindows);
      _underWaterWindows = designDataProvider.oceanBuilder.underWaterWindows;
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
                SliverPadding(
                  padding: const EdgeInsets.only(top: 8.0),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return InkWell(
                      onTap: () => _bloc.sink.add(list[index]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: UIHelper.getCustomRadioButtonHorizontal(
                            _bloc.stream, list[index], price[index]),
                      ),
                    );
                  }, childCount: list.length)),
                ),
                UIHelper.getTopEmptyContainer(90, false),
              ],
            ),
            Appbar(
              ScreenTitle.UNDERWATER_WINDOWS,
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
    designDataProvider.oceanBuilder.underWaterWindows = _underWaterWindows;
    if (designDataProvider.oceanBuilder.underWaterWindows == null) {
      designDataProvider.oceanBuilder.underWaterWindows = "";
    }
    Navigator.of(context).pushNamed(SoundSystemScreen.routeName);
    // debugPrint(designDataProvider.oceanBuilder.underWaterWindows.toString());
  }

  goBack() {
    Navigator.pop(context);
  }
}
