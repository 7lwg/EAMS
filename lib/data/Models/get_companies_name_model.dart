class GetCompaniesNameModel {
  int id;
  String name;
  String Admin_username;
  String Admin_password;
  List<String> Location;
  int Company_diameter;

  GetCompaniesNameModel({
    required this.id,
    required this.name,
    required this.Admin_username,
    required this.Admin_password,
    required this.Location,
    required this.Company_diameter,
  });

  factory GetCompaniesNameModel.fromJson(Map<String, dynamic> json) {
    return GetCompaniesNameModel(
      id: json['id'],
      name: json['Name'],
      Admin_username: json['Admin_username'],
      Admin_password: json['Admin_password'],
      Location: List<String>.from(json['Location']),
      Company_diameter: json['Company_diameter'],
    );
  }
}
