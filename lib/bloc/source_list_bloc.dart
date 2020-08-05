import 'package:ocean_builder/mixins/validator.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class SourceListBloc extends Object with Validator implements BlocBase {
  
  var marineSourceController = BehaviorSubject<String>();

  var weatherSourceController = BehaviorSubject<String>();

  var humiditySourceController = BehaviorSubject<String>();

  var solarRadiationSourceController = BehaviorSubject<String>();

  var uvRadiationSourceController = BehaviorSubject<String>();

  var windSpeedSourceController = BehaviorSubject<String>();

  var windGustsSourceController = BehaviorSubject<String>();

  var windDirectionSourceController = BehaviorSubject<String>();

  var bpuSourceController = BehaviorSubject<String>();

  var temperatureSourceController = BehaviorSubject<String>();

  Observable<String> get temperatureSource =>
      temperatureSourceController.stream.transform(stringNonNullValidator);

  Function(String) get temperatureSourceChanged =>
      temperatureSourceController.sink.add;

  Observable<String> get bpuSource =>
      bpuSourceController.stream.transform(stringNonNullValidator);

  Function(String) get bpuSourceChanged => bpuSourceController.sink.add;

  Observable<String> get windDirectionSource =>
      windDirectionSourceController.stream.transform(stringNonNullValidator);

  Function(String) get windDirectionSourceChanged =>
      windDirectionSourceController.sink.add;

  Observable<String> get windGustsSource =>
      windGustsSourceController.stream.transform(stringNonNullValidator);

  Function(String) get windGustsSourceChanged =>
      windGustsSourceController.sink.add;

  Observable<String> get windSpeedSource =>
      windSpeedSourceController.stream.transform(stringNonNullValidator);

  Function(String) get windSpeedSourceChanged =>
      windSpeedSourceController.sink.add;

  Observable<String> get uvRadiationSource =>
      uvRadiationSourceController.stream.transform(stringNonNullValidator);

  Function(String) get uvRadiationSourceChanged =>
      uvRadiationSourceController.sink.add;

  Observable<String> get solarRadiationSource =>
      solarRadiationSourceController.stream.transform(stringNonNullValidator);

  Function(String) get solarRadiationSourceChanged =>
      solarRadiationSourceController.sink.add;

  Observable<String> get humiditySource =>
      humiditySourceController.stream.transform(stringNonNullValidator);

  Function(String) get humiditySourceChanged =>
      humiditySourceController.sink.add;

  Observable<String> get weatherSource =>
      weatherSourceController.stream.transform(stringNonNullValidator);

  Function(String) get weatherSourceChanged => weatherSourceController.sink.add;

  Observable<String> get marineSource =>
      marineSourceController.stream.transform(stringNonNullValidator);

  Function(String) get marineSourceChanged => marineSourceController.sink.add;

  @override
  void dispose() {
    weatherSourceController.close();
    marineSourceController.close();
    humiditySourceController.close();
    solarRadiationSourceController.close();
    uvRadiationSourceController.close();
    windSpeedSourceController.close();
    windGustsSourceController.close();
    windDirectionSourceController.close();
    bpuSourceController.close();
    temperatureSourceController.close();
  }
}
