// ignore_for_file: unused_import

// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD NOT BE WARNED ~.~.~.~.~.~.~.~
import 'package:flutter/material.dart';
import 'dart:math';

// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD BE WARNED ~.~.~.~.~.~.~.~

// expect_lint: prefer_importing_index_file
import 'relative_import_test.dart';
// expect_lint: prefer_importing_index_file
import 'relative/relative_import_test.dart';
// expect_lint: prefer_importing_index_file
import '../prefer_async_await_test.dart';
// expect_lint: prefer_importing_index_file
import '../excluded_test/incorrect_todo_comment_excluded_test.dart';
