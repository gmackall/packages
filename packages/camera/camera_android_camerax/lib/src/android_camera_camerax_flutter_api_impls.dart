// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'analyzer.dart';
import 'camera.dart';
import 'camera_info.dart';
import 'camera_selector.dart';
import 'camerax_library.g.dart';
import 'image_proxy.dart';
import 'java_object.dart';
import 'pending_recording.dart';
import 'plane_proxy.dart';
import 'process_camera_provider.dart';
import 'recorder.dart';
import 'recording.dart';
import 'system_services.dart';
import 'video_capture.dart';

/// Handles initialization of Flutter APIs for the Android CameraX library.
class AndroidCameraXCameraFlutterApis {
  /// Creates a [AndroidCameraXCameraFlutterApis].
  AndroidCameraXCameraFlutterApis({
    JavaObjectFlutterApiImpl? javaObjectFlutterApi,
    CameraFlutterApiImpl? cameraFlutterApi,
    CameraInfoFlutterApiImpl? cameraInfoFlutterApi,
    CameraSelectorFlutterApiImpl? cameraSelectorFlutterApi,
    ProcessCameraProviderFlutterApiImpl? processCameraProviderFlutterApi,
    SystemServicesFlutterApiImpl? systemServicesFlutterApi,
    PendingRecordingFlutterApiImpl? pendingRecordingFlutterApiImpl,
    RecordingFlutterApiImpl? recordingFlutterApiImpl,
    RecorderFlutterApiImpl? recorderFlutterApiImpl,
    VideoCaptureFlutterApiImpl? videoCaptureFlutterApiImpl,
    AnalyzerFlutterApiImpl? analyzerFlutterApiImpl,
    ImageProxyFlutterApiImpl? imageProxyFlutterApiImpl,
    PlaneProxyFlutterApiImpl? planeProxyFlutterApiImpl,
  }) {
    this.javaObjectFlutterApi =
        javaObjectFlutterApi ?? JavaObjectFlutterApiImpl();
    this.cameraInfoFlutterApi =
        cameraInfoFlutterApi ?? CameraInfoFlutterApiImpl();
    this.cameraSelectorFlutterApi =
        cameraSelectorFlutterApi ?? CameraSelectorFlutterApiImpl();
    this.processCameraProviderFlutterApi = processCameraProviderFlutterApi ??
        ProcessCameraProviderFlutterApiImpl();
    this.cameraFlutterApi = cameraFlutterApi ?? CameraFlutterApiImpl();
    this.systemServicesFlutterApi =
        systemServicesFlutterApi ?? SystemServicesFlutterApiImpl();
    this.pendingRecordingFlutterApiImpl =
        pendingRecordingFlutterApiImpl ?? PendingRecordingFlutterApiImpl();
    this.recordingFlutterApiImpl = recordingFlutterApiImpl ?? RecordingFlutterApiImpl();
    this.recorderFlutterApiImpl = recorderFlutterApiImpl ?? RecorderFlutterApiImpl();
    this.videoCaptureFlutterApiImpl =
        videoCaptureFlutterApiImpl ?? VideoCaptureFlutterApiImpl();
    this.analyzerFlutterApiImpl =
        analyzerFlutterApiImpl ?? AnalyzerFlutterApiImpl();
    this.imageProxyFlutterApiImpl =
        imageProxyFlutterApiImpl ?? ImageProxyFlutterApiImpl();
    this.planeProxyFlutterApiImpl =
        planeProxyFlutterApiImpl ?? PlaneProxyFlutterApiImpl();
  }

  static bool _haveBeenSetUp = false;

  /// Mutable instance containing all Flutter Apis for Android CameraX Camera.
  ///
  /// This should only be changed for testing purposes.
  static AndroidCameraXCameraFlutterApis instance =
      AndroidCameraXCameraFlutterApis();

  /// Handles callbacks methods for the native Java Object class.
  late final JavaObjectFlutterApi javaObjectFlutterApi;

  /// Flutter Api for [CameraInfo].
  late final CameraInfoFlutterApiImpl cameraInfoFlutterApi;

  /// Flutter Api for [CameraSelector].
  late final CameraSelectorFlutterApiImpl cameraSelectorFlutterApi;

  /// Flutter Api for [ProcessCameraProvider].
  late final ProcessCameraProviderFlutterApiImpl
      processCameraProviderFlutterApi;

  /// Flutter Api for [Camera].
  late final CameraFlutterApiImpl cameraFlutterApi;

  /// Flutter Api for [SystemServices].
  late final SystemServicesFlutterApiImpl systemServicesFlutterApi;

  /// Flutter Api for [PendingRecording].
  late final PendingRecordingFlutterApiImpl pendingRecordingFlutterApiImpl;

  /// Flutter Api for [Recording].
  late final RecordingFlutterApiImpl recordingFlutterApiImpl;

  /// Flutter Api for [Recorder].
  late final RecorderFlutterApiImpl recorderFlutterApiImpl;

  /// Flutter Api for [VideoCapture].
  late final VideoCaptureFlutterApiImpl videoCaptureFlutterApiImpl;

  /// Flutter Api implementation for [Analyzer].
  late final AnalyzerFlutterApiImpl analyzerFlutterApiImpl;

  /// Flutter Api implementation for [ImageProxy].
  late final ImageProxyFlutterApiImpl imageProxyFlutterApiImpl;

  /// Flutter Api implementation for [PlaneProxy].
  late final PlaneProxyFlutterApiImpl planeProxyFlutterApiImpl;

  /// Ensures all the Flutter APIs have been setup to receive calls from native code.
  void ensureSetUp() {
    if (!_haveBeenSetUp) {
      JavaObjectFlutterApi.setup(javaObjectFlutterApi);
      CameraInfoFlutterApi.setup(cameraInfoFlutterApi);
      CameraSelectorFlutterApi.setup(cameraSelectorFlutterApi);
      ProcessCameraProviderFlutterApi.setup(processCameraProviderFlutterApi);
      CameraFlutterApi.setup(cameraFlutterApi);
      SystemServicesFlutterApi.setup(systemServicesFlutterApi);
      PendingRecordingFlutterApi.setup(pendingRecordingFlutterApiImpl);
      RecordingFlutterApi.setup(recordingFlutterApiImpl);
      RecorderFlutterApi.setup(recorderFlutterApiImpl);
      VideoCaptureFlutterApi.setup(videoCaptureFlutterApiImpl);
      AnalyzerFlutterApi.setup(analyzerFlutterApiImpl);
      ImageProxyFlutterApi.setup(imageProxyFlutterApiImpl);
      PlaneProxyFlutterApi.setup(planeProxyFlutterApiImpl);
      _haveBeenSetUp = true;
    }
  }
}
