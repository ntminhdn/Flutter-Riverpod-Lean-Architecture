import '../../../../index.dart';

enum ErrorResponseDecoderType {
  jsonObject,
  jsonArray,
  line,
}

abstract class BaseErrorResponseDecoder<T extends Object> {
  const BaseErrorResponseDecoder();

  factory BaseErrorResponseDecoder.fromType(ErrorResponseDecoderType type) {
    switch (type) {
      case ErrorResponseDecoderType.jsonObject:
        return JsonObjectErrorResponseDecoder() as BaseErrorResponseDecoder<T>;
      case ErrorResponseDecoderType.jsonArray:
        return JsonArrayErrorResponseDecoder() as BaseErrorResponseDecoder<T>;
      case ErrorResponseDecoderType.line:
        return LineErrorResponseDecoder() as BaseErrorResponseDecoder<T>;
    }
  }

  ServerError map(dynamic errorResponse) {
    try {
      if (errorResponse is! T) {
        throw RemoteException(
          kind: RemoteExceptionKind.decodeError,
          rootException: 'Response ${errorResponse} is not $T',
        );
      }

      final serverError = mapToServerError(errorResponse);

      return serverError;
    } on RemoteException catch (_) {
      rethrow;
    } catch (e) {
      throw RemoteException(kind: RemoteExceptionKind.decodeError, rootException: e);
    }
  }

  ServerError mapToServerError(T? errorResponse);
}
