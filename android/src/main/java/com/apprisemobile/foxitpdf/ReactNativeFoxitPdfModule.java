package com.apprisemobile.foxitpdf;

import android.content.Context;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

class ReactNativeFoxitPdfModule extends ReactContextBaseJavaModule {
    private Context context;

    public ReactNativeFoxitPdfModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.context = reactContext;
    }

    /**
     * @return the name of this module. This will be the name used to {@code require()} this module
     * from javascript.
     */
    @Override
    public String getName() {
        return "ReactNativeFoxitPdf";
    }

    @ReactMethod
    public void openPdf(Callback onSuccess, Callback onFailure) {
        onSuccess.invoke("Hello World!");
    }
}
