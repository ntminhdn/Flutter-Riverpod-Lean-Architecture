import 'dart:io';

import 'package:dio/dio.dart';

import '../../index.dart';

class DioExceptionMapper extends AppExceptionMapper<RemoteException> {
  DioExceptionMapper(this._errorResponseDecoder);

  final BaseErrorResponseDecoder<dynamic> _errorResponseDecoder;

  @override
  RemoteException map(Object? exception) {
    if (exception is RemoteException) {
      return exception;
    }

    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.cancel:
          return RemoteException(kind: RemoteExceptionKind.cancellation);
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return RemoteException(
            kind: RemoteExceptionKind.timeout,
            rootException: exception,
          );
        case DioExceptionType.badResponse:
          final dioStatusCode = exception.response?.statusCode ?? -1;

          if (dioStatusCode == HttpStatus.serviceUnavailable) {
            return RemoteException(
              kind: RemoteExceptionKind.serverMaintenance,
              dioStatusCode: dioStatusCode,
              rootException: exception,
            );
          }

          /// server-defined error
          if (exception.response?.data != null) {
            final serverError = _errorResponseDecoder.map(exception.response!.data!);

            return switch (serverError.generalServerErrorId) {
              Constant.userNotFoundErrorId => RemoteException(
                  kind: RemoteExceptionKind.userNotFound,
                  dioStatusCode: dioStatusCode,
                  serverError: serverError,
                ),
              _ => RemoteException(
                  kind: RemoteExceptionKind.otherServerDefined,
                  dioStatusCode: dioStatusCode,
                  serverError: serverError,
                ),
            };
          }

          /// other server errors that doesn't have response data like 5xx errors
          return RemoteException(
            kind: RemoteExceptionKind.serverUndefined,
            dioStatusCode: dioStatusCode,
            rootException: exception,
          );
        case DioExceptionType.badCertificate:
          return RemoteException(
            kind: RemoteExceptionKind.badCertificate,
            rootException: exception,
          );
        case DioExceptionType.connectionError:
          return RemoteException(kind: RemoteExceptionKind.network, rootException: exception);
        case DioExceptionType.unknown:
          if (exception.error is SocketException) {
            return RemoteException(kind: RemoteExceptionKind.network, rootException: exception);
          }

          if (exception.error is RemoteException) {
            return exception.error as RemoteException;
          }
      }
    }

    return RemoteException(kind: RemoteExceptionKind.unknown, rootException: exception);
  }
}
