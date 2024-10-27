class GetAttendanceModel {
  int id;
  String name;
  List<int> employees;
  List<int> check_in;
  List<int> check_out;

  GetAttendanceModel({
    required this.id,
    required this.name,
    required this.employees,
    required this.check_in,
    required this.check_out,
  });

  factory GetAttendanceModel.fromJson(Map<String, dynamic> json) {
    return GetAttendanceModel(
      id: json['id'],
      name: json['Name'],
      employees: List<int>.from(json['employees']),
      check_in: List<int>.from(json['check_in']),
      check_out: List<int>.from(json['check_out']),
    );
  }
}
