// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'test_camerax_library.g.dart';

@GenerateMocks(<Type>[TestPendingRecordingHostApi])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
}