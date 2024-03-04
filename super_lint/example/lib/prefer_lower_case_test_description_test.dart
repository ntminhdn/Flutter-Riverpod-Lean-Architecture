// ignore_for_file: prefer_named_parameters
// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD NOT BE WARNED ~.~.~.~.~.~.~.~

void main() {
  test('lowercase text', () {});
  test('1lowercase text', () {});
  test('_lowercase text', () {});
  test('*lowercase text', () {});

  blocTest('lowercase text', () {});
  blocTest('1lowercase text', () {});
  blocTest('_lowercase text', () {});
  blocTest('*lowercase text', () {});

  stateNotifierTest('Uppercase text', () {});
}

// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD BE WARNED ~.~.~.~.~.~.~.~

void group() {
  // expect_lint: prefer_lower_case_test_description
  test('Uppercase text', () {});
  // expect_lint: prefer_lower_case_test_description
  blocTest('Uppercase text', () {});
}

void test(String description, Function body) {}
void blocTest(String desc, Function body) {}
void stateNotifierTest(String description, Function body) {}
