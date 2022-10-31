package com.bvidya;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.example.bvidya.MainActivity2;

import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterView;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    String CHANNEL = "test_activity";
    String Channal1 = "Lockscreen flag";


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        Window window = this.getWindow();
        window.addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            String rtmchannalname = call.argument("rtcchannal");
                            String rtmtoken = call.argument("rtctoken");
                            String screen = call.argument("stop");
                            Log.d("resdfd",rtmchannalname+"_____"+rtmtoken);
                            Intent i = new Intent(getApplicationContext(), MainActivity2.class);
                            i.putExtra("rtcchannal",rtmchannalname);
                            i.putExtra("rtctoken",rtmtoken);
                            i.putExtra("stop",screen);
                            startActivity(i);
                        }
                );
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), Channal1)
                .setMethodCallHandler(
                        (call, result) -> {
                            String flag = call.argument("flag");
                            Log.e("basu", "call");
                            if(flag.equals("on")) {
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
                                    setShowWhenLocked(true);
                                    setTurnScreenOn(true);
                                } else {
                                    window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
                                }
                                //window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
                            }else if (flag.equals("off")){
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
                                    setShowWhenLocked(false);
                                    setTurnScreenOn(false);
                                } else {
                                    window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
                                }
                              //  window.clearFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
                            }

                        }
                );

    }

}
