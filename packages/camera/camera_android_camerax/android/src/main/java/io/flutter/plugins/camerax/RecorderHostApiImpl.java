// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camerax;

import android.content.ContentValues;
import android.content.Context;
import android.provider.MediaStore;

import androidx.annotation.NonNull;
import androidx.camera.video.FileOutputOptions;
import androidx.camera.video.MediaStoreOutputOptions;
import androidx.camera.video.PendingRecording;
import androidx.camera.video.Recorder;
import androidx.core.content.ContextCompat;

import java.io.File;
import java.io.IOException;
import java.util.Objects;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.camerax.GeneratedCameraXLibrary.RecorderHostApi;

public class RecorderHostApiImpl implements RecorderHostApi {
    private final BinaryMessenger binaryMessenger;
    private final InstanceManager instanceManager;
    private Context context;

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
        //TODO: Aspect ratio and bitrate setters are only exposed in the most recent camerax
        Recorder.Builder recorderBuilder = new Recorder.Builder();
        Recorder recorder = recorderBuilder
                .setAspectRatio(Math.toIntExact(aspectRatio))
                .setTargetVideoEncodingBitRate(Math.toIntExact(bitRate))
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

    @NonNull
    @Override
    public Long prepareRecording(@NonNull Long identifier) {
        Recorder recorder = getRecorderFromInstanceId(identifier);
        final File outputDir = context.getCacheDir();
        File temporaryCaptureFile;
        try {
            temporaryCaptureFile = File.createTempFile("MOV", ".mp4", outputDir);
        } catch (IOException | SecurityException e) {
            return 0L; //TODO fix
        }

        FileOutputOptions fileOutputOptions = new FileOutputOptions.Builder(temporaryCaptureFile).build();
        PendingRecording pendingRecording = recorder.prepareRecording(context, fileOutputOptions);
        PendingRecordingFlutterApiImpl pendingRecordingFlutterApiImpl
                = new PendingRecordingFlutterApiImpl(binaryMessenger, instanceManager);
        pendingRecordingFlutterApiImpl.create(pendingRecording, result -> {});
        return Objects.requireNonNull(
                instanceManager.getIdentifierForStrongReference(pendingRecording));
    }

    private Recorder getRecorderFromInstanceId(Long instanceId) {
        return (Recorder) Objects.requireNonNull(instanceManager.getInstance(instanceId));
    }
}
