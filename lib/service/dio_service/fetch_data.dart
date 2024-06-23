import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchData() async {
    try {
      Response response = await _dio.get('http://192.168.221.48:1826/data');
      return (response.data);
    } catch (e) {
      throw Exception('Failed to fetch data');
    }
  }
}
