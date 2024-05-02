// ignore_for_file: avoid_hard_coded_strings
// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD NOT BE WARNED ~.~.~.~.~.~.~.~

Future<void> test() async {
  final future = Future(() {
    print('future');
  });

  await future;

  future.then((value) => print('then'));

  future.then((value) => null).then((value) => null).then((value) => null);

  future.then((value) {
    print('then');
  }).then((value) {
    print('then');
  }).then((value) {
    print('then');
  });
}
