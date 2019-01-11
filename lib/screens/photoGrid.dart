import 'dart:typed_data';
import 'package:photo_sync/models/assetModel.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_sync/utils/utils.dart';

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

		Future<Uint8List> thumbDataWithSize = entity.thumbDataWithSize(500, 500);

		return FutureBuilder<Uint8List>(
			future: thumbDataWithSize,
			builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
				if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
					return InkWell(
						onTap: () => showInfo(entity),
						child: assetContainer(snapshot.data, entity.type),
					);
				}
				return Center(
					child: Container(
						width: 30.0,
						height: 30.0,
						child: CircularProgressIndicator(),
					),
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
