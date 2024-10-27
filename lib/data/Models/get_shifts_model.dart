class GetShiftsModel {
  int id;
  String name;
  String description;
  String companyName;
  String start_time;
  String end_time;

  GetShiftsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.companyName,
    required this.start_time,
    required this.end_time,
  });

  factory GetShiftsModel.fromJson(Map<String, dynamic> json) {
    return GetShiftsModel(
      id: json['id'] as int,
      name: json['Name'] as String,
      description: json['Description'] as String,
      companyName: json['companyName'] as String,
      start_time: json['start_time'] as String,
      end_time: json['end_time'] as String,
    );
  }
  map(GetShiftsModel Function(dynamic json) param0) {}
}
