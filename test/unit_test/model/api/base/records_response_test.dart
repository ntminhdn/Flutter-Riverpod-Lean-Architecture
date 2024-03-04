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
            'birthday': '2023-08-12 00:00:00.000',
            'income': '1000000000000',
            'avatar': 'https://i.imgur.com/BoN9kdC.png',
            'photos': [
              'https://i.imgur.com/BoN9kdC.png',
              'https://i.imgur.com/BoN9kdC.png',
              'https://i.imgur.com/BoN9kdC.png',
              'https://i.imgur.com/BoN9kdC.png',
            ],
            'sex': 1,
          },
          {
            'uid': 100,
            'email': 'ntminh@gmail.com',
            'birthday': '2023-08-12 00:00:00.000',
            'income': '1000000000000',
            'avatar': 'https://i.imgur.com/BoN9kdC.png',
            'photos': [
              'https://i.imgur.com/BoN9kdC.png',
              'https://i.imgur.com/BoN9kdC.png',
              'https://i.imgur.com/BoN9kdC.png',
              'https://i.imgur.com/BoN9kdC.png',
            ],
            'sex': 1,
          },
        ],
        'page': 2,
        'next': 3,
        'prev': 1,
        'offset': 10,
        'total': 5,
      };

      const expected = RecordsListResponse(
        records: [
          ApiUserData(
            id: 100,
            email: 'ntminh@gmail.com',
            birthday: '2023-08-12 00:00:00.000',
            income: '1000000000000',
            avatar: 'https://i.imgur.com/BoN9kdC.png',
            photos: [
              'https://i.imgur.com/BoN9kdC.png',
              'https://i.imgur.com/BoN9kdC.png',
              'https://i.imgur.com/BoN9kdC.png',
              'https://i.imgur.com/BoN9kdC.png',
            ],
            gender: 1,
          ),
          ApiUserData(
            id: 100,
            email: 'ntminh@gmail.com',
            birthday: '2023-08-12 00:00:00.000',
            income: '1000000000000',
            avatar: 'https://i.imgur.com/BoN9kdC.png',
            photos: [
              'https://i.imgur.com/BoN9kdC.png',
              'https://i.imgur.com/BoN9kdC.png',
              'https://i.imgur.com/BoN9kdC.png',
              'https://i.imgur.com/BoN9kdC.png',
            ],
            gender: 1,
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
