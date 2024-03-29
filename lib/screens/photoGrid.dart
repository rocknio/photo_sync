import 'dart:typed_data';
import 'package:photo_sync/models/assetModel.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_sync/screens/assetContainer.dart';

class PhotoGrid extends StatefulWidget {
	final List<AssetModel> photos;

	PhotoGrid({this.photos});

	@override
	_PhotoGridState createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
	@override
	Widget build(BuildContext context) {
		return GridView.builder(
			gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
				crossAxisCount: 3,
				childAspectRatio: 1.0,
			),
			itemBuilder: _buildItem,
			itemCount: widget.photos.length,
//			scrollDirection: Axis.horizontal,
		);
	}

	Widget _buildItem(BuildContext context, int index) {
		AssetEntity entity = widget.photos[index].asset;
		print("request index = $index , image id = ${entity.id} type = ${entity.type}");

		Future<Uint8List> thumbDataWithSize = entity.thumbDataWithSize(300, 300);

		return FutureBuilder<Uint8List>(
			future: thumbDataWithSize,
			builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
				if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
					widget.photos[index].setThumbData(snapshot.data);
					return InkWell(
						onTap: () => showInfo(entity),
						child: AssetContainer(snapshot.data, widget.photos[index]),
					);
				}
				return Center(
						child: Container(width: 200.0, height: 200.0 ,child: Image.asset('assets/images/loading.gif')),
				);
			},
		);
	}

	showInfo(AssetEntity entity) async {
		var file = await entity.file;
		var length = file.lengthSync();
		print("${entity.id} length = $length");
	}
}
