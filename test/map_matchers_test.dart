import 'package:matcher/src/map_matchers.dart';
import 'package:test/test.dart' show test;

import 'test_utils.dart';

void main() {
  test('containsValue', () {
    shouldPass({'a': 1, 'null': null}, containsValue(1));
    shouldPass({'a': 1, 'null': null}, containsValue(null));
    shouldFail(
      {'a': 1, 'null': null},
      containsValue(2),
      'Expected: contains value <2> '
      "Actual: {'a': 1, 'null': null}",
    );
  });

  test('containsPair', () {
    shouldPass({'a': 1, 'null': null}, containsPair('a', 1));
    shouldPass({'a': 1, 'null': null}, containsPair('null', null));
    shouldFail(
      {'a': 1, 'null': null},
      containsPair('a', 2),
      "Expected: contains pair 'a' => <2> "
      "Actual: {'a': 1, 'null': null} "
      "Which:  contains key 'a' but with value is <1>",
    );
    shouldFail(
      {'a': 1, 'null': null},
      containsPair('b', 1),
      "Expected: contains pair 'b' => <1> "
      "Actual: {'a': 1, 'null': null} "
      "Which:  doesn't contain key 'b'",
    );
    shouldFail(
      {'a': 1, 'null': null},
      containsPair('null', 2),
      "Expected: contains pair 'null' => <2> "
      "Actual: {'a': 1, 'null': null} "
      "Which:  contains key 'null' but with value is <null>",
    );
    shouldFail(
      {'a': 1, 'null': null},
      containsPair('2', null),
      "Expected: contains pair '2' => <null> "
      "Actual: {'a': 1, 'null': null} "
      "Which:  doesn't contain key '2'",
    );
    shouldFail(
      {'a': 1, 'null': null},
      containsPair('2', 'b'),
      "Expected: contains pair '2' => 'b' "
      "Actual: {'a': 1, 'null': null} "
      "Which:  doesn't contain key '2'",
    );
  });
}