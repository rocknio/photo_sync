import 'package:grpc/grpc.dart';
import 'package:photo_sync/grpc/own_fog_api.pb.dart';
import 'package:photo_sync/grpc/own_fog_api.pbgrpc.dart';
import 'package:photo_sync/models/assetModel.dart';
import 'package:photo_sync/models/server.dart' as gRpcServer;
import 'dart:typed_data';
import 'package:photo_sync/utils/utils.dart';

const int seg_len = 512 * 1024;

Future<bool> uploadFile(gRpcServer.Server server, AssetModel assetModel, String deviceId) async {
	RegExp reg = RegExp(r"((?:(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d))))");
	String serverIp;
	bool ret, isFinished;
	int fix, totalCount, idx, start, dst, reTry;
	String assetMd5;
	ClientChannel channel;
	UploadFileServiceClient stub;

	serverIp = reg.firstMatch(server.registerUrl).group(0);
	channel = ClientChannel(
			serverIp,
			port: server.fileUploadPort,
			options: const ChannelOptions(
					credentials: const ChannelCredentials.insecure()
			)
	);
	stub = UploadFileServiceClient(channel, options: CallOptions(timeout: Duration(seconds: 30)));

	var file = await assetModel.asset.file;
	Uint8List assetContent = await assetModel.asset.fullData;

	assetMd5 = calcMd5(assetContent);
	if ((assetContent.lengthInBytes % seg_len) != 0) {
		fix = 1;
	} else {
		fix = 0;
	}

	totalCount = assetContent.lengthInBytes ~/ seg_len + fix;
	for (idx = 0; idx < totalCount; idx++) {
		start = idx * seg_len;
		dst = idx * seg_len + seg_len;
		if (dst > assetContent.lengthInBytes) {
			dst = assetContent.lengthInBytes;
		}

		var deviceInfo = DeviceInfo()
			..deviceName = deviceId;

		var fileName = assetModel.assetId.toString().split('/').last;
		var transFileInfo = TransFileInfo()
			..fileLen = file.lengthSync()
			..fileName = fileName
			..md5 = assetMd5;

		var currentTransInfo = CurrentTransInfo()
			..pageTotal = totalCount
			..pageIdx = idx
			..tranLen = dst - start;

		var uploadReq = uploadFileRequest()
			..deviceInfo = deviceInfo
			..fileInfo = transFileInfo
			..transInfo = currentTransInfo
			..timestamp = DateTime.now().microsecondsSinceEpoch.toString()
			..fileContent = assetContent.getRange(start, dst).toList();

		for(reTry = 0; reTry < 3; reTry++) {
			try {
				final resp = await stub.uploadFile(uploadReq);
				print(resp.toString());
				if (resp.status == EnumStatus.SUCCESS) {
					ret = true;
					isFinished = resp.isFinished;
					break;
				}
			} catch (e) {
				ret = false;
				isFinished = false;
				print("Caught error: $e");

				// 重新初始化客户端
				await channel.shutdown();

				channel = ClientChannel(
						serverIp,
						port: server.fileUploadPort,
						options: const ChannelOptions(
								credentials: const ChannelCredentials.insecure()
						)
				);
				stub = UploadFileServiceClient(channel, options: CallOptions(timeout: Duration(seconds: 30)));
			}
		}

		if (isFinished) {
			break;
		}

		if (reTry >= 3) {
			ret = false;
			break;
		}
	}

	await channel.shutdown();
	return ret;
}
