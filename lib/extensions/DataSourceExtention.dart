

import 'package:healginx/constants/data_source.dart';
import 'package:healginx/core/error/failure.dart';
import 'package:healginx/core/error/response_code.dart';
import 'package:healginx/core/error/response_message.dart';

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.success:
        return Failure(ResponseCode.success, ResponseMessage.success);
      case DataSource.noContent:
        return Failure(ResponseCode.noContent, ResponseMessage.noContent);
      case DataSource.badRequest:
        return Failure(ResponseCode.badRequest, ResponseMessage.badRequestError);
      case DataSource.forbidden:
        return Failure(ResponseCode.forbidden, ResponseMessage.forbiddenError);
      case DataSource.unauthorised:
        return Failure(ResponseCode.unauthorised, ResponseMessage.unauthorizedError);
      case DataSource.notFound:
        return Failure(ResponseCode.notFound, ResponseMessage.notFoundError);
      case DataSource.internetServerError:
        return Failure(ResponseCode.internalServerError, ResponseMessage.internalServerError);
      case DataSource.connectTimeout:
        return Failure(ResponseCode.connectTimeout, ResponseMessage.connectTimeout);
      case DataSource.connectionError:
        return Failure(ResponseCode.connectionError, ResponseMessage.connectionError);
      case DataSource.cancel:
        return Failure(ResponseCode.cancel, ResponseMessage.cancel);
      case DataSource.receiveTimeout:
        return Failure(ResponseCode.receiveTimeout, ResponseMessage.receiveTimeout);
      case DataSource.sendTimeout:
        return Failure(ResponseCode.sendTimeout, ResponseMessage.sendTimeout);
      case DataSource.cacheError:
        return Failure(ResponseCode.cacheError, ResponseMessage.cacheError);
      case DataSource.noInternetConnection:
        return Failure(ResponseCode.noInternetConnection, ResponseMessage.noInternetError);
      case DataSource.defaultError:
        return Failure(ResponseCode.defaultError, ResponseMessage.defaultError);
    }
  }
}