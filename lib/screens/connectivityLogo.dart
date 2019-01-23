import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:photo_sync/utils/dbUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_sync/utils/connectivityNotification.dart';

class ConnectivityLogo extends StatefulWidget {
  @override
  _ConnectivityLogoState createState() => _ConnectivityLogoState();
}

class _ConnectivityLogoState extends State<ConnectivityLogo> {
	StreamSubscription<ConnectivityResult> _subscription;
	final Connectivity _connectivity = Connectivity();
	String _connectStatus = 'Unknown';
	String _wifiName = 'Unknown';

	Future<void> getWifiInfo() async {
		String connectStatus;
		String wifiName;

		try {
			wifiName = (await _connectivity.getWifiName()).toString();
			if (wifiName == 'null') {
				connectStatus = 'Unknown';
				wifiName = 'Unknown';
			} else {
				connectStatus = (await _connectivity.checkConnectivity()).toString();
			}
		} on PlatformException catch (e) {
			print(e.toString());
			connectStatus = 'Unknown';
		}

		if (!mounted) {
			return;
		}

		// 网络状态变化，发送通知
		ConnectivityNotification(_wifiName).dispatch(context);

		setState(() {
			_connectStatus = connectStatus;
			_wifiName = wifiName;
		});
	}

	@override
  void initState() {
		getWifiInfo();

		_subscription = _connectivity.onConnectivityChanged.listen(
			(ConnectivityResult result) {
				getWifiInfo();
			}
		);

    super.initState();
  }



  @override
  void dispose() async {
		if (_subscription != null) {
			_subscription.cancel();
		}

    await closeDb();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
	    child: Logo(wifiName: _wifiName, connectType: _connectStatus,),
    );
  }
}

class Logo extends StatelessWidget {
	final String wifiName;
	final String connectType;

	Logo({Key key, this.wifiName, this.connectType}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		if (connectType != 'Unknown') {
			return Container(
				padding: const EdgeInsets.symmetric(horizontal: 10.0),
				child: Center(
					child: connectType == 'ConnectivityResult.wifi'
							? Icon(Icons.signal_wifi_4_bar, color: Colors.green,)
							: Icon(Icons.signal_cellular_4_bar, color: Colors.blueGrey,),
				),
			);
		} else {
			return Container(
				padding: const EdgeInsets.symmetric(horizontal: 10.0),
				child: Center(
					child: Icon(Icons.error, color: Colors.redAccent,),
				),
			);
		}
	}
}
