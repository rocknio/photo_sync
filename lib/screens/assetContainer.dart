import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_sync/utils/utils.dart';
import 'package:photo_sync/utils/eventUtils.dart';

class AssetContainer extends StatefulWidget {
	final String assetId;
	final Uint8List data;
	final AssetType type;

	AssetContainer(this.data, this.type, this.assetId);

  @override
  _AssetContainerState createState() => _AssetContainerState();
}

class _AssetContainerState extends State<AssetContainer> {
	bool isSynced = false;
	@override
  void initState() {
    eventBus.on<SyncDoneEvent>().listen((event){
    	updateState(event);
    });

    super.initState();
  }

  void updateState(SyncDoneEvent event) {
		if (event.syncResult) {
			if (event.syncedEntityId == widget.assetId) {
				setState(() {
				  isSynced = true;
				});
			}
		}
  }

	@override
  Widget build(BuildContext context) {
    return assetContainer(widget.data, widget.type, isSynced);
  }
}
