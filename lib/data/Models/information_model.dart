class InformationModel {
  int? id;
  String? firstName;
  String? lastName;
  int? age;
  String? gender;
  String? email;
  String? phone;
  String? image;
  String? departmentId;
  String? shiftId;
  String? companyName;
  int? salary;
  String? salaryType;
  String? address;
  String? position;
  String? hiringDate;
  String? rating;
  String? current_salary;
  InformationModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.age,
      this.gender,
      this.email,
      this.phone,
      this.image,
      this.departmentId,
      this.shiftId,
      this.companyName,
      this.salary,
      this.salaryType,
      this.address,
      this.position,
      this.hiringDate,
      this.rating});

  InformationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    age = json['age'];
    gender = json['gender'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    departmentId = json['departmentId'];
    shiftId = json['shiftId'];
    companyName = json['companyName'];
    salary = json['salary'];
    salaryType = json['salary_type'];
    address = json['address'];
    position = json['position'];
    hiringDate = json['hiring_date'];
    rating = json['rating'];
    current_salary = json['current_salary'];
  }
}
