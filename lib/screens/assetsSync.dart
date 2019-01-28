import 'package:flutter/material.dart';
import 'package:photo_sync/models/assetModel.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
							  crossAxisAlignment: CrossAxisAlignment.center,
							  children: <Widget>[
							  	Expanded(
									  flex: 3,
									  child: CircularPercentIndicator(
										  radius: 150.0,
										  animation: true,
										  animationDuration: 1200,
										  lineWidth: 13.0,
										  percent: 0.7,
										  center: Text(
											  '$_syncCount',
											  style: TextStyle(fontSize: 30.0, color: Colors.amber[700], fontWeight: FontWeight.bold),
										  ),
										  progressColor: Colors.amber[700],
										  circularStrokeCap: CircularStrokeCap.round,
									  ),
								  ),
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
							  ],
						  ),
					  ),
				  ),
			  ],
			)
		);
	}
}
