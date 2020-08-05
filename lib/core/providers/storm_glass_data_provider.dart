import 'package:flutter/foundation.dart';
import 'package:ocean_builder/core/models/storm_glass_data.dart';
import 'package:ocean_builder/core/repositories/storm_glass_repository.dart';

class StormGlassDataProvider extends ChangeNotifier {
  StormGlassRepository _stormGlassRepository = StormGlassRepository();

  StormGlassData _weatherData;
  StormGlassData get weatherData => _weatherData;

  TideData _tideData;
  TideData get tideData => _tideData;

  UvIndexData _uvIndexData;
  UvIndexData get uvIndexData => _uvIndexData;

  // Future<void> getWeatherData() async {
  //   notifyListeners();

  //   try {
  //     final StormGlassData weatherData =
  //         await _stormGlassRepository.getWeatherData();
  //     _weatherData = weatherData;
  //     notifyListeners();
  //   } catch (e) {
  //     print(e.toString());
  //     notifyListeners();
  //   }
  // }
  Future<StormGlassData> fetchWeatherData() async {
    notifyListeners();
    try {
      final StormGlassData weatherData =
          await _stormGlassRepository.getWeatherData();
      _weatherData = weatherData;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return weatherData;
  }

  Future<TideData> fetchTideData() async {
    notifyListeners();
    try {
      final TideData tideData = await _stormGlassRepository.getTideData();
      _tideData = tideData;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return tideData;
  }

  Future<StormGlassData> fetchTodayWeatherData() async {
    notifyListeners();
    try {
      final StormGlassData weatherData =
          await _stormGlassRepository.getTodayWeatherData();
      _weatherData = weatherData;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return weatherData;
  }

  Future<StormGlassData> fetchNext7DaysWeatherData() async {
    notifyListeners();
    try {
      final StormGlassData weatherData =
          await _stormGlassRepository.getNext7DaysWeatherData();
      _weatherData = weatherData;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return weatherData;
  }

  Future<UvIndexData> fetchUvIndexData() async {
    notifyListeners();
    try {
      final UvIndexData uvIndexData =
          await _stormGlassRepository.getUvIndexWeatherData();
      _uvIndexData = uvIndexData;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return uvIndexData;
  }
}
