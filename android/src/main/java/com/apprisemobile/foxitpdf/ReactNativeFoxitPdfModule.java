package com.apprisemobile.foxitpdf;

import android.content.Context;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.RelativeLayout;
import android.app.Activity;

import com.foxit.sdk.PDFViewCtrl;
import com.foxit.sdk.common.Library;
import com.foxit.sdk.common.PDFException;
import com.foxit.uiextensions.UIExtensionsManager;
import com.foxit.uiextensions.pdfreader.impl.PDFReader;

import java.io.InputStream;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;

import org.json.JSONArray;
import org.json.JSONException;

class ReactNativeFoxitPdfModule extends ReactContextBaseJavaModule {
    private Context context;
    private static int errCode = PDFException.e_errSuccess;
    static {
        System.loadLibrary("rdk");
    }

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
    public void openPdf(final String filePath, final Callback onSuccess, final Callback onFailure) {
        final String path = filePath.replace("file://", "");
        if (path == null || path.trim().length() < 1) {
            onFailure.invoke("Please input validate path.");
            return;
        }

        if (errCode != PDFException.e_errSuccess) {
            onFailure.invoke("Please initialize Foxit library Firstly.");
        }

        final Context context = getCurrentActivity();
        final Activity activity = getCurrentActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                final RelativeLayout relativeLayout = new RelativeLayout(context);
                RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(
                        RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);

                final PDFViewCtrl pdfViewCtrl = new PDFViewCtrl(context);

                relativeLayout.addView(pdfViewCtrl, params);
                relativeLayout.setWillNotDraw(false);
                relativeLayout.setBackgroundColor(Color.argb(255, 225, 225, 225));
                relativeLayout.setDrawingCacheEnabled(true);
                setContentView(relativeLayout);

                final String UIExtensionsConfig = "{\n" +
                    "    \"defaultReader\": true,\n" +
                    "    \"modules\": {\n" +
                    "        \"readingbookmark\": true,\n" +
                    "        \"outline\": true,\n" +
                    "        \"annotations\": true,\n" +
                    "        \"thumbnail\" : false,\n" +
                    "        \"attachment\": true,\n" +
                    "        \"signature\": false,\n" +
                    "        \"search\": true,\n" +
                    "        \"pageNavigation\": true,\n" +
                    "        \"form\": true,\n" +
                    "        \"selection\": true,\n" +
                    "        \"encryption\" : false\n" +
                    "    }\n" +
                    "}\n";

                InputStream stream = new ByteArrayInputStream(UIExtensionsConfig.getBytes(Charset.forName("UTF-8")));
                UIExtensionsManager.Config config = new UIExtensionsManager.Config(stream);

                UIExtensionsManager uiextensionsManager = new UIExtensionsManager(context, relativeLayout, pdfViewCtrl,config);
                uiextensionsManager.setAttachedActivity(activity);

                pdfViewCtrl.setUIExtensionsManager(uiextensionsManager);

                PDFReader mPDFReader= (PDFReader) uiextensionsManager.getPDFReader();
                mPDFReader.onCreate(activity, pdfViewCtrl, null);
                mPDFReader.openDocument(path, null);
                setContentView(mPDFReader.getContentView());
                mPDFReader.onStart(activity);
            }
        });
    }

    private void setContentView(View view) {
        getCurrentActivity().setContentView(view);
    }
}
