import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';
import 'dart:async';
import 'dart:ui';

class AssetShowPage extends StatelessWidget {
	final AssetEntity asset;

	AssetShowPage({Key key, this.asset}) : super(key: key);

	@override
  Widget build(BuildContext context) {
    if (asset.type == AssetType.image) {
	    return FutureBuilder<Uint8List>(
		    future: asset.fullData,
		    builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
			    if (snapshot.data != null) {
				    return Container(
				      child: GestureDetector(
							  child: Center(child: Image.memory(snapshot.data)),
						    onTap: () {
							  	Navigator.pop(context);
						    },
					    ),
				    );
			    } else {
				    return Container(
					    child: CircularProgressIndicator(),
				    );
			    }
		    },
	    );
    } else if (asset.type == AssetType.video ) {
    	return ChewiePage(asset: asset,);
    } else {
    	return Container();
    }
  }
}

class ChewiePage extends StatefulWidget {
	final String title;
	final AssetEntity asset;

	ChewiePage({this.title = 'Video Player', this.asset});

  @override
  _ChewiePageState createState() => _ChewiePageState();
}

class _ChewiePageState extends State<ChewiePage> {
	VideoPlayerController _controller;
	File _file;

	Future<void> getAssetFile() async {
		File tmpFile;

		tmpFile = await widget.asset.file;

		setState(() {
		  _file = tmpFile;
		});
	}

	@override
  void initState() {
    getAssetFile();
    super.initState();
  }

  @override
  void dispose() {
  if (_controller != null) {
  	_controller.dispose();
  }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
		Size physicalSize;
		if (_file == null) {
			return Container();
		}

		_controller = VideoPlayerController.file(_file);
		physicalSize = window.physicalSize;

    return Container(
	    child: Column(
		    children: <Widget>[
		    	Expanded(
				    child: Center(
					    child: Chewie(
						    _controller,
						    aspectRatio: physicalSize.width / physicalSize.height,
						    autoPlay: true,
						    looping: false,
								fullScreenByDefault: false,
						    showControls: true,
//						    materialProgressColors: ChewieProgressColors(
//							    playedColor: Colors.red,
//							    handleColor: Colors.blue,
//							    backgroundColor: Colors.grey,
//							    bufferedColor: Colors.lightGreen,
//						    ),
//						    placeholder: Container(
//							    color: Colors.grey,
//						    ),
						    autoInitialize: false,
					    ),
				    ),
			    ),
		    ],
	    ),
    );
  }
}

