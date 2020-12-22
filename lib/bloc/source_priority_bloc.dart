import 'package:ocean_builder/mixins/validator.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class SourcePriorityBloc extends Object with Validator implements BlocBase {
  var priorityController = BehaviorSubject<String>();

  Observable<String> get topProprity => priorityController.stream;

  Function(String) get topProprityChanged => priorityController.sink.add;

  SourcePriorityBloc(data) {
    priorityController.sink.add(data);
  }

  @override
  void dispose() {
    priorityController.close();
  }
}
