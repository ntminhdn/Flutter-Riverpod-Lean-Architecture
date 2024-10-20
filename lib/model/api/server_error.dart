import 'package:freezed_annotation/freezed_annotation.dart';

import '../../index.dart';

part 'server_error.freezed.dart';

@freezed
class ServerError with _$ServerError {
  const ServerError._();
  const factory ServerError({
    /// server-defined status code
    int? generalServerStatusCode,

    /// server-defined error id
    String? generalServerErrorId,

    /// server-defined message
    String? generalMessage,
    @Default(ServerError.defaultErrors) List<ServerErrorDetail> errors,
  }) = _ServerError;

  static const defaultErrors = <ServerErrorDetail>[];
}
