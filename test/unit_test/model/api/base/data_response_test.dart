// ignore_for_file: variable_type_mismatch
import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('fromJson', () {
    test('when JSON response is valid', () async {
      final validResponse = {
        'data': {
          'uid': 100,
          'email': 'ntminh@gmail.com',
          'dob': {
            'date': '1978-04-02T12:48:58.136Z',
          },
          'gender': 'male',
        },
        'meta': {
          'page_info': {
            'next': 10,
          },
        },
      };

      final expected = DataResponse(
        data: ApiUserData(
          id: 100,
          email: 'ntminh@gmail.com',
          birthday: DateTime(1978, 4, 2, 12, 48, 58),
          gender: Gender.male,
        ),
        meta: Meta(
          pageInfo: PageInfo(next: 10),
        ),
      );

      final result = DataResponse<ApiUserData>.fromJson(
        validResponse,
        (json) => ApiUserData.fromJson(json as Map<String, dynamic>),
      );

      expect(result, expected);
    });
  });
}
