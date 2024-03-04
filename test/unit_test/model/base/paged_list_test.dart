// ignore_for_file: variable_type_mismatch
import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('isLastPage', () {
    test('when data is empty', () async {
      const pagedList = PagedList(data: []);

      expect(pagedList.isLastPage, true);
    });

    test('when data is not empty', () async {
      const pagedList = PagedList(data: [1, 2, 3]);

      expect(pagedList.isLastPage, false);
    });
  });

  group('toLoadMoreOutput', () {
    test('toLoadMoreOutput', () async {
      const pagedList = PagedList(
        data: [1, 2, 3],
        next: 4,
        offset: 5,
        total: 6,
        otherData: 7,
      );

      expect(
        pagedList.toLoadMoreOutput(),
        const LoadMoreOutput(data: [1, 2, 3], otherData: 7, isLastPage: false),
      );
    });
  });
}
