import 'feature_matcher.dart';
import 'interfaces.dart';

/// Returns a matcher which matches if the match argument is a DateTime and
/// is within [delta] of [value].
Matcher isCloseTo(DateTime value, Duration delta) =>
    _IsCloseTo(value, delta);

class _IsCloseTo extends FeatureMatcher<DateTime> {
  final DateTime _value;
  final Duration _delta;

  _IsCloseTo(this._value, this._delta);

  Duration elapsed(DateTime item) => item.difference(_value).abs();

  @override
  bool typedMatches(DateTime item, Map matchState) {
    return elapsed(item) <= _delta;
  }

  @override
  Description describe(Description description) =>
      description.addDescriptionOf(_value);

  @override
  Description describeTypedMismatch(DateTime item,
      Description mismatchDescription, Map matchState, bool verbose) {
    return mismatchDescription
      .add('has delta ')
      .addDescriptionOf(elapsed(item))
      .add(' greater than ')
      .addDescriptionOf(_delta);
  }
}