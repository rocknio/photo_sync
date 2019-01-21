import 'package:flutter/material.dart';
import 'photoGrid.dart';
import 'package:photo_sync/models/assetModel.dart';

class AssetsSyncPage extends StatefulWidget {
	final List<AssetModel> assetsModel;

	AssetsSyncPage({Key key, this.assetsModel}) : super(key: key);

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
						  child: Row(
							  children: <Widget>[
							  	Expanded(
									  child: Center(
										  child: Text(
												'$_syncCount',
											  style: TextStyle(fontSize: 120.0, color: Colors.amberAccent, fontWeight: FontWeight.bold),
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
