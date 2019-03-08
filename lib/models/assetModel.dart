import 'package:photo_manager/photo_manager.dart';
import 'package:crypto/crypto.dart';
import 'dart:async';
import 'package:convert/convert.dart';
import 'package:photo_sync/utils/dbUtils.dart';
import 'dart:typed_data';

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
	Uint8List _thumbDataWithSize;

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
//		List<int> tmpFullData =  await _asset.fullData;
//		var content = md5.convert(tmpFullData);
		var content = md5.convert(_thumbDataWithSize);
		_md5 = hex.encode(content.bytes);

		_isSynced = await checkSyncStatus();

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