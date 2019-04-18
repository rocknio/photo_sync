import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';

class AllAssets {
	List<AssetModel> _assets = [];

	get assets => _assets;

	void addAsset(AssetEntity assetEntity) async {
		AssetModel assetModel = AssetModel();
		assetModel.setAsset(assetEntity);

		_assets.add(assetModel);
	}

	void clearAsset() {
		_assets.clear();
	}
}

class AssetModel {
	AssetEntity _asset;
	bool _isSynced = false;
	String _md5 = "";
	Uint8List _thumbDataWithSize = Uint8List(0);

	get isSynced => _isSynced;
	get sign => _md5;
	get asset => _asset;
	get assetId => _asset.id;
	get assetType => _asset.type;
	get thumbData => _thumbDataWithSize;

	void setThumbData(Uint8List data) {
		_thumbDataWithSize = data;
	}

	bool setAsset(AssetEntity asset) {
		_asset = asset;
		return _isSynced;
	}

	void setIsSynced(bool isSynced) {
		_isSynced = isSynced;
	}
}