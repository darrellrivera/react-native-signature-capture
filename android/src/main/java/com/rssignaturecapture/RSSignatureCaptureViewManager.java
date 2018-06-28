package com.rssignaturecapture;

import android.util.Log;

import com.facebook.infer.annotation.Assertions;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.rssignaturecapture.RSSignatureCaptureContextModule;

import java.util.Map;

import javax.annotation.Nullable;

public class RSSignatureCaptureViewManager extends ViewGroupManager<RSSignatureCaptureMainView> {

	public static final String PROPS_SAVE_IMAGE_FILE="saveImageFileInExtStorage";
	public static final String PROPS_STROKE_COLOR="strokeColor";
	public static final String PROPS_BACKGROUND_COLOR="backgroundColor";

	public static final int COMMAND_SAVE_IMAGE = 1;
	public static final int COMMAND_RESET_IMAGE = 2;

	private RSSignatureCaptureContextModule mContextModule;

	public RSSignatureCaptureViewManager(ReactApplicationContext reactContext) {
		mContextModule = new RSSignatureCaptureContextModule(reactContext);
	}

	@Override
	public String getName() {
		return "RSSignatureView";
	}

	@ReactProp(name = PROPS_SAVE_IMAGE_FILE)
	public void setSaveImageFileInExtStorage(RSSignatureCaptureMainView view, @Nullable Boolean saveFile) {
		Log.d("setFileInExtStorage:", "" + saveFile);
		if(view!=null){
			view.setSaveFileInExtStorage(saveFile);
		}
	}

	@ReactProp(name = PROPS_BACKGROUND_COLOR, customType = "Color")
	public void setBackgroundColor(RSSignatureCaptureMainView view, @Nullable Integer color) {
		Log.d("setBackgroundColor:", "" + color);
		if(view!=null) {
			view.setBackgroundColor(color);
		}
	}

	@ReactProp(name = PROPS_STROKE_COLOR, customType = "Color")
	public void setStrokeColor(RSSignatureCaptureMainView view, @Nullable Integer color) {
		Log.d("setStrokeColor:", "" + color);
		if(view!=null) {
			view.setStrokeColor(color);
		}
	}

	@Override
	public RSSignatureCaptureMainView createViewInstance(ThemedReactContext context) {
		Log.d("React"," View manager createViewInstance:");
		return new RSSignatureCaptureMainView(context, mContextModule.getActivity());
	}

	@Override
	public Map<String,Integer> getCommandsMap() {
		Log.d("React"," View manager getCommandsMap:");
		return MapBuilder.of(
				"saveImage",
				COMMAND_SAVE_IMAGE,
				"resetImage",
				COMMAND_RESET_IMAGE);
	}

	@Override
	public void receiveCommand(
			RSSignatureCaptureMainView view,
			int commandType,
			@Nullable ReadableArray args) {
		Assertions.assertNotNull(view);
		Assertions.assertNotNull(args);
		switch (commandType) {
			case COMMAND_SAVE_IMAGE: {
				view.saveImage();
				return;
			}
			case COMMAND_RESET_IMAGE: {
				view.reset();
				return;
			}

			default:
				throw new IllegalArgumentException(String.format(
						"Unsupported command %d received by %s.",
						commandType,
						getClass().getSimpleName()));
		}
	}


}
