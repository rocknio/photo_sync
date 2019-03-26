import 'package:photo_manager/photo_manager.dart';
import 'dart:async';
import 'package:photo_sync/utils/dbUtils.dart';
import 'dart:typed_data';
import 'package:photo_sync/utils/utils.dart';

class AllAssets {
	AssetPathEntity assetPath;
	List<AssetModel> _assets = [];

	get assets => _assets;

	void addAsset(AssetEntity assetEntity) {
		AssetModel assetModel = AssetModel();
		assetModel.setAsset(assetEntity);

		_assets.add(assetModel);
	}

	void clearAsset() {
		_assets.clear();
		assetPath = null;
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

	Future<bool> checkSyncStatus() async {
		return await isAssetAlreadySynced(assetId, _md5);
	}

	Future<bool> getAssetFullData() async {
		if (_md5.length <= 0) {
			_thumbDataWithSize = await _asset.thumbDataWithSize(300, 300);

			_md5 = calcMd5(_thumbDataWithSize);

//			_isSynced = await checkSyncStatus();
		}

		print("md5 = $_md5, isSynced = $_isSynced");
		return _isSynced;
	}

	void setThumbData(Uint8List data) {
		_thumbDataWithSize = data;
	}

	void setAsset(AssetEntity asset) {
		_asset = asset;
	}
}