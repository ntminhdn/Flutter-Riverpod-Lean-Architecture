import 'package:dio/dio.dart';

import '../../../../index.dart';

enum RestMethod { get, post, put, patch, delete }

class RestApiClient {
  RestApiClient({
    required this.dio,
    this.errorResponseDecoderType = Constant.defaultErrorResponseDecoderType,
    this.successResponseDecoderType = Constant.defaultSuccessResponseDecoderType,
  });

  final SuccessResponseDecoderType successResponseDecoderType;
  final ErrorResponseDecoderType errorResponseDecoderType;
  final Dio dio;

  Future<T?> request<D extends Object, T extends Object>({
    required RestMethod method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Decoder<D>? decoder,
    SuccessResponseDecoderType? successResponseDecoderType,
    ErrorResponseDecoderType? errorResponseDecoderType,
    Options? options,
  }) async {
    assert(
        method != RestMethod.get ||
            (successResponseDecoderType ?? this.successResponseDecoderType) ==
                SuccessResponseDecoderType.plain ||
            decoder != null,
        'decoder must not be null if method is GET');
    try {
      final response = await _requestByMethod(
        method: method,
        path: path.startsWith(dio.options.baseUrl)
            ? path.substring(dio.options.baseUrl.length)
            : path,
        queryParameters: queryParameters,
        body: body,
        options: Options(
          headers: options?.headers,
          contentType: options?.contentType,
          responseType: options?.responseType,
          sendTimeout: options?.sendTimeout,
          receiveTimeout: options?.receiveTimeout,
        ),
      );

      if (response.data == null) {
        return null;
      }

      return BaseSuccessResponseDecoder<D, T>.fromType(
        successResponseDecoderType ?? this.successResponseDecoderType,
      ).map(response: response.data, decoder: decoder);
    } catch (error) {
      throw DioExceptionMapper(
        BaseErrorResponseDecoder.fromType(
          errorResponseDecoderType ?? this.errorResponseDecoderType,
        ),
      ).map(error);
    }
  }

  Future<Response<dynamic>> _requestByMethod({
    required RestMethod method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
  }) {
    switch (method) {
      case RestMethod.get:
        return dio.get(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
      case RestMethod.post:
        return dio.post(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
      case RestMethod.patch:
        return dio.patch(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
      case RestMethod.put:
        return dio.put(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
      case RestMethod.delete:
        return dio.delete(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
    }
  }

  Future<Response<T>> fetch<T>(RequestOptions requestOptions) => dio.fetch<T>(requestOptions);
}
