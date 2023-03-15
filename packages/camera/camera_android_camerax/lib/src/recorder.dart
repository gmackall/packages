// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';

import 'android_camera_camerax_flutter_api_impls.dart';
import 'camerax_library.g.dart';
import 'instance_manager.dart';
import 'java_object.dart';
import 'pending_recording.dart';

/// A dart wrapping of the CameraX Recorder class. Does not exactly wrap all
/// methods.
///
/// See https://developer.android.com/reference/androidx/camera/video/Recorder
class Recorder extends JavaObject {
  /// Creates a [Recorder].
  Recorder({BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
    this.aspectRatio,
    this.bitRate})
      : super.detached(
      binaryMessenger: binaryMessenger, instanceManager: instanceManager) {
    AndroidCameraXCameraFlutterApis.instance.ensureSetUp();
    _api = RecorderHostApiImpl(binaryMessenger: binaryMessenger, instanceManager: instanceManager);
    _api.createFromInstance(this, aspectRatio, bitRate);
  }

  /// Creates a [Recorder] that is not automatically attached to a native object
  Recorder.detached(
      {BinaryMessenger? binaryMessenger, InstanceManager? instanceManager, this.aspectRatio, this.bitRate})
      : super.detached(
      binaryMessenger: binaryMessenger, instanceManager: instanceManager) {
    _api = RecorderHostApiImpl(
        binaryMessenger: binaryMessenger, instanceManager: instanceManager);
    AndroidCameraXCameraFlutterApis.instance.ensureSetUp();
  }

  late final RecorderHostApiImpl _api;

  /// The video aspect ratio of this Recorder.
  final int? aspectRatio;
  /// The intended video encoding bitrate for recording.
  final int? bitRate;

  /// Prepare a recording that will be saved to a file
  Future<PendingRecording> prepareRecording(String path) {
    return _api.prepareRecordingFromInstance(this, path);
  }
}

class RecorderHostApiImpl extends RecorderHostApi {
  ///Creates a RecorderHostApiImpl
  RecorderHostApiImpl(
      {this.binaryMessenger, InstanceManager? instanceManager}) {
    this.instanceManager = instanceManager ?? JavaObject.globalInstanceManager;
  }

  final BinaryMessenger? binaryMessenger;

  late final InstanceManager instanceManager;

  void createFromInstance(Recorder instance, int? aspectRatio, int? bitRate) {
    int? identifier = instanceManager.getIdentifier(instance);
    identifier ??= instanceManager.addDartCreatedInstance(instance,
        onCopy: (Recorder original) {
          return Recorder.detached(binaryMessenger: binaryMessenger,
              instanceManager: instanceManager,
              aspectRatio: aspectRatio,
              bitRate: bitRate);
        });
    create(identifier, aspectRatio, bitRate);
  }

  Future<PendingRecording> prepareRecordingFromInstance(Recorder instance, String path) async {
    final int pendingRecordingId = await prepareRecording(
        instanceManager.getIdentifier(instance)!,
        path
    );

    return instanceManager.getInstanceWithWeakReference(pendingRecordingId)!;
  }
}

class RecorderFlutterApiImpl extends RecorderFlutterApi {

  RecorderFlutterApiImpl(
      {this.binaryMessenger, InstanceManager? instanceManager,
      }) : this.instanceManager = instanceManager ??
      JavaObject.globalInstanceManager;

  final BinaryMessenger? binaryMessenger;
  final InstanceManager instanceManager;

  @override
  void create(int identifier, int? aspectRatio, int? bitRate) {
    instanceManager.addHostCreatedInstance(Recorder.detached(
      binaryMessenger: binaryMessenger,
      instanceManager: instanceManager,
      aspectRatio: aspectRatio,
      bitRate: bitRate,
    ), identifier, onCopy: (Recorder original) {
      return Recorder.detached(
        binaryMessenger: binaryMessenger,
        instanceManager: instanceManager,
        aspectRatio: aspectRatio,
        bitRate: bitRate,
      );
    });
  }
}
