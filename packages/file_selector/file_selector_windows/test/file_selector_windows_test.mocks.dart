// Mocks generated by Mockito 5.4.0 from annotations
// in file_selector_windows/test/file_selector_windows_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:file_selector_windows/src/messages.g.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

import 'test_api.g.dart' as _i2;

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

/// A class which mocks [TestFileSelectorApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockTestFileSelectorApi extends _i1.Mock
    implements _i2.TestFileSelectorApi {
  MockTestFileSelectorApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<String?> showOpenDialog(
    _i3.SelectionOptions? options,
    String? initialDirectory,
    String? confirmButtonText,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #showOpenDialog,
          [
            options,
            initialDirectory,
            confirmButtonText,
          ],
        ),
        returnValue: <String?>[],
      ) as List<String?>);
  @override
  List<String?> showSaveDialog(
    _i3.SelectionOptions? options,
    String? initialDirectory,
    String? suggestedName,
    String? confirmButtonText,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #showSaveDialog,
          [
            options,
            initialDirectory,
            suggestedName,
            confirmButtonText,
          ],
        ),
        returnValue: <String?>[],
      ) as List<String?>);
}
