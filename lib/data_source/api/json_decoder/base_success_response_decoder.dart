import '../../../../index.dart';

enum SuccessResponseDecoderType {
  dataJsonObject,
  dataJsonArray,
  jsonObject,
  jsonArray,
  recordsJsonArray,
  resultsJsonArray,
  plain,
}

abstract class BaseSuccessResponseDecoder<I extends Object, O extends Object> {
  const BaseSuccessResponseDecoder();

  factory BaseSuccessResponseDecoder.fromType(SuccessResponseDecoderType type) {
    return switch (type) {
      SuccessResponseDecoderType.dataJsonObject =>
        DataJsonObjectResponseDecoder<I>() as BaseSuccessResponseDecoder<I, O>,
      SuccessResponseDecoderType.dataJsonArray =>
        DataJsonArrayResponseDecoder<I>() as BaseSuccessResponseDecoder<I, O>,
      SuccessResponseDecoderType.jsonObject =>
        JsonObjectResponseDecoder<I>() as BaseSuccessResponseDecoder<I, O>,
      SuccessResponseDecoderType.jsonArray =>
        JsonArrayResponseDecoder<I>() as BaseSuccessResponseDecoder<I, O>,
      SuccessResponseDecoderType.recordsJsonArray =>
        RecordsJsonArrayResponseDecoder<I>() as BaseSuccessResponseDecoder<I, O>,
      SuccessResponseDecoderType.resultsJsonArray =>
        ResultsJsonArrayResponseDecoder<I>() as BaseSuccessResponseDecoder<I, O>,
      SuccessResponseDecoderType.plain =>
        PlainResponseDecoder<I>() as BaseSuccessResponseDecoder<I, O>,
    };
  }

  // ignore: avoid-dynamic
  O? map({
    required dynamic response,
    Decoder<I>? decoder,
  }) {
    assert(response != null);
    try {
      return mapToDataModel(response: response, decoder: decoder);
    } on RemoteException catch (_) {
      rethrow;
    } catch (e) {
      throw RemoteException(kind: RemoteExceptionKind.decodeError, rootException: e);
    }
  }

  // ignore: avoid-dynamic
  O? mapToDataModel({
    required dynamic response,
    Decoder<I>? decoder,
  });
}
