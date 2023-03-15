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
import java.util.concurrent.Executor;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.camerax.GeneratedCameraXLibrary.PendingRecordingHostApi;

public class PendingRecordingHostApiImpl implements PendingRecordingHostApi {
  private final BinaryMessenger binaryMessenger;
  private final InstanceManager instanceManager;
  private Context context;

  @VisibleForTesting public CameraXProxy cameraXProxy = new CameraXProxy();

  @VisibleForTesting SystemServicesFlutterApiImpl systemServicesFlutterApi;

  @VisibleForTesting RecordingFlutterApiImpl recordingFlutterApi;

  public PendingRecordingHostApiImpl(
      BinaryMessenger binaryMessenger, @NonNull InstanceManager instanceManager, Context context) {
    this.binaryMessenger = binaryMessenger;
    this.instanceManager = instanceManager;
    this.context = context;
    systemServicesFlutterApi = cameraXProxy.createSystemServicesFlutterApiImpl(binaryMessenger);
    recordingFlutterApi = new RecordingFlutterApiImpl(binaryMessenger, instanceManager);
  }

  public void setContext(Context context) {
    this.context = context;
  }

  @NonNull
  @Override
  public Long start(@NonNull Long identifier) {
    PendingRecording pendingRecording = getPendingRecordingFromInstanceId(identifier);
    Recording recording = pendingRecording.start(this.getExecutor(), this::handleVideoRecordEvent);
    recordingFlutterApi.create(recording, reply -> {});
    return Objects.requireNonNull(instanceManager.getIdentifierForStrongReference(recording));
  }

  @VisibleForTesting
  public Executor getExecutor() {
    return ContextCompat.getMainExecutor(context);
  }

  private void handleVideoRecordEvent(VideoRecordEvent event) {
    if (event instanceof VideoRecordEvent.Finalize) {
      VideoRecordEvent.Finalize castedEvent = (VideoRecordEvent.Finalize) event;
      if (castedEvent.hasError()) {
        systemServicesFlutterApi.sendCameraError(castedEvent.getCause().toString(), reply -> {});
      }
    }
  }

  private PendingRecording getPendingRecordingFromInstanceId(Long instanceId) {
    return (PendingRecording) Objects.requireNonNull(instanceManager.getInstance(instanceId));
  }
}
