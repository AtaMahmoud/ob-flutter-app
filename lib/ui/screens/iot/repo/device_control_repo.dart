import 'package:ocean_builder/ui/screens/iot/model/light.dart';

abstract class DeviceControlRepo {
  getLights();
  getLightById(int id);
  addLight(Light light);
  updateLight(Light light);
  deleteLight(int id);
}
