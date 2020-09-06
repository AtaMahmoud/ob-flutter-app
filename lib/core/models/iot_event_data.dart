class IotEventData{
  
/*
        "EventID": 1,
        "Temperature": "68.45",
        "TimeStamp": "2020-08-29T12:17:14.000Z"
*/

  int eventID;
  String temperature;
  String tiemStamp;


  IotEventData({this.eventID,this.temperature,this.tiemStamp});

  factory IotEventData.fromJson(Map<String,dynamic> json){

    return IotEventData(
      eventID: json['EventID'],
      temperature: json['Temperature'],
      tiemStamp: json['TimeStamp'],
    );

  }

}