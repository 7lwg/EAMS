import 'dart:convert';
import 'package:graduation_project/data/Models/get_companies_name_model.dart';
import 'package:http/http.dart' as http;

List<GetCompaniesNameModel> companies_name = [];
String? selectedAttendanceItem = 'day';
String url = "";
var response;
var selectedCompany;
bool adding_new_company = false;
bool edit_comoany_company = false;
var postCompanyName;
var putcompanyData;
int editted_company_index = 0;
int editted_company_id = 0;

class GetCompaniesNameRepo {
  final supabaseUrl = 'https://oarqjspwajbojrddcvky.supabase.co/rest/v1';
  final supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9hcnFqc3B3YWpib2pyZGRjdmt5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE3Mzk2NTQsImV4cCI6MjAyNzMxNTY1NH0.NJ-QaQKrveyPpE2G9-8kizBh6ByFShdQ47xs2Bx8wmQ';
  Future<String?> getCompaniesNameData() async {
    try {
      if (adding_new_company == true) {
        response = await http.post(
          Uri.parse('$supabaseUrl/companies_name'),
          body: jsonEncode(postCompanyName),
          headers: {
            'Content-Type': 'application/json',
            'apikey': supabaseKey,
          },
        );
        adding_new_company = false;
      } else if (edit_comoany_company) {
        response = await http.put(
          Uri.parse('$supabaseUrl/companies_name?id=eq.${editted_company_id}'),
          body: jsonEncode(putcompanyData),
          headers: {
            'Content-Type': 'application/json',
            'apikey': supabaseKey,
          },
        );
        edit_comoany_company = false;
      }
      url = '$supabaseUrl/companies_name';
      var attendance_response = await http.get(
        Uri.parse(url),
        headers: {'apikey': supabaseKey},
      );

      if (attendance_response.statusCode == 200) {
        List<dynamic> decodedResponse = jsonDecode(attendance_response.body);
        companies_name = decodedResponse
            .map((json) => GetCompaniesNameModel.fromJson(json))
            .toList();
        companies_name.sort((a, b) => a.id - b.id);
        return "ahmed";
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
