package com.apprisemobile.foxitpdf;

import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Canvas;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.WindowManager;

import com.foxit.sdk.PDFViewCtrl;
import com.foxit.sdk.pdf.PDFDoc;
import com.foxit.uiextensions.UIExtensionsManager;
import com.foxit.uiextensions.home.IHomeModule;
import com.foxit.uiextensions.pdfreader.impl.MainFrame;
import com.foxit.uiextensions.pdfreader.impl.PDFReader;
import com.foxit.uiextensions.utils.AppFileUtil;

import java.io.InputStream;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;

import static com.foxit.sdk.PDFViewCtrl.ZOOMMODE_FITHEIGHT;
import static com.foxit.sdk.PDFViewCtrl.ZOOMMODE_FITWIDTH;

public class ReactNativeFoxitPdfActivity extends AppCompatActivity {
    public PDFReader mPDFReader;
    private boolean resetZoomOnNextDraw = false;

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
            "    \"modules\": {\n" +
            "        \"readingbookmark\": " + annotationsEnabledString + ",\n" +
            "        \"outline\": true,\n" +
            "        \"annotations\": {\n" +
            "          \"highlight\": " + annotationsEnabledString + ",\n" +
            "          \"underline\": " + annotationsEnabledString + ",\n" +
            "          \"squiggly\": " + annotationsEnabledString + ",\n" +
            "          \"strikeout\": " + annotationsEnabledString + ",\n" +
            "          \"inserttext\": " + annotationsEnabledString + ",\n" +
            "          \"replacetext\": " + annotationsEnabledString + ",\n" +
            "          \"line\": " + annotationsEnabledString + ",\n" +
            "          \"rectangle\": " + annotationsEnabledString + ",\n" +
            "          \"oval\": " + annotationsEnabledString + ",\n" +
            "          \"arrow\": " + annotationsEnabledString + ",\n" +
            "          \"pencil\": " + annotationsEnabledString + ",\n" +
            "          \"eraser\": " + annotationsEnabledString + ",\n" +
            "          \"typewriter\": " + annotationsEnabledString + ",\n" +
            "          \"note\": " + annotationsEnabledString + ",\n" +
            "          \"stamp\": " + annotationsEnabledString + "\n" +
            "        },\n" +
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
        uiextensionsManager.setAttachedActivity(this);
        pdfViewCtrl.setUIExtensionsManager(uiextensionsManager);

        mPDFReader= (PDFReader) uiextensionsManager.getPDFReader();
        mPDFReader.onCreate(this, pdfViewCtrl, savedInstanceState);
        uiextensionsManager.registerConfigurationChangedListener(new UIExtensionsManager.ConfigurationChangedListener() {
            @Override
            public void onConfigurationChanged(Configuration configuration) {
                resetZoomOnNextDraw = true;
            }
        });
        pdfViewCtrl.registerDrawEventListener(new PDFViewCtrl.IDrawEventListener() {
            @Override
            public void onDraw(int i, Canvas canvas) {
                if (resetZoomOnNextDraw) {
                    resetZoomOnNextDraw = false;
                    pdfViewCtrl.setZoomMode(ZOOMMODE_FITHEIGHT);
                    pdfViewCtrl.setZoomMode(ZOOMMODE_FITWIDTH);
                    pdfViewCtrl.updatePagesLayout();
                }
            }
        });
        pdfViewCtrl.registerDocEventListener(new PDFViewCtrl.IDocEventListener() {
            public void onDocWillOpen() {
            }

            public void onDocOpened(PDFDoc document, int errCode) {
                pdfViewCtrl.setZoomMode(ZOOMMODE_FITHEIGHT);
                pdfViewCtrl.setZoomMode(ZOOMMODE_FITWIDTH);
                pdfViewCtrl.updatePagesLayout();
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
    protected void onNewIntent(Intent intent) {
      super.onNewIntent(intent);
      if (mPDFReader == null)
        return;
      if (mPDFReader.getMainFrame().getAttachedActivity() != this)
        return;
      setIntent(intent);
      String path = AppFileUtil.getFilePath(this, intent, IHomeModule.FILE_EXTRA);
      if (path != null) {
        mPDFReader.openDocument(path, null);
      }
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
        // ((MainFrame) mPDFReader.getMainFrame()).updateSettingBar();
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
