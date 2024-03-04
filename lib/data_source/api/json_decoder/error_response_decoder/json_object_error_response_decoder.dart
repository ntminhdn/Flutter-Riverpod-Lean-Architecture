import 'package:injectable/injectable.dart';

import '../../../../index.dart';

@Injectable()
class JsonObjectErrorResponseDecoder extends BaseErrorResponseDecoder<Map<String, dynamic>> {
  @override
  ServerError mapToServerError(Map<String, dynamic>? data) {
    return ServerError(
      generalServerStatusCode: data?['error']?['status_code'] as int?,
      generalServerErrorId: data?['error']?['error_code'] as String?,
      generalMessage: data?['error']?['message'] as String?,
    );
  }
}
