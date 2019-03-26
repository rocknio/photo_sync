import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_sync/models/assetModel.dart';
import 'package:photo_sync/screens/assetsSync.dart';
import 'package:photo_sync/screens/connectivityLogo.dart';
import 'package:photo_sync/utils/dbUtils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';
import 'package:photo_sync/models/deviceInfoModel.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:photo_sync/models/server.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:photo_sync/screens/photoGrid.dart';
import 'package:photo_sync/grpc/own_fog_client.dart';

void main() {
  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PhotoSync',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final AllAssets allAssets = AllAssets();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _wifiName;
  DeviceInfo _deviceInfo;
  bool _isDbInitialized = false;
  bool _isNotifying = false;
  Timer _loopTimer;
  Server _server = Server("", 0, "");
  bool isStartSync = false;

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
  }

  void addDiscardServer(String serverHashCode) async {
    await insertDiscardServer(serverHashCode);

    _isNotifying = false;
  }

  void displayDialog(Server serverInfo) {
    if (_isNotifying != true) {
      _isNotifying = true;
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
      _server.isConfirmed = true;
    }

    _isNotifying = false;
  }

  bool isInitProcessDone(bool isCheckServer) {
    // 如果device info还未获取，数据库未初始化完成，跳过，等待下一次消息
    print("***************************************************************");
    print(_deviceInfo.deviceId);
    print(_isDbInitialized);
    print(widget.allAssets.assets.length);
    print(_wifiName);
    print(_server.isConfirmed);
    print("***************************************************************");
    if (isCheckServer) {
      return (_deviceInfo == null || _isDbInitialized == false || widget.allAssets.assets.length == 0 || _wifiName == 'Unknown' || _server.isConfirmed == false);
    } else {
      return (_deviceInfo == null || _isDbInitialized == false || widget.allAssets.assets.length == 0 || _wifiName == 'Unknown');
    }
  }

  deviceRegister(String udpServerMsg) async {
    if (isInitProcessDone(false)) {
      return;
    }

    Map serverMap = jsonDecode(udpServerMsg);
    _server = Server.fromJson(serverMap);
    _server.isConfirmed = false;

    // 如果是已經忽略的server，跳過注冊
    bool isDiscardServer = await checkDiscardServer(_server.serverHashCode);
    if (isDiscardServer) {
      print("Server - ${_server.serverHashCode} is discard!!!!!!!!");
      return;
    }

    // 檢查是否已經注冊過
    bool isSyncServer = await checkServer(_server.serverHashCode);
    if (!isSyncServer) {
      displayDialog(_server);
    } else {
      _server.isConfirmed = true;
      print("Server - ${_server.serverHashCode} is already registered!!!!!!!!");
    }
  }

  startUdpServer() {
    var addr = InternetAddress.anyIPv4;
    int port = 21216;

    RawDatagramSocket.bind(addr, port).then((RawDatagramSocket udpSocket) {
      udpSocket.listen((RawSocketEvent event) {
        if ( event == RawSocketEvent.read ) {
          Datagram dg = udpSocket.receive();
          deviceRegister(String.fromCharCodes(dg.data));
        }
      });
    });
  }

  Future<void> doDbInit() async {
    _isDbInitialized = await initLocalDb();
  }

  Future<void> refreshAssetsWithPermission() async {
    List<AssetEntity> tmpList;
    List<AssetPathEntity> list = await PhotoManager.getAssetPathList(hasVideo: true);

    widget.allAssets.clearAsset();

    for (AssetPathEntity oneAssetPath in list) {
      if (oneAssetPath.name.toLowerCase() == 'Camera'.toLowerCase()) {
        widget.allAssets.assetPath = oneAssetPath;
        tmpList = await oneAssetPath.assetList;
        // 確認是系統相冊
        if (!tmpList[0].id.contains("Baidu")) {
          break;
        }
      }
    }

    if (!mounted) {
      return;
    }

    for (AssetEntity one_asset in tmpList) {
      widget.allAssets.addAsset(one_asset);
    }

    setState(() {

    });
  }

  Future<void> refreshAssets() async {
    var result = await PhotoManager.requestPermission();
    if (!(result == true)) {
      Flushbar(flushbarPosition: FlushbarPosition.BOTTOM,)
        ..title = "亲"
        ..message = "让我读相册啊......"
        ..icon = Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.red[300],
        )
        ..duration = Duration(seconds: 5)
        ..leftBarIndicatorColor = Colors.blue[300]
        ..backgroundColor = Colors.red
        ..shadowColor = Colors.blue[800]
        ..backgroundGradient = LinearGradient(colors: [Colors.blueGrey, Colors.black])
        ..isDismissible = false
        ..mainButton = FlatButton(
          child: Icon(Icons.album, color: Colors.blue[300], size: 30.0,),
          onPressed: () async {
            var result = await PhotoManager.requestPermission();
            if (result) {
              refreshAssetsWithPermission();
            }
          },
        )
        ..show(context);
    } else {
      refreshAssetsWithPermission();
    }
  }

  void startSyncLoop() {
    if (_loopTimer != null) {
      _loopTimer.cancel();
    }

    if (!isStartSync) {
      _loopTimer = Timer.periodic(Duration(seconds: 5), (_) async {
        if (!isInitProcessDone(true)) {
          isStartSync = true;
          await uploadFile(_server, widget.allAssets.assets[0], _deviceInfo.deviceId);
          isStartSync = false;
        }
      });
    }
  }

  @override
  void initState() {
    _server.isConfirmed = false;

    refreshAssets();

    // 初始化本地数据库
    doDbInit();

    getDeviceInfo();

    // 启动udp server 接收局域网内own_fog的广播
    startUdpServer();

    // 启动同步操作
    startSyncLoop();

    super.initState();
  }

  @override
  void dispose() async {
    await closeDb();
    _loopTimer.cancel();
    grpcDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        setState(() {
          _wifiName = notification.msg;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Photo Sync'),
          actions: <Widget>[
            ConnectivityLogo(),
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: AssetsSyncPage(assetsModel: widget.allAssets.assets, wifiName: _wifiName,),
              ),
              Expanded(
                flex: 1,
                child: PhotoGrid(photos: widget.allAssets.assets,),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Only for test
            await deleteDiscardServer();
            await deleteServer();
            await deleteAssets();
            refreshAssets();
          },
          child: Icon(Icons.restore, size: 30.0,),
        ),
      ),
    );
  }

//  void _openSetting() {
//    PhotoManager.openSetting();
//  }
}
