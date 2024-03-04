import 'package:dio/dio.dart';

import '../../../index.dart';

class HeaderInterceptor extends BaseInterceptor {
  HeaderInterceptor({
    required this.packageHelper,
    required this.deviceHelper,
    this.headers = const {},
  }) : super(InterceptorType.header);

  final PackageHelper packageHelper;
  final DeviceHelper deviceHelper;
  final Map<String, dynamic> headers;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final userAgentValue = userAgentClientHintsHeader();
    options.headers[Constant.userAgentKey] = userAgentValue;
    if (headers.isNotEmpty) {
      options.headers.addAll(headers);
    }

    handler.next(options);
  }

  String userAgentClientHintsHeader() {
    return '${deviceHelper.operatingSystem} - ${packageHelper.versionName}(${packageHelper.versionCode})';
  }
}
