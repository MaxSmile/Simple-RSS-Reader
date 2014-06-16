package com.vasilkoff.simple.rss;

import android.app.Application;
import android.graphics.Bitmap;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;

import org.acra.ACRA;
import org.acra.ReportingInteractionMode;
import org.acra.annotation.ReportsCrashes;

/**
 * Created by maxim.vasilkov@gmail.com on 14/06/14.
 */
@ReportsCrashes(formKey = "", // will not be used
        mailTo = "maxim.vasilkov@gmail.com",
        mode = ReportingInteractionMode.TOAST,
        resToastText = R.string.crash_toast_text)
public class App extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        ACRA.init(this);
        DisplayImageOptions defaultOptions = new DisplayImageOptions.Builder()
                .cacheInMemory(true)
                .cacheOnDisc(true)
                .build();
        ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(getApplicationContext())
                .defaultDisplayImageOptions(defaultOptions)
                .memoryCacheExtraOptions(400, 400)
                .discCacheExtraOptions(400, 400, Bitmap.CompressFormat.PNG, 75, null)
                .build();
        ImageLoader.getInstance().init(config);
    }
}