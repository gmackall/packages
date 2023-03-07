// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/camerax_library.g.dart',
    dartTestOut: 'test/test_camerax_library.g.dart',
    dartOptions: DartOptions(copyrightHeader: <String>[
      'Copyright 2013 The Flutter Authors. All rights reserved.',
      'Use of this source code is governed by a BSD-style license that can be',
      'found in the LICENSE file.',
    ]),
    javaOut:
        'android/src/main/java/io/flutter/plugins/camerax/GeneratedCameraXLibrary.java',
    javaOptions: JavaOptions(
      package: 'io.flutter.plugins.camerax',
      className: 'GeneratedCameraXLibrary',
      copyrightHeader: <String>[
        'Copyright 2013 The Flutter Authors. All rights reserved.',
        'Use of this source code is governed by a BSD-style license that can be',
        'found in the LICENSE file.',
      ],
    ),
  ),
)
class ResolutionInfo {
  ResolutionInfo({
    required this.width,
    required this.height,
  });

  int width;
  int height;
}

class CameraPermissionsErrorData {
  CameraPermissionsErrorData({
    required this.errorCode,
    required this.description,
  });

  String errorCode;
  String description;
}

@HostApi(dartHostTestHandler: 'TestJavaObjectHostApi')
abstract class JavaObjectHostApi {
  void dispose(int identifier);
}

@FlutterApi()
abstract class JavaObjectFlutterApi {
  void dispose(int identifier);
}

@HostApi(dartHostTestHandler: 'TestCameraInfoHostApi')
abstract class CameraInfoHostApi {
  int getSensorRotationDegrees(int identifier);
}

@FlutterApi()
abstract class CameraInfoFlutterApi {
  void create(int identifier);
}

@HostApi(dartHostTestHandler: 'TestCameraSelectorHostApi')
abstract class CameraSelectorHostApi {
  void create(int identifier, int? lensFacing);

  List<int> filter(int identifier, List<int> cameraInfoIds);
}

@FlutterApi()
abstract class CameraSelectorFlutterApi {
  void create(int identifier, int? lensFacing);
}

@HostApi(dartHostTestHandler: 'TestProcessCameraProviderHostApi')
abstract class ProcessCameraProviderHostApi {
  @async
  int getInstance();

  List<int> getAvailableCameraInfos(int identifier);

  int bindToLifecycle(
      int identifier, int cameraSelectorIdentifier, List<int> useCaseIds);

  void unbind(int identifier, List<int> useCaseIds);

  void unbindAll(int identifier);
}

@FlutterApi()
abstract class ProcessCameraProviderFlutterApi {
  void create(int identifier);
}

@FlutterApi()
abstract class CameraFlutterApi {
  void create(int identifier);
}

@HostApi(dartHostTestHandler: 'TestSystemServicesHostApi')
abstract class SystemServicesHostApi {
  @async
  CameraPermissionsErrorData? requestCameraPermissions(bool enableAudio);

  void startListeningForDeviceOrientationChange(
      bool isFrontFacing, int sensorOrientation);

  void stopListeningForDeviceOrientationChange();

  @async
  String getTempFilePath();
}

@FlutterApi()
abstract class SystemServicesFlutterApi {
  void onDeviceOrientationChanged(String orientation);

  void onCameraError(String errorDescription);
}

@HostApi(dartHostTestHandler: 'TestPreviewHostApi')
abstract class PreviewHostApi {
  void create(int identifier, int? rotation, ResolutionInfo? targetResolution);

  int setSurfaceProvider(int identifier);

  void releaseFlutterSurfaceTexture();

  ResolutionInfo getResolutionInfo(int identifier);
}

@HostApi(dartHostTestHandler: 'TestVideoCaptureHostApi')
abstract class VideoCaptureHostApi {
  void create(int identifier);

  int withOutput(int videoOutputId);

  int getOutput(int identifier);
}

@FlutterApi()
abstract class VideoCaptureFlutterApi {
  void create(int identifier);
}

@HostApi(dartHostTestHandler: 'TestRecorderHostApi')
abstract class RecorderHostApi {
  void create(int identifier, int? aspectRatio, int? bitRate);

  int getAspectRatio(int identifier);

  int getTargetVideoEncodingBitRate(int identifier);

  int prepareRecording(int identifier, String path);
}

@FlutterApi()
abstract class RecorderFlutterApi {
  void create(int identifier, int? aspectRatio, int? bitRate);
}

@HostApi(dartHostTestHandler: 'TestPendingRecordingHostApi')
abstract class PendingRecordingHostApi {
  int start(int identifier);
}

@FlutterApi()
abstract class PendingRecordingFlutterApi {
  void create(int identifier);
}

@HostApi(dartHostTestHandler: 'TestRecordingHostApi')
abstract class RecordingHostApi {
  void close(int identifier);

  void pause(int identifier);

  void resume(int identifier);

  void stop(int identifier);
}

@FlutterApi()
abstract class RecordingFlutterApi {
  void create(int identifier);
}
