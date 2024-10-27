class GetUsersModel {
  int id;
  String firstName;
  String lastName;
  int age;
  String gender;
  String email;
  String phone;
  String image;
  String? departmentId;
  String? shiftId;
  String companyName;
  int salary;
  String salary_type;
  String hiring_date;
  String address;
  String position;
  String rating;
  String password;
  String current_salary;

  GetUsersModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    required this.image,
    this.departmentId,
    this.shiftId,
    required this.companyName,
    required this.salary,
    required this.salary_type,
    required this.hiring_date,
    required this.address,
    required this.position,
    required this.rating,
    required this.password,
    required this.current_salary,
  });

  factory GetUsersModel.fromJson(Map<String, dynamic> json) {
    return GetUsersModel(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      image: json['image'] as String,
      departmentId: json['departmentId'] as String?,
      shiftId: json['shiftId'] as String?,
      companyName: json['companyName'] as String,
      salary: json['salary'] as int,
      salary_type: json['salary_type'] as String,
      hiring_date: json['hiring_date'] as String,
      address: json['address'] as String,
      position: json['position'] as String,
      rating: json['rating'] as String,
      password: json['password'] as String,
      current_salary: json['current_salary'] as String,
    );
  }
  map(GetUsersModel Function(dynamic json) param0) {}
}
