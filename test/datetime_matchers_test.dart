import 'package:matcher/matcher.dart';
import 'package:test/test.dart' show test;

import 'test_utils.dart';

void main() {
  test('isCloseTo', () {
    var dt = DateTime(2000, 1, 1);
    var later = dt.add(Duration(days: 1));

    shouldPass(dt, isCloseTo(dt, Duration(milliseconds: 1)));
    shouldPass(dt, isCloseTo(later, Duration(days: 1, milliseconds: 1)));
    shouldFail(dt, isCloseTo(later, Duration(milliseconds: 1)), startsWith(
        "Expected: DateTime:<2000-01-02 00:00:00.000>  "
            "Actual: DateTime:<2000-01-01 00:00:00.000>   "
            "Which: has delta Duration:<24:00:00.000000> greater than Duration:<0:00:00.001000>"));
  });
}
