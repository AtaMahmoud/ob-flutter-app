import 'package:ocean_builder/helper/api_base_helper.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

class EarthStationRepository{

  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Map<String,dynamic> _userCredentials = {
    "username": "abdullah@oceanbuilders.com",
    "password": "BNoM2k5idzcmHfgeIDHb"
    };

  Map<String,dynamic> _getRecordsParams = {
	"startDate": DateFormat('yyyy-MM-dd').format(new DateTime.now().subtract(Duration(days: 3))),//"2020-03-28",
	"endDate":DateFormat('yyyy-MM-dd').format(new DateTime.now()),
	"startTime":"00:00:00",
	"endTime":"23:59:59"
};  

}