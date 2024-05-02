// ignore_for_file: avoid_hard_coded_strings
// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD NOT BE WARNED ~.~.~.~.~.~.~.~

Future<void> test() async {
  final future = Future(() {
    print('future');
  });

  await future;
}

// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD BE WARNED ~.~.~.~.~.~.~.~

void main() {
  final future = Future(() {
    print('future');
  });

  // expect_lint: prefer_async_await
  future.then((value) => print('then'));

  // expect_lint: prefer_async_await
  future.then((value) => null).then((value) => null).then((value) => null);

  // expect_lint: prefer_async_await
  future.then((value) {
    print('then');
    // expect_lint: prefer_async_await
  }).then((value) {
    print('then');
    // expect_lint: prefer_async_await
  }).then((value) {
    print('then');
  });
}
