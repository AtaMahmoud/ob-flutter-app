import 'package:flutter/material.dart';

class EsRecord{

  List<EsBluePrint> blueprints;
  List<EsData> data;

  EsRecord({this.blueprints,this.data});

  factory EsRecord.fromJson(Map<String, dynamic> json){
  List<EsBluePrint> esBluePrintList = [];
  var _bluePrintJson = json['blueprints'];
  var dataList = [];
  var list = json['data'] as List;
  if(list!=null && list.length > 1)
  {
     dataList = list.map((f)=>EsData.fromJson(f)).toList();
  }

  _bluePrintJson.forEach((k,v) => esBluePrintList.add(EsBluePrint.fromJson(v)));

  return EsRecord(
    blueprints: esBluePrintList,
    data: dataList
  );
}

}

class EsBluePrint{
  String id;
  String name;
  bool mandatory;
  String frequency;
  String icon;

  EsBluePrint({this.id,this.name,this.mandatory,this.frequency,this.icon});

  factory EsBluePrint.fromJson(Map<String,dynamic> json){
    return EsBluePrint(
      id: json['id'],
      name: json['name'],
      mandatory: json['mandatory'],
      frequency: json['frequency'],
      icon: json['icon']
    );
  }
}

class EsData{
  
  String date;
  String time;
  String blueprintID;
  String value;

  EsData({this.date,this.time,this.blueprintID,this.value});

  factory EsData.fromJson(Map<String,dynamic> json){

    return EsData(
      date: json['date'],
      time: json['time'],
      blueprintID: json['blueprintID'],
      value: json['value']
    );

  }

}