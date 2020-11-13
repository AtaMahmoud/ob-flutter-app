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
         "topic": "test/message",
        "Temperature": 45.1,
        "TimeStamp": "2020-10-13T20:22:47.000Z"
    }
        "EventID": 5,
        "topic": "test/message",
        "value": "1",
        "TimeStamp": "2020-11-06T10:39:45.000Z"
]
*/

  int eventID;
  String value;
  String topic;
  String tiemStamp;


  IotEventData({this.eventID,this.value,this.topic,this.tiemStamp});

  factory IotEventData.fromJson(Map<String,dynamic> json){

    return IotEventData(
      eventID: json['EventID'],
      value: json['value'],
      topic: json['topic'],
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