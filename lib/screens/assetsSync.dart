import 'package:flutter/material.dart';
import 'photoGrid.dart';
import 'package:photo_sync/models/assetModel.dart';

class AssetsSyncPage extends StatefulWidget {
	final List<AssetModel> assetsModel;
	final String wifiName;

	AssetsSyncPage({Key key, this.assetsModel, this.wifiName}) : super(key: key);

  @override
  AssetsSyncPageState createState() {
    return new AssetsSyncPageState();
  }
}

class AssetsSyncPageState extends State<AssetsSyncPage> {
	int _syncCount;

	@override
	Widget build(BuildContext context) {
		_syncCount = widget.assetsModel.length;
		return Container(
			child: Column(
			  children: <Widget>[
				  Expanded(
					  flex: 1,
					  child: Container(
						  decoration: BoxDecoration(color: Colors.blue),
						  child: Column(
							  children: <Widget>[
							  	Expanded(
									  flex: 1,
									  child: Row(
										  mainAxisAlignment: MainAxisAlignment.center,
									    children: <Widget>[
									    	Container(
												    child: widget.wifiName == "Unknown" || widget.wifiName == null
														    ? Icon(Icons.sync_disabled, color: Colors.red[300],)
														    : Icon(Icons.sync, color: Colors.lightGreenAccent,)
										    ),
									      Center(
										      child: widget.wifiName == "Unknown" || widget.wifiName == null
												      ? Text("等待WiFi，同步暂停", style: TextStyle(color: Colors.white),)
												      : Text("${widget.wifiName}", style: TextStyle(color: Colors.white, fontSize: 18.0),),
									      ),
									    ],
									  ),
								  ),
							  	Expanded(
									  flex: 4,
									  child: Center(
										  child: Text(
												'$_syncCount',
											  style: TextStyle(fontSize: 120.0, color: Colors.amber[700], fontWeight: FontWeight.bold),
										  ),
									  ),
								  )
							  ],
						  ),
					  ),
				  ),
			  	Expanded(
					  flex: 2,
						child: PhotoGrid(photos: widget.assetsModel,),
				  )
			  ],
			)
		);
	}
}
