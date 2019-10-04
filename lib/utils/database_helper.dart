import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:iptv_app/models/link.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Singleton DatabaseHelper
  static Database _database;             //Singleton database

  String linkTable = 'link_table';
  String  colId = 'id';
  String colUrl = 'url';
  String colDescription = 'description';
  String colType = 'type';

  DatabaseHelper.createInstance();    //Constructor name to create instance of DatabaseHelper

  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper.createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if (_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async{
    //Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'links.db';

    //Open/create the database at a given path
    Database linksDatabase = await openDatabase(path, version:1, onCreate:_createDb);
    return linksDatabase;
  }

  void _createDb (Database db, int newVersion) async{
    await db.execute('CREATE TABLE $linkTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
    '$colUrl TEXT,$colDescription TEXT,$colType INTEGER)');
  }

    //Fetch Operation: Get Link Map List  of given type
    Future<List<Map<String,dynamic>>> getLinkMapListByType(int type) async{
      Database db = await this.database;
      List<Map<String,dynamic>> result = await db.rawQuery('SELECT * FROM $linkTable WHERE $colType = $type ORDER BY $colId ASC');
      return result;
    } 

    //Insert link ...
    Future<int> insertLink (Link link) async{ 
      Database db = await this.database;
      int result = await db.insert(linkTable, link.toMap());
      return result;
    }

    //Update link
    Future<int> updateLink (Link link) async{
      Database db = await this.database;
      int result = await db.update(linkTable, link.toMap(), where: '$colId = ?', whereArgs: [link.id]);
      return result;
    }

    //Delete a link
    Future<int> deleteLink (int id) async{
      Database db = await this.database;
      int result = await db.rawDelete('DELETE $linkTable WHERE $colId = $id');
      return result;
    }

    //Get count by type
    Future<int> getCountbyType(int type) async{
      Database db = await this.database;
      List<Map<String,dynamic>> x = await db.rawQuery('SELECT COUNT(*) FROM $linkTable WHERE $colType = $type');
      int result = Sqflite.firstIntValue(x);
      return result;
    }

    //Get Link List from Link Map List by Type
    Future<List<Link>> getLinkListByType (int type) async{
      List<Map<String,dynamic>> linkMapList = await getLinkMapListByType(type);
      List<Link> linkList = List<Link>();
      int count = linkMapList.length;
      for (int i=0;i<count;i++){
        linkList.add(Link.toLink(linkMapList[i]));
      }
      return linkList;
    }
}