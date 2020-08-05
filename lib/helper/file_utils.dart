import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ocean_builder/ui/shared/shared_pref_data.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File>  localFile(String filenameWithExt) async {
    final path = await _localPath;
    return File('$path/$filenameWithExt');
  }

  static removeProfilePicture() async {
    
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String path = prefs.getString(SharedPreferanceKeys.KEY_PROFILE_PIC);

    String path =  await SharedPrefHelper.getProfilePicFilePath();

    if(path!=null){
    final File imageFile = File(path);
    if (await imageFile.exists()) {
      // Use the cached images if it exists
      imageFile.deleteSync(recursive: true);
    }

    }


  }

}
