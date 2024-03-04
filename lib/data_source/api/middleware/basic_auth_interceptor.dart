import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../index.dart';

class BasicAuthInterceptor extends BaseInterceptor {
  BasicAuthInterceptor({
    this.username = Env.appBasicAuthName,
    this.password = Env.appBasicAuthPassword,
  }) : super(InterceptorType.basicAuth);

  final String username;
  final String password;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[Constant.basicAuthorization] = _basicAuthenticationHeader();

    return super.onRequest(options, handler);
  }

  String _basicAuthenticationHeader() {
    return 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  }
}
