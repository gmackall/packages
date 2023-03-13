// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:camera_android_camerax/src/camerax_library.g.dart';
import 'package:camera_android_camerax/src/instance_manager.dart';
import 'package:camera_android_camerax/src/recording.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'test_camerax_library.g.dart';
import 'recording_test.mocks.dart';

@GenerateMocks(<Type>[TestRecordingHostApi])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Recording', () {
    tearDown(() => TestRecorderHostApi.setup(null));

    test('close calls close on Java side', () async {
      final MockTestRecordingHostApi mockApi = MockTestRecordingHostApi();
      TestRecordingHostApi.setup(mockApi);

      final InstanceManager instanceManager = InstanceManager(
        onWeakReferenceRemoved: (_) {},
      );

      final Recording recording = Recording.detached(
          instanceManager: instanceManager);
      const int recordingId = 0;

      instanceManager.addHostCreatedInstance(
          recording,
          recordingId,
          onCopy: (_) => Recording.detached());

      recording.close();

      verify(mockApi.close(recordingId));
    });

    test('pause calls pause on Java side', () async {
      final MockTestRecordingHostApi mockApi = MockTestRecordingHostApi();
      TestRecordingHostApi.setup(mockApi);

      final InstanceManager instanceManager = InstanceManager(
        onWeakReferenceRemoved: (_) {},
      );

      final Recording recording = Recording.detached(
          instanceManager: instanceManager);
      const int recordingId = 0;

      instanceManager.addHostCreatedInstance(
          recording,
          recordingId,
          onCopy: (_) => Recording.detached());

      recording.pause();

      verify(mockApi.pause(recordingId));
    });

    test('resume calls resume on Java side', () async {
      final MockTestRecordingHostApi mockApi = MockTestRecordingHostApi();
      TestRecordingHostApi.setup(mockApi);

      final InstanceManager instanceManager = InstanceManager(
        onWeakReferenceRemoved: (_) {},
      );

      final Recording recording = Recording.detached(
          instanceManager: instanceManager);
      const int recordingId = 0;

      instanceManager.addHostCreatedInstance(
          recording,
          recordingId,
          onCopy: (_) => Recording.detached());

      recording.resume();

      verify(mockApi.resume(recordingId));
    });

    test('stop calls stop on Java side', () async {
      final MockTestRecordingHostApi mockApi = MockTestRecordingHostApi();
      TestRecordingHostApi.setup(mockApi);

      final InstanceManager instanceManager = InstanceManager(
        onWeakReferenceRemoved: (_) {},
      );

      final Recording recording = Recording.detached(
          instanceManager: instanceManager);
      const int recordingId = 0;

      instanceManager.addHostCreatedInstance(
          recording,
          recordingId,
          onCopy: (_) => Recording.detached());

      recording.stop();

      verify(mockApi.stop(recordingId));
    });
  });
}