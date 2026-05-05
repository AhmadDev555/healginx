
import 'package:healginx/constants/error_messages.dart';

class ResponseMessage {
  static const String success = ErrorMessages.success; // success with data
  static const String noContent = ErrorMessages.noContent; // success with no data (no content)
  static const String badRequestError = ErrorMessages.badRequestError; // failure, API rejected request
  static const String unauthorizedError = ErrorMessages.unauthorizedError; // failure, user is not authorised
  static const String forbiddenError = ErrorMessages.forbiddenError; // failure, API rejected request
  static const String internalServerError = ErrorMessages.internalServerError; // failure, crash on server side
  static const String notFoundError = ErrorMessages.notFoundError; // failure, crash on server side

// Local status codes
  static const String connectTimeout = ErrorMessages.timeoutError;
  static const String cancel = ErrorMessages.defaultError;
  static const String receiveTimeout = ErrorMessages.timeoutError;
  static const String sendTimeout = ErrorMessages.timeoutError;
  static const String cacheError = ErrorMessages.cacheError;
  static const String noInternetError = ErrorMessages.noInternetError;
  static const String defaultError = ErrorMessages.defaultError;
  static const String connectionError = ErrorMessages.defaultError;

}