import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/spar_finishing_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class ExteriorColorScreen extends StatefulWidget {
  static const String routeName = '/exteriorColor';

  @override
  _ExteriorColorScreenState createState() => _ExteriorColorScreenState();
}

class _ExteriorColorScreenState extends State<ExteriorColorScreen> {
  List<String> list = ListHelper.getExteriorColorList();

  GenericBloc<String> _bloc = GenericBloc(ListHelper.getExteriorColorList()[0]);
  GenericBloc<int> _colorCountBloc = GenericBloc(8);
  GenericBloc<int> _selectedColor = GenericBloc(ListHelper.colorList()[0]);

  String _exteriorColor = ListHelper.getExteriorColorList()[0];
  String _exteriorColorCustom = ListHelper.colorList()[0].toString();

  @override
  void initState() {
    super.initState();
    _selectedColor.controller.listen((onData) {
      Color color = new Color(onData);
      String valueString = color.toString().split('(')[1].split(')')[0];
      _exteriorColorCustom = valueString;
    });
    _bloc.controller.listen((onData) {
      _exteriorColor = onData;
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    _colorCountBloc.dispose();
    _selectedColor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    final DesignDataProvider designDataProvider =
        Provider.of<DesignDataProvider>(context);

    if (designDataProvider.oceanBuilder.exteriorColor != null) {
      if (designDataProvider.oceanBuilder.exteriorColor
              .compareTo(ListHelper.getExteriorColorList()[0]) ==
          0)
        _bloc.sink.add(designDataProvider.oceanBuilder.exteriorColor);
      else {
        _bloc.sink.add(list[1]);
        _selectedColor.sink
            .add(int.parse(designDataProvider.oceanBuilder.exteriorColor));
      }
    }

    // var _util = ScreenUtil();

    return Container(
      decoration: BoxDecoration(gradient: blueBackgroundGradient),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: [
                UIHelper.getTopEmptyContainer(
                    MediaQuery.of(context).size.height / 4, false),
                SliverToBoxAdapter(
                    child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () => _bloc.sink.add(list[0]),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                ImagePaths.defaultIcon,
                                width:380.w,
                                height:380.w,
                              ),
                              SizedBox(height: 16.0),
                              UIHelper.getCustomRadioButtonVertical(
                                  _bloc.stream, list[0])
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => _bloc.sink.add(list[1]),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                ImagePaths.defaultIcon,
                                width: 380.w,
                                height: 380.w,
                              ),
                              SizedBox(height: 16.0),
                              UIHelper.getCustomRadioButtonVertical(
                                  _bloc.stream, list[1])
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
                StreamBuilder<String>(
                    stream: _bloc.stream,
                    builder: (context, snapshot) {
                      return snapshot.data ==
                              ListHelper.getExteriorColorList()[1]
                          ? UIHelper.getSliverGridColor(_colorCountBloc.stream,
                              _selectedColor.stream, (data) => selectItem(data))
                          : SliverPadding(padding: EdgeInsets.all(0.0));
                    }),
                StreamBuilder<String>(
                    stream: _bloc.stream,
                    builder: (context, snapshot) {
                      return StreamBuilder<int>(
                          stream: _colorCountBloc.stream,
                          builder: (context, snap) {
                            return SliverToBoxAdapter(
                              child: snapshot.data ==
                                          ListHelper.getExteriorColorList()[
                                              1] &&
                                      snap.data == 8
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  _colorCountBloc.sink.add(50),
                                              child: Text(
                                                ButtonText.SHOW_MORE_COLORS,
                                                style: TextStyle(
                                                    color: ColorConstants
                                                        .TOP_CLIPPER_END),
                                              ))
                                        ],
                                      ),
                                    )
                                  : Container(),
                            );
                          });
                    }
                    ),
                _endSpace(),
              ],
            ),
            _topBar(),
            _bottomBar(designDataProvider)
          ],
        ),
      ),
    );
  }

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  Positioned _bottomBar(DesignDataProvider designDataProvider) {
    return Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomClipper(ButtonText.BACK, ButtonText.NEXT,
                  () => goBack(), () => goNext(designDataProvider)));
  }

  Appbar _topBar() {
    return Appbar(
            ScreenTitle.EXTERIOR_COLOR,
            isDesignScreen: true,
          );
  }

  goNext(DesignDataProvider designDataProvider) {
    if (_exteriorColor.compareTo(ListHelper.getExteriorColorList()[0]) == 0) {
      _exteriorColor = '0xFFFFFFF0';
      designDataProvider.oceanBuilder.exteriorColor = _exteriorColor;
    } else {
      designDataProvider.oceanBuilder.exteriorColor = _exteriorColorCustom;
    }

    Navigator.of(context).pushNamed(SparFinishingScreen.routeName);
    // debugPrint(designDataProvider.oceanBuilder.exteriorColor.toString());
  }

  goBack() {
    Navigator.pop(context);
  }

  selectItem(int data) {
    _selectedColor.sink.add(data);
  }
}
