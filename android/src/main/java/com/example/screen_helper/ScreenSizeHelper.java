package com.example.screen_helper;

import android.app.Activity;
import android.util.DisplayMetrics;
import android.view.WindowManager;
import android.os.Build;
import android.graphics.Rect;
import android.view.Display;
import java.util.HashMap;
import java.util.Map;

public class ScreenSizeHelper {

    private Activity activity;
    private DisplayMetrics metrics;
    private Display display;

    public ScreenSizeHelper(Activity activity) {
        this.activity = activity;
        this.metrics = new DisplayMetrics();
        WindowManager windowManager = activity.getWindowManager();

        // Check Android version to use appropriate method for getting screen metrics
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            // For Android 11 (API 30) and above
            Rect bounds = windowManager.getCurrentWindowMetrics().getBounds();
            metrics.widthPixels = bounds.width();
            metrics.heightPixels = bounds.height();
        } else {
            // For Android 10 (API 29) and below
            Display display = windowManager.getDefaultDisplay();
            display.getRealMetrics(metrics);
        }

        // Set the screen density (DPI) values
        metrics.xdpi = activity.getResources().getDisplayMetrics().xdpi;
        metrics.ydpi = activity.getResources().getDisplayMetrics().ydpi;
    }

    // function to get real screen size in inches (width and height)
    public Map<String, Double> getScreenSizeInInches() {
        double widthInches = metrics.widthPixels / metrics.xdpi;
        double heightInches = metrics.heightPixels / metrics.ydpi;
        Map<String, Double> result = new HashMap<>();
        result.put("width", widthInches);
        result.put("height", heightInches);
        return result;
    }

    // function to get screen resolution in pixels (width and height)
    public Map<String, Double> screenSizeInPixels() {
        Map<String, Double> result = new HashMap<>();
        result.put("width", Double.valueOf(metrics.widthPixels));
        result.put("height", Double.valueOf(metrics.heightPixels));
        return result;
    }
}