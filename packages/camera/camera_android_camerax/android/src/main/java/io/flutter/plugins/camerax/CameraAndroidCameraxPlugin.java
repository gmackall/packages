// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camerax;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.lifecycle.LifecycleOwner;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.view.TextureRegistry;

/** Platform implementation of the camera_plugin implemented with the CameraX library. */
public final class CameraAndroidCameraxPlugin implements FlutterPlugin, ActivityAware {
  private InstanceManager instanceManager;
  private FlutterPluginBinding pluginBinding;
  private ProcessCameraProviderHostApiImpl processCameraProviderHostApi;
  public SystemServicesHostApiImpl systemServicesHostApi;
  private PendingRecordingHostApiImpl pendingRecordingHostApi;
  private RecorderHostApiImpl recorderHostApi;
  private VideoCaptureHostApiImpl videoCaptureHostApi;

  /**
   * Initialize this within the {@code #configureFlutterEngine} of a Flutter activity or fragment.
   *
   * <p>See {@code io.flutter.plugins.camera.MainActivity} for an example.
   */
  public CameraAndroidCameraxPlugin() {}

  void setUp(BinaryMessenger binaryMessenger, Context context, TextureRegistry textureRegistry) {
    // Set up instance manager.
    instanceManager =
        InstanceManager.open(
            identifier -> {
              new GeneratedCameraXLibrary.JavaObjectFlutterApi(binaryMessenger)
                  .dispose(identifier, reply -> {});
            });

    // Set up Host APIs.
    GeneratedCameraXLibrary.CameraInfoHostApi.setup(
        binaryMessenger, new CameraInfoHostApiImpl(instanceManager));
    GeneratedCameraXLibrary.CameraSelectorHostApi.setup(
        binaryMessenger, new CameraSelectorHostApiImpl(binaryMessenger, instanceManager));
    GeneratedCameraXLibrary.JavaObjectHostApi.setup(
        binaryMessenger, new JavaObjectHostApiImpl(instanceManager));
    processCameraProviderHostApi =
        new ProcessCameraProviderHostApiImpl(binaryMessenger, instanceManager, context);
    GeneratedCameraXLibrary.ProcessCameraProviderHostApi.setup(
        binaryMessenger, processCameraProviderHostApi);
    systemServicesHostApi =
        new SystemServicesHostApiImpl(binaryMessenger, instanceManager, context);
    GeneratedCameraXLibrary.SystemServicesHostApi.setup(binaryMessenger, systemServicesHostApi);
    GeneratedCameraXLibrary.PreviewHostApi.setup(
        binaryMessenger, new PreviewHostApiImpl(binaryMessenger, instanceManager, textureRegistry));
    GeneratedCameraXLibrary.RecordingHostApi.setup(
        binaryMessenger, new RecordingHostApiImpl(binaryMessenger, instanceManager));
    recorderHostApi = new RecorderHostApiImpl(binaryMessenger, instanceManager, context);
    GeneratedCameraXLibrary.RecorderHostApi.setup(binaryMessenger, recorderHostApi);
    pendingRecordingHostApi =
        new PendingRecordingHostApiImpl(binaryMessenger, instanceManager, context);
    GeneratedCameraXLibrary.PendingRecordingHostApi.setup(binaryMessenger, pendingRecordingHostApi);
    videoCaptureHostApi = new VideoCaptureHostApiImpl(binaryMessenger, instanceManager);
    GeneratedCameraXLibrary.VideoCaptureHostApi.setup(binaryMessenger, videoCaptureHostApi);
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    pluginBinding = flutterPluginBinding;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (instanceManager != null) {
      instanceManager.close();
    }
  }

  // Activity Lifecycle methods:

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding activityPluginBinding) {
    setUp(
        pluginBinding.getBinaryMessenger(),
        pluginBinding.getApplicationContext(),
        pluginBinding.getTextureRegistry());
    updateContext(pluginBinding.getApplicationContext());
    processCameraProviderHostApi.setLifecycleOwner(
        (LifecycleOwner) activityPluginBinding.getActivity());
    systemServicesHostApi.setActivity(activityPluginBinding.getActivity());
    systemServicesHostApi.setPermissionsRegistry(
        activityPluginBinding::addRequestPermissionsResultListener);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    updateContext(pluginBinding.getApplicationContext());
  }

  @Override
  public void onReattachedToActivityForConfigChanges(
      @NonNull ActivityPluginBinding activityPluginBinding) {
    updateContext(activityPluginBinding.getActivity());
  }

  @Override
  public void onDetachedFromActivity() {
    updateContext(pluginBinding.getApplicationContext());
  }

  /**
   * Updates context that is used to fetch the corresponding instance of a {@code
   * ProcessCameraProvider}.
   */
  public void updateContext(Context context) {
    if (processCameraProviderHostApi != null) {
      processCameraProviderHostApi.setContext(context);
    }
    if (recorderHostApi != null) {
      recorderHostApi.setContext(context);
    }
    if (pendingRecordingHostApi != null) {
      pendingRecordingHostApi.setContext(context);
    }
    if (systemServicesHostApi != null) {
      systemServicesHostApi.setContext(context);
    }
  }
}
