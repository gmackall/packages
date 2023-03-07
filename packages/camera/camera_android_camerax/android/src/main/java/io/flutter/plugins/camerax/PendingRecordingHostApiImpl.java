// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camerax;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;
import androidx.camera.video.PendingRecording;
import androidx.camera.video.Recording;
import androidx.camera.video.VideoRecordEvent;
import androidx.core.content.ContextCompat;

import java.util.Objects;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.camerax.GeneratedCameraXLibrary.PendingRecordingHostApi;

public class PendingRecordingHostApiImpl implements PendingRecordingHostApi {
    private final BinaryMessenger binaryMessenger;
    private final InstanceManager instanceManager;
    private Context context;

    @VisibleForTesting
    public CameraXProxy cameraXProxy = new CameraXProxy();

    public PendingRecordingHostApiImpl(
            BinaryMessenger binaryMessenger,
            @NonNull InstanceManager instanceManager,
            Context context) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
        this.context = context;
    }

    public void setContext(Context context) {
        this.context = context;
    }

    @NonNull
    @Override
    public Long start(@NonNull Long identifier) {
        PendingRecording pendingRecording = getPendingRecordingFromInstanceId(identifier);
        Recording recording = pendingRecording.start(ContextCompat.getMainExecutor(context),
                (videoRecordEvent) -> {
            if (videoRecordEvent instanceof VideoRecordEvent.Finalize) {
                if (((VideoRecordEvent.Finalize) videoRecordEvent).hasError()) {
                    SystemServicesFlutterApiImpl systemServicesFlutterApi =
                            cameraXProxy.createSystemServicesFlutterApiImpl(binaryMessenger);
                    systemServicesFlutterApi.sendCameraError((
                            ((VideoRecordEvent.Finalize) videoRecordEvent).getCause().toString()
                            ), reply -> {});
                }
            }
                });
        RecordingFlutterApiImpl recordingFlutterApi = new RecordingFlutterApiImpl(binaryMessenger,
                instanceManager);
        recordingFlutterApi.create(recording, reply -> {});
        return Objects.requireNonNull(instanceManager.getIdentifierForStrongReference(recording));
    }

    private PendingRecording getPendingRecordingFromInstanceId(Long instanceId) {
        return (PendingRecording) Objects.requireNonNull(instanceManager.getInstance(instanceId));
    }
}
