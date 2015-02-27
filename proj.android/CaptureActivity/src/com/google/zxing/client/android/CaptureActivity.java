/*
 * Copyright (C) 2008 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.zxing.client.android;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.DecodeHintType;
import com.google.zxing.Result;
import com.google.zxing.ResultMetadataType;
import com.google.zxing.ResultPoint;
import com.google.zxing.client.android.R;
import com.google.zxing.client.android.R.color;
import com.google.zxing.client.android.R.drawable;
import com.google.zxing.client.android.R.id;
import com.google.zxing.client.android.R.layout;
import com.google.zxing.client.android.R.string;
import com.google.zxing.client.android.R.xml;
import com.google.zxing.client.android.camera.CameraManager;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.IOException;
import java.text.DateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.EnumSet;
import java.util.Map;

public final class CaptureActivity extends Activity implements
		SurfaceHolder.Callback {

	private static final String TAG = CaptureActivity.class.getSimpleName();

	private static final long DEFAULT_INTENT_RESULT_DURATION_MS = 1500L;
	private static final long BULK_MODE_SCAN_DELAY_MS = 1000L;

	public static final int HISTORY_REQUEST_CODE = 0x0000bacc;

	private static final Collection<ResultMetadataType> DISPLAYABLE_METADATA_TYPES = EnumSet
			.of(ResultMetadataType.ISSUE_NUMBER,
					ResultMetadataType.SUGGESTED_PRICE,
					ResultMetadataType.ERROR_CORRECTION_LEVEL,
					ResultMetadataType.POSSIBLE_COUNTRY);

	private CameraManager cameraManager;
	private CaptureActivityHandler handler;
	private Result savedResultToShow;
	private ViewfinderView viewfinderView;
	private TextView statusView;
	//private View resultView;
	private Result lastResult;
	private boolean hasSurface;
	private IntentSource source;
	private Collection<BarcodeFormat> decodeFormats;
	private Map<DecodeHintType, ?> decodeHints;
	private String characterSet;
	private InactivityTimer inactivityTimer;
	private BeepManager beepManager;
	private AmbientLightManager ambientLightManager;

	ViewfinderView getViewfinderView() {
		return viewfinderView;
	}

	public Handler getHandler() {
		return handler;
	}

	CameraManager getCameraManager() {
		return cameraManager;
	}

	@Override
	public void onCreate(Bundle icicle) {
		super.onCreate(icicle);

		Window window = getWindow();
		window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		setContentView(R.layout.capture);

		hasSurface = false;
		inactivityTimer = new InactivityTimer(this);
		beepManager = new BeepManager(this);
		ambientLightManager = new AmbientLightManager(this);

		PreferenceManager.setDefaultValues(this, R.xml.preferences, false);
	}

	@Override
	protected void onResume() {
		super.onResume();

		// CameraManager must be initialized here, not in onCreate(). This is
		// necessary because we don't
		// want to open the camera driver and measure the screen size if we're
		// going to show the help on
		// first launch. That led to bugs where the scanning rectangle was the
		// wrong size and partially
		// off screen.
		cameraManager = new CameraManager(getApplication());

		viewfinderView = (ViewfinderView) findViewById(R.id.viewfinder_view);
		viewfinderView.setCameraManager(cameraManager);

//		resultView = findViewById(R.id.result_view);
		statusView = (TextView) findViewById(R.id.status_view);

		handler = null;
		lastResult = null;

		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

		resetStatusView();

		SurfaceView surfaceView = (SurfaceView) findViewById(R.id.preview_view);
		SurfaceHolder surfaceHolder = surfaceView.getHolder();
		if (hasSurface) {
			// The activity was paused but not stopped, so the surface still
			// exists. Therefore
			// surfaceCreated() won't be called, so init the camera here.
			initCamera(surfaceHolder);
		} else {
			// Install the callback and wait for surfaceCreated() to init the
			// camera.
			surfaceHolder.addCallback(this);
		}

		beepManager.updatePrefs();
		ambientLightManager.start(cameraManager);

		inactivityTimer.onResume();

		Intent intent = getIntent();

		source = IntentSource.NONE;
		decodeFormats = null;
		characterSet = null;
        ImageView btn_return = (ImageView) findViewById(id.btn_return);
        btn_return.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
		//edit by vsv remove useless code
		// if (intent != null) {
		//
		// String action = intent.getAction();
		// String dataString = intent.getDataString();
		//
		// if (Intents.Scan.ACTION.equals(action)) {
		//
		// // Scan the formats the intent requested, and return the result to
		// the calling activity.
		// source = IntentSource.NATIVE_APP_INTENT;
		// decodeFormats = DecodeFormatManager.parseDecodeFormats(intent);
		// decodeHints = DecodeHintManager.parseDecodeHints(intent);
		//
		// if (intent.hasExtra(Intents.Scan.WIDTH) &&
		// intent.hasExtra(Intents.Scan.HEIGHT)) {
		// int width = intent.getIntExtra(Intents.Scan.WIDTH, 0);
		// int height = intent.getIntExtra(Intents.Scan.HEIGHT, 0);
		// if (width > 0 && height > 0) {
		// cameraManager.setManualFramingRect(width, height);
		// }
		// }
		//
		// if (intent.hasExtra(Intents.Scan.CAMERA_ID)) {
		// int cameraId = intent.getIntExtra(Intents.Scan.CAMERA_ID, -1);
		// if (cameraId >= 0) {
		// cameraManager.setManualCameraId(cameraId);
		// }
		// }
		//
		// String customPromptMessage =
		// intent.getStringExtra(Intents.Scan.PROMPT_MESSAGE);
		// if (customPromptMessage != null) {
		// statusView.setText(customPromptMessage);
		// }
		//
		// } else if (dataString != null &&
		// dataString.contains("http://www.google") &&
		// dataString.contains("/m/products/scan")) {
		//
		// // Scan only products and send the result to mobile Product Search.
		// source = IntentSource.PRODUCT_SEARCH_LINK;
		// sourceUrl = dataString;
		// decodeFormats = DecodeFormatManager.PRODUCT_FORMATS;
		//
		// } else if (isZXingURL(dataString)) {
		//
		// // Scan formats requested in query string (all formats if none
		// specified).
		// // If a return URL is specified, send the results there. Otherwise,
		// handle it ourselves.
		// source = IntentSource.ZXING_LINK;
		// sourceUrl = dataString;
		// Uri inputUri = Uri.parse(dataString);
		// scanFromWebPageManager = new ScanFromWebPageManager(inputUri);
		// decodeFormats = DecodeFormatManager.parseDecodeFormats(inputUri);
		// // Allow a sub-set of the hints to be specified by the caller.
		// decodeHints = DecodeHintManager.parseDecodeHints(inputUri);
		//
		// }
		//
		// characterSet = intent.getStringExtra(Intents.Scan.CHARACTER_SET);
		//
		// }
		//launchSearch("xxxxlaksfhalfhlahfklhkl开户费撒开了房哈开户费水电费会计核算大概开会");
	}
	

	@Override
	protected void onPause() {
		if (handler != null) {
			handler.quitSynchronously();
			handler = null;
		}
		inactivityTimer.onPause();
		ambientLightManager.stop();
		beepManager.close();
		cameraManager.closeDriver();
		if (!hasSurface) {
			SurfaceView surfaceView = (SurfaceView) findViewById(R.id.preview_view);
			SurfaceHolder surfaceHolder = surfaceView.getHolder();
			surfaceHolder.removeCallback(this);
		}
		super.onPause();
	}

	@Override
	protected void onDestroy() {
		inactivityTimer.shutdown();
		super.onDestroy();
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		switch (keyCode) {
		case KeyEvent.KEYCODE_BACK:
			setResult(RESULT_CANCELED);
			finish();
			return true;
		case KeyEvent.KEYCODE_FOCUS:
		case KeyEvent.KEYCODE_CAMERA:
			// Handle these events so they don't launch the Camera app
			return true;
			// Use volume up/down to turn on light
		case KeyEvent.KEYCODE_VOLUME_DOWN:
			cameraManager.setTorch(false);
			return true;
		case KeyEvent.KEYCODE_VOLUME_UP:
			cameraManager.setTorch(true);
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

//	@Override
//	public boolean onCreateOptionsMenu(Menu menu) {
//		MenuInflater menuInflater = getMenuInflater();
//		menuInflater.inflate(R.menu.capture, menu);
//		return super.onCreateOptionsMenu(menu);
//	}
//
//	@Override
//	public boolean onOptionsItemSelected(MenuItem item) {
//		Intent intent = new Intent(Intent.ACTION_VIEW);
//		intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET);
//		switch (item.getItemId()) {
//		case R.id.menu_settings:
//			intent.setClassName(this, PreferencesActivity.class.getName());
//			startActivity(intent);
//			break;
//		default:
//			return super.onOptionsItemSelected(item);
//		}
//		return true;
//	}

	private void decodeOrStoreSavedBitmap(Bitmap bitmap, Result result) {
		// Bitmap isn't used yet -- will be used soon
		if (handler == null) {
			savedResultToShow = result;
		} else {
			if (result != null) {
				savedResultToShow = result;
			}
			if (savedResultToShow != null) {
				Message message = Message.obtain(handler,
						R.id.decode_succeeded, savedResultToShow);
				handler.sendMessage(message);
			}
			savedResultToShow = null;
		}
	}

	@Override
	public void surfaceCreated(SurfaceHolder holder) {
		if (holder == null) {
			Log.e(TAG,
					"*** WARNING *** surfaceCreated() gave us a null surface!");
		}
		if (!hasSurface) {
			hasSurface = true;
			initCamera(holder);
		}
	}

	@Override
	public void surfaceDestroyed(SurfaceHolder holder) {
		hasSurface = false;
	}

	@Override
	public void surfaceChanged(SurfaceHolder holder, int format, int width,
			int height) {

	}

	/**
	 * A valid barcode has been found, so give an indication of success and show
	 * the results.
	 * 
	 * @param rawResult
	 *            The contents of the barcode.
	 * @param scaleFactor
	 *            amount by which thumbnail was scaled
	 * @param barcode
	 *            A greyscale bitmap of the camera data which was decoded.
	 */
	public void handleDecode(Result rawResult, Bitmap barcode, float scaleFactor) {
		inactivityTimer.onActivity();
		lastResult = rawResult;
		System.out.println("result" + lastResult);
		Intent intent = new Intent();
		intent.putExtra("result", lastResult.toString());
		setResult(RESULT_OK, intent);
		this.finish();


//		boolean fromLiveScan = barcode != null;
//		if (fromLiveScan) {
//			// Then not from history, so beep/vibrate and we have an image to
//			// draw on
//			beepManager.playBeepSoundAndVibrate();
//			drawResultPoints(barcode, scaleFactor, rawResult);
//		}
//
//		switch (source) {
//		case NATIVE_APP_INTENT:
//		case NONE:
//			handleDecodeInternally(rawResult, barcode);
//			break;
//		}
	}

