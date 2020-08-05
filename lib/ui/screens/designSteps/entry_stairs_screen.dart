import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/fathometer_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class EntryStairsScreen extends StatefulWidget {
  static const String routeName = '/entryStairs';

  @override
  _EntryStairsScreenState createState() => _EntryStairsScreenState();
}

class _EntryStairsScreenState extends State<EntryStairsScreen> {
  List<String> list = ListHelper.getEntryStairsList();
  List<String> price = ListHelper.getEntryStairsPricingList();
  GenericBloc<String> _bloc = GenericBloc(ListHelper.getEntryStairsList()[0]);

  String _entryStairs = ListHelper.getEntryStairsList()[0];

  @override
  void initState() {
    super.initState();
    _bloc.controller.listen((onData) {
      _entryStairs = onData;
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

    if (designDataProvider.oceanBuilder.entryStairs != null) {
      _bloc.sink.add(designDataProvider.oceanBuilder.entryStairs);
      _entryStairs = designDataProvider.oceanBuilder.entryStairs;
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
              ScreenTitle.ENTRY_STAIRS,
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
    designDataProvider.oceanBuilder.entryStairs = _entryStairs;
    Navigator.of(context).pushNamed(FathometerScreen.routeName);
    // debugPrint(designDataProvider.oceanBuilder.entryStairs.toString());
  }

  goBack() {
    Navigator.pop(context);
  }
}
