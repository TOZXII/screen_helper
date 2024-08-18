package com.example.screen_helper;

import android.view.WindowManager;

import android.content.res.Configuration;
import android.content.res.Resources;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.ViewConfiguration;
import android.view.KeyCharacterMap;
import android.view.KeyEvent;
import android.app.Activity;
import android.graphics.Point;
import android.content.Context;
import android.view.WindowInsets;
import android.os.Build;
import android.graphics.Rect;

public class ScreenSizeHelper {

    private Activity activity;
    private DisplayMetrics metrics;
    private Display display;

    public ScreenSizeHelper(Activity activity) {
        this.activity = activity;
        this.metrics = new DisplayMetrics();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            // For API level 30 and above
            WindowManager windowManager = activity.getWindowManager();
            Rect bounds = windowManager.getCurrentWindowMetrics().getBounds();
            metrics.widthPixels = bounds.width();
            metrics.heightPixels = bounds.height();
            metrics.xdpi = activity.getResources().getDisplayMetrics().xdpi;
            metrics.ydpi = activity.getResources().getDisplayMetrics().ydpi;
        } else {
            // For API level 29 and below
            // because of the deprecation of the getRealMetrics method
            this.display = activity.getWindowManager().getDefaultDisplay();
            display.getRealMetrics(metrics);
        }
    }

    public double getScreenPPI() {
        // Get the diagonal size in pixels
        double diagonalPixels = getScreenDiagonalInPixels();

        // Get the diagonal size in inches
        double diagonalInches = getScreenDiagonalInInches();

        // Calculate the PPI
        return diagonalPixels / diagonalInches;
    }

    public double getScreenWidthInInches() {

        // Get the screen width in pixels
        int widthPixels = getScreenRealWidthInPixels();

        // Calculate the width in inches
        return widthPixels / metrics.xdpi;
    }

    public double getScreenHeightInInches() {

        // Get the screen height in pixels
        int heightPixels = getScreenRealHeightInPixels();

        // Calculate the height in inches
        return heightPixels / metrics.ydpi;
    }

    // Get the screen width in pixels
    public int getScreenRealWidthInPixels() {
        Resources resources = activity.getResources();

        return metrics.widthPixels;

    }

    // Get the screen height in pixels
    public int getScreenRealHeightInPixels() {
        Resources resources = activity.getResources();

        return metrics.heightPixels;
    }

    public int getScreenDiagonalInPixels() {

        int widthPixels = getScreenRealWidthInPixels();
        int heightPixels = getScreenRealHeightInPixels();

        return (int) Math.sqrt(Math.pow(widthPixels, 2) + Math.pow(heightPixels, 2));
    }

    public double getScreenDiagonalInInches() {

        // Get the screen dimensions in pixels
        int widthPixels = getScreenRealWidthInPixels();
        int heightPixels = getScreenRealHeightInPixels();

        // Get the diagonal size in pixels
        double diagonalPixels = getScreenDiagonalInPixels();

        // Get the diagonal size in inches
        double widthInches = getScreenWidthInInches();
        double heightInches = getScreenHeightInInches();
        return Math.sqrt(Math.pow(widthInches, 2) + Math.pow(heightInches, 2));
    }

    public int getStatusBarHeight() {
        int result = 0;
        int resourceId = activity.getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (resourceId > 0) {
            result = activity.getResources().getDimensionPixelSize(resourceId);
        }
        return result;
    }

    public int getNavigationBarHeight11() {
        if (Build.VERSION.SDK_INT >= 30) {
            WindowInsets windowInsets = activity.getWindowManager().getCurrentWindowMetrics().getWindowInsets();
            return windowInsets.getInsets(WindowInsets.Type.navigationBars()).bottom;
        } else {
            return calculateNavigationBarHeightForOlderDevices();
        }
    }

    private int calculateNavigationBarHeightForOlderDevices() {
        Display display = activity.getWindowManager().getDefaultDisplay();
        Point appUsableSize = new Point();
        Point realScreenSize = new Point();
        display.getSize(appUsableSize);
        display.getRealSize(realScreenSize);

        // navigation bar on the side
        if (appUsableSize.x < realScreenSize.x) {
            return realScreenSize.x - appUsableSize.x;
        }

        // navigation bar at the bottom
        if (appUsableSize.y < realScreenSize.y) {
            return realScreenSize.y - appUsableSize.y;
        }

        return 0;
    }

    private boolean isTablet() {
        return (activity.getResources().getConfiguration().screenLayout
                & Configuration.SCREENLAYOUT_SIZE_MASK) >= Configuration.SCREENLAYOUT_SIZE_LARGE;
    }

}
