package com.example.screen_helper;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import org.junit.Test;

public class ScreenHelperPluginTest {
  @Test
  public void reportsAnErrorWithoutAnActivity() {
    ScreenHelperPlugin plugin = new ScreenHelperPlugin();
    MethodChannel.Result result = mock(MethodChannel.Result.class);
    plugin.onMethodCall(new MethodCall("getScreenResolution", null), result);
    verify(result).error("Activity not attached", "ScreenSizeHelper is not initialized", null);
  }
}
