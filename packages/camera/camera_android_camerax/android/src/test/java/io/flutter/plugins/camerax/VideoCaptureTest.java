// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camerax;

import static org.junit.Assert.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.spy;

import androidx.camera.video.Recorder;
import androidx.camera.video.VideoCapture;
import io.flutter.plugin.common.BinaryMessenger;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import org.robolectric.RobolectricTestRunner;

@RunWith(RobolectricTestRunner.class)
public class VideoCaptureTest {
  @Rule public MockitoRule mockitoRule = MockitoJUnit.rule();

  @Mock public BinaryMessenger mockBinaryMessenger;
  @Mock public Recorder mockRecorder;
  @Mock public VideoCaptureFlutterApiImpl mockVideoCaptureFlutterApi;

  InstanceManager testInstanceManager;

  @Before
  public void setUp() {
    testInstanceManager = spy(InstanceManager.open(identifier -> {}));
  }

  @After
  public void tearDown() {
    testInstanceManager.close();
  }

  @Test
  public void getOutput_returnsAssociatedRecorder() {
    final Long recorderId = 5L;
    final Long videoCaptureId = 6L;
    VideoCapture<Recorder> videoCapture = VideoCapture.withOutput(mockRecorder);

    testInstanceManager.addDartCreatedInstance(mockRecorder, recorderId);
    testInstanceManager.addDartCreatedInstance(videoCapture, videoCaptureId);

    VideoCaptureHostApiImpl videoCaptureHostApi =
        new VideoCaptureHostApiImpl(mockBinaryMessenger, testInstanceManager);
    assertEquals(videoCaptureHostApi.getOutput(videoCaptureId), recorderId);
    testInstanceManager.remove(recorderId);
    testInstanceManager.remove(videoCaptureId);
  }

  @Test
  @SuppressWarnings("unchecked")
  public void withOutput_returnsNewVideoCaptureWithAssociatedRecorder() {
    final Long recorderId = 5L;
    testInstanceManager.addDartCreatedInstance(mockRecorder, recorderId);

    VideoCaptureHostApiImpl videoCaptureHostApi =
        new VideoCaptureHostApiImpl(mockBinaryMessenger, testInstanceManager);
    VideoCaptureHostApiImpl spyVideoCaptureApi = spy(videoCaptureHostApi);
    doReturn(mockVideoCaptureFlutterApi)
        .when(spyVideoCaptureApi)
        .getVideoCaptureFlutterApiImpl(mockBinaryMessenger, testInstanceManager);
    doNothing()
        .when(mockVideoCaptureFlutterApi)
        .create(
            any(VideoCapture.class),
            any(GeneratedCameraXLibrary.VideoCaptureFlutterApi.Reply.class));
    final Long videoCaptureId = videoCaptureHostApi.withOutput(recorderId);
    VideoCapture<Recorder> videoCapture = testInstanceManager.getInstance(videoCaptureId);
    assertEquals(videoCapture.getOutput(), mockRecorder);

    testInstanceManager.remove(recorderId);
    testInstanceManager.remove(videoCaptureId);
  }
}