import 'model_students.dart';
import 'package:sqflite/sqflite.dart';
import 'model_students_fields.dart';
import 'package:logger/logger.dart';

class DataBase {
  static final DataBase _instance = DataBase._internal();
  static Database? _database;

  static final Logger _logger = Logger();

  DataBase._internal();

  factory DataBase(){
    return _instance;
  }

  Future<Database> initializedDB() async {

    if(_database != null){
      return _database!;
    }

    String databasePath = await getDatabasesPath();
    final path = '$databasePath/students.db';

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,

    );

    return _database!;

  }

  Future<void> closeDB() async {
    if(_database != null){
      await _database!.close();
      _database = null;
    }

  }

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
    CREATE TABLE ${StudentFields.tableName}(
    ${StudentFields.id} ${StudentFields.typeId},
    ${StudentFields.firstName} ${StudentFields.typeText},
    ${StudentFields.lastName} ${StudentFields.typeText},
    ${StudentFields.studentsYear} ${StudentFields.typeInt}
    )
    ''');
  }

  Future<int> insertStudents(List<Students> students) async {
    int result = 0;

    try{
      final Database db = await initializedDB();
      for(final student in students){
        result = await db.insert(StudentFields.tableName, student.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }

    } catch (e){
      _logger.e('Error while inserting students: $e');
    }

    return result;

  }

  Future<List<Students>> retrieveStudents() async {
    try{
      final Database db = await initializedDB();
      final List<Map<String, dynamic>> result = await db.query(StudentFields.tableName);
      return result.map((e) => Students.fromMap(e)).toList();
    } catch (e){
      _logger.e('Error while retrieving students: $e');
      return [];
    }
  }

  Future<void> deleteStudent(int id) async {
    try{
      final db = await initializedDB();
      await db.delete(
        StudentFields.tableName,
        where: "id = ?",
        whereArgs: [id]
      );
    } catch (e){
      _logger.e('Error while deleting student: $e');

    }
  }

  Future<int> updateStudent(Students student) async {
    try {
      final db = await initializedDB();
      return await db.update(
        StudentFields.tableName,
        student.toMap(),
        where: "${StudentFields.id} = ?",
        whereArgs: [student.id]
      );
    } catch (e){}
  }

}