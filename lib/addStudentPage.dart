
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'sql_management/model_students.dart';
import 'sql_management/database.dart';
import 'main.dart';



class AddStudentPage extends StatefulWidget {


  const AddStudentPage({
    super.key,
  });

  @override
  State<AddStudentPage> createState() => _AddStudentPage();
}

class _AddStudentPage extends State<AddStudentPage> {

  String name = '';
  String lastName = '';
  int year = 1;

  int newStudentIndex = 999;

  late DataBase handler;
  late Future<List<Students>> _studentsFuture;

  Future<void> addNewStudent(Students newStudent) async{
    await handler.insertNewStudent(newStudent);
  }

  Future<List<Students>> _loadStudents() async {
    await handler.initializedDB();
    return handler.retrieveStudents();
  }

  @override
  void initState() {
    super.initState();
    handler = DataBase();
    _studentsFuture = _loadStudents();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: const Text(
            'Dodaj studenta',
            style: TextStyle(
                shadows: [Shadow(
                  blurRadius: 3.0,
                  color: Colors.blueGrey,
                  offset: Offset(0, 1.5),
                )]
            )
        ),
        iconTheme: const IconThemeData(
            color: Colors.white,
            shadows: [Shadow(
              blurRadius: 3.0,
              color: Colors.blueGrey,
              offset: Offset(0, 1),
            )]
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Card(
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: FutureBuilder(
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

                  newStudentIndex = snapshot.data!.length;

                  return SingleChildScrollView(
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
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    TextField(
                                      onChanged: (value){
                                        name = value;
                                      },
                                    )
                                  ]
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
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    TextField(
                                      onChanged: (value){
                                        lastName = value;
                                      },
                                    )
                                  ]
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
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    DropdownButton<int>(
                                      value: year,
                                      onChanged: (value) {
                                        setState(() {
                                          year = value!;
                                        });
                                      },
                                      items: List<DropdownMenuItem<int>>.generate(
                                        5,
                                            (index) => DropdownMenuItem<int>(
                                          value: index + 1,
                                          child: Text('${index + 1}'),
                                        ),
                                      ),
                                    )
                                  ]
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  addNewStudent(Students(id: newStudentIndex, firstName: name, lastName: lastName, studentsYear: year));
                                  newStudentIndex += 1;
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                    'Dodaj studenta',
                                    style: TextStyle(
                                      fontSize: 18,
                                    )
                                )
                            ),
                          )
                        ]
                    ),
                  );

                }
            ),
          ),
        ),
      ),
    );
  }

}

