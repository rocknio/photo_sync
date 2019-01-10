import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_sync/screens/assetsGrid.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<ConnectivityResult> _subscription;
  final Connectivity _connectivity = Connectivity();
  String _connectStatus = 'Unknown';
  String _wifiName = 'Unknown';
  bool _isSync = false;
  var _pathList = <AssetEntity>[];

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
      connectStatus = 'Failed to get connectivity';
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _connectStatus = connectStatus;
      _wifiName = wifiName;
    });
  }

  Future<void> refreshAssets() async {
    List<AssetEntity> tmpList;
    var result = await PhotoManager.requestPermission();
    if (!(result == true)) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('没有读取系统相册权限!')));
      return;
    } else {
      List<AssetPathEntity> list = await PhotoManager.getAssetPathList(hasVideo: true);

      for (AssetPathEntity oneAsset in list) {
        if (oneAsset.name.toLowerCase() == 'Camera'.toLowerCase()) {
          tmpList = await oneAsset.assetList;
        }
      }

      if (!mounted) {
        return;
      }

      _pathList.clear();
      _pathList.addAll(tmpList);

      setState(() {

      });
    }
  }

  @override
  void initState() {
    getWifiInfo();
    refreshAssets();

    _subscription = _connectivity.onConnectivityChanged.listen(
        (ConnectivityResult result) {
          getWifiInfo();
        }
    );
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Sync'),
        actions: <Widget>[
          ConnectivityLogo(wifiName: _wifiName, connectType: _connectStatus,),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset('assets/images/sync_logo.png'),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.message, color: Colors.blue,),
              title: Text('当前Wifi：$_wifiName'),
              onTap: () {
              },
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Icon(Icons.sync, color: Colors.blue,),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text('在该Wifi下同步')
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Switch(
                    value: _isSync,
                    onChanged: (result) {
                      setState(() {
                        _isSync = result;
                      });
                    },
                  ),
                )
              ],
            ),
            ListTile(
              onTap: _openSetting,
              leading: Icon(Icons.settings_applications, color: Colors.blue,),
              title: Text('应用设置'),
            ),
          ],
        ),
      ),
      body: AssetsGridPage(assetsList: _pathList,),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          refreshAssets();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  void _openSetting() {
    PhotoManager.openSetting();
  }
}

class ConnectivityLogo extends StatelessWidget {
  final String wifiName;
  final String connectType;

  ConnectivityLogo({Key key, this.wifiName, this.connectType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (connectType != 'Unknown') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
          child: connectType == 'ConnectivityResult.wifi'
                  ? Icon(Icons.signal_wifi_4_bar, color: Colors.lightGreenAccent,)
                  : Icon(Icons.signal_cellular_4_bar, color: Colors.lightGreenAccent,),
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

