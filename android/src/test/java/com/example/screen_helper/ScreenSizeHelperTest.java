package com.example.screen_helper;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockConstruction;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.app.Activity;
import android.content.res.Resources;
import android.graphics.Rect;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.WindowManager;
import android.view.WindowMetrics;
import org.junit.Before;
import org.junit.Test;
import org.mockito.MockedConstruction;

public class ScreenSizeHelperTest {
  private Activity activity;
  private WindowManager windowManager;
  private DisplayMetrics density;

  @Before
  public void setUp() {
    activity = mock(Activity.class);
    windowManager = mock(WindowManager.class);
    Resources resources = mock(Resources.class);
    density = mock(DisplayMetrics.class);
    density.xdpi = 300;
    density.ydpi = 300;
    when(activity.getWindowManager()).thenReturn(windowManager);
    when(activity.getResources()).thenReturn(resources);
    when(resources.getDisplayMetrics()).thenReturn(density);
  }

  private Rect modernBounds() {
    WindowMetrics windowMetrics = mock(WindowMetrics.class);
    Rect bounds = mock(Rect.class);
    when(windowManager.getCurrentWindowMetrics()).thenReturn(windowMetrics);
    when(windowMetrics.getBounds()).thenReturn(bounds);
    when(bounds.width()).thenReturn(900);
    when(bounds.height()).thenReturn(1200);
    return bounds;
  }

  @Test
  public void refreshesWindowDimensionsAndDensityOnEveryRequest() {
    Rect bounds = modernBounds();
    ScreenSizeHelper helper = new ScreenSizeHelper(activity, 30);
    try (MockedConstruction<DisplayMetrics> ignored = mockConstruction(DisplayMetrics.class)) {
      assertEquals(900.0, helper.screenSizeInPixels().get("width"), 0.0);
      assertEquals(3.0, helper.getScreenSizeInInches().get("width"), 0.0);
      when(bounds.width()).thenReturn(1200);
      when(bounds.height()).thenReturn(900);
      density.xdpi = 400;
      density.ydpi = 450;
      assertEquals(1200.0, helper.screenSizeInPixels().get("width"), 0.0);
      assertEquals(3.0, helper.getScreenSizeInInches().get("width"), 0.0);
      assertEquals(2.0, helper.getScreenSizeInInches().get("height"), 0.0);
      verify(windowManager, times(5)).getCurrentWindowMetrics();
    }
  }

  @SuppressWarnings("deprecation")
  @Test
  public void refreshesLegacyDisplayMetrics() {
    Display display = mock(Display.class);
    when(windowManager.getDefaultDisplay()).thenReturn(display);
    int[] dimensions = {900, 1200};
    doAnswer(invocation -> {
      DisplayMetrics metrics = invocation.getArgument(0);
      metrics.widthPixels = dimensions[0];
      metrics.heightPixels = dimensions[1];
      return null;
    }).when(display).getRealMetrics(any(DisplayMetrics.class));
    ScreenSizeHelper helper = new ScreenSizeHelper(activity, 29);
    try (MockedConstruction<DisplayMetrics> ignored = mockConstruction(DisplayMetrics.class)) {
      assertEquals(900.0, helper.screenSizeInPixels().get("width"), 0.0);
      dimensions[0] = 1200;
      dimensions[1] = 900;
      assertEquals(1200.0, helper.screenSizeInPixels().get("width"), 0.0);
      assertEquals(3.0, helper.getScreenSizeInInches().get("height"), 0.0);
    }
  }

  @Test
  public void invalidDensityMakesPhysicalDimensionsUnavailable() {
    modernBounds();
    ScreenSizeHelper helper = new ScreenSizeHelper(activity, 30);
    try (MockedConstruction<DisplayMetrics> ignored = mockConstruction(DisplayMetrics.class)) {
      for (float value : new float[] {0, -1, Float.NaN, Float.POSITIVE_INFINITY}) {
        density.xdpi = value;
        assertNull(helper.getScreenSizeInInches());
        assertEquals(900.0, helper.screenSizeInPixels().get("width"), 0.0);
      }
    }
  }
}
