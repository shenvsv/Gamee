/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 ****************************************************************************/
package prime.bacoo.gamee;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.ViewGroup.LayoutParams;
import android.webkit.CookieManager;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.android.Contents;
import com.google.zxing.client.android.Intents;
import com.wanpu.pay.PayConnect;
import com.wanpu.pay.PayResultListener;

public class Gamee extends Cocos2dxActivity {
	static Gamee gamee = null;
	static WebView m_webView;
	static FrameLayout m_webLayout;

	// about qr
	protected static final int REQUEST_CODE = 0;
	protected static final int REQUEST_CODE_SHOW = 0;
	private static int luaFun = 0;

	// about pay
	private String wapsKey = "edf12fcf18bf6ef63b8462c790c6f380";
	private String publishWay = "gamee内测";

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		gamee = this;
		m_webLayout = new FrameLayout(this);
		FrameLayout.LayoutParams lytp = new FrameLayout.LayoutParams(
				LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
		lytp.gravity = Gravity.CENTER;
		gamee.addContentView(m_webLayout, lytp);

		// 初始化统计器(必须调用)
		PayConnect.getInstance(wapsKey, publishWay, this);
	}

	static {
		System.loadLibrary("game");
	}

	public static void login() {
		gamee.runOnUiThread(new Runnable() {
			public void run() {
				m_webView = new WebView(gamee);
				m_webView.getSettings().setJavaScriptEnabled(true);
				m_webView.getSettings().setSupportZoom(true);
				m_webView.getSettings().setBuiltInZoomControls(true);
                m_webView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
				m_webView
						.loadUrl("https://open.yixin.im/oauth/authorize?response_type=code&client_id=yxe957c97fa9bd4d799c3d50be38e6d4ac");
				m_webView.requestFocus();
				m_webView.setWebViewClient(new WebViewClient() {
					public boolean shouldOverrideUrlLoading(WebView view,
							String url) {
						if (url.indexOf("tel:") < 0) {
							view.loadUrl(url);
						}
						return true;
					}
				});
				m_webView.setWebViewClient(new WebViewClient() {
					public void onPageFinished(WebView view, String url) {
						String string = url.substring((url.length() - 11),
								url.length() - 7);
						if (string.equals("code")) {
							String tokenString = url.substring(
									(url.length() - 6), url.length());
							Cocos2dxLuaJavaBridge
									.callLuaGlobalFunctionWithString(
                                            "yixin_callback", tokenString);
							removeWebView();
						}
						return;
					}
				});
				m_webLayout.addView(m_webView);
			}
		});
	}

	@Override
	public boolean onKeyDown(int keyCoder, KeyEvent event) {
        if (m_webView != null){
            if (m_webView.canGoBack() && keyCoder == KeyEvent.KEYCODE_BACK ) {
                m_webView.goBack();
            } else {
                removeWebView();
            }
        }
		return false;
	}

	public static void removeWebView() {
		m_webLayout.removeView(m_webView);
		m_webView.destroy();
        CookieManager cookieManager = CookieManager.getInstance();
        cookieManager.removeAllCookie();
	}

