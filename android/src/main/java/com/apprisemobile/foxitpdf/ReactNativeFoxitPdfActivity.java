package com.apprisemobile.foxitpdf;

import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.WindowManager;

import com.foxit.sdk.PDFViewCtrl;
import com.foxit.sdk.pdf.PDFDoc;
import com.foxit.uiextensions.UIExtensionsManager;
import com.foxit.uiextensions.pdfreader.impl.MainFrame;
import com.foxit.uiextensions.pdfreader.impl.PDFReader;

import java.io.InputStream;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;

import static com.foxit.sdk.PDFViewCtrl.ZOOMMODE_FITHEIGHT;
import static com.foxit.sdk.PDFViewCtrl.ZOOMMODE_FITWIDTH;

public class ReactNativeFoxitPdfActivity extends AppCompatActivity {
    public PDFReader mPDFReader;

    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        final Bundle bundle = getIntent().getExtras();
        final String path = bundle.getString("path");
        final boolean annotationsEnabled = bundle.getBoolean("annotationsEnabled");
        // final RelativeLayout relativeLayout = new RelativeLayout(this);
        // final RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(
        //         RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);
        //
        // relativeLayout.addView(pdfViewCtrl, params);
        // relativeLayout.setWillNotDraw(false);
        // relativeLayout.setBackgroundColor(Color.argb(255, 225, 225, 225));
        // relativeLayout.setDrawingCacheEnabled(true);
        // setContentView(relativeLayout);

        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);

        final String annotationsEnabledString = annotationsEnabled ? "true" : "false";

        final String UIExtensionsConfig = "{\n" +
            "    \"defaultReader\": true,\n" +
            "    \"modules\": {\n" +
            "        \"readingbookmark\": " + annotationsEnabledString + ",\n" +
            "        \"outline\": true,\n" +
            "        \"annotations\": " + annotationsEnabledString + ",\n" +
            "        \"thumbnail\" : false,\n" +
            "        \"attachment\": false,\n" +
            "        \"signature\": false,\n" +
            "        \"search\": true,\n" +
            "        \"pageNavigation\": true,\n" +
            "        \"form\": true,\n" +
            "        \"selection\": true,\n" +
            "        \"encryption\" : false\n" +
            "    }\n" +
            "}\n";

        final InputStream stream = new ByteArrayInputStream(UIExtensionsConfig.getBytes(Charset.forName("UTF-8")));
        UIExtensionsManager.Config config = new UIExtensionsManager.Config(stream);

        final PDFViewCtrl pdfViewCtrl = new PDFViewCtrl(this.getApplicationContext());
        final UIExtensionsManager uiextensionsManager = new UIExtensionsManager(this.getApplicationContext(), null, pdfViewCtrl,config);

        pdfViewCtrl.setUIExtensionsManager(uiextensionsManager);
        uiextensionsManager.setFormHighlightColor(0xffff0000);

        uiextensionsManager.setAttachedActivity(this);

        mPDFReader= (PDFReader) uiextensionsManager.getPDFReader();
        mPDFReader.onCreate(this, pdfViewCtrl, savedInstanceState);
        pdfViewCtrl.registerDocEventListener(new PDFViewCtrl.IDocEventListener() {
            public void onDocWillOpen() {
            }

            public void onDocOpened(PDFDoc document, int errCode) {
                pdfViewCtrl.setZoomMode(ZOOMMODE_FITHEIGHT);
                pdfViewCtrl.setZoomMode(ZOOMMODE_FITWIDTH);
            }

            public void onDocWillClose(PDFDoc document) {
            }

            public void onDocClosed(PDFDoc document, int errCode) {
            }

            public void onDocWillSave(PDFDoc document) {
            }

            public void onDocSaved(PDFDoc document, int errCode) {
            }
        });
        mPDFReader.openDocument(path, null);
        setContentView(mPDFReader.getContentView());
    }

    @Override
    protected void onStart() {
        super.onStart();
        if(mPDFReader == null)
            return;
        mPDFReader.onStart(this);
    }

    @Override
    protected void onPause() {
        super.onPause();
        if(mPDFReader == null)
            return;
        mPDFReader.onPause(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        if(mPDFReader == null)
            return;
        mPDFReader.onResume(this);
    }

    @Override
    protected void onStop() {
        super.onStop();
        if(mPDFReader == null)
            return;
        mPDFReader.onStop(this);
    }

    @Override
    protected void onDestroy() {
        this.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        if(mPDFReader != null)
            mPDFReader.onDestroy(this);
        super.onDestroy();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(mPDFReader != null)
            mPDFReader.onActivityResult(this, requestCode, resultCode, data);
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        if(mPDFReader == null)
            return;
        ((MainFrame) mPDFReader.getMainFrame()).updateSettingBar();
        mPDFReader.onConfigurationChanged(this, newConfig);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (mPDFReader != null && mPDFReader.onKeyDown(this, keyCode, event))
            return true;
        return super.onKeyDown(keyCode, event);
    }

    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        if (mPDFReader != null && !mPDFReader.onPrepareOptionsMenu(this, menu))
            return false;
        return super.onPrepareOptionsMenu(menu);
    }

    private void finishActivity() {
        this.finish();
    }
}
