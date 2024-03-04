import 'package:injectable/injectable.dart';

import '../../../../index.dart';

@Injectable()
class LineErrorResponseDecoder extends BaseErrorResponseDecoder<Map<String, dynamic>> {
  @override
  ServerError mapToServerError(Map<String, dynamic>? json) {
    return ServerError(generalMessage: json?['error_description'] as String?);
  }
}
