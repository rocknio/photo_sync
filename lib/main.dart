import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
//import 'package:photo_sync/screens/assetsGrid.dart';
import 'package:photo_sync/models/assetModel.dart';
import 'package:photo_sync/screens/assetsSync.dart';

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

      for (AssetPathEntity oneAssetPath in list) {
        if (oneAssetPath.name.toLowerCase() == 'Camera'.toLowerCase()) {
          widget.allAssets.assetPath = oneAssetPath;
          tmpList = await oneAssetPath.assetList;
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
        body: AssetsSyncPage(assetsModel: widget.allAssets.assets),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            refreshAssets();
          },
          child: Icon(Icons.sync),
        ),
    );
  }

//  void _openSetting() {
//    PhotoManager.openSetting();
//  }
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

