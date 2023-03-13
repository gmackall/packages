// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:camera_android_camerax/src/instance_manager.dart';
import 'package:camera_android_camerax/src/pending_recording.dart';
import 'package:camera_android_camerax/src/recording.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'android_camera_camerax_test.mocks.dart';
import 'pending_recording_test.mocks.dart';
import 'test_camerax_library.g.dart';

@GenerateMocks(<Type>[TestPendingRecordingHostApi])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('start calls the Java side and returns correct recording', () async {
    final MockTestPendingRecordingHostApi mockApi
        = MockTestPendingRecordingHostApi();
    TestPendingRecordingHostApi.setup(mockApi);

    final InstanceManager instanceManager = InstanceManager(
      onWeakReferenceRemoved: (_) {},
    );

    final PendingRecording pendingRecording = PendingRecording.detached(
        instanceManager: instanceManager);
    const int pendingRecordingId = 2;
    instanceManager.addHostCreatedInstance(
        pendingRecording,
        pendingRecordingId,
        onCopy: (_) => PendingRecording.detached(instanceManager: instanceManager)
    );

    final Recording mockRecording = MockRecording();
    const int mockRecordingId = 3;
    instanceManager.addHostCreatedInstance(
        mockRecording,
        mockRecordingId,
        onCopy: (_) => Recording.detached(instanceManager: instanceManager)
    );

    when(mockApi.start(pendingRecordingId)).thenReturn(mockRecordingId);
    expect(await pendingRecording.start(), mockRecording);
    verify(mockApi.start(pendingRecordingId));
  });
}
