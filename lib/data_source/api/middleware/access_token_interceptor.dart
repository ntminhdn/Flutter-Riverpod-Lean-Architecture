import 'package:dio/dio.dart';

import '../../../index.dart';

class AccessTokenInterceptor extends BaseInterceptor {
  AccessTokenInterceptor(this._appPreferences) : super(InterceptorType.accessToken);

  final AppPreferences _appPreferences;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _appPreferences.accessToken;
    if (token.isNotEmpty) {
      options.headers[Constant.basicAuthorization] = '${Constant.bearer} $token';
    }

    handler.next(options);
  }
}
