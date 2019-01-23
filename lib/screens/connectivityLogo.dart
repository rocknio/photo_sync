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
import 'package:photo_sync/utils/dbUtils.dart';
import 'package:flutter/cupertino.dart';

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
	bool _isDbInitialized = false;

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

	void addDiscardServer(String serverHashCode) async {
		await insertDiscardServer(serverHashCode);
	}

	void displayDialog(Server serverInfo) {
		showDialog(
				context: context,
				builder: (BuildContext context) => CupertinoAlertDialog(
					title: Text("同步？"),
					content: Container(
						padding: EdgeInsets.symmetric(vertical: 30.0),
						height: 100.0,
						child: Column(
							children: <Widget>[
								Expanded(child: Text("WiFi：$_wifiName", style: TextStyle(fontWeight: FontWeight.bold),)),
								Expanded(child: Text("服务器：${serverInfo.serverHashCode}", style: TextStyle(color: Colors.grey),))
							],
						),
					),
					actions: <Widget>[
						CupertinoDialogAction(
							isDefaultAction: true,
							child: Text("整"),
							onPressed: () {
								Navigator.of(context, rootNavigator: true).pop();
								registerToServer(serverInfo);
							},
						),
						CupertinoDialogAction(
							child: Text("不約"),
							onPressed: () {
								Navigator.of(context, rootNavigator: true).pop();
								addDiscardServer(serverInfo.serverHashCode);
							},
						)
					],
				)
		);
	}

	Future<void> registerToServer(Server server) async {
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
		if (resp.statusCode == 200 ) {
			await insertServer(server.serverHashCode);
		}
	}

	deviceRegister(String udpServerMsg) async {
		// 如果device info还未获取，数据库未初始化完成，跳过，等待下一次消息
		if (_deviceInfo == null || _isDbInitialized == false) {
			return;
		}

		Map serverMap = jsonDecode(udpServerMsg);
		Server server = Server.fromJson(serverMap);

		// 如果是已經忽略的server，跳過注冊
		bool isDiscardServer = await checkDiscardServer(server.serverHashCode);
		if (isDiscardServer) {
			print("Server - ${server.serverHashCode} is discard!!!!!!!!");
			return;
		}

		// 檢查是否已經注冊過
		bool isSyncServer = await checkServer(server.serverHashCode);
		if (!isSyncServer) {
			displayDialog(server);
		} else {
			print("Server - ${server.serverHashCode} is already registered!!!!!!!!");
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
		_isDbInitialized = await initLocalDb();
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
