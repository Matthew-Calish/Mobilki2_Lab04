import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'sql_management/model_students.dart';
import 'sql_management/database.dart';

class EditStudentPage extends StatefulWidget {
  final Students student;
  const EditStudentPage({required this.student, super.key});

  @override
  State<EditStudentPage> createState() => _EditStudentPage();
}

class _EditStudentPage extends State<EditStudentPage> {
  late Students editedStudent;

  late DataBase handler;

  Future<void> editStudent(Students newStudent) async {
    await handler.insertNewStudent(newStudent);
  }

  @override
  void initState() {
    super.initState();
    handler = DataBase();
    handler.initializedDB();

    editedStudent = Students(
      id: widget.student.id,
      firstName: widget.student.firstName,
      lastName: widget.student.lastName,
      studentsYear: widget.student.studentsYear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: const Text(
          'Edytuj dane studenta',
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
        iconTheme: const IconThemeData(
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 3.0,
              color: Colors.blueGrey,
              offset: Offset(0, 1),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Card(
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Wprowadz imię studenta:",
                            style: TextStyle(fontSize: 18),
                          ),
                          TextField(
                            controller: TextEditingController(
                              text: editedStudent.firstName,
                            ),
                            onChanged: (value) {
                              editedStudent.firstName = value;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Wprowadz nazwisko studenta:",
                            style: TextStyle(fontSize: 18),
                          ),
                          TextField(
                            controller: TextEditingController(
                              text: editedStudent.lastName,
                            ),
                            onChanged: (value) {
                              editedStudent.lastName = value;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Wybierz rok studenta:",
                            style: TextStyle(fontSize: 18),
                          ),
                          DropdownButton<int>(
                            value: editedStudent.studentsYear,
                            onChanged: (value) {
                              setState(() {
                                editedStudent.studentsYear = value!;
                              });
                            },
                            items: List<DropdownMenuItem<int>>.generate(
                              5,
                              (index) => DropdownMenuItem<int>(
                                value: index + 1,
                                child: Text('${index + 1}'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        editStudent(editedStudent);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Edytuj dane studenta',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
