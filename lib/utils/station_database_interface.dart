import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:v_lille/models/station.dart';

class StationDatabaseInterface {
  static final StationDatabaseInterface instance =
      StationDatabaseInterface._internal();

  static Database? _database;
  StationDatabaseInterface._internal();

  // Database constants

  static const String databaseName = 'station.db';

  static const int versionNumber = 2;

  static const String colId = 'id';

  static const String stationTableName = 'Station';
  static const String colName = 'name';
  static const String colAddress = 'address';
  static const String colType = 'type';
  static const String colAvailableSlots = 'availableSlots';
  static const String colAvailableBikes = 'availableBikes';
  static const String colConnectionState = 'connectionState';
  static const String colX = 'x';
  static const String colY = 'y';
  static const String colLastUpdate = 'lastUpdate';
  static const String colIsFavorite = 'isFavorite';

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), databaseName);
    // When the database is first created, create a table to store Stations
    var db = await openDatabase(
      path,
      version: versionNumber,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $stationTableName (
        $colId INTEGER PRIMARY KEY,
        $colName TEXT NOT NULL,
        $colAddress TEXT NOT NULL,
        $colType TEXT NOT NULL,
        $colAvailableSlots INTEGER NOT NULL,
        $colAvailableBikes INTEGER NOT NULL,
        $colConnectionState TEXT NOT NULL,
        $colX REAL NOT NULL,
        $colY REAL NOT NULL,
        $colLastUpdate TEXT NOT NULL,
        $colIsFavorite INTEGER
      )
    ''');
  }

  // Upgrade the database by dropping the existing tables and creating new ones if the version number is increased
  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('''
        DROP TABLE IF EXISTS $stationTableName
      ''');

      await db.execute('''
        DROP TABLE IF EXISTS $stationTableName
      ''');
      await _onCreate(db, newVersion);
    }
  }

  // CRUD operations

  Future<int> insertStation(Station station) async {
    final db = await database;
    return await db.insert(
      stationTableName,
      station.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertStations(List<Station> stations) async {
    final db = await database;
    Batch batch = db.batch();
    for (Station station in stations) {
      batch.insert(
        stationTableName,
        station.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    List<dynamic> results = await batch.commit();
    return results.length;
  }

  Future<List<Station>> get stations async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(stationTableName);
    return maps.map((map) => Station.fromMap(map)).toList();
  }

  Future<int> updateStation(Station station) async {
    // Update the given Station without updating the favorite status
    final db = await database;
    return await db.update(
      stationTableName,
      station.toMap(),
      where: '$colId = ?',
      whereArgs: [station.id],
    );
  }

  Future<int> deleteStation(int id) async {
    final db = await database;
    return await db.delete(
      stationTableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<Station?> getStationById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      stationTableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Station.fromMap(maps.first);
    }
    return null;
  }
}
