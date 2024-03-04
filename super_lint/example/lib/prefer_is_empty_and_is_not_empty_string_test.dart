// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD NOT BE WARNED ~.~.~.~.~.~.~.~

void test1(String a) {
  if (a.isEmpty) {}

  if (a.isNotEmpty) {}
}

void test2({String a = '', String b = ''}) {
  if (a.isEmpty || b.isNotEmpty) {}

  if (a.isNotEmpty && a.isEmpty) {}
}

// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD BE WARNED ~.~.~.~.~.~.~.~

void test3(String a) {
  // expect_lint: prefer_is_empty_string
  if (a == '') {}

  // expect_lint: prefer_is_not_empty_string
  if (a != '') {}
}

void test4({String a = '', String b = ''}) {
  // expect_lint: prefer_is_not_empty_string
  if (a.isEmpty || '' != b) {}

  // expect_lint: prefer_is_empty_string
  if ('' == a && a.isEmpty) {}

  // expect_lint: prefer_is_empty_string, prefer_is_not_empty_string
  if (a != '' && '' == b) {}
}