	// show qr
	public static void showQr(final String text) {
		gamee.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				launchShow(text);
			}
		});
	}

	// scan qr
	public static void scanQr(final int fun) {
		gamee.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				luaFun = fun;
				launchScan();
			}
		});
	}

	private static void launchShow(String text) {
		Intent intent = new Intent(Intents.Encode.ACTION);
		intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET);
		intent.putExtra(Intents.Encode.TYPE, Contents.Type.TEXT);
		intent.putExtra(Intents.Encode.DATA, text);
		intent.putExtra(Intents.Encode.FORMAT, BarcodeFormat.QR_CODE.toString());
		gamee.startActivityForResult(intent, REQUEST_CODE_SHOW);
	}

	private static void launchScan() {
		Intent intent = new Intent(Intents.Scan.ACTION);
		gamee.startActivityForResult(intent, REQUEST_CODE);
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		super.onActivityResult(requestCode, resultCode, data);
		// System.out.println(requestCode);
		switch (requestCode) {
		case REQUEST_CODE:
			if (resultCode == RESULT_OK && luaFun != 0) {
				final String result = data.getStringExtra("result");
				gamee.runOnGLThread(new Runnable() {
					@Override
					public void run() {
						// TODO Auto-generated method stub
						Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFun,
								result);
						Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFun);
						luaFun = 0;
					}
				});
			}
			break;
		}
	}

	// pay
	public static void pay(final String userId, final float diamond,
			final int fun) {
		int n = (int) diamond;
		// 应用或游戏商自定义的支付订单(数据不可相同)
		final String orderId = userId + System.currentTimeMillis();
		// 支付商品名称
		final String goodsName = "Gamee钻石" + n + "个";
		// 支付金额
		final float price = (float) (0.01 * n);
		System.out.println(price);
		// 支付描述
		final String goodsDesc = "购买Gamee钻石";
		// 应用或游戏商服务器端回调接口
		final String notifyUrl = "http://115.29.110.108/pay";
		System.out.println(orderId);
		gamee.runOnUiThread(new Runnable() {

			@Override
			public void run() {
				// TODO Auto-generated method stub
				PayConnect.getInstance(gamee).pay(gamee, orderId, userId,
						price, goodsName, goodsDesc, notifyUrl,
						new PayResultListener() {

							@Override
							public void onPayFinish(Context payViewContext,
									String s_orderId, int resultCode,
									String resultString, int payType,
									float amount, String goodsName) {
								// TODO Auto-generated method stub
								String stutas = "";
								String message = "";
								System.out.println(s_orderId + "/" + orderId);
								// if (s_orderId != orderId) {
								// return;
								// }

								if (resultCode == 0) {
									PayConnect.getInstance(gamee).closePayView(
											payViewContext);
									stutas = "ok";
									message = resultString + "：" + amount + "元";
								} else {
									stutas = "err";
									message = resultString;
								}
								// System.out.println(resultCode+resultString+s_orderId);
								JSONObject jsonObject = new JSONObject();
								try {
									jsonObject.put("stu", stutas);
									jsonObject.put("msg", message);
								} catch (JSONException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
								final String json = jsonObject.toString();
								// System.out.println("sdjak"+json);
								gamee.runOnGLThread(new Runnable() {

									@Override
									public void run() {
										// TODO Auto-generated method stub
										Cocos2dxLuaJavaBridge
												.callLuaFunctionWithString(fun,
														json);
										Cocos2dxLuaJavaBridge
												.releaseLuaFunction(fun);
									}
								});

							}
						});
			}
		});

	}

	//解压
	public static void Unzip(final String zipFile, final String targetDir,final int fun) {
		int BUFFER = 4096; // 这里缓冲区我们使用4KB，
		String strEntry; // 保存每个zip的条目名称

		try {
			BufferedOutputStream dest = null; // 缓冲输出流
			FileInputStream fis = new FileInputStream(zipFile);
			ZipInputStream zis = new ZipInputStream(
					new BufferedInputStream(fis));
			ZipEntry entry; // 每个zip条目的实例

			while ((entry = zis.getNextEntry()) != null) {

				try {
					Log.i("Unzip: ", "=" + entry);
					int count;
					byte data[] = new byte[BUFFER];
					strEntry = entry.getName();

					File entryFile = new File(targetDir + strEntry);
					File entryDir = new File(entryFile.getParent());
					if (!entryDir.exists()) {
						entryDir.mkdirs();
					}

					FileOutputStream fos = new FileOutputStream(entryFile);
					dest = new BufferedOutputStream(fos, BUFFER);
					while ((count = zis.read(data, 0, BUFFER)) != -1) {
						dest.write(data, 0, count);
					}
					dest.flush();
					dest.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
			zis.close();
			Cocos2dxLuaJavaBridge.callLuaFunctionWithString(fun,
					"ok");
			Cocos2dxLuaJavaBridge.releaseLuaFunction(fun);
		} catch (Exception cwj) {
			cwj.printStackTrace();
			Cocos2dxLuaJavaBridge.callLuaFunctionWithString(fun,
					"sorry");
			Cocos2dxLuaJavaBridge.releaseLuaFunction(fun);
		}
	}

	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		PayConnect.getInstance(gamee).close();
		super.onDestroy();
	}
}
