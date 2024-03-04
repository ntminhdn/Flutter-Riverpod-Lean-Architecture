// MIT License

// Copyright (c) 2021 Solid Software LLC

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Type definition of a value factory which allows us to map data from
/// YAML configuration to an object of type [T].
typedef RuleParameterParser<T> = T Function(Map<String, Object?> json);

/// Type definition for a problem message factory after finding a problem
/// by a given lint.
typedef RuleProblemFactory<T> = String Function(T value);

/// [RuleConfig] allows us to quickly parse a lint rule and
/// declare basic configuration for it.
class RuleConfig<T extends Object?> {
  /// Constructor for [RuleConfig] model.
  RuleConfig({
    required this.name,
    required CustomLintConfigs configs,
    required RuleProblemFactory<T> problemMessage,
    RuleParameterParser<T>? paramsParser,
  })  : enabled = configs.rules[name]?.enabled ?? false,
        parameters = paramsParser?.call(configs.rules[name]?.json ?? {}) as T,
        _problemMessageFactory = problemMessage;

  /// The [LintCode] of this lint rule that represents the error.
  final String name;

  /// A flag which indicates whether this rule was enabled by the user.
  final bool enabled;

  /// Value with a configuration for a particular rule.
  final T parameters;

  /// Factory for generating error messages.
  final RuleProblemFactory<T> _problemMessageFactory;

  /// [LintCode] which is generated based on the provided data.
  LintCode get lintCode => LintCode(
        name: name,
        problemMessage: _problemMessageFactory(parameters),
        errorSeverity: ErrorSeverity.WARNING,
      );
}
