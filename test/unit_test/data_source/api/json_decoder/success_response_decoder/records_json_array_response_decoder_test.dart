// ignore_for_file: variable_type_mismatch
import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('mapToDataModel', () {
    test('should return correct RecordsListResponse when using valid data response', () async {
      // arrange
      final response = {
        'records': [
          {'uid': 1, 'email': 'name1'},
          {'uid': 2, 'email': 'name2'},
        ],
      };
      final decoder = (json) => ApiUserData.fromJson(json as Map<String, dynamic>);
      const expected = RecordsListResponse<ApiUserData>(
        records: [
          ApiUserData(id: 1, email: 'name1'),
          ApiUserData(id: 2, email: 'name2'),
        ],
      );
      // act
      final result = RecordsJsonArrayResponseDecoder<ApiUserData>().mapToDataModel(
        response: response,
        decoder: decoder,
      );
      // assert
      expect(result, expected);
    });

    test('should return null when decoder is null', () async {
      final result = RecordsJsonArrayResponseDecoder<ApiUserData>().mapToDataModel(
        response: '',
        decoder: null,
      );

      expect(result, null);
    });

    test('should return null when response is not Map<String, dynamic>', () async {
      final response = [];
      final decoder = (json) => ApiUserData.fromJson(json as Map<String, dynamic>);

      final result = RecordsJsonArrayResponseDecoder<ApiUserData>().mapToDataModel(
        response: response,
        decoder: decoder,
      );

      expect(result, null);
    });
  });
}
