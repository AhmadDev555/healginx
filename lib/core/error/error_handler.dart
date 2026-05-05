import 'package:dio/dio.dart';
import 'package:healginx/constants/data_source.dart';
import 'package:healginx/core/error/response_code.dart';
import 'package:healginx/extensions/DataSourceExtention.dart';


import 'failure.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    } else {
      failure = DataSource.defaultError.getFailure() as Failure;
    }
  }


  Failure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.connectTimeout.getFailure() as Failure;
      case DioExceptionType.sendTimeout:
        return DataSource.sendTimeout.getFailure() as Failure;
      case DioExceptionType.receiveTimeout:
        return DataSource.receiveTimeout.getFailure() as Failure;
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.cancel:
        return DataSource.cancel.getFailure() as Failure;
      case DioExceptionType.connectionError:
        return DataSource.connectionError.getFailure() as Failure;
      default:
        return _handleDefaultError(error);
    }
  }

  _handleBadResponse(DioException error) {
    try {
      final code = error.response?.statusCode ?? ResponseCode.defaultError;
      String message = '';
      switch (code) {
        case ResponseCode.unauthorised:
          return DataSource.unauthorised.getFailure();
        case ResponseCode.forbidden:
          return DataSource.forbidden.getFailure();
        case ResponseCode.notFound:
          return DataSource.notFound.getFailure();
        default:
          message = _extractErrorMessage(error.response?.data);
          return Failure(code, message);
      }
    } catch (e) {
      return DataSource.defaultError.getFailure();
    }
  }

  _handleDefaultError(DioException error) {
    if (error.response?.statusCode == ResponseCode.noInternetConnection) {
      return DataSource.noInternetConnection.getFailure();
    } else {
      return DataSource.defaultError.getFailure();
    }
  }

  String _extractErrorMessage(dynamic data) {
    if (data is String) return data;
    String message = '';
    if (data is Map) {
      data.forEach((key, value) {
        if (value is List) {
          message += value.join('\n');
        } else if (value is String) {
          message += value;
        } else {
          message += value.toString();
        }
      });
    }
    return message;
  }


}