import '../../../../index.dart';

class PlainResponseDecoder<T extends Object> extends BaseSuccessResponseDecoder<T, T> {
  @override
  T? mapToDataModel({
    required dynamic response,
    Decoder<T>? decoder,
  }) {
    assert(decoder == null);

    return response is T ? response : null;
  }
}
