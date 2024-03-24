// ignore_for_file: variable_type_mismatch
import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('fromJson', () {
    test('when JSON response is valid', () async {
      final validResponse = {
        'records': [
          {
            'uid': 100,
            'email': 'ntminh@gmail.com',
            'dob': {
              'date': '2003-12-15T12:48:58.136Z',
            },
          },
          {
            'uid': 100,
            'email': 'ntminh@gmail.com',
            'dob': {
              'date': '1978-04-02T12:48:58.136Z',
            },
            'gender': 'female',
          },
        ],
        'page': 2,
        'next': 3,
        'prev': 1,
        'offset': 10,
        'total': 5,
      };

      final expected = RecordsListResponse(
        records: [
          ApiUserData(
            id: 100,
            email: 'ntminh@gmail.com',
            birthday: DateTime(2003, 12, 15, 12, 48, 58),
            gender: Gender.other,
          ),
          ApiUserData(
            id: 100,
            email: 'ntminh@gmail.com',
            birthday: DateTime(1978, 4, 2, 12, 48, 58),
            gender: Gender.female,
          ),
        ],
        page: 2,
        next: 3,
        prev: 1,
        offset: 10,
        total: 5,
      );

      final result = RecordsListResponse<ApiUserData>.fromJson(
        validResponse,
        (json) => ApiUserData.fromJson(json as Map<String, dynamic>),
      );

      expect(result, expected);
    });
  });
}
