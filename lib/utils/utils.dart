import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

BoxDecoration assetDecoration() {
	return BoxDecoration(
			color: Colors.transparent,
			border: Border.all(
					color: Colors.white,
					width: 0.5
			),
//			borderRadius: BorderRadius.all(Radius.circular(3.0))
	);
}

Container assetContainer(Uint8List data, AssetType type, bool isSynced) {
	return Container(
		margin: const EdgeInsets.all(0.5),
		decoration: assetDecoration(),
		child: Stack(
			children: <Widget>[
				Center(
					child: Stack(
						children: <Widget>[
							Center(
								child: Image.memory(
									data,
									fit: BoxFit.cover,
								  width: double.infinity,
								  height: double.infinity,
								)
							),
							Center(child: type == AssetType.video ? Icon(Icons.play_arrow, color: Colors.white, size: 50.0,) : Container(),)
						],
					),
				),
				Container(
						alignment: Alignment.topRight,
						child: isSynced ? Icon(Icons.check_circle, size: 24.0, color: Colors.green[800],):
															Icon(Icons.check_circle_outline, size: 24.0, color: Colors.white,)
				),
			],
		),
	);
}

String calcMd5(Uint8List data) {
	var content = md5.convert(data);
	String _md5 = hex.encode(content.bytes);
	return _md5;
}
