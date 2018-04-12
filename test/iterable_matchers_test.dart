// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:matcher/matcher.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  test('isEmpty', () {
    shouldPass([], isEmpty);
    shouldFail([1], isEmpty, "Expected: empty Actual: [1]");
  });

  test('isNotEmpty', () {
    shouldFail([], isNotEmpty, "Expected: non-empty Actual: []");
    shouldPass([1], isNotEmpty);
  });

  test('contains', () {
    var d = [1, 2];
    shouldPass(d, contains(1));
    shouldFail(
        d,
        contains(0),
        "Expected: contains <0> "
        "Actual: [1, 2]");
  });

  test('equals with matcher element', () {
    var d = ['foo', 'bar'];
    shouldPass(d, equals(['foo', startsWith('ba')]));
    shouldFail(
        d,
        equals(['foo', endsWith('ba')]),
        "Expected: ['foo', <a string ending with 'ba'>] "
        "Actual: ['foo', 'bar'] "
        "Which: does not match a string ending with 'ba' at location [1]");
  });

  test('isIn', () {
    var d = [1, 2];
    shouldPass(1, isIn(d));
    shouldFail(0, isIn(d), "Expected: is in [1, 2] Actual: <0>");
  });

  test('everyElement', () {
    var d = [1, 2];
    var e = [1, 1, 1];
    shouldFail(
        d,
        everyElement(1),
        "Expected: every element(<1>) "
        "Actual: [1, 2] "
        "Which: has value <2> which doesn't match <1> at index 1");
    shouldPass(e, everyElement(1));
  });

  test('nested everyElement', () {
    var d = [
      ['foo', 'bar'],
      ['foo'],
      []
    ];
    var e = [
      ['foo', 'bar'],
      ['foo'],
      3,
      []
    ];
    shouldPass(d, everyElement(anyOf(isEmpty, contains('foo'))));
    shouldFail(
        d,
        everyElement(everyElement(equals('foo'))),
        "Expected: every element(every element('foo')) "
        "Actual: [['foo', 'bar'], ['foo'], []] "
        "Which: has value ['foo', 'bar'] which has value 'bar' "
        "which is different. Expected: foo Actual: bar ^ "
        "Differ at offset 0 at index 1 at index 0");
    shouldFail(
        d,
        everyElement(allOf(hasLength(greaterThan(0)), contains('foo'))),
        "Expected: every element((an object with length of a value "
        "greater than <0> and contains 'foo')) "
        "Actual: [['foo', 'bar'], ['foo'], []] "
        "Which: has value [] which has length of <0> at index 2");
    shouldFail(
        d,
        everyElement(allOf(contains('foo'), hasLength(greaterThan(0)))),
        "Expected: every element((contains 'foo' and "
        "an object with length of a value greater than <0>)) "
        "Actual: [['foo', 'bar'], ['foo'], []] "
        "Which: has value [] which doesn't match (contains 'foo' and "
        "an object with length of a value greater than <0>) at index 2");
    shouldFail(
        e,
        everyElement(allOf(contains('foo'), hasLength(greaterThan(0)))),
        "Expected: every element((contains 'foo' and an object with "
        "length of a value greater than <0>)) "
        "Actual: [['foo', 'bar'], ['foo'], 3, []] "
        "Which: has value <3> which is not a string, map or iterable "
        "at index 2");
  });

  test('anyElement', () {
    var d = [1, 2];
    var e = [1, 1, 1];
    shouldPass(d, anyElement(2));
    shouldFail(
        e, anyElement(2), "Expected: some element <2> Actual: [1, 1, 1]");
  });

  test('orderedEquals', () {
    shouldPass([null], orderedEquals([null]));
    var d = [1, 2];
    shouldPass(d, orderedEquals([1, 2]));
    shouldFail(
        d,
        orderedEquals([2, 1]),
        "Expected: equals [2, 1] ordered "
        "Actual: [1, 2] "
        "Which: was <1> instead of <2> at location [0]");
  });

  test('unorderedEquals', () {
    var d = [1, 2];
    shouldPass(d, unorderedEquals([2, 1]));
    shouldFail(
        d,
        unorderedEquals([1]),
        "Expected: equals [1] unordered "
        "Actual: [1, 2] "
        "Which: has too many elements (2 > 1)");
    shouldFail(
        d,
        unorderedEquals([3, 2, 1]),
        "Expected: equals [3, 2, 1] unordered "
        "Actual: [1, 2] "
        "Which: has too few elements (2 < 3)");
    shouldFail(
        d,
        unorderedEquals([3, 1]),
        "Expected: equals [3, 1] unordered "
        "Actual: [1, 2] "
        "Which: has no match for <3> at index 0");
    shouldFail(
        d,
        unorderedEquals([3, 4]),
        "Expected: equals [3, 4] unordered "
        "Actual: [1, 2] "
        "Which: has no match for <3> at index 0"
        " along with 1 other unmatched");
  });

  test('unorderedMatches', () {
    var d = [1, 2];
    shouldPass(d, unorderedMatches([2, 1]));
    shouldPass(d, unorderedMatches([greaterThan(1), greaterThan(0)]));
    shouldPass(d, unorderedMatches([greaterThan(0), greaterThan(1)]));
    shouldPass([2, 1], unorderedMatches([greaterThan(1), greaterThan(0)]));

    shouldPass([2, 1], unorderedMatches([greaterThan(0), greaterThan(1)]));
    // Excersize the case where pairings should get "bumped" multiple times
    shouldPass(
        [0, 1, 2, 3, 5, 6],
        unorderedMatches([
          greaterThan(1), // 6
          equals(2), // 2
          allOf([lessThan(3), isNot(0)]), // 1
          equals(0), // 0
          predicate((v) => v % 2 == 1), // 3
          equals(5), // 5
        ]));
    shouldFail(
        d,
        unorderedMatches([greaterThan(0)]),
        "Expected: matches [a value greater than <0>] unordered "
        "Actual: [1, 2] "
        "Which: has too many elements (2 > 1)");
    shouldFail(
        d,
        unorderedMatches([3, 2, 1]),
        "Expected: matches [<3>, <2>, <1>] unordered "
        "Actual: [1, 2] "
        "Which: has too few elements (2 < 3)");
    shouldFail(
        d,
        unorderedMatches([3, 1]),
        "Expected: matches [<3>, <1>] unordered "
        "Actual: [1, 2] "
        "Which: has no match for <3> at index 0");
    shouldFail(
        d,
        unorderedMatches([greaterThan(3), greaterThan(0)]),
        "Expected: matches [a value greater than <3>, a value greater than "
        "<0>] unordered "
        "Actual: [1, 2] "
        "Which: has no match for a value greater than <3> at index 0");
  });

  test('containsAll', () {
    var d = [0, 1, 2];
    shouldPass(d, containsAll([1, 2]));
    shouldPass(d, containsAll([2, 1]));
    shouldPass(d, containsAll([greaterThan(0), greaterThan(1)]));
    shouldPass([2, 1], containsAll([greaterThan(0), greaterThan(1)]));
    shouldFail(
        d,
        containsAll([1, 2, 3]),
        "Expected: contains all of [1, 2, 3] "
        "Actual: [0, 1, 2] "
        "Which: has no match for <3> at index 2");
    shouldFail(
        1,
        containsAll([1]),
        "Expected: contains all of [1] "
        "Actual: <1> "
        "Which: not iterable");
    shouldFail(
        [-1, 2],
        containsAll([greaterThan(0), greaterThan(1)]),
        "Expected: contains all of [<a value greater than <0>>, "
        "<a value greater than <1>>] "
        "Actual: [-1, 2] "
        "Which: has no match for a value greater than <1> at index 1");
  });

  test('containsAllInOrder', () {
    var d = [0, 1, 0, 2];
    shouldPass(d, containsAllInOrder([1, 2]));
    shouldPass(d, containsAllInOrder([greaterThan(0), greaterThan(1)]));
    shouldFail(
        d,
        containsAllInOrder([2, 1]),
        "Expected: contains in order([2, 1]) "
        "Actual: [0, 1, 0, 2] "
        "Which: did not find a value matching <1> following expected prior "
        "values");
    shouldFail(
        d,
        containsAllInOrder([greaterThan(1), greaterThan(0)]),
        "Expected: contains in order([<a value greater than <1>>, "
        "<a value greater than <0>>]) "
        "Actual: [0, 1, 0, 2] "
        "Which: did not find a value matching a value greater than <0> "
        "following expected prior values");
    shouldFail(
        d,
        containsAllInOrder([1, 2, 3]),
        "Expected: contains in order([1, 2, 3]) "
        "Actual: [0, 1, 0, 2] "
        "Which: did not find a value matching <3> following expected prior "
        "values");
    shouldFail(
        1,
        containsAllInOrder([1]),
        "Expected: contains in order([1]) "
        "Actual: <1> "
        "Which: not an iterable");
  });

  test('pairwise compare', () {
    var c = [1, 2];
    var d = [1, 2, 3];
    var e = [1, 4, 9];
    shouldFail(
        'x',
        pairwiseCompare(e, (e, a) => a <= e, "less than or equal"),
        "Expected: pairwise less than or equal [1, 4, 9] "
        "Actual: 'x' "
        "Which: is not an Iterable");
    shouldFail(
        c,
        pairwiseCompare(e, (e, a) => a <= e, "less than or equal"),
        "Expected: pairwise less than or equal [1, 4, 9] "
        "Actual: [1, 2] "
        "Which: has length 2 instead of 3");
    shouldPass(d, pairwiseCompare(e, (e, a) => a <= e, "less than or equal"));
    shouldFail(
        d,
        pairwiseCompare(e, (e, a) => a < e, "less than"),
        "Expected: pairwise less than [1, 4, 9] "
        "Actual: [1, 2, 3] "
        "Which: has <1> which is not less than <1> at index 0");
    shouldPass(d, pairwiseCompare(e, (e, a) => a * a == e, "square root of"));
    shouldFail(
        d,
        pairwiseCompare(e, (e, a) => a + a == e, "double"),
        "Expected: pairwise double [1, 4, 9] "
        "Actual: [1, 2, 3] "
        "Which: has <1> which is not double <1> at index 0");
  });

  test('isEmpty', () {
    var d = new SimpleIterable(0);
    var e = new SimpleIterable(1);
    shouldPass(d, isEmpty);
    shouldFail(
        e,
        isEmpty,
        "Expected: empty "
        "Actual: SimpleIterable:[1]");
  });

  test('isNotEmpty', () {
    var d = new SimpleIterable(0);
    var e = new SimpleIterable(1);
    shouldPass(e, isNotEmpty);
    shouldFail(
        d,
        isNotEmpty,
        "Expected: non-empty "
        "Actual: SimpleIterable:[]");
  });

  test('contains', () {
    var d = new SimpleIterable(3);
    shouldPass(d, contains(2));
    shouldFail(
        d,
        contains(5),
        "Expected: contains <5> "
        "Actual: SimpleIterable:[3, 2, 1]");
  });
}
