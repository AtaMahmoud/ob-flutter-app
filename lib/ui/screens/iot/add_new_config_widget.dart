import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/bloc/smart_home_config_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';

class AddMqttConfig extends StatefulWidget {
  AddMqttConfig({Key key}) : super(key: key);

  @override
  _AddMqttConfigState createState() => _AddMqttConfigState();
}

class _AddMqttConfigState extends State<AddMqttConfig> {
  SmartHomeConfigBloc _blocSmartHomeConfig;

  TextEditingController _mqttServerController;

  FocusNode _mqttServerNode;

  @override
  void initState() {
    super.initState();
    _blocSmartHomeConfig = SmartHomeConfigBloc();
    _mqttServerController = TextEditingController();
    _mqttServerNode = FocusNode();
  }

  @override
  void dispose() {
    _blocSmartHomeConfig.dispose();
    _mqttServerController.dispose();
    _mqttServerNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        UIHelper.getRegistrationTextField(
            context,
            _blocSmartHomeConfig.mqttServer,
            _blocSmartHomeConfig.mqttServerChanged,
            TextFieldHints.MQTT_SERVER,
            _mqttServerController,
            InputTypes.TEXT,
            null,
            false,
            TextInputAction.done,
            _mqttServerNode,
            null),
        Row(
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                color: ColorConstants.TOP_CLIPPER_END_DARK,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: MaterialButton(
                color: ColorConstants.TOP_CLIPPER_END_DARK,
                child: Text(
                  "Reset",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              ),
            ),
          ],
        )
      ],
    );
  }
}
