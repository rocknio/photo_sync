import 'package:photo_manager/photo_manager.dart';
import 'package:crypto/crypto.dart';
import 'dart:async';
import 'package:convert/convert.dart';

class AllAssets {
	AssetPathEntity assetPath;
	List<AssetModel> _assets = [];

	get assets => _assets;

	void addAsset(AssetEntity assetEntity) {
		AssetModel assetModel = AssetModel();
		assetModel.setAsset(assetEntity);

		_assets.add(assetModel);
	}
}

class AssetModel {
	AssetEntity _asset;
	bool _isSynced = false;
	bool _isSelected = true; // 默认需要同步
	String _md5 = "";

	get isSynced => _isSynced;
	get isSelected => _isSelected;
	get sign => _md5;
	get asset => _asset;

	Future<bool> checkSyncStatus(String md5) async {
		//TODO 和服务端比对MD5，是否已经同步过
		return false;
	}

	Future<void> getAssetFullData(AssetEntity asset) async {
		List<int> tmpFullData =  await asset.fullData;
		var content = md5.convert(tmpFullData);
		_md5 = hex.encode(content.bytes);

		_isSynced = await checkSyncStatus(_md5);

		print("md5 = $_md5, isSynced = $_isSynced");
	}

	void setAsset(AssetEntity asset) {
		_asset = asset;
		if (_md5 == "") {
//			getAssetFullData(_asset);
		}
	}
}