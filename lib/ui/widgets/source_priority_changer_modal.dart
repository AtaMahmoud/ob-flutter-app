import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/source_priority_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

class SourcePrioritySelectorModal extends StatefulWidget {
  final SourcePriorityBloc sourcePriorityBloc;
  SourcePrioritySelectorModal(this.sourcePriorityBloc, {Key key})
      : super(key: key);

  @override
  _SourcePrioritySelectorModalState createState() =>
      _SourcePrioritySelectorModalState();
}

class _SourcePrioritySelectorModalState
    extends State<SourcePrioritySelectorModal> {
  bool _seaPodSceneChanged;

  List<String> _weatherSourceRows = [];

  ScreenUtil _util = ScreenUtil();

  @override
  void initState() {
    super.initState();
    if (ApplicationStatics.selectedWeatherProvider
            .compareTo(ListHelper.getSourceList()[1]) ==
        0) {
      _weatherSourceRows.add(WEATEHR_SOURCE_LIST[0]);
      _weatherSourceRows.add(WEATEHR_SOURCE_LIST[1]);
    } else {
      _weatherSourceRows.add(WEATEHR_SOURCE_LIST[1]);
      _weatherSourceRows.add(WEATEHR_SOURCE_LIST[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          Positioned(
              top: 32.h,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                height: 800.h,
              )),
          CustomScrollView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            slivers: <Widget>[
              UIHelper.getTopEmptyContainerWithColor(
                  _util.setHeight(150), Colors.white),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32.h),
                  child: Text(
                    'Please move to the top your favourite weather data provider',
                    style: TextStyle(
                        color: ColorConstants.WEATHER_BKG_CIRCLE,
                        fontSize: 48.sp),
                  ),
                ),
              ),
              _reorderableContent()
            ],
          ),
          Positioned(
            top: 32.h,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              // padding: EdgeInsets.only(top: 8.0, right: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          left: _util.setWidth(48),
                          top: _util.setHeight(32),
                          bottom: _util.setHeight(32),
                        ),
                        child: Text(
                          'WEATHER PROVIDER PRIORITY',
                          style: TextStyle(
                              color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                              fontWeight: FontWeight.normal,
                              fontSize: 48.sp),
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          if (!Provider.of<UserProvider>(context).isLoading)
                            Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: _util.setWidth(48),
                            top: _util.setHeight(32),
                            bottom: _util.setHeight(32),
                          ),
                          child: Image.asset(
                            ImagePaths.cross,
                            width: _util.setWidth(48),
                            height: _util.setHeight(48),
                            color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSeaPodScenesReorder(int oldIndex, int newIndex) {
    setState(() {
      String row = _weatherSourceRows.removeAt(oldIndex);
      _weatherSourceRows.insert(newIndex, row);
      _seaPodSceneChanged = true;
      if (_weatherSourceRows[0].compareTo('LOCAL (WEATHERFLOW STATION)') == 0) {
        Provider.of<UserProvider>(context)
            .setWeatherSource('local')
            .then((response) {
          if (response.status == 200) {
            widget.sourcePriorityBloc
                .topProprityChanged(ListHelper.getSourceList()[1]);
            ApplicationStatics.selectedWeatherProvider =
                ListHelper.getSourceList()[1];
            Provider.of<UserProvider>(context)
                .authenticatedUser
                .selectedWeatherSource = 'local';
          }
        });
      } else {
        Provider.of<UserProvider>(context)
            .setWeatherSource('external')
            .then((response) {
          if (response.status == 200) {
            widget.sourcePriorityBloc
                .topProprityChanged(ListHelper.getSourceList()[0]);
            ApplicationStatics.selectedWeatherProvider =
                ListHelper.getSourceList()[1];
            Provider.of<UserProvider>(context)
                .authenticatedUser
                .selectedWeatherSource = 'external';
          }
        });
      }
    });
  }

  _reorderableContent() {
    return ReorderableSliverList(
      delegate: ReorderableSliverChildBuilderDelegate(
          (BuildContext context, int index) => Align(
                alignment: Alignment.center,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                  child: _rowItem(index),
                ),
              ),
          childCount: _weatherSourceRows
              .length //ListHelper.getlightSceneList().length//
          ),
      onReorder: _onSeaPodScenesReorder,
    );
  }

  _rowItem(int index) {
    // return _rows[index];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          (index + 1).toString(),
          style: TextStyle(
              fontSize: 38.sp, color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
        ),
        SizedBox(
          width: 16.w,
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(right: 32.w),
                padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.w),
                    border:
                        Border.all(color: ColorConstants.TOP_CLIPPER_END_DARK)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 32.w),
                      child: Image.asset(
                        ImagePaths.icVerticalDots,
                        color: ColorConstants.LIGHTING_CHIP_LABEL,
                      ),
                    ),
                    SizedBox(
                      width: 32.w,
                    ),
                    Text(
                      _weatherSourceRows[index],
                      style: TextStyle(
                          fontSize: 38.sp,
                          color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
