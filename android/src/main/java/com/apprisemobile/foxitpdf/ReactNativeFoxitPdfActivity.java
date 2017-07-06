package com.apprisemobile.foxitpdf;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.widget.RelativeLayout;

import com.foxit.sdk.PDFViewCtrl;
import com.foxit.uiextensions.UIExtensionsManager;
import com.foxit.uiextensions.pdfreader.impl.PDFReader;

import java.io.InputStream;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;

public class ReactNativeFoxitPdfActivity extends Activity {
    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        final Bundle bundle = getIntent().getExtras();
        final String path = bundle.getString("path");
        final RelativeLayout relativeLayout = new RelativeLayout(this);
        final RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);

        final PDFViewCtrl pdfViewCtrl = new PDFViewCtrl(this);

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

        final InputStream stream = new ByteArrayInputStream(UIExtensionsConfig.getBytes(Charset.forName("UTF-8")));
        UIExtensionsManager.Config config = new UIExtensionsManager.Config(stream);

        final UIExtensionsManager uiextensionsManager = new UIExtensionsManager(this, relativeLayout, pdfViewCtrl,config);
        uiextensionsManager.setAttachedActivity(this);

        pdfViewCtrl.setUIExtensionsManager(uiextensionsManager);

        final PDFReader mPDFReader= (PDFReader) uiextensionsManager.getPDFReader();
        mPDFReader.onCreate(this, pdfViewCtrl, null);
        mPDFReader.openDocument(path, null);
        setContentView(mPDFReader.getContentView());
        mPDFReader.onStart(this);
    }
}
