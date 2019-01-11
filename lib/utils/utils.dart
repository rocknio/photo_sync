import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';

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

Container assetContainer(Uint8List data, AssetType type) {
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
						child: Icon(Icons.check_circle_outline, size: 18.0, color: Colors.grey,)
				),
			],
		),
	);
}
