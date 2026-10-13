// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'camerax_library.g.dart';
import 'image_reader_rotated_preview.dart';
import 'rotated_preview_utils.dart';
import 'surface_texture_rotated_preview.dart';

/// Widget that rotates the camera preview to be upright according to the
/// current user interface orientation based on whether or not the device
/// uses an Impeller backend that handles crop and rotation of Surfaces
/// correctly automatically.
@internal
final class RotatedPreviewDelegate extends StatelessWidget {
  /// Creates [RotatedPreviewDelegate] that will build the correctly
  /// rotated preview widget depending on whether or not the Impeller
  /// backend handles crop and rotation automatically.
  const RotatedPreviewDelegate({
    super.key,
    required this.handlesCropAndRotation,
    required this.initialDeviceOrientation,
    required this.initialDefaultDisplayRotation,
    required this.deviceOrientationStream,
    required this.sensorOrientationDegrees,
    required this.cameraIsFrontFacing,
    required this.deviceOrientationManager,
    this.initialSurfaceRequestTransformationInfo = const SurfaceRequestTransformationInfo(),
    this.surfaceRequestTransformationInfoStream,
    required this.child,
  });

  /// Whether or not the Android surface producer automatically handles
  /// correcting the rotation of camera previews for the device this plugin
  /// runs on.
  final bool handlesCropAndRotation;

  /// The initial orientation of the device when the camera is created.
  final DeviceOrientation initialDeviceOrientation;

  /// The initial rotation of the Android default display when the camera is created,
  /// in terms of a Surface rotation constant.
  final int initialDefaultDisplayRotation;

  /// Stream of changes to the device orientation.
  final Stream<DeviceOrientation> deviceOrientationStream;

  /// The orientation of the camera sensor in degrees.
  final double sensorOrientationDegrees;

  /// Whether or not the camera is front facing.
  final bool cameraIsFrontFacing;

  /// The camera's device orientation manager.
  ///
  /// Instance required to check the current rotation of the default Android display.
  final DeviceOrientationManager deviceOrientationManager;

  /// The initial `SurfaceRequest.TransformationInfo` metadata for the camera
  /// preview.
  final SurfaceRequestTransformationInfo initialSurfaceRequestTransformationInfo;

  /// Stream of changes to the camera preview's
  /// `SurfaceRequest.TransformationInfo` metadata.
  final Stream<SurfaceRequestTransformationInfo>? surfaceRequestTransformationInfoStream;

  /// The camera preview [Widget] to rotate.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (handlesCropAndRotation) {
      return SurfaceTextureRotatedPreview(
        initialDeviceOrientation,
        initialDefaultDisplayRotation,
        deviceOrientationStream,
        deviceOrientationManager,
        initialSurfaceRequestTransformationInfo: initialSurfaceRequestTransformationInfo,
        surfaceRequestTransformationInfo: surfaceRequestTransformationInfoStream,
        child: child,
      );
    }

    if (cameraIsFrontFacing) {
      return ImageReaderRotatedPreview.frontFacingCamera(
        initialDeviceOrientation,
        initialDefaultDisplayRotation,
        deviceOrientationStream,
        sensorOrientationDegrees,
        deviceOrientationManager,
        initialSurfaceRequestTransformationInfo: initialSurfaceRequestTransformationInfo,
        surfaceRequestTransformationInfo: surfaceRequestTransformationInfoStream,
        child: child,
      );
    } else {
      return ImageReaderRotatedPreview.backFacingCamera(
        initialDeviceOrientation,
        initialDefaultDisplayRotation,
        deviceOrientationStream,
        sensorOrientationDegrees,
        deviceOrientationManager,
        initialSurfaceRequestTransformationInfo: initialSurfaceRequestTransformationInfo,
        surfaceRequestTransformationInfo: surfaceRequestTransformationInfoStream,
        child: child,
      );
    }
  }
}
