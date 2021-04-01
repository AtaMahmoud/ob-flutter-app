import 'package:ocean_builder/mixins/validator.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class IotTopicBloc extends Object
    implements BlocBase {

  var topicController = BehaviorSubject<String>();

  Stream<String> get selectedTopic =>
      topicController.stream;

  Function(String) get selectedTopicChanged =>
      topicController.sink.add;


  @override
  void dispose() {
    topicController.close();
  }
}