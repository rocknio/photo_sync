import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';
import 'package:photo_sync/models/deviceInfoModel.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:photo_sync/models/server.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:photo_sync/utils/dbUtils.dart';

class ConnectivityLogo extends StatefulWidget {
  @override
  _ConnectivityLogoState createState() => _ConnectivityLogoState();
}

class _ConnectivityLogoState extends State<ConnectivityLogo> {
	StreamSubscription<ConnectivityResult> _subscription;
	final Connectivity _connectivity = Connectivity();
	String _connectStatus = 'Unknown';
	String _wifiName = 'Unknown';
	DeviceInfo _deviceInfo;
	bool _isRegistered = false;
	Database _db;

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

		setState(() {
			_connectStatus = connectStatus;
			_wifiName = wifiName;
		});
	}

	generateMd5(String data) {
		var content = new Utf8Encoder().convert(data);
		var md5 = crypto.md5;
		var digest = md5.convert(content);
		return hex.encode(digest.bytes);
	}

	Future<void> getDeviceInfo() async {
		DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
		if ( Platform.isAndroid ) {
			AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
			_deviceInfo = DeviceInfo();
			_deviceInfo.brand = androidInfo.brand;
			_deviceInfo.device = androidInfo.device;
			_deviceInfo.deviceId = androidInfo.androidId;
			_deviceInfo.clientHashCode = generateMd5(_deviceInfo.brand + _deviceInfo.device + _deviceInfo.deviceId);
		} else if ( Platform.isIOS ) {
			IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
			print("Running on IOS: $iosInfo");
		}

//		String ip = await GetIp.ipAddress;
//		print("Ip Address = $ip ------------------------");
	}

	deviceRegister(String udpServerMsg) async {
		// 如果device info还未获取，跳过，等待下一次消息
		if (_deviceInfo == null || _db == null) {
			return;
		}

		// 已经注册过，跳过注册流程
		if (_isRegistered) {
			return;
		} else {
			_isRegistered = true;
		}

		Map serverMap = jsonDecode(udpServerMsg);
		Server server = Server.fromJson(serverMap);

		var now = new DateTime.now();
		var formatter = new DateFormat("yyyyMMddHHmmss");
		var transId = formatter.format(now);
		String httpBody = '{"tranId": "$transId","brand": "${_deviceInfo.brand}","device": "${_deviceInfo.device}","client_hash_code": "${_deviceInfo.deviceId}"}';

		String url = server.registerUrl + "/" + _deviceInfo.deviceId;
		Map<String, String> headers = {
			"Content-type": "application/json",
			"Accept": "application/json",
		};

		final resp = await http.post(url, body: httpBody, headers: headers);
		if (resp.statusCode != 200 ) {
			_isRegistered = false;
		}
	}

	startUdpServer() {
		var addr = InternetAddress.anyIPv4;
		int port = 21216;

		RawDatagramSocket.bind(addr, port).then((RawDatagramSocket udpSocket) {
			udpSocket.listen((RawSocketEvent event) {
				if ( event == RawSocketEvent.read ) {
					Datagram dg = udpSocket.receive();
					deviceRegister(new String.fromCharCodes(dg.data));
				}
			});
		});
	}

	Future<void> doDbInit() async {
		_db = await initLocalDb();
	}

	@override
  void initState() {
		// 启动udp server 接收局域网内own_fog的广播
		startUdpServer();

		// 初始化本地数据库
		doDbInit();

		getWifiInfo();

		_subscription = _connectivity.onConnectivityChanged.listen(
			(ConnectivityResult result) {
				getWifiInfo();
			}
		);

		getDeviceInfo();

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
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
