// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camerax;

import static org.junit.Assert.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.content.Context;

import androidx.camera.video.Recorder;
import androidx.test.core.app.ApplicationProvider;

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
public class RecorderTest {
    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Mock
    public BinaryMessenger mockBinaryMessenger;
    @Mock
    public Recorder mockRecorder;
    private Context context;

    InstanceManager testInstanceManager;

    @Before
    public void setUp() {
        testInstanceManager = spy(InstanceManager.open(identifier -> {}));
        context = ApplicationProvider.getApplicationContext();
    }

    @After
    public void tearDown() {
        testInstanceManager.close();
    }

    @Test
    public void createTest() {
        final RecorderHostApiImpl recorderHostApi =
            new RecorderHostApiImpl(mockBinaryMessenger, testInstanceManager, context);

        final CameraXProxy mockCameraXProxy = mock(CameraXProxy.class);
        final Recorder.Builder mockRecorderBuilder = mock(Recorder.Builder.class);
        recorderHostApi.cameraXProxy = mockCameraXProxy;
        when(mockCameraXProxy.createRecorderBuilder())
                .thenReturn(mockRecorderBuilder);
        when(mockRecorderBuilder.setAspectRatio(1))
                .thenReturn(mockRecorderBuilder);
        when(mockRecorderBuilder.setTargetVideoEncodingBitRate(2))
                .thenReturn(mockRecorderBuilder);
        when(mockRecorderBuilder.setExecutor(any(Executor.class)))
                .thenReturn(mockRecorderBuilder);
        when(mockRecorderBuilder.build()).thenReturn(mockRecorder);

        recorderHostApi.create(0L, 1L, 2L);
        verify(mockCameraXProxy).createRecorderBuilder();
        verify(mockRecorderBuilder).setAspectRatio(1);
        verify(mockRecorderBuilder).setTargetVideoEncodingBitRate(2);
        verify(mockRecorderBuilder).build();
        assertEquals(testInstanceManager.getInstance(0L), mockRecorder);
        testInstanceManager.remove(0L);
    }

    @Test
    public void getAspectRatioTest() {
        when(mockRecorder.getAspectRatio()).thenReturn(6);
        testInstanceManager.addDartCreatedInstance(mockRecorder, 3L);
        final RecorderHostApiImpl recorderHostApi =
                new RecorderHostApiImpl(mockBinaryMessenger, testInstanceManager, context);
        assertEquals(recorderHostApi.getAspectRatio(3L), Long.valueOf(6L));
        verify(mockRecorder).getAspectRatio();
        testInstanceManager.remove(3L);
    }

    @Test
    public void getTargetVideoEncodingBitRateTest() {
        when(mockRecorder.getTargetVideoEncodingBitRate()).thenReturn(7);
        testInstanceManager.addDartCreatedInstance(mockRecorder, 3L);
        final RecorderHostApiImpl recorderHostApi =
                new RecorderHostApiImpl(mockBinaryMessenger, testInstanceManager, context);
        assertEquals(recorderHostApi.getTargetVideoEncodingBitRate(3L), Long.valueOf(7L));
        verify(mockRecorder).getTargetVideoEncodingBitRate();
        testInstanceManager.remove(3L);
    }
}
