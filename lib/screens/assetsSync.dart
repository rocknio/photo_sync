import 'package:flutter/material.dart';
import 'photoGrid.dart';
import 'package:photo_sync/models/assetModel.dart';

class AssetsSyncPage extends StatelessWidget {
	final List<AssetModel> assetsModel;

	AssetsSyncPage({Key key, this.assetsModel}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Container(
			child: Column(
			  children: <Widget>[
				  Expanded(
					  flex: 1,
					  child: Container(
						  decoration: BoxDecoration(color: Colors.blue),
					  ),
				  ),
			  	Expanded(
					  flex: 2,
						child: PhotoGrid(photos: assetsModel,),
				  )
			  ],
			)
		);
	}
}