//	/**
//	 * Superimpose a line for 1D or dots for 2D to highlight the key features of
//	 * the barcode.
//	 *
//	 * @param barcode
//	 *            A bitmap of the captured image.
//	 * @param scaleFactor
//	 *            amount by which thumbnail was scaled
//	 * @param rawResult
//	 *            The decoded results which contains the points to draw.
//	 */
//	private void drawResultPoints(Bitmap barcode, float scaleFactor,
//			Result rawResult) {
//		ResultPoint[] points = rawResult.getResultPoints();
//		if (points != null && points.length > 0) {
//			Canvas canvas = new Canvas(barcode);
//			Paint paint = new Paint();
//			paint.setColor(getResources().getColor(R.color.result_points));
//			if (points.length == 2) {
//				paint.setStrokeWidth(4.0f);
//				drawLine(canvas, paint, points[0], points[1], scaleFactor);
//			} else if (points.length == 4
//					&& (rawResult.getBarcodeFormat() == BarcodeFormat.UPC_A || rawResult
//							.getBarcodeFormat() == BarcodeFormat.EAN_13)) {
//				// Hacky special case -- draw two lines, for the barcode and
//				// metadata
//				drawLine(canvas, paint, points[0], points[1], scaleFactor);
//				drawLine(canvas, paint, points[2], points[3], scaleFactor);
//			} else {
//				paint.setStrokeWidth(10.0f);
//				for (ResultPoint point : points) {
//					if (point != null) {
//						canvas.drawPoint(scaleFactor * point.getX(),
//								scaleFactor * point.getY(), paint);
//					}
//				}
//			}
//		}
//	}

