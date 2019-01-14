///
//  Generated code. Do not modify.
//  source: own_fog_api.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'own_fog_api.pbenum.dart';

export 'own_fog_api.pbenum.dart';

class TransFileInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('TransFileInfo', package: const $pb.PackageName('fileUpload'))
    ..aOS(1, 'fileName')
    ..a<int>(2, 'fileLen', $pb.PbFieldType.O3)
    ..aOS(3, 'md5')
    ..hasRequiredFields = false
  ;

  TransFileInfo() : super();
  TransFileInfo.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  TransFileInfo.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  TransFileInfo clone() => new TransFileInfo()..mergeFromMessage(this);
  TransFileInfo copyWith(void Function(TransFileInfo) updates) => super.copyWith((message) => updates(message as TransFileInfo));
  $pb.BuilderInfo get info_ => _i;
  static TransFileInfo create() => new TransFileInfo();
  TransFileInfo createEmptyInstance() => create();
  static $pb.PbList<TransFileInfo> createRepeated() => new $pb.PbList<TransFileInfo>();
  static TransFileInfo getDefault() => _defaultInstance ??= create()..freeze();
  static TransFileInfo _defaultInstance;
  static void $checkItem(TransFileInfo v) {
    if (v is! TransFileInfo) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get fileName => $_getS(0, '');
  set fileName(String v) { $_setString(0, v); }
  bool hasFileName() => $_has(0);
  void clearFileName() => clearField(1);

  int get fileLen => $_get(1, 0);
  set fileLen(int v) { $_setSignedInt32(1, v); }
  bool hasFileLen() => $_has(1);
  void clearFileLen() => clearField(2);

  String get md5 => $_getS(2, '');
  set md5(String v) { $_setString(2, v); }
  bool hasMd5() => $_has(2);
  void clearMd5() => clearField(3);
}

class CurrentTransInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CurrentTransInfo', package: const $pb.PackageName('fileUpload'))
    ..a<int>(1, 'pageTotal', $pb.PbFieldType.O3)
    ..a<int>(2, 'pageIdx', $pb.PbFieldType.O3)
    ..a<int>(3, 'tranLen', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  CurrentTransInfo() : super();
  CurrentTransInfo.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CurrentTransInfo.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CurrentTransInfo clone() => new CurrentTransInfo()..mergeFromMessage(this);
  CurrentTransInfo copyWith(void Function(CurrentTransInfo) updates) => super.copyWith((message) => updates(message as CurrentTransInfo));
  $pb.BuilderInfo get info_ => _i;
  static CurrentTransInfo create() => new CurrentTransInfo();
  CurrentTransInfo createEmptyInstance() => create();
  static $pb.PbList<CurrentTransInfo> createRepeated() => new $pb.PbList<CurrentTransInfo>();
  static CurrentTransInfo getDefault() => _defaultInstance ??= create()..freeze();
  static CurrentTransInfo _defaultInstance;
  static void $checkItem(CurrentTransInfo v) {
    if (v is! CurrentTransInfo) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get pageTotal => $_get(0, 0);
  set pageTotal(int v) { $_setSignedInt32(0, v); }
  bool hasPageTotal() => $_has(0);
  void clearPageTotal() => clearField(1);

  int get pageIdx => $_get(1, 0);
  set pageIdx(int v) { $_setSignedInt32(1, v); }
  bool hasPageIdx() => $_has(1);
  void clearPageIdx() => clearField(2);

  int get tranLen => $_get(2, 0);
  set tranLen(int v) { $_setSignedInt32(2, v); }
  bool hasTranLen() => $_has(2);
  void clearTranLen() => clearField(3);
}

class DeviceInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeviceInfo', package: const $pb.PackageName('fileUpload'))
    ..aOS(1, 'deviceName')
    ..hasRequiredFields = false
  ;

  DeviceInfo() : super();
  DeviceInfo.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeviceInfo.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeviceInfo clone() => new DeviceInfo()..mergeFromMessage(this);
  DeviceInfo copyWith(void Function(DeviceInfo) updates) => super.copyWith((message) => updates(message as DeviceInfo));
  $pb.BuilderInfo get info_ => _i;
  static DeviceInfo create() => new DeviceInfo();
  DeviceInfo createEmptyInstance() => create();
  static $pb.PbList<DeviceInfo> createRepeated() => new $pb.PbList<DeviceInfo>();
  static DeviceInfo getDefault() => _defaultInstance ??= create()..freeze();
  static DeviceInfo _defaultInstance;
  static void $checkItem(DeviceInfo v) {
    if (v is! DeviceInfo) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get deviceName => $_getS(0, '');
  set deviceName(String v) { $_setString(0, v); }
  bool hasDeviceName() => $_has(0);
  void clearDeviceName() => clearField(1);
}

class uploadFileRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('uploadFileRequest', package: const $pb.PackageName('fileUpload'))
    ..aOS(1, 'timestamp')
    ..a<DeviceInfo>(2, 'deviceInfo', $pb.PbFieldType.OM, DeviceInfo.getDefault, DeviceInfo.create)
    ..a<TransFileInfo>(3, 'fileInfo', $pb.PbFieldType.OM, TransFileInfo.getDefault, TransFileInfo.create)
    ..a<CurrentTransInfo>(4, 'transInfo', $pb.PbFieldType.OM, CurrentTransInfo.getDefault, CurrentTransInfo.create)
    ..a<List<int>>(5, 'fileContent', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  uploadFileRequest() : super();
  uploadFileRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  uploadFileRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  uploadFileRequest clone() => new uploadFileRequest()..mergeFromMessage(this);
  uploadFileRequest copyWith(void Function(uploadFileRequest) updates) => super.copyWith((message) => updates(message as uploadFileRequest));
  $pb.BuilderInfo get info_ => _i;
  static uploadFileRequest create() => new uploadFileRequest();
  uploadFileRequest createEmptyInstance() => create();
  static $pb.PbList<uploadFileRequest> createRepeated() => new $pb.PbList<uploadFileRequest>();
  static uploadFileRequest getDefault() => _defaultInstance ??= create()..freeze();
  static uploadFileRequest _defaultInstance;
  static void $checkItem(uploadFileRequest v) {
    if (v is! uploadFileRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get timestamp => $_getS(0, '');
  set timestamp(String v) { $_setString(0, v); }
  bool hasTimestamp() => $_has(0);
  void clearTimestamp() => clearField(1);

  DeviceInfo get deviceInfo => $_getN(1);
  set deviceInfo(DeviceInfo v) { setField(2, v); }
  bool hasDeviceInfo() => $_has(1);
  void clearDeviceInfo() => clearField(2);

  TransFileInfo get fileInfo => $_getN(2);
  set fileInfo(TransFileInfo v) { setField(3, v); }
  bool hasFileInfo() => $_has(2);
  void clearFileInfo() => clearField(3);

  CurrentTransInfo get transInfo => $_getN(3);
  set transInfo(CurrentTransInfo v) { setField(4, v); }
  bool hasTransInfo() => $_has(3);
  void clearTransInfo() => clearField(4);

  List<int> get fileContent => $_getN(4);
  set fileContent(List<int> v) { $_setBytes(4, v); }
  bool hasFileContent() => $_has(4);
  void clearFileContent() => clearField(5);
}

class ReceivedFileInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ReceivedFileInfo', package: const $pb.PackageName('fileUpload'))
    ..a<TransFileInfo>(1, 'fileInfo', $pb.PbFieldType.OM, TransFileInfo.getDefault, TransFileInfo.create)
    ..a<int>(2, 'receivedLen', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ReceivedFileInfo() : super();
  ReceivedFileInfo.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ReceivedFileInfo.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ReceivedFileInfo clone() => new ReceivedFileInfo()..mergeFromMessage(this);
  ReceivedFileInfo copyWith(void Function(ReceivedFileInfo) updates) => super.copyWith((message) => updates(message as ReceivedFileInfo));
  $pb.BuilderInfo get info_ => _i;
  static ReceivedFileInfo create() => new ReceivedFileInfo();
  ReceivedFileInfo createEmptyInstance() => create();
  static $pb.PbList<ReceivedFileInfo> createRepeated() => new $pb.PbList<ReceivedFileInfo>();
  static ReceivedFileInfo getDefault() => _defaultInstance ??= create()..freeze();
  static ReceivedFileInfo _defaultInstance;
  static void $checkItem(ReceivedFileInfo v) {
    if (v is! ReceivedFileInfo) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  TransFileInfo get fileInfo => $_getN(0);
  set fileInfo(TransFileInfo v) { setField(1, v); }
  bool hasFileInfo() => $_has(0);
  void clearFileInfo() => clearField(1);

  int get receivedLen => $_get(1, 0);
  set receivedLen(int v) { $_setSignedInt32(1, v); }
  bool hasReceivedLen() => $_has(1);
  void clearReceivedLen() => clearField(2);
}

class uploadFileResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('uploadFileResponse', package: const $pb.PackageName('fileUpload'))
    ..aOS(1, 'timestamp')
    ..a<ReceivedFileInfo>(2, 'receivedFileInfo', $pb.PbFieldType.OM, ReceivedFileInfo.getDefault, ReceivedFileInfo.create)
    ..aOB(3, 'isFinished')
    ..e<EnumStatus>(4, 'status', $pb.PbFieldType.OE, EnumStatus.SUCCESS, EnumStatus.valueOf, EnumStatus.values)
    ..aOS(5, 'statusDesc')
    ..hasRequiredFields = false
  ;

  uploadFileResponse() : super();
  uploadFileResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  uploadFileResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  uploadFileResponse clone() => new uploadFileResponse()..mergeFromMessage(this);
  uploadFileResponse copyWith(void Function(uploadFileResponse) updates) => super.copyWith((message) => updates(message as uploadFileResponse));
  $pb.BuilderInfo get info_ => _i;
  static uploadFileResponse create() => new uploadFileResponse();
  uploadFileResponse createEmptyInstance() => create();
  static $pb.PbList<uploadFileResponse> createRepeated() => new $pb.PbList<uploadFileResponse>();
  static uploadFileResponse getDefault() => _defaultInstance ??= create()..freeze();
  static uploadFileResponse _defaultInstance;
  static void $checkItem(uploadFileResponse v) {
    if (v is! uploadFileResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get timestamp => $_getS(0, '');
  set timestamp(String v) { $_setString(0, v); }
  bool hasTimestamp() => $_has(0);
  void clearTimestamp() => clearField(1);

  ReceivedFileInfo get receivedFileInfo => $_getN(1);
  set receivedFileInfo(ReceivedFileInfo v) { setField(2, v); }
  bool hasReceivedFileInfo() => $_has(1);
  void clearReceivedFileInfo() => clearField(2);

  bool get isFinished => $_get(2, false);
  set isFinished(bool v) { $_setBool(2, v); }
  bool hasIsFinished() => $_has(2);
  void clearIsFinished() => clearField(3);

  EnumStatus get status => $_getN(3);
  set status(EnumStatus v) { setField(4, v); }
  bool hasStatus() => $_has(3);
  void clearStatus() => clearField(4);

  String get statusDesc => $_getS(4, '');
  set statusDesc(String v) { $_setString(4, v); }
  bool hasStatusDesc() => $_has(4);
  void clearStatusDesc() => clearField(5);
}

