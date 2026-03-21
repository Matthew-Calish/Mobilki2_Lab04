import 'model_students_fields.dart';

class Students {

  late  int id;
  late  String firstName;
  late  String lastName;
  late  int studentsYear;

  Students({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.studentsYear
  });

  Students.fromMap(Map<String, dynamic> result)
  : id = result[StudentFields.id],
    firstName = result[StudentFields.firstName],
    lastName = result[StudentFields.lastName],
    studentsYear = result[StudentFields.studentsYear];

  Map<String, Object> toMap(){
    return {
      StudentFields.id: id,
      StudentFields.firstName: firstName,
      StudentFields.lastName: lastName,
      StudentFields.studentsYear: studentsYear
    };
  }

}