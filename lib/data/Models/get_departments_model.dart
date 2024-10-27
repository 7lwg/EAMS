class GetDepartmentsModel {
  int id;
  String name;
  String description;
  String companyName;
  String department_manger;

  GetDepartmentsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.companyName,
    required this.department_manger,
  });

  factory GetDepartmentsModel.fromJson(Map<String, dynamic> json) {
    return GetDepartmentsModel(
      id: json['id'] as int,
      name: json['Name'] as String,
      description: json['Description'] as String,
      companyName: json['companyName'] as String,
      department_manger: json['department_manger'] as String,
    );
  }
  map(GetDepartmentsModel Function(dynamic json) param0) {}
}
