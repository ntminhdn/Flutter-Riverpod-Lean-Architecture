import '../../../../index.dart';

class JsonObjectResponseDecoder<T extends Object> extends BaseSuccessResponseDecoder<T, T> {
  @override
  // ignore: avoid-dynamic
  T? mapToDataModel({
    required dynamic response,
    Decoder<T>? decoder,
  }) {
    return decoder != null && response is Map<String, dynamic> ? decoder(response) : null;
  }
}