//	private static void drawLine(Canvas canvas, Paint paint, ResultPoint a,
//			ResultPoint b, float scaleFactor) {
//		if (a != null && b != null) {
//			canvas.drawLine(scaleFactor * a.getX(), scaleFactor * a.getY(),
//					scaleFactor * b.getX(), scaleFactor * b.getY(), paint);
//		}
//	}
//
//	// Put up our own UI for how to handle the decoded contents.
//	private void handleDecodeInternally(Result rawResult, Bitmap barcode) {
//
//		statusView.setVisibility(View.GONE);
//		viewfinderView.setVisibility(View.GONE);
//		resultView.setVisibility(View.VISIBLE);
//
//		ImageView barcodeImageView = (ImageView) findViewById(R.id.barcode_image_view);
//		if (barcode == null) {
//			barcodeImageView.setImageBitmap(BitmapFactory.decodeResource(
//					getResources(), R.drawable.launcher_icon));
//		} else {
//			barcodeImageView.setImageBitmap(barcode);
//		}
//
//		TextView formatTextView = (TextView) findViewById(R.id.format_text_view);
//		formatTextView.setText(rawResult.getBarcodeFormat().toString());
//
//		DateFormat formatter = DateFormat.getDateTimeInstance(DateFormat.SHORT,
//				DateFormat.SHORT);
//		TextView timeTextView = (TextView) findViewById(R.id.time_text_view);
//		timeTextView
//				.setText(formatter.format(new Date(rawResult.getTimestamp())));
//
//		TextView metaTextView = (TextView) findViewById(R.id.meta_text_view);
//		View metaTextViewLabel = findViewById(R.id.meta_text_view_label);
//		metaTextView.setVisibility(View.GONE);
//		metaTextViewLabel.setVisibility(View.GONE);
//		Map<ResultMetadataType, Object> metadata = rawResult
//				.getResultMetadata();
//		if (metadata != null) {
//			StringBuilder metadataText = new StringBuilder(20);
//			for (Map.Entry<ResultMetadataType, Object> entry : metadata
//					.entrySet()) {
//				if (DISPLAYABLE_METADATA_TYPES.contains(entry.getKey())) {
//					metadataText.append(entry.getValue()).append('\n');
//				}
//			}
//			if (metadataText.length() > 0) {
//				metadataText.setLength(metadataText.length() - 1);
//				metaTextView.setText(metadataText);
//				metaTextView.setVisibility(View.VISIBLE);
//				metaTextViewLabel.setVisibility(View.VISIBLE);
//			}
//		}
//
//	}

	private void initCamera(SurfaceHolder surfaceHolder) {
		if (surfaceHolder == null) {
			throw new IllegalStateException("No SurfaceHolder provided");
		}
		if (cameraManager.isOpen()) {
			Log.w(TAG,
					"initCamera() while already open -- late SurfaceView callback?");
			return;
		}
		try {
			cameraManager.openDriver(surfaceHolder);
			// Creating the handler starts the preview, which can also throw a
			// RuntimeException.
			if (handler == null) {
				handler = new CaptureActivityHandler(this, decodeFormats,
						decodeHints, characterSet, cameraManager);
			}
			decodeOrStoreSavedBitmap(null, null);
		} catch (IOException ioe) {
			Log.w(TAG, ioe);
			displayFrameworkBugMessageAndExit();
		} catch (RuntimeException e) {
			// Barcode Scanner has seen crashes in the wild of this variety:
			// java.?lang.?RuntimeException: Fail to connect to camera service
			Log.w(TAG, "Unexpected error initializing camera", e);
			displayFrameworkBugMessageAndExit();
		}
	}

	private void displayFrameworkBugMessageAndExit() {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle(getString(R.string.app_name));
		builder.setMessage(getString(R.string.msg_camera_framework_bug));
		builder.setPositiveButton(R.string.button_ok, new FinishListener(this));
		builder.setOnCancelListener(new FinishListener(this));
		builder.show();
	}

//	public void restartPreviewAfterDelay(long delayMS) {
//		if (handler != null) {
//			handler.sendEmptyMessageDelayed(R.id.restart_preview, delayMS);
//		}
//		resetStatusView();
//	}

	private void resetStatusView() {
//		resultView.setVisibility(View.GONE);
//		statusView.setText(R.string.msg_default_status);
//		statusView.setVisibility(View.VISIBLE);
		viewfinderView.setVisibility(View.VISIBLE);
		lastResult = null;
	}

	public void drawViewfinder() {
		viewfinderView.drawViewfinder();
	}
}
