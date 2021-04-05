import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/es_record.dart';
import 'package:ocean_builder/core/providers/earth_station_data_provider.dart';
import 'package:provider/provider.dart';

class EarthStationScreen extends StatefulWidget {
  static const String routeName = '/earthStationData';
  EarthStationScreen({Key key}) : super(key: key);

  @override
  _EarthStationScreenState createState() => _EarthStationScreenState();
}

class _EarthStationScreenState extends State<EarthStationScreen> {
  EarthStationDataProvider _earthStationDataProvider;

  Future<EsRecord> _futureEsRecordData;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _earthStationDataProvider =
          Provider.of<EarthStationDataProvider>(context);
      _earthStationDataProvider.logIn().then((response) {
        if (response.status == 200) {
          _futureEsRecordData = _earthStationDataProvider.getRecords();
        } else {
          // debugPrint('login failied  ${response.message}');
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(child: _futureEarthStationData()),
      ),
    );
  }

  _futureEarthStationData() {
    return FutureBuilder(
        future: _futureEsRecordData,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _esRecordTable(snapshot.data)
              : Container(
                  child: CircularProgressIndicator(),
                );
        });
  }

  _esRecordTable(EsRecord esRecord) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              top: ScreenUtil().statusBarHeight + ScreenUtil().setHeight(16),
              bottom: ScreenUtil().setHeight(16)),
          color: ColorConstants.TOP_CLIPPER_START,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '${esRecord.blueprints[0].name}'.toUpperCase(),
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(64),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(16)),
                child: Container(
                  color: ColorConstants.TOP_CLIPPER_END_DARK,
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(16),
                      bottom: ScreenUtil().setHeight(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '      DateTime',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(48),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      Text(
                        '    Value',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(48),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          // flex: 9,
          child: Container(
              color: Colors.white,
              child: ListView.builder(
                  itemCount: esRecord.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                        child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            '${esRecord.data[index].date} ${esRecord.data[index].time}',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(48),
                                fontStyle: FontStyle.normal,
                                color: Colors.black),
                          ),
                          Text(
                            '${esRecord.data[index].value}',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(48),
                                fontStyle: FontStyle.normal,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ));
                  })),
        ),
      ],
    );
  }
}
