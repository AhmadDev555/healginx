import 'package:dio/dio.dart';

abstract class ApiService {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParams});
  Future<dynamic> post(String path, {Map<String, dynamic>? data, FormData? formData});
  Future<dynamic> put(String path, {Map<String, dynamic>? data});
  Future<dynamic> delete(String path);
}