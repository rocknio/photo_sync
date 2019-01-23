import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_sync/models/assetModel.dart';
import 'package:photo_sync/screens/assetsSync.dart';
import 'package:photo_sync/screens/connectivityLogo.dart';
import 'package:photo_sync/utils/dbUtils.dart';

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
  Future<void> refreshAssets() async {
    List<AssetEntity> tmpList;
    var result = await PhotoManager.requestPermission();
    if (!(result == true)) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('没有读取系统相册权限!')));
      return;
    } else {
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
  }

  @override
  void initState() {
    refreshAssets();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Photo Sync'),
          actions: <Widget>[
            ConnectivityLogo(),
          ],
        ),
        body: AssetsSyncPage(assetsModel: widget.allAssets.assets),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Only for test
            await deleteDiscardServer();
            await deleteServer();
          },
          child: Icon(Icons.restore),
        ),
    );
  }

//  void _openSetting() {
//    PhotoManager.openSetting();
//  }
}
