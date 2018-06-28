package com.rssignaturecapture;

import android.util.Log;
import android.view.ViewGroup;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.uimanager.ThemedReactContext;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import java.io.File;
import java.io.FileOutputStream;
import java.io.ByteArrayOutputStream;

import android.util.Base64;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.os.Environment;
import android.view.View;
import android.widget.LinearLayout;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import java.lang.Boolean;

public class RSSignatureCaptureMainView extends LinearLayout implements RSSignatureCaptureView.SignatureCallback {
  RSSignatureCaptureView signatureView;

  Activity mActivity;
  int mOriginalOrientation;

  public RSSignatureCaptureMainView(Context context, Activity activity) {
    super(context);
    Log.d("React:", "RSSignatureCaptureMainView(Contructtor)");
    mOriginalOrientation = activity.getRequestedOrientation();
    mActivity = activity;

    this.setOrientation(LinearLayout.VERTICAL);
    this.signatureView = new RSSignatureCaptureView(context,this);
    // add the signature view
    this.addView(signatureView);

    setLayoutParams(new android.view.ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
        ViewGroup.LayoutParams.MATCH_PARENT));
  }

  public void setStrokeColor(Integer color) {
    this.signatureView.setStrokeColor(color);
  }

  public void reset() {
    if (this.signatureView != null) {
      this.signatureView.clearSignature();
    }
  }

  @Override public void onDragged() {
    WritableMap event = Arguments.createMap();
    event.putBoolean("dragged", true);
    ReactContext reactContext = (ReactContext) getContext();
    reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(getId(), "topChange", event);

  }
}
