import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../../index.dart';

final refreshTokenApiServiceProvider = Provider<RefreshTokenApiService>(
  (ref) => getIt.get<RefreshTokenApiService>(),
);

@LazySingleton()
class RefreshTokenApiService {
  RefreshTokenApiService(this._refreshTokenApiClient);

  final RefreshTokenApiClient _refreshTokenApiClient;

  Future<DataResponse<ApiRefreshTokenData>?> refreshToken(String refreshToken) async {
    try {
      final respone = await _refreshTokenApiClient
          .request<ApiRefreshTokenData, DataResponse<ApiRefreshTokenData>>(
        method: RestMethod.post,
        path: 'v1/auth/refresh',
        decoder: (json) => ApiRefreshTokenData.fromJson(json as Map<String, dynamic>),
      );

      return respone;
    } catch (e) {
      // TODO(minh): fix depend on project #0
      if (e is RemoteException &&
          (e.kind == RemoteExceptionKind.serverDefined ||
              e.kind == RemoteExceptionKind.serverUndefined)) {
        throw RemoteException(kind: RemoteExceptionKind.refreshTokenFailed);
      }

      rethrow;
    }
  }
}
