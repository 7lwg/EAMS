class GetAttendanceNewModel {
  int id;
  int employee_id;
  int date;
  String time_in;
  String time_out;
  String company_name;
  String firstName;
  String lastName;
  bool current_month;

  GetAttendanceNewModel({
    required this.id,
    required this.employee_id,
    required this.date,
    required this.time_in,
    required this.time_out,
    required this.company_name,
    required this.firstName,
    required this.lastName,
    required this.current_month,
  });

  factory GetAttendanceNewModel.fromJson(Map<String, dynamic> json) {
    return GetAttendanceNewModel(
      id: json['id'] as int,
      employee_id: json['employee_id'] as int,
      date: json['date'] as int,
      time_in: json['time_in'] as String,
      time_out: json['time_out'] as String,
      company_name: json['company_name'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      current_month: json['current_month'] as bool,
    );
  }
  map(GetAttendanceNewModel Function(dynamic json) param0) {}
}
