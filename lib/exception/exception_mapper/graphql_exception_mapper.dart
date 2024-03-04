// Module: GRAPHQL

// import 'package:dio/dio.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// import '../../index.dart';

// class GraphQLExceptionMapper extends AppExceptionMapper<RemoteException> {
//   GraphQLExceptionMapper(this._errorResponseDecoder);

//   final BaseErrorResponseDecoder<dynamic> _errorResponseDecoder;
//   final _serverGraphQLErrorResponseDecoder = const ServerGraphQLErrorDecoder();

//   @override
//   RemoteException map(Object? exception) {
//     if (exception is! OperationException) {
//       return RemoteException(kind: RemoteExceptionKind.unknown, rootException: exception);
//     }

//     if (exception.linkException?.originalException is DioException) {
//       final dioException = exception.linkException!.originalException as DioException;
//       if (dioException.type == DioExceptionType.badResponse) {
//         /// server-defined error
//         ServerError? serverError;
//         if (dioException.response?.data != null) {
//           serverError = dioException.response!.data! is Map
//               ? _errorResponseDecoder.map(dioException.response!.data!)
//               : ServerError(
//                   generalMessage: dioException.response!.data! is String
//                       ? dioException.response!.data! as String
//                       : null,
//                 );
//         }

//         return RemoteException(
//           kind: RemoteExceptionKind.serverUndefined,
//           serverError: serverError,
//         );
//       } else {
//         return DioExceptionMapper(_errorResponseDecoder)
//             .map(exception.linkException?.originalException);
//       }
//     } else {
//       final serverError = _serverGraphQLErrorResponseDecoder.map(exception);

//       return RemoteException(
//         kind: RemoteExceptionKind.serverDefined,
//         serverError: serverError,
//       );
//     }
//   }
// }
