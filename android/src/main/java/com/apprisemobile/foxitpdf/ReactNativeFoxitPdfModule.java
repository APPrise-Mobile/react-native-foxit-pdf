package com.apprisemobile.foxitpdf;

import android.content.Intent;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

import com.foxit.sdk.common.Library;
import com.foxit.sdk.common.PDFException;

class ReactNativeFoxitPdfModule extends ReactContextBaseJavaModule {
    private static int errCode = PDFException.e_errSuccess;
    static {
        System.loadLibrary("rdk");
    }

    public ReactNativeFoxitPdfModule(ReactApplicationContext reactContext) {
        super(reactContext);
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
    private void init(final String sn, final String key, final Callback onSuccess, final Callback onFailure) {
        try {
            Library.init(sn, key);
        } catch (PDFException e) {
            errCode = e.getLastError();
            onFailure.invoke("Failed to initialize Foxit library.");
        }

        errCode = PDFException.e_errSuccess;
        onSuccess.invoke("Succeed to initialize Foxit library.");
    }

    @ReactMethod
    public void openPdf(final String filePath, final boolean annotationsEnabled, final Callback onSuccess, final Callback onFailure) {
        final String path = filePath.replace("file://", "");
        if (path == null || path.trim().length() < 1) {
            onFailure.invoke("Please input validate path.");
            return;
        }

        if (errCode != PDFException.e_errSuccess) {
            onFailure.invoke("Please initialize Foxit library Firstly.");
        }

        final Intent intent = new Intent(getCurrentActivity(), ReactNativeFoxitPdfActivity.class);
        intent.putExtra("path", path);
        intent.putExtra("annotationsEnabled", annotationsEnabled);
        getCurrentActivity().startActivity(intent);
    }
}
