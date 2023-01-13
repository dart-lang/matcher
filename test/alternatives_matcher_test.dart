import 'package:test/test.dart';

void main() {
  final alternativeMatcher = alternatives(
    'oldCase',
    {'alternative', 'alternative2'},
  );

  test('Equals', () {
    expect('oldCase', alternativeMatcher);
  });

  test('Equals alternative', () {
    expect('alternative', alternativeMatcher);
    expect('alternative2', alternativeMatcher);
  });

  test('Equals fails', () {
    expect(
      () => expect('newCaseNotInAlternatives', alternativeMatcher),
      throwsA(isA<TestFailure>()),
    );
  });

  test('Pass matcher as argument', () {
    expect([1, 2, 3, 3], alternatives(3, {2}, containsOnce));
  });

  test('Pass matcher as argument and fail', () {
    expect(
      () => expect([1, 2, 3, 3], alternatives(4, {}, containsOnce)),
      throwsA(isA<TestFailure>()),
    );
  });
}
