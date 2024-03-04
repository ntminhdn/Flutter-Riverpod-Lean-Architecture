import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('map', () {
    test('should return correct ServerError when using valid data response', () async {
      // arrange
      final errorResponse = {
        'error_description': 'The request is invalid',
      };
      const expected = ServerError(
        generalMessage: 'The request is invalid',
      );
      // act
      final result = LineErrorResponseDecoder().map(errorResponse);
      // assert
      expect(result, expected);
    });
  });
}
