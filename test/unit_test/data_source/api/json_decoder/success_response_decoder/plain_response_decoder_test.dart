import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('map', () {
    test('should return correct String when response is String', () {
      // arrange
      const validResponse = 'validResponse';
      const expected = 'validResponse';
      // act
      final result = PlainResponseDecoder().map(
        response: validResponse,
      );
      // assert
      expect(result, expected);
    });

    test('should throw AssertionError when response is null', () {
      expect(
        () => PlainResponseDecoder().map(
          response: null,
        ),
        throwsAssertionError,
      );
    });

    test(
      'should throw RemoteException.invalidSuccessResponseDecoderType when response type is incorrect',
      () {
        // arrange
        const response = [
          {
            'uid': 2,
            'email': 'email',
          },
        ];

        final result = PlainResponseDecoder<String>().map(
          response: response,
        );

        // assert
        expect(result, null);
      },
    );
  });
}
