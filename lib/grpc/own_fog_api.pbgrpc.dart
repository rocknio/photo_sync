///
//  Generated code. Do not modify.
//  source: own_fog_api.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'own_fog_api.pb.dart';
export 'own_fog_api.pb.dart';

class UploadFileServiceClient extends Client {
  static final _$uploadFile =
      new ClientMethod<uploadFileRequest, uploadFileResponse>(
          '/fileUpload.UploadFileService/UploadFile',
          (uploadFileRequest value) => value.writeToBuffer(),
          (List<int> value) => new uploadFileResponse.fromBuffer(value));

  UploadFileServiceClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<uploadFileResponse> uploadFile(uploadFileRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$uploadFile, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class UploadFileServiceBase extends Service {
  String get $name => 'fileUpload.UploadFileService';

  UploadFileServiceBase() {
    $addMethod(new ServiceMethod<uploadFileRequest, uploadFileResponse>(
        'UploadFile',
        uploadFile_Pre,
        false,
        false,
        (List<int> value) => new uploadFileRequest.fromBuffer(value),
        (uploadFileResponse value) => value.writeToBuffer()));
  }

  $async.Future<uploadFileResponse> uploadFile_Pre(
      ServiceCall call, $async.Future request) async {
    return uploadFile(call, await request);
  }

  $async.Future<uploadFileResponse> uploadFile(
      ServiceCall call, uploadFileRequest request);
}
