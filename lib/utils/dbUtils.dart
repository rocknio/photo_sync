import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class TableInfo {
	TableInfo({this.name, this.ddl, this.isInitialized});

	String name;
	String ddl;
	bool isInitialized;
}

Map<String, TableInfo> tables = {
	"servers": TableInfo(
		name: "servers",
		isInitialized: false,
		ddl: 'CREATE TABLE "servers" ("id" integer primary key autoincrement,"server_hash" varchar(64),"init_time" datetime, "last_sync_time" datetime)'),
	"assets": TableInfo(
		name: "assets",
		isInitialized: false,
		ddl: 'CREATE TABLE "assets" ("id" integer primary key autoincrement,"md5" varchar(32),"sync_time" datetime, "synced" integer)'
	)
};

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
			await db.execute(tableInfo.ddl);
		}
	});
}

Future<Database> initLocalDb() async {
	var dbPath = await getDatabasesPath();
	String dbFilePath = path.join(dbPath, "photoSync.db");

	Database _db = await openDatabase(dbFilePath, version: 1,
		onOpen: initDbTable,
	);

	return _db;
}