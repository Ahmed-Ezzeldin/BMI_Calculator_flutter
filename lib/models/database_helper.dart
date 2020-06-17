import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/bmi_data.dart';

class DatabaseHelper {
  DatabaseHelper.internal(); // Create internal constructor for DatabaseHelper
  static DatabaseHelper _databaseHelper = DatabaseHelper.internal();
  // factory constructor to cache all of the state of this DatabaseHelper every time we invoke
  //  that DatabaseHelper we not creating lots of object in memory and slow down our system
  factory DatabaseHelper() => _databaseHelper;

  static Database _database;
  String tableName = 'data_table';

  //========================================================= Create  database Column
  String columnId = 'id';
  String columnBmi = 'bmi';
  String columnTitle = 'title';
  String columnDescription = 'description';
  String columnHeight = 'height';
  String columnWeight = 'weight';
  String columnAge = 'age';
  String columnGender = 'gender';
  String columnDate = 'date';

  //========================================================= check  database exists or not
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  //========================================================= initializing database in device memory
  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "main_db.db"; // home://file/main_db.db
    var ourDb = await openDatabase(path, version: 1, onCreate: createDatabase);
    return ourDb;
  }

  //========================================================= Creating database function
  void createDatabase(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $tableName ($columnId INTEGER PRIMARY KEY AUTOINCREMENT ,$columnBmi TEXT , $columnDescription TEXT ," +
          " $columnHeight TEXT , $columnWeight TEXT  , $columnAge TEXT , $columnGender TEXT , $columnDate TEXT, $columnTitle TEXT )",
    );
  }

  //========================= (C R U D) CREATE, READ, UPDATE , DELETE =========================

  //========================================================= Get all Data (query return List<Map>) Order:( ASC , DESC )
  Future<List> getAllInListDB() async {
    Database db = await database;
    var result = await db.query(tableName, orderBy: "$columnId DESC");
    return result;
  }

  //========================================================= Insertion
  Future<int> insertDB(BmiData bmiData) async {
    Database db = await database;
    var result = await db.insert(tableName, bmiData.toMap());
    return result;
  }

  //========================================================= DELETE
  Future<int> deleteDB(int id) async {
    Database db = await database;
    return await db.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  //========================================================= UPDATE
  Future<int> updateDB(BmiData bmiData) async {
    Database db = await database;
    return await db.update(tableName, bmiData.toMap(),
        where: "$columnId =?", whereArgs: [bmiData.id]);
  }

  //========================================================= Get all Data in List of <Object>
  Future<List<BmiData>> getObjectListDB() async {
    var bmiDataMapList = await getAllInListDB();
    int count = bmiDataMapList.length;
    List<BmiData> bmiData = List<BmiData>();
    for (int i = 0; i < count; i++) {
      bmiData.add(BmiData.fromMap(bmiDataMapList[i]));
    }
    return bmiData;
  }

  //========================================================= Get values in bmi column access it by "Bmi"
  Future getBmiColumn() async {
    var db = await database;
    var result = await db.rawQuery("SELECT $columnBmi Bmi FROM $tableName");
    return result;
  }

  //========================================================= Convert values in bmi column to List<double>
  Future<List<double>> getBmiList() async {
    var bmiDataMapList = await getAllInListDB();
    int count = bmiDataMapList.length;
    List<double> bmiList = List<double>();
    for (int i = 0; i < count; i++) {
      var bmiNum = (await getBmiColumn())[i]['Bmi'];
      bmiList.add(double.parse(bmiNum));
    }
    return bmiList;
  }

  // //========================================================= Get Count
  // Future<int> getCountDB() async {
  //   Database db = await database;
  //   return Sqflite.firstIntValue(
  //     await db.rawQuery("SELECT COUNT(*) FROM $tableName"),
  //   );
  // }

  // //========================================================= Close Database
  // Future closeDB() async {
  //   Database db = await database;
  //   return db.close();
  // }

  // //========================================================= Get One Element by ID
  // Future<BmiData> getOneElementDB(int id) async {
  //   Database db = await database;
  //   var result =
  //       await db.rawQuery("SELECT (*) FROM $tableName WHERE $columnId = $id");
  //   if (result.length == 0) return null;
  //   return BmiData.fromMap(result.first);
  // }

}
