import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../constants/api_constants.dart';
import 'api_service_interface/i_api_service.dart';

class DioApiService implements ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );


  DioApiService(){

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {

        if (options.path.contains(ApiConstants.groqAIModel)) {
          options.headers.addAll({
            "Authorization": "Bearer ${ApiConstants.groqApiKey}",
          });
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Handle responses (if needed)
        return handler.next(response);
      },
      onError: (DioException err, handler) async {



        // Pass the error to the next interceptor in the chain.
        // Handling timeout and network errors
        // Handling timeout and network errors
        if (err.type == DioExceptionType.connectionTimeout || err.type == DioExceptionType.receiveTimeout) {
          // Throw custom error for timeout
          // throw HtpCustomError(
          //   code: 0,
          //   message: "Request Timeout: Please try again later",
          //   result: '',
          // );
          final DioException error = DioException(message: "Request Timeout: Please try again later", requestOptions: RequestOptions());

          handler.next(error);
        } else if (err.type == DioExceptionType.connectionError && err.error is SocketException) {
          // Handle specific SocketException for "No route to host"
          // SocketException socketException = err.error as SocketException;
          // if (socketException.osError?.errorCode == 7) {
          final DioException error = DioException(message: "No route to host: Unable to connect to the server. Please check your network.", requestOptions: RequestOptions());

          handler.next(error);
          //  }
        }

        else {



          handler.next(err);
        }
      },
    ));
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        responseBody: true,
        requestBody: true,
      ));
    }

  }






  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParams);
      return response.data;
    } on Exception catch (e) {
      _handleError(e);
    }
  }



  @override
  Future<dynamic> post(String path, {Map<String, dynamic>? data, FormData? formData}) async {
    try {
      final response = await _dio.post(
          path,
          data: data??formData,
          options: Options(
          // responseType: ResponseType.bytes,
        ),
      );

      if (response.data is List<int>) {
        final decoded = utf8.decode(
          response.data,
          allowMalformed: true,
        );
        return jsonDecode(decoded);
      }
      if (response.data is String) {
        return jsonDecode(response.data);
      }
      return response.data;
    } on Exception catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<dynamic> put(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } on Exception catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<dynamic> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.data;
    } on Exception catch (e, _) {
      _handleError(e);
    }
  }


  void _handleError(Exception exception) {
    throw exception;
  }
}
 
