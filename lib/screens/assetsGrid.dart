import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_sync/utils/utils.dart';
import 'package:photo_sync/screens/assetShowPage.dart';
import 'package:photo_sync/models/assetModel.dart';

class AssetsGridPage extends StatelessWidget {
	final List<AssetModel>assetsModelList;

	AssetsGridPage({Key key, this.assetsModelList}) : super(key: key);

	Widget _buildHasPreviewItem(BuildContext context, int index) {
		var asset = assetsModelList[index].asset;
		return _buildPreview(asset);
	}

	Widget _buildPreview(AssetEntity asset) {
		return FutureBuilder<Uint8List>(
			future: asset.thumbDataWithSize(200, 200),
			builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
				if (snapshot.data != null) {
					return GestureDetector(
						onTap: () {
							Navigator.push(context, MaterialPageRoute(builder: (context) => AssetShowPage(asset: asset,)));
						},
						child: assetContainer(snapshot.data, asset.type)
					);
				} else {
					return Center(
						child: Container(
							width: 30.0,
							height: 30.0,
							child: CircularProgressIndicator()
						),
					);
				}
			},
		);
	}

	@override
	Widget build(BuildContext context) {
		if (assetsModelList.isEmpty) {
			return Container();
		} else {
			return GridView.count(
				crossAxisCount: 2,
				children: List.generate(assetsModelList.length, (index) {
					return _buildHasPreviewItem(context, index);
				}),
			);
		}
	}
}
