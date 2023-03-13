// Mocks generated by Mockito 5.3.2 from annotations
// in camera_android_camerax/test/recording_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:mockito/mockito.dart' as _i1;

import 'test_camerax_library.g.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [TestRecordingHostApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockTestRecordingHostApi extends _i1.Mock
    implements _i2.TestRecordingHostApi {
  MockTestRecordingHostApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void close(int? identifier) => super.noSuchMethod(
        Invocation.method(
          #close,
          [identifier],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void pause(int? identifier) => super.noSuchMethod(
        Invocation.method(
          #pause,
          [identifier],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void resume(int? identifier) => super.noSuchMethod(
        Invocation.method(
          #resume,
          [identifier],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void stop(int? identifier) => super.noSuchMethod(
        Invocation.method(
          #stop,
          [identifier],
        ),
        returnValueForMissingStub: null,
      );
}
