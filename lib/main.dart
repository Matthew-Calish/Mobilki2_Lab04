import 'package:flutter/material.dart';
import 'sql_management/model_students.dart';
import 'sql_management/database.dart';
import 'dart:async';
import 'addStudentPage.dart';
import 'editStudentPage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQLite MK',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  late DataBase handler;
  late Future<List<Students>> _studentsFuture;

  int lastID = 0;

  Future<void> addStudents() async {
    final existingStudents = await handler.retrieveStudents();
    final existingIds = existingStudents.map((student) => student.id).toSet();

    final seedStudents = <Students>[
      Students(
        id: 1,
        firstName: 'Mateusz',
        lastName: 'Kalisz',
        studentsYear: 1,
      ),
      Students(id: 2, firstName: 'Adam', lastName: 'Nowak', studentsYear: 2),
      Students(
        id: 3,
        firstName: 'Piotr',
        lastName: 'Kowalski',
        studentsYear: 3,
      ),
      Students(
        id: 4,
        firstName: 'Kamil',
        lastName: 'Chlebiej',
        studentsYear: 1,
      ),
      Students(id: 5, firstName: 'Patryk', lastName: 'Kusper', studentsYear: 1),
      Students(
        id: 6,
        firstName: 'Aleksandra',
        lastName: 'Pawlik',
        studentsYear: 5,
      ),
    ];

    lastID += 6;

    final missingStudents = seedStudents
        .where((student) => !existingIds.contains(student.id))
        .toList();

    if (missingStudents.isNotEmpty) {
      await handler.insertStudents(missingStudents);
    }
  }

  Future<List<Students>> _loadStudents() async {
    await handler.initializedDB();
    await addStudents();
    return handler.retrieveStudents();
  }

  @override
  void initState() {
    super.initState();
    handler = DataBase();
    _studentsFuture = _loadStudents();
  }

  @override
  void dispose() {
    unawaited(handler.closeDB());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text(
          "Baza Danych MK",
          style: TextStyle(
            shadows: [
              Shadow(
                blurRadius: 3.0,
                color: Colors.blueGrey,
                offset: Offset(0, 1.5),
              ),
            ],
          ),
        ),
      ),
      body: _mainLayout(context),
    );
  }

  Widget _mainLayout(BuildContext context) {
    return FutureBuilder<List<Students>>(
      future: _studentsFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Students>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(fontSize: 20, color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Brak danych w bazie danych',
              style: TextStyle(fontSize: 20),
            ),
          );
        }

        final students = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.blueAccent,
          body: ListView.builder(
            itemCount: students.length,
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 90),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(10, 2, 2, 2),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                            Icons.edit,
                          color: Colors.green,
                        ),
                        onPressed: () {

                          _goToEditStudentPage(context, students[index]);

                        }
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                          handler.deleteStudent(students[index].id);
                          setState(() {
                            students.removeAt(index);
                          });
                          }
                      ),
                    ]
                  ),
                  title: Text(
                    '${students[index].firstName} ${students[index].lastName}',
                  ),
                  subtitle: Text('Year: ${students[index].studentsYear}'),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _goToAddStudentPage(context);
            },
            child: const Icon(Icons.add),
          ),

        );
      },
    );
  }

  void _goToAddStudentPage(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => AddStudentPage())).then((_) {
      setState(() {
        _studentsFuture = _loadStudents();
      });
    });
  }

  void _goToEditStudentPage(BuildContext context, Students student) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => EditStudentPage(student: student))).then((_) {
      setState(() {
        _studentsFuture = _loadStudents();
      });
    });
  }
}
