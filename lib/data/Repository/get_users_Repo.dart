import 'dart:convert';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:http/http.dart' as http;
import 'package:graduation_project/data/Models/get_users_data_module.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<GetUsersModel> users = [];
String search_users_text = "";
String search_users_text_department = "";
bool deleted_employee = false;
bool adding_employee = false;
bool editing_employee = false;
String deleted_employee_id = "";
int editted_employee_id = 0;
var response;
String? selectedUsersSortItem = 'id';
bool sort = false;
bool sort_ascending = true;
String? selectedUsersItem = 'id';
String? selectedUsersItem_department = 'id';
String Employer_first_Name = "";
String Employer_last_Name = "";
String Employer_age = "";
int Employer_age_start = 20;
int Employer_age_end = 90;
String Employer_email = "";
String Employer_image = "";
String Employer_phone = "";
String shiftId = "";
String Employer_salary = "";
int Employer_salary_start = 0;
int Employer_salary_end = 100000;
double Employer_rating_start = 0.0;
double Employer_rating_end = 5.0;
String Employer_address = "";
String Employer_position = "";
double Employer_rating = 0.0;
int gender_current_option = 0;
int salary_type_current_option = 0;
var postUsersData;
var putUsersData;
String Departments_number = "";
String Shifts_number = "";
bool Department_Employee_List = false;

bool adding_employee_to_department = false;
bool adding_employee_to_shift = false;
int selected_adding_employee_to_department = 0;
String url = "";
List<bool> isChecked = [];
String exiption_condition = "";
var editted_employee_index;
String emploees_to_be_attended = "";
bool adding_employee_to_attendance = false;
var getting_number_of_users;
bool login_page = false;

