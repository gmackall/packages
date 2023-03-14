// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camerax;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;

import static org.junit.Assert.assertEquals;

import android.content.Context;

import androidx.camera.video.PendingRecording;
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

import java.util.concurrent.Executor;

import io.flutter.plugin.common.BinaryMessenger;

@RunWith(RobolectricTestRunner.class)
public class PendingRecordingTest {
    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Mock
    public BinaryMessenger mockBinaryMessenger;
    @Mock
    public PendingRecording mockPendingRecording;
    @Mock
    public Recording mockRecording;
    @Mock
    public RecordingFlutterApiImpl mockRecordingFlutterApi;
    @Mock
    public Context mockContext;

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
    public void testStart() {
        final Long mockPendingRecordingId = 3L;
        final Long mockRecordingId = testInstanceManager.addHostCreatedInstance(mockRecording);
        testInstanceManager.addDartCreatedInstance(mockPendingRecording, mockPendingRecordingId);

        doReturn(mockRecording).when(mockPendingRecording).start(any(), any());
        doNothing().when(mockRecordingFlutterApi).create(any(Recording.class), any());
        PendingRecordingHostApiImpl spy = spy(new PendingRecordingHostApiImpl(
                mockBinaryMessenger, testInstanceManager, mockContext));
        doReturn(mock(Executor.class)).when(spy).getExecutor();
        spy.recordingFlutterApi = mockRecordingFlutterApi;
        assertEquals(spy.start(mockPendingRecordingId), mockRecordingId);
        verify(mockRecordingFlutterApi).create(eq(mockRecording), any());

        testInstanceManager.remove(mockPendingRecordingId);
        testInstanceManager.remove(mockRecordingId);
    }
}
