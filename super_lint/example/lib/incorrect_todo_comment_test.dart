// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD NOT BE WARNED ~.~.~.~.~.~.~.~

// TODO(minhnt3): Remove this file when the issue is fixed #123 issue number.
// TODO(minhnt3): Remove this file when the issue is fixed #0

// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD BE WARNED ~.~.~.~.~.~.~.~

// expect_lint: incorrect_todo_comment
// TODO(minhnt3): Remove this file when the issue is fixed.

// expect_lint: incorrect_todo_comment
// TODO: Remove this file when the issue is fixed #123.

// expect_lint: incorrect_todo_comment
// TODO(minhnt3): Remove this file when the issue is fixed #-123 .

// expect_lint: incorrect_todo_comment
// TODO(minhnt3)     : Remove this file when the issue is fixed #-123 .

// expect_lint: incorrect_todo_comment
// TODO   (minhnt3): Remove this file when the issue is fixed #123 .

// expect_lint: incorrect_todo_comment
// TODO(minhnt3):               #123  .

// expect_lint: incorrect_todo_comment
// TODO() Remove this file when the issue is fixed #123.
