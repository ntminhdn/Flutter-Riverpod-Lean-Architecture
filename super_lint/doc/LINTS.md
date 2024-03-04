<!-- omit from toc -->

# All Lint Rules

## Table of Contents

- [Table of Contents](#table-of-contents)
- [All lint rules](#all-lint-rules-1)
  - [prefer_named_parameters](#prefer_named_parameters)
  - [incorrect_todo_comment](#incorrect_todo_comment)
  - [prefer_is_empty_string](#prefer_is_empty_string)
  - [prefer_is_not_empty_string](#prefer_is_not_empty_string)
  - [avoid_unnecessary_async_function](#avoid_unnecessary_async_function)
  - [prefer_async_await](#prefer_async_await)
  - [prefer_lower_case_test_description](#prefer_lower_case_test_description)
  - [test_folder_must_mirror_lib_folder](#test_folder_must_mirror_lib_folder)

## All lint rules

### prefer_named_parameters

If a function or constructor takes more parameters than the threshold, use named parameters.

```yaml
- prefer_named_parameters:
  threshold: 2
```

**Good**:

```dart
class A {
  final String a;
  final String b;

  A({
    required this.a,
    required this.b,
  });

  A.a({
    required this.a,
    this.b = '',
  });

  A.b({
    required this.a,
    String? b,
  }) : b = b ?? '';

  void test2({
    required String a,
    String b = '',
  }) {}
}

void test2({
  String a = '',
  String? b,
}) {}
```

**Bad**:

```dart
class B {
  final String a;
  final String b;

  B(this.a, this.b); 
  B.a(this.a, [this.b = '']); 
  B.b(this.a, {this.b = ''}); 
  B.c(this.a, {required this.b}); 
  B.d(this.a, String? b) : b = b ?? ''; 
}

void test4(String a, String b) {} 
void test5(String a, [String b = '']) {} 
void test6(String a, {required String b}) {} 
void test7(String a, {String b = ''}) {} 
void test8(String a, {String? b}) {} 
void test9([String? a, String? b = '']) {} 
```

### incorrect_todo_comment

TODO comments must have username, description and issue number (or #0 if no issue).

Example: `// TODO(username): some description text #123.`

```yaml
- incorrect_todo_comment:
```

**Good**:

```dart
// TODO(minhnt3): Remove this file when the issue is fixed #123 issue number.

// TODO(minhnt3): Remove this file when the issue is fixed #0
```

**Bad**:

```dart
// TODO(minhnt3): Remove this file when the issue is fixed.

// TODO: Remove this file when the issue is fixed #123.

// TODO(minhnt3): Remove this file when the issue is fixed #-123 .

// TODO(minhnt3)     : Remove this file when the issue is fixed #-123 .

// TODO   (minhnt3): Remove this file when the issue is fixed #123 .

// TODO(minhnt3):               #123  .

// TODO() Remove this file when the issue is fixed #123.
```

### prefer_is_empty_string

Use `isEmpty` instead of `==` to test whether the string is empty.

```yaml
- prefer_is_empty_string:
```

**Good**:

```dart
void test(String a) {
  if (a.isEmpty) {}
}
```

**Bad**:

```dart
void test(String a) {
  if (a == '') {}

  if ('' == a) {}
}
```

### prefer_is_not_empty_string

Use `isNotEmpty` instead of `==` to test whether the string is empty.

```yaml
- prefer_is_not_empty_string:
```

**Good**:

```dart
void test(String a) {
  if (a.isNotEmpty) {}
}
```

**Bad**:

```dart
void test(String a) {
  if (a != '') {}

  if ('' != a) {}
}
```

### avoid_unnecessary_async_function

If a function does not have any asynchronous computation, there is no need to create an async function.

```yaml
- avoid_unnecessary_async_function:
```

**Good**:

```dart
Future<void> login() async {
  await Future<dynamic>.delayed(const Duration(milliseconds: 2000));
  print('login');
}

FutureOr<String> getName() async {
  return Future(() => 'name');
}

FutureOr<int?> getAge() async {
  try {
    print('do something');

    return Future.value(3);
  } catch (e) {
    return null;
  }
}

class AsyncNotifier {
  Future<void> login() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 2000));
    print('login');
  }

  FutureOr<String> getName() async {
    return Future(() => 'name');
  }

  FutureOr<int?> getAge() async {
    try {
      print('do something');

      return Future.value(3);
    } catch (e) {
      return null;
    }
  }
}
```

**Bad**:

```dart
Future<void> logout() async {
  print('logout');
}

FutureOr<String> getFullName() async {
  return 'name';
}

FutureOr<int?> getUserAge() async {
  try {
    print('do something');

    return 3;
  } catch (e) {
    return null;
  }
}

class Notifier {
  Future<void> login() async {
    Future(() => print('hello'));

    print('login');
  }

  FutureOr<String> getName() async {
    unawaited(Future<dynamic>.delayed(const Duration(milliseconds: 2000)));

    return 'name';
  }
}
```

### test_folder_must_mirror_lib_folder

Test files must have names ending with '\_test', and their paths must mirror the structure of the 'lib' folder.

```yaml
- test_folder_must_mirror_lib_folder:
```

**Good**:

```
lib/external_interface/repositories/job_repository.dart
test/unit_test/external_interface/repositories/job_repository_test.dart
```

**Bad**:

```
lib/external_interface/repositories/job_repository.dart
test/unit_test/job_repository.dart
```

### prefer_async_await

Prefer using async/await syntax instead of .then invocations.

```yaml
- prefer_async_await:
```

**Good**:

```dart
Future<void> test() async {
  final future = Future(() {
    print('future');
  });

  await future;
}
```

**Bad**:

```dart
Future<void> test() async {
  final future = Future(() {
    print('future');
  });


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
```

### prefer_lower_case_test_description

Lower case the first character when writing tests descriptions.

```yaml
- prefer_lower_case_test_description:
  test_methods:
    - method_name: "test"
      param_name: "description"
    - method_name: "blocTest"
      param_name: "desc"
```

**Good**:

```dart
test('lowercase text', () {});
test('1lowercase text', () {});
test('_lowercase text', () {});
test('*lowercase text', () {});

blocTest('lowercase text', () {});
blocTest('1lowercase text', () {});
blocTest('_lowercase text', () {});
blocTest('*lowercase text', () {});

stateNotifierTest('Uppercase text', () {});
```

**Bad**:

```dart
test('uppercase text', () {});

blocTest('Uppercase text', () {});
```
