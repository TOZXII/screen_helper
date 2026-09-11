package com.example.screen_helper;

import android.app.Activity;
import android.util.DisplayMetrics;
import android.view.WindowManager;
import android.os.Build;
import android.graphics.Rect;
import java.util.HashMap;
import java.util.Map;

public class ScreenSizeHelper {

    private final Activity activity;
    private final int sdkVersion;

    public ScreenSizeHelper(Activity activity) {
        this(activity, Build.VERSION.SDK_INT);
    }

    ScreenSizeHelper(Activity activity, int sdkVersion) {
        this.activity = activity;
        this.sdkVersion = sdkVersion;
    }

    private DisplayMetrics readDisplayMetrics() {
        DisplayMetrics metrics = new DisplayMetrics();
        WindowManager windowManager = activity.getWindowManager();

        // Check Android version to use appropriate method for getting screen metrics
        if (sdkVersion >= Build.VERSION_CODES.R) {
            // For Android 11 (API 30) and above
            Rect bounds = windowManager.getCurrentWindowMetrics().getBounds();
            metrics.widthPixels = bounds.width();
            metrics.heightPixels = bounds.height();
        } else {
            // For Android 10 (API 29) and below
            populateLegacyDisplayMetrics(windowManager, metrics);
        }

        // Set the screen density (DPI) values
        metrics.xdpi = activity.getResources().getDisplayMetrics().xdpi;
        metrics.ydpi = activity.getResources().getDisplayMetrics().ydpi;
        return metrics;
    }

    @SuppressWarnings("deprecation")
    private static void populateLegacyDisplayMetrics(
            WindowManager windowManager,
            DisplayMetrics metrics
    ) {
        windowManager.getDefaultDisplay().getRealMetrics(metrics);
    }

    // function to get real screen size in inches (width and height)
    public Map<String, Double> getScreenSizeInInches() {
        DisplayMetrics metrics = readDisplayMetrics();
        if (metrics.xdpi <= 0 || metrics.ydpi <= 0
                || Float.isNaN(metrics.xdpi) || Float.isNaN(metrics.ydpi)
                || Float.isInfinite(metrics.xdpi) || Float.isInfinite(metrics.ydpi)) {
            return null;
        }
        double widthInches = metrics.widthPixels / (double) metrics.xdpi;
        double heightInches = metrics.heightPixels / (double) metrics.ydpi;
        Map<String, Double> result = new HashMap<>();
        result.put("width", widthInches);
        result.put("height", heightInches);
        return result;
    }

    // function to get screen resolution in pixels (width and height)
    public Map<String, Double> screenSizeInPixels() {
        DisplayMetrics metrics = readDisplayMetrics();
        Map<String, Double> result = new HashMap<>();
        result.put("width", Double.valueOf(metrics.widthPixels));
        result.put("height", Double.valueOf(metrics.heightPixels));
        return result;
    }
}
