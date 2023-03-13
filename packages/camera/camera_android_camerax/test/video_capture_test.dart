// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:camera_android_camerax/src/instance_manager.dart';
import 'package:camera_android_camerax/src/recorder.dart';
import 'package:camera_android_camerax/src/video_capture.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'android_camera_camerax_test.mocks.dart';
import 'test_camerax_library.g.dart';
import 'video_capture_test.mocks.dart';

@GenerateMocks(<Type>[TestVideoCaptureHostApi])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('detached create does not call create on the Java side', () async {
    final MockTestVideoCaptureHostApi mockApi = MockTestVideoCaptureHostApi();
    TestVideoCaptureHostApi.setup(mockApi);
    final InstanceManager instanceManager = InstanceManager(
      onWeakReferenceRemoved: (_) {},
    );

    VideoCapture.detached(instanceManager: instanceManager);

    verifyNever(
      mockApi.create(argThat(isA<int>()))
    );
  });

  test('withOutput calls the Java side and returns correct video capture', () async {
    final MockTestVideoCaptureHostApi mockApi = MockTestVideoCaptureHostApi();
    TestVideoCaptureHostApi.setup(mockApi);
    final InstanceManager instanceManager = InstanceManager(
      onWeakReferenceRemoved: (_) {},
    );

    final Recorder mockRecorder = MockRecorder();
    const int mockRecorderId = 2;
    instanceManager.addHostCreatedInstance(
        mockRecorder,
        mockRecorderId,
        onCopy: (_) => Recorder.detached());

    final VideoCapture videoCapture = VideoCapture.detached(
        instanceManager: instanceManager);
    const int videoCaptureId = 3;
    instanceManager.addHostCreatedInstance(
        videoCapture,
        videoCaptureId,
        onCopy: (_) => VideoCapture.detached(instanceManager: instanceManager));

    when(mockApi.withOutput(mockRecorderId)).thenReturn(videoCaptureId);

    expect
      (
        await VideoCapture.withOutput(
            mockRecorder,
            instanceManager: instanceManager),
        videoCapture);
    verify(mockApi.withOutput(mockRecorderId));
  });

  test('getOutput calls the Java side and returns correct Recorder', () async {
    final MockTestVideoCaptureHostApi mockApi = MockTestVideoCaptureHostApi();
    TestVideoCaptureHostApi.setup(mockApi);
    final InstanceManager instanceManager = InstanceManager(
      onWeakReferenceRemoved: (_) {},
    );

    final VideoCapture videoCapture = VideoCapture.detached(
        instanceManager: instanceManager);
    const int videoCaptureId = 2;
    instanceManager.addHostCreatedInstance(
        videoCapture,
        videoCaptureId,
        onCopy: (_) => VideoCapture.detached(instanceManager: instanceManager)
    );

    final MockRecorder mockRecorder = MockRecorder();
    const int mockRecorderId = 3;
    instanceManager.addHostCreatedInstance(
        mockRecorder,
        mockRecorderId,
        onCopy: (_) => Recorder.detached(instanceManager: instanceManager)
    );

    when(mockApi.getOutput(videoCaptureId)).thenReturn(mockRecorderId);
    expect(await videoCapture.getOutput(), mockRecorder);
    verify(mockApi.getOutput(videoCaptureId));
  });
}
