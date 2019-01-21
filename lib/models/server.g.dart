// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Server _$ServerFromJson(Map<String, dynamic> json) {
  return Server(json['register_url'] as String, json['file_upload_port'] as int,
      json['hash_code'] as String);
}

Map<String, dynamic> _$ServerToJson(Server instance) => <String, dynamic>{
      'register_url': instance.registerUrl,
      'file_upload_port': instance.fileUploadPort,
      'hash_code': instance.serverHashCode
    };
