// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camerax;

import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;

import androidx.camera.video.Recording;

import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import org.robolectric.RobolectricTestRunner;

import io.flutter.plugin.common.BinaryMessenger;

@RunWith(RobolectricTestRunner.class)
public class RecordingTest {
    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Mock
    public BinaryMessenger mockBinaryMessenger;
    @Mock
    public Recording mockRecording;

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
    public void close_getsRecordingFromInstanceManagerAndCloses() {
        final RecordingHostApiImpl recordingHostApi
                = new RecordingHostApiImpl(mockBinaryMessenger, testInstanceManager);
        final Long recordingId = 5L;

        testInstanceManager.addDartCreatedInstance(mockRecording, recordingId);

        recordingHostApi.close(recordingId);

    verify(mockRecording).close();
        testInstanceManager.remove(recordingId);
    }

    @Test
    public void stop_getsRecordingFromInstanceManagerAndStops() {
        final RecordingHostApiImpl recordingHostApi
                = new RecordingHostApiImpl(mockBinaryMessenger, testInstanceManager);
        final Long recordingId = 5L;

        testInstanceManager.addDartCreatedInstance(mockRecording, recordingId);

        recordingHostApi.stop(recordingId);

        verify(mockRecording).stop();
        testInstanceManager.remove(recordingId);
    }

    @Test
    public void resume_getsRecordingFromInstanceManagerAndResumes() {
        final RecordingHostApiImpl recordingHostApi
                = new RecordingHostApiImpl(mockBinaryMessenger, testInstanceManager);
        final Long recordingId = 5L;

        testInstanceManager.addDartCreatedInstance(mockRecording, recordingId);

        recordingHostApi.resume(recordingId);

        verify(mockRecording).resume();
        testInstanceManager.remove(recordingId);
    }

    @Test
    public void pause_getsRecordingFromInstanceManagerAndPauses() {
        final RecordingHostApiImpl recordingHostApi
                = new RecordingHostApiImpl(mockBinaryMessenger, testInstanceManager);
        final Long recordingId = 5L;

        testInstanceManager.addDartCreatedInstance(mockRecording, recordingId);

        recordingHostApi.pause(recordingId);

        verify(mockRecording).pause();
        testInstanceManager.remove(recordingId);
    }
}
