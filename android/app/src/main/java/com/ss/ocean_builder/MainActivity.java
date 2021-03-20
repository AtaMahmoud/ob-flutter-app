package com.ss.ocean_builder;
import io.flutter.embedding.android.FlutterActivity;
import android.content.ContentResolver;
import android.content.Context;
import android.media.RingtoneManager;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.util.*;

public class MainActivity extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),"ob.dev/ocean_builder").setMethodCallHandler(
           (call, result) -> {
               if("drawableToUri" == call.method){
                    int resourceId = this.getResources().getIdentifier(call.arguments.toString(),"drawable",this.getPackageName());
                    result.success(resourceToUriString(this,resourceId));
               }
               if("getAlarmUri" ==  call.method){
                   result.success(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM).toString());
               }
               if("getTimeZone" == call.method){
                   result.success(TimeZone.getDefault().getID());
               }
           }
        );
    }

    private String resourceToUriString(Context context, int resId){
        return (ContentResolver.SCHEME_ANDROID_RESOURCE + "://"
                + context.getResources().getResourcePackageName(resId)
                + "/"
                + context.getResources().getResourceTypeName(resId)
                + "/"
                + context.getResources().getResourceEntryName(resId));
    }
}
