import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:photo_sync/utils/utils.dart';
import 'package:photo_sync/utils/eventUtils.dart';
import 'package:photo_sync/models/assetModel.dart';

class AssetContainer extends StatefulWidget {
	final Uint8List data;
	final AssetModel asset;

	AssetContainer(this.data, this.asset);

  @override
  _AssetContainerState createState() => _AssetContainerState();
}

class _AssetContainerState extends State<AssetContainer> {
	bool isSynced = false;
	bool isDispose = false;

	@override
  void dispose() {
    isDispose = true;
    super.dispose();
  }

	void initAsset() async {
		bool ret = await widget.asset.getAssetFullData();
		if ( ret != isSynced && isDispose == false ){
			setState(() {
				isSynced = widget.asset.isSynced;
			});
		}
	}
	@override
  void initState() {
    eventBus.on<SyncDoneEvent>().listen((event){
    	updateState(event);
    });

    initAsset();
    super.initState();
  }

  void updateState(SyncDoneEvent event) {
		if (event.syncResult) {
			if (event.syncedEntityId == widget.asset.assetId) {
				if (isSynced != true) {
					setState(() {
						isSynced = true;
					});
				}
			}
		}
  }

	@override
  Widget build(BuildContext context) {
    return assetContainer(widget.data, widget.asset.assetType, isSynced);
  }
}
