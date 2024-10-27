class GetHolidaysAsksModel {
  int id;
  int employee_id;
  String ask_time;
  int start_holiday;
  int end_holiday;
  bool respond_status;
  String reason;
  String company_name;

  GetHolidaysAsksModel({
    required this.id,
    required this.employee_id,
    required this.ask_time,
    required this.start_holiday,
    required this.end_holiday,
    required this.respond_status,
    required this.reason,
    required this.company_name,
  });

  factory GetHolidaysAsksModel.fromJson(Map<String, dynamic> json) {
    return GetHolidaysAsksModel(
      id: json['id'] as int,
      employee_id: json['employee_id'] as int,
      ask_time: json['ask_time'] as String,
      start_holiday: json['start_holiday'] as int,
      end_holiday: json['end_holiday'] as int,
      respond_status: json['respond_status'] as bool,
      reason: json['reason'] as String,
      company_name: json['company_name'] as String,
    );
  }
  map(GetHolidaysAsksModel Function(dynamic json) param0) {}
}
