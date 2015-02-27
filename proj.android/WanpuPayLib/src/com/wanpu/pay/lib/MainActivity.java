package com.wanpu.pay.lib;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.wanpu.pay.PayConnect;
import com.wanpu.pay.PayResultListener;
import com.wanpu.pay.demo.R;

public class MainActivity extends Activity {

	// 应用或游戏商自定义的支付订单(每条支付订单数据不可相同)
	String orderId = "";
	// 用户标识
	String userId = "";
	// 支付商品名称
	String goodsName = "Gamee钻石";
	// 支付金额
	float price = 0.0f;
	// 支付时间
	String time = "";
	// 支付描述
	String goodsDesc = "";
	// 应用或游戏商服务器端回调接口
	String notifyUrl = "http://115.29.110.108/pay";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(savedInstanceState);
		this.setContentView(R.layout.main);

		// 初始化统计器(必须调用)
		PayConnect
				.getInstance("edf12fcf18bf6ef63b8462c790c6f380", "WAPS", this);

		TextView goodsNameView = (TextView) this.findViewById(R.id.goodsName);
		goodsNameView.setText(goodsName);

		final EditText amountView = (EditText) this.findViewById(R.id.amount);

		TextView detailsView = (TextView) this.findViewById(R.id.details);
		goodsDesc = "购买" + goodsName;
		detailsView.setText(goodsDesc);

//		userId = PayConnect.getInstance(MainActivity.this).getDeviceId(
//				MainActivity.this);
		userId = "10003";

		Button submitButton = (Button) this.findViewById(R.id.submitBtn);

		// 支付SDK版本号
		TextView sdkVersionView = (TextView) this.findViewById(R.id.sdkVersion);
		sdkVersionView.setText("SDK版本：" + PayConnect.LIBRARY_VERSION_NUMBER);

		submitButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				try {
					// // 游戏商自定义支付订单号，保证该订单号的唯一性，建议在执行支付操作时才进行该订单号的生成
					orderId = System.currentTimeMillis() + "";

					String amountStr = amountView.getText().toString();
					if (!"".equals(amountStr)) {
						price = Float.valueOf(amountStr);
					} else {
						price = 0.0f;
					}
					
					price = 0.01f;

					PayConnect.getInstance(MainActivity.this).pay(
							MainActivity.this, orderId, userId, price,
							goodsName, goodsDesc, notifyUrl,
							new MyPayResultListener());

				} catch (NumberFormatException e) {
					e.printStackTrace();
				}
			}
		});

	}

	@Override
	protected void onDestroy() {
		// 以前版本的finalize()方法作废
		PayConnect.getInstance(this).close();
		super.onDestroy();
	}

	/**
	 * 自定义Listener实现PaySuccessListener，用于监听支付成功
	 * 
	 * @author Administrator
	 * 
	 */
	private class MyPayResultListener implements PayResultListener {

		@Override
		public void onPayFinish(Context payViewContext, String orderId,
				int resultCode, String resultString, int payType, float amount,
				String goodsName) {
			// 可根据resultCode自行判断
			if (resultCode == 0) {
				Toast.makeText(getApplicationContext(),
						resultString + "：" + amount + "元", Toast.LENGTH_LONG)
						.show();
				// 支付成功时关闭当前支付界面
				PayConnect.getInstance(MainActivity.this).closePayView(
						payViewContext);

				// TODO 在客户端处理支付成功的操作

				// 未指定notifyUrl的情况下，交易成功后，必须发送回执
				PayConnect.getInstance(MainActivity.this).confirm(orderId,
						payType);
			} else {
				Toast.makeText(getApplicationContext(), resultString,
						Toast.LENGTH_LONG).show();
			}
		}
	}

}