class GetUsersRepo {
  final supabaseUrl = 'https://oarqjspwajbojrddcvky.supabase.co/rest/v1';
  final supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9hcnFqc3B3YWpib2pyZGRjdmt5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE3Mzk2NTQsImV4cCI6MjAyNzMxNTY1NH0.NJ-QaQKrveyPpE2G9-8kizBh6ByFShdQ47xs2Bx8wmQ';
  Future<String?> getEmployeeData() async {
    try {
      if (deleted_employee == true) {
        response = await http.delete(
          Uri.parse(
              '$supabaseUrl/users?id=eq.${deleted_employee_id}&companyName=eq.${Company_Name}'),
          headers: {'apikey': supabaseKey},
        );
        deleted_employee = false;
      } else if (adding_employee == true) {
        response = await http.post(
          Uri.parse('$supabaseUrl/users'),
          body: jsonEncode(postUsersData),
          headers: {
            'Content-Type': 'application/json',
            'apikey': supabaseKey,
          },
        );

        adding_employee = false;
      } else if (editing_employee == true) {
        response = await http.put(
          Uri.parse('$supabaseUrl/users?id=eq.${editted_employee_id}'),
          body: jsonEncode(putUsersData),
          headers: {
            'Content-Type': 'application/json',
            'apikey': supabaseKey,
          },
        );
        editted_employee_id = 0;
        editing_employee = false;
      }

      if (adding_employee_to_department == true ||
          adding_employee_to_shift == true) {
        if (adding_employee_to_department == true) {
          exiption_condition = "departmentId";
        } else if (adding_employee_to_shift == true) {
          exiption_condition = "shiftId";
        }
        if (search_users_text_department != "") {
          if (selectedUsersItem_department == 'salary') {
            url =
                '$supabaseUrl/users?${exiption_condition}=neq.${search_users_text}&${selectedUsersItem_department}=gt.${(Employer_salary_start - 1).toString()}&${selectedUsersItem_department}=lt.${(Employer_salary_end + 1).toString()}&companyName=eq.${Company_Name}';
          } else if (selectedUsersItem_department == 'age') {
            url =
                '$supabaseUrl/users?${exiption_condition}=neq.${search_users_text}&${selectedUsersItem_department}=gt.${(Employer_age_start - 1).toString()}&${selectedUsersItem_department}=lt.${(Employer_age_end + 1).toString()}&companyName=eq.${Company_Name}';
          } else if (selectedUsersItem_department == 'rating') {
            url =
                '$supabaseUrl/users?${exiption_condition}=neq.${search_users_text}&${selectedUsersItem_department}=gt.${(Employer_rating_start - 0.0000000000001).toString()}&${selectedUsersItem_department}=lt.${(Employer_rating_end + 0.0000000000001).toString()}&companyName=eq.${Company_Name}';
          } else if (selectedUsersItem_department == 'id' ||
              selectedUsersItem_department == 'gender') {
            url =
                '$supabaseUrl/users?${exiption_condition}=neq.${search_users_text}&${selectedUsersItem_department}=eq.${search_users_text_department}&companyName=eq.${Company_Name}';
          } else {
            url =
                '$supabaseUrl/users?${exiption_condition}=neq.${search_users_text}&${selectedUsersItem_department}=ilike.*${search_users_text_department}*&companyName=eq.${Company_Name}';
          }
        } else {
          url =
              '$supabaseUrl/users?${exiption_condition}=neq.${search_users_text}&companyName=eq.${Company_Name}';
        }
      } else if (adding_employee_to_attendance == true) {
        if (search_users_text == "") {
          url =
              '$supabaseUrl/users?${emploees_to_be_attended}&companyName=eq.${Company_Name}';
        } else {
          if (selectedUsersItem == 'age') {
            url =
                '$supabaseUrl/users?${emploees_to_be_attended}&${selectedUsersItem}=gt.${(Employer_age_start - 1).toString()}&${selectedUsersItem}=lt.${(Employer_age_end + 1).toString()}&companyName=eq.${Company_Name}';
          } else if (selectedUsersItem == 'salary') {
            url =
                '$supabaseUrl/users?${emploees_to_be_attended}&${selectedUsersItem}=gt.${(Employer_salary_start - 1).toString()}&${selectedUsersItem}=lt.${(Employer_salary_end + 1).toString()}&companyName=eq.${Company_Name}';
          } else if (selectedUsersItem == 'rating') {
            url =
                '$supabaseUrl/users?${emploees_to_be_attended}&${selectedUsersItem}=gt.${(Employer_rating_start - 0.0000000000001).toString()}&${selectedUsersItem}=lt.${(Employer_rating_end + 0.0000000000001).toString()}&companyName=eq.${Company_Name}';
          } else if (selectedUsersItem == 'id' ||
              selectedUsersItem == 'gender') {
            url =
                '$supabaseUrl/users?${emploees_to_be_attended}&${selectedUsersItem}=eq.${search_users_text}&companyName=eq.${Company_Name}';
          } else {
            url =
                '$supabaseUrl/users?${emploees_to_be_attended}&${selectedUsersItem}=ilike.*${search_users_text}*&companyName=eq.${Company_Name}';
          }
        }
      } else {
        // searching in a specific department or shift for an employee in this department or shift
        if (search_users_text != "" && search_users_text_department != "") {
          if (selectedUsersItem_department == 'salary') {
            url =
                '$supabaseUrl/users?${selectedUsersItem}=eq.${search_users_text}&${selectedUsersItem_department}=gt.${(Employer_salary_start - 1).toString()}&${selectedUsersItem_department}=lt.${(Employer_salary_end + 1).toString()}&companyName=eq.${Company_Name}';
          } else if (selectedUsersItem_department == 'age') {
            url =
                '$supabaseUrl/users?${selectedUsersItem}=eq.${search_users_text}&${selectedUsersItem_department}=gt.${(Employer_age_start - 1).toString()}&${selectedUsersItem_department}=lt.${(Employer_age_end + 1).toString()}&companyName=eq.${Company_Name}';
          } else if (selectedUsersItem_department == 'rating') {
            url =
                '$supabaseUrl/users?${selectedUsersItem}=eq.${search_users_text}&${selectedUsersItem_department}=gt.${(Employer_rating_start - 0.0000000000001).toString()}&${selectedUsersItem_department}=lt.${(Employer_rating_end + 0.0000000000001).toString()}&companyName=eq.${Company_Name}';
          } else if (selectedUsersItem_department == 'id' ||
              selectedUsersItem_department == 'gender') {
            url =
                '$supabaseUrl/users?${selectedUsersItem}=eq.${search_users_text}&${selectedUsersItem_department}=eq.${search_users_text_department}&companyName=eq.${Company_Name}';
          } else {
            url =
                '$supabaseUrl/users?${selectedUsersItem}=eq.${search_users_text}&${selectedUsersItem_department}=ilike.*${search_users_text_department}*&companyName=eq.${Company_Name}';
          }
        } else if (search_users_text != "" &&
            search_users_text_department == "") {
          if (selectedUsersItem == 'age') {
            url =
                '$supabaseUrl/users?${selectedUsersItem}=gt.${(Employer_age_start - 1).toString()}&${selectedUsersItem}=lt.${(Employer_age_end + 1).toString()}&companyName=eq.${Company_Name}';
          } else if (selectedUsersItem == 'salary') {
            url =
                '$supabaseUrl/users?${selectedUsersItem}=gt.${(Employer_salary_start - 1).toString()}&${selectedUsersItem}=lt.${(Employer_salary_end + 1).toString()}&companyName=eq.${Company_Name}';
          } else if (selectedUsersItem == 'rating') {
            url =
                '$supabaseUrl/users?${selectedUsersItem}=gt.${(Employer_rating_start - 0.0000000000001).toString()}&${selectedUsersItem}=lt.${(Employer_rating_end + 0.0000000000001).toString()}&companyName=eq.${Company_Name}';
          } else if (selectedUsersItem == 'id' ||
              selectedUsersItem == 'gender') {
            url =
                '$supabaseUrl/users?${selectedUsersItem}=eq.${search_users_text}&companyName=eq.${Company_Name}';
          } else {
            url =
                '$supabaseUrl/users?${selectedUsersItem}=ilike.*${search_users_text}*&companyName=eq.${Company_Name}';
          }
        } else if (search_users_text == "" &&
            search_users_text_department != "") {
          url =
              '$supabaseUrl/users?${selectedUsersItem_department}=ilike.*${search_users_text_department}*&companyName=eq.${Company_Name}';
        } else if (search_users_text == "" &&
            search_users_text_department == "") {
          // default case without search or sort
          url = '$supabaseUrl/users?companyName=eq.${Company_Name}';
        }
      }

      if (splashscreen == true) {
        url = '$supabaseUrl/users?companyName=eq.${Company_Name}';
        splashscreen = false;
      }

      if (getting_number_of_users == true) {
        url = '$supabaseUrl/users';
      }
      response = await http.get(
        Uri.parse(url),
        headers: {'apikey': supabaseKey},
      );
      if (response.statusCode == 200) {
        List<dynamic> decodedResponse = jsonDecode(response.body);

        users = decodedResponse
            .map((json) => GetUsersModel.fromJson(json))
            .toList();

        // sorting in employees page
        if (sort == true) {
          users.sort((a, b) {
            switch (selectedUsersSortItem) {
              case 'id':
                if (sort_ascending == true) {
                  return a.id.compareTo(b.id);
                } else {
                  return b.id.compareTo(a.id);
                }

              case 'firstName':
                if (sort_ascending == true) {
                  return a.firstName.compareTo(b.firstName);
                } else {
                  return b.firstName.compareTo(a.firstName);
                }

              case 'lastName':
                if (sort_ascending == true) {
                  return a.lastName.compareTo(b.lastName);
                } else {
                  return b.lastName.compareTo(a.lastName);
                }
              case 'age':
                if (sort_ascending == true) {
                  return a.age.compareTo(b.age);
                } else {
                  return b.age.compareTo(a.age);
                }

              case 'phone':
                if (sort_ascending == true) {
                  return a.phone.compareTo(b.phone);
                } else {
                  return b.phone.compareTo(a.phone);
                }

              case 'email':
                if (sort_ascending == true) {
                  return a.email.compareTo(b.email);
                } else {
                  return b.email.compareTo(a.email);
                }

              case 'salary':
                if (sort_ascending == true) {
                  return a.salary.compareTo(b.salary);
                } else {
                  return b.salary.compareTo(a.salary);
                }
              case 'shiftId':
                if (sort_ascending == true) {
                  return a.shiftId.toString().compareTo(b.shiftId.toString());
                } else {
                  return b.shiftId.toString().compareTo(a.shiftId.toString());
                }
              case 'departmentId':
                if (sort_ascending == true) {
                  return a.departmentId
                      .toString()
                      .compareTo(b.departmentId.toString());
                } else {
                  return b.departmentId
                      .toString()
                      .compareTo(a.departmentId.toString());
                }
              case 'rating':
                if (sort_ascending == true) {
                  return a.rating.compareTo((b.rating));
                } else {
                  return (b.rating).compareTo((a.rating));
                }
              default:
                return 0; // If the field is not recognized, no sorting is applied
            }
          });
        } else {
          users.sort((a, b) => a.id.compareTo(b.id));
        }

        isChecked.clear();
        for (int i = 0; i < users.length; i++) {
          isChecked.add(false);
        }
        final prefs = await SharedPreferences.getInstance();
        Departments_number = prefs.getString('Departments_number') ?? "";
        Shifts_number = prefs.getString('Shifts_number') ?? "";
        return "ahmed";
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
