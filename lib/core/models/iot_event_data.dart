class IotEventData{
  
/*
[
    {
        "EventID": 1,
        "Temperature": 65.2,
        "TimeStamp": "2020-10-13T20:22:47.000Z"
    },
    {
        "EventID": 2,
        "Temperature": 45.1,
        "TimeStamp": "2020-10-13T20:22:47.000Z"
    }
]
*/

  int eventID;
  double temperature;
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

class IotTopic{
  String topic;
  IotTopic({this.topic});

  factory IotTopic.fromJson(Map<String,dynamic> json){

    return IotTopic(
      topic: json['topic']
    );
  }
}