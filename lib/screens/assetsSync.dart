import 'package:flutter/material.dart';
import 'package:photo_sync/models/assetModel.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:photo_sync/utils/eventUtils.dart';

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
	int _syncCount = 0;
	int _totalCount = 0;
	double _percent = 0.0;
	bool _isInitialized = false;

	void initCount() {
		_totalCount = widget.assetsModel.length;
		_syncCount = _totalCount;
		_percent = _syncCount / _totalCount;
	}

	@override
  void initState() {
		eventBus.on<CountDownEvent>().listen((event){
			setState(() {
			  _syncCount = _syncCount - event.step;
			  _percent = _syncCount / _totalCount;
			});
		});

    super.initState();
  }

	@override
	Widget build(BuildContext context) {
		if (widget.assetsModel.length > 0 && _isInitialized == false) {
			initCount();
			_isInitialized = true;
		}
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
										  animation: false,
										  animationDuration: 1200,
										  lineWidth: 13.0,
										  percent: _percent,
										  center: Text(
											  '$_syncCount' + '/' + '$_totalCount',
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
