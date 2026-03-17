import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'sql_management/model_students.dart';
import 'sql_management/database.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQLite MK',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blue),
      ),
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

  Future<void> addStudents() async {
    final existingStudents = await handler.retrieveStudents();
    final existingIds = existingStudents.map((student) => student.id).toSet();

    final seedStudents = <Students>[
      Students(id: 1, firstName: 'Mateusz', lastName: 'Kalisz', studentsYear: 1),
      Students(id: 2, firstName: 'Adam', lastName: 'Nowak', studentsYear: 2),
      Students(id: 3, firstName: 'Piotr', lastName: 'Kowalski', studentsYear: 3),
      Students(id: 4, firstName: 'Kamil', lastName: 'Chlebiej', studentsYear: 1),
    ];

    final missingStudents = seedStudents.where((student) => !existingIds.contains(student.id)).toList();

    if (missingStudents.isNotEmpty){
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
  void dispose(){
    unawaited(handler.closeDB());
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text("Baza Danych MK"),
        ),
        body: FutureBuilder<List<Students>>(
            future: _studentsFuture,
            builder: (BuildContext context, AsyncSnapshot<List<Students>> snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }

              if(snapshot.hasError){
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.red
                    ),

                  ),
                );

              }

              if(!snapshot.hasData || snapshot.data!.isEmpty){
                return const Center(
                  child: Text(
                    'Brak danych w bazie danych',
                    style: TextStyle(
                      fontSize: 20,
                    )
                  )
                );
              }

              final students = snapshot.data!;

              return ListView.builder(
                itemCount: students.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      title: Text(
                        '${students[index].firstName} ${students[index].lastName}'
                      ),
                      subtitle: Text(
                        'Year: ${students[index].studentsYear}'
                      ),
                    ),
                  );
                }
              );

            }
        )
    );
  }
}