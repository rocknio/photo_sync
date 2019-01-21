import 'package:json_annotation/json_annotation.dart';
part 'server.g.dart';

@JsonSerializable()

class Server {
	Server(this.registerUrl, this.fileUploadPort, this.serverHashCode);

	@JsonKey(name: "register_url")
	String registerUrl;

	@JsonKey(name: "file_upload_port")
	int fileUploadPort;

	@JsonKey(name: "hash_code")
	String serverHashCode;

	factory Server.fromJson(Map<String, dynamic> json) => _$ServerFromJson(json);

	Map<String, dynamic> toJson() => _$ServerToJson(this);
}