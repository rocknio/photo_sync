///
//  Generated code. Do not modify.
//  source: own_fog_api.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class EnumStatus extends $pb.ProtobufEnum {
  static const EnumStatus SUCCESS = const EnumStatus._(0, 'SUCCESS');
  static const EnumStatus CHECK_FAIL = const EnumStatus._(1, 'CHECK_FAIL');
  static const EnumStatus OTHER_FAIL = const EnumStatus._(2, 'OTHER_FAIL');

  static const List<EnumStatus> values = const <EnumStatus> [
    SUCCESS,
    CHECK_FAIL,
    OTHER_FAIL,
  ];

  static final Map<int, EnumStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EnumStatus valueOf(int value) => _byValue[value];
  static void $checkItem(EnumStatus v) {
    if (v is! EnumStatus) $pb.checkItemFailed(v, 'EnumStatus');
  }

  const EnumStatus._(int v, String n) : super(v, n);
}

