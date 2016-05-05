// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:matcher/matcher.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  test('closeTo', () {
    shouldPass(0, closeTo(0, 1));
    shouldPass(-1, closeTo(0, 1));
    shouldPass(1, closeTo(0, 1));
    shouldFail(1.001, closeTo(0, 1),
        "Expected: a numeric value within <1> of <0> "
        "Actual: <1.001> "
        "Which: differs by <1.001>");
    shouldFail(-1.001, closeTo(0, 1),
        "Expected: a numeric value within <1> of <0> "
        "Actual: <-1.001> "
        "Which: differs by <1.001>");
  });

  test('inInclusiveRange', () {
    shouldFail(-1, inInclusiveRange(0, 2),
        "Expected: be in range from 0 (inclusive) to 2 (inclusive) "
        "Actual: <-1>");
    shouldPass(0, inInclusiveRange(0, 2));
    shouldPass(1, inInclusiveRange(0, 2));
    shouldPass(2, inInclusiveRange(0, 2));
    shouldFail(3, inInclusiveRange(0, 2),
        "Expected: be in range from 0 (inclusive) to 2 (inclusive) "
        "Actual: <3>");
  });

  test('inExclusiveRange', () {
    shouldFail(0, inExclusiveRange(0, 2),
        "Expected: be in range from 0 (exclusive) to 2 (exclusive) "
        "Actual: <0>");
    shouldPass(1, inExclusiveRange(0, 2));
    shouldFail(2, inExclusiveRange(0, 2),
        "Expected: be in range from 0 (exclusive) to 2 (exclusive) "
        "Actual: <2>");
  });

  test('inOpenClosedRange', () {
    shouldFail(0, inOpenClosedRange(0, 2),
        "Expected: be in range from 0 (exclusive) to 2 (inclusive) "
        "Actual: <0>");
    shouldPass(1, inOpenClosedRange(0, 2));
    shouldPass(2, inOpenClosedRange(0, 2));
  });

  test('inClosedOpenRange', () {
    shouldPass(0, inClosedOpenRange(0, 2));
    shouldPass(1, inClosedOpenRange(0, 2));
    shouldFail(2, inClosedOpenRange(0, 2),
        "Expected: be in range from 0 (inclusive) to 2 (exclusive) "
        "Actual: <2>");
  });
}
