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

import '../index.dart';

/// A base class for emitting information about
/// issues with user's `.dart` files.
abstract class OptionsFix<T extends Object?> extends DartFix {
  /// Constructor for [OptionsFix] model.
  OptionsFix(this.config) : super();

  /// Configuration for a particular rule with all the
  /// defined custom parameters.
  final RuleConfig<T> config;

  /// A flag which indicates whether this rule was enabled by the user.
  bool get enabled => config.enabled;
}
