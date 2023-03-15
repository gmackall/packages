// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camerax;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;
import androidx.camera.video.FileOutputOptions;
import androidx.camera.video.PendingRecording;
import androidx.camera.video.Recorder;
import androidx.core.content.ContextCompat;

import java.io.File;
import java.util.Objects;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.camerax.GeneratedCameraXLibrary.RecorderHostApi;

public class RecorderHostApiImpl implements RecorderHostApi {
    private final BinaryMessenger binaryMessenger;
    private final InstanceManager instanceManager;
    private Context context;

    @VisibleForTesting
    public CameraXProxy cameraXProxy = new CameraXProxy();

    public RecorderHostApiImpl(
            BinaryMessenger binaryMessenger,
            @NonNull InstanceManager instanceManager,
            Context context) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
        this.context = context;
    }

    @Override
    public void create(@NonNull Long instanceId, Long aspectRatio, Long bitRate) {
        Recorder.Builder recorderBuilder = cameraXProxy.createRecorderBuilder();
        if (aspectRatio != null) {
            recorderBuilder.setAspectRatio(Math.toIntExact(aspectRatio));
        }
        if (bitRate != null) {
            recorderBuilder.setTargetVideoEncodingBitRate(Math.toIntExact(bitRate));
        }
        Recorder recorder = recorderBuilder
                .setExecutor(ContextCompat.getMainExecutor(context))
                .build();
        instanceManager.addDartCreatedInstance(recorder, instanceId);
    }

    public void setContext(Context context) {
        this.context = context;
    }

    @NonNull
    @Override
    public Long getAspectRatio(@NonNull Long identifier) {
        Recorder recorder = getRecorderFromInstanceId(identifier);
        return Long.valueOf(recorder.getAspectRatio());
    }

    @NonNull
    @Override
    public Long getTargetVideoEncodingBitRate(@NonNull Long identifier) {
        Recorder recorder = getRecorderFromInstanceId(identifier);
        return Long.valueOf(recorder.getTargetVideoEncodingBitRate());
    }

    @Override
    public void prepareRecording(@NonNull Long identifier, @NonNull String path,
                                 GeneratedCameraXLibrary.Result<Long> result) {
        Recorder recorder = getRecorderFromInstanceId(identifier);
        File temporaryCaptureFile;
        try {
            temporaryCaptureFile = new File(path);
        } catch (NullPointerException | SecurityException e) {
            result.error(e);
            return;
        }

        FileOutputOptions fileOutputOptions = new FileOutputOptions.Builder(temporaryCaptureFile)
                .build();
        PendingRecording pendingRecording = recorder.prepareRecording(context, fileOutputOptions)
                .withAudioEnabled();
        PendingRecordingFlutterApiImpl pendingRecordingFlutterApiImpl
                = new PendingRecordingFlutterApiImpl(binaryMessenger, instanceManager);
        pendingRecordingFlutterApiImpl.create(pendingRecording, reply -> {});
        result.success(
                Objects.requireNonNull(
                        instanceManager.getIdentifierForStrongReference(pendingRecording)));
    }

    private Recorder getRecorderFromInstanceId(Long instanceId) {
        return (Recorder) Objects.requireNonNull(instanceManager.getInstance(instanceId));
    }
}
