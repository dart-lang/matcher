import 'equals_matcher.dart';
import 'interfaces.dart';
import 'operator_matchers.dart';

/// Matches expected or any of the given alternatives.
///
/// Example:
/// ```dart
///  expect(2, alternatives(1, {2})) // returns true
/// ```
///
/// Especially helpful in enabling the setup of alternative expected values
/// before breaking changes, to avoid test failures in migrations.
Matcher alternatives(
  Object expected, [
  Set<Object>? alternatives,
  Matcher Function(Object) matcher = equals,
]) =>
    anyOf([expected, ...?alternatives].map(matcher).toList());
