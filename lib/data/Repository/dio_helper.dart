import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(BaseOptions(
        baseUrl: 'https://oarqjspwajbojrddcvky.supabase.co/',
        receiveDataWhenStatusError: true,
        headers: {
          'apikey':
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9hcnFqc3B3YWpib2pyZGRjdmt5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE3Mzk2NTQsImV4cCI6MjAyNzMxNTY1NH0.NJ-QaQKrveyPpE2G9-8kizBh6ByFShdQ47xs2Bx8wmQ',
        }));
  }

  static Future<Response<dynamic>> getdata({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    return await dio!.get(url, queryParameters: query);
  }

  static Future<Response> updata({
    required String url,
    required Map<String, dynamic> query,
    required Map<String, dynamic> data,
  }) async {
    return await dio!.patch(url, queryParameters: query, data: data);
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
  }) async {
    return await dio!.post(url, queryParameters: query, data: data);
  }
}
