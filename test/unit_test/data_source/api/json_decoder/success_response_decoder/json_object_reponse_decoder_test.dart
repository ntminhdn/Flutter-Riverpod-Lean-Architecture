import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('map', () {
    test('should return correct MockData2 when response is MockData2', () async {
      // arrange
      final validResponse = {
        'mock_data': {
          'uid': 1,
          'email': 'email',
        },
      };
      const expected = MockData2(
        mockData: MockData(
          id: 1,
          email: 'email',
        ),
      );
      // act
      final result = JsonObjectResponseDecoder<MockData2>().map(
        response: validResponse,
        decoder: (json) => MockData2.fromJson(json as Map<String, dynamic>),
      );
      // assert
      expect(result, expected);
    });

    test('should return correct MockData when response is MockData', () {
      // arrange
      final validResponse = {
        'uid': 1,
        'email': 'email',
      };
      const expected = MockData(
        id: 1,
        email: 'email',
      );
      // act
      final result = JsonObjectResponseDecoder<MockData>().map(
        response: validResponse,
        decoder: (json) => MockData.fromJson(json as Map<String, dynamic>),
      );
      // assert
      expect(result, expected);
    });

    test(
      'should return null when response is not JSONObject',
      () {
        // arrange
        const response = [
          {
            'uid': 2,
            'email': 'email',
          },
        ];

        final result = JsonObjectResponseDecoder<MockData>().map(
          response: response,
          decoder: (json) => MockData.fromJson(json as Map<String, dynamic>),
        );

        // assert
        expect(result, null);
      },
    );

    test('should throw AssertionError when response is null', () {
      expect(
        () => JsonObjectResponseDecoder<MockData>().map(
          response: null,
          decoder: (json) => MockData.fromJson(json as Map<String, dynamic>),
        ),
        throwsAssertionError,
      );
    });
  });
}
