import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'dart:async';

Database _db;

class TableInfo {
	TableInfo({this.name, this.ddl, this.isInitialized});

	String name;
	List<String> ddl;
	bool isInitialized;
}

Map<String, TableInfo> tables = {
	"servers": TableInfo(
		name: "servers",
		isInitialized: false,
		ddl: ['CREATE TABLE "servers" ("id" integer primary key autoincrement,"server_hash" varchar(64),"init_time" int, "last_sync_time" int)']
	),
	"assets": TableInfo(
		name: "assets",
		isInitialized: false,
		ddl: [
			'CREATE TABLE "assets" ("id" integer primary key autoincrement,"asset_id" varchar(128), "md5" varchar(32),"sync_time" int, "synced" int)',
			'CREATE INDEX idx_assets_asset_id on table_name ("asset_id")',
			'CREATE INDEX idx_assets_md5 on table_name ("md5")',
		]
	),
	"discard_servers": TableInfo(
		name: "discard_servers",
		isInitialized: false,
		ddl: ['CREATE TABLE "discard_servers" ("id" integer primary key autoincrement,"server_hash" varchar(64),"discard_time" int)']
	),
};

Future<bool> initLocalDb() async {
	var dbPath = await getDatabasesPath();
	String dbFilePath = path.join(dbPath, "photoSync.db");

	_db = await openDatabase(dbFilePath, version: 1,
		onOpen: initDbTable,
	);

	return true;
}

initDbTable(Database db) async {
	List<Map> list = await db.rawQuery("select * from sqlite_master where type='table'", );

	list.forEach((oneTable) {
		String tableName = oneTable['tbl_name'];
		if (tables.containsKey(tableName)) {
			tables[tableName].isInitialized = true;
		}
	});

	tables.forEach((tableName, tableInfo) async {
		if (!tableInfo.isInitialized) {
			tableInfo.ddl.forEach((ddl) async {
				await db.execute(ddl);
			});
		}
	});
}

int getCurrentTimestamp() {
	return new DateTime.now().millisecondsSinceEpoch;
}

Future<bool> checkServer(String serverHash) async {
	List<Map> list = await _db.rawQuery("select * from servers where server_hash='$serverHash'", );
	if (list.length == 0) {
		return false;
	} else {
		return true;
	}
}

Future<bool> insertServer(String serverHash) async {
	int id = await _db.rawInsert("insert into servers('server_hash', 'init_time') values (?, ?)", [serverHash, getCurrentTimestamp()]);
	if ( id > 0 ) {
		return true;
	} else {
		return false;
	}
}

Future<bool> checkDiscardServer(String serverHash) async {
	List<Map> list = await _db.rawQuery("select * from discard_servers where server_hash='$serverHash'", );
	if (list.length == 0) {
		return false;
	} else {
		return true;
	}
}

Future<bool> insertDiscardServer(String serverHash) async {
	int id = await _db.rawInsert("insert into discard_servers('server_hash', 'discard_time') values (?, ?)", [serverHash, getCurrentTimestamp()]);
	if ( id > 0 ) {
		return true;
	} else {
		return false;
	}
}

deleteDiscardServer() async {
	await _db.rawDelete("delete from discard_servers");
}

deleteServer() async {
	await _db.rawDelete("delete from servers");
}

closeDb() async {
	if ( _db != null ) {
		await _db.close();
		_db = null;
	}
}
