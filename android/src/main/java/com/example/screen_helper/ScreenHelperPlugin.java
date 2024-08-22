package com.example.screen_helper;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import android.app.Activity;
import android.content.Context;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/** ScreenHelperPlugin */
public class ScreenHelperPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private Activity activity;
  private ScreenSizeHelper screenSizeHelper;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "screen_helper");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    screenSizeHelper = new ScreenSizeHelper(activity);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    activity = null;
    screenSizeHelper = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    screenSizeHelper = new ScreenSizeHelper(activity);
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
    screenSizeHelper = null;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (screenSizeHelper == null) {
      result.error("Activity not attached", "ScreenSizeHelper is not initialized", null);
      return;
    }

    switch (call.method) {
      case "getScreenSizeInInches":
        result.success(screenSizeHelper.getScreenSizeInInches());
        break;
      case "getScreenResolution":
        result.success(screenSizeHelper.screenSizeInPixels());
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}