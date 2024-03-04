// ignore_for_file: variable_type_mismatch
import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('nextPage', () {
    test('when page is 1', () async {
      const loadMoreOutput = LoadMoreOutput(data: [], page: 1);

      expect(loadMoreOutput.nextPage, 2);
    });
  });

  group('previousPage', () {
    test('when page is 2', () async {
      const loadMoreOutput = LoadMoreOutput(data: [], page: 2);

      expect(loadMoreOutput.previousPage, 1);
    });
  });
}
