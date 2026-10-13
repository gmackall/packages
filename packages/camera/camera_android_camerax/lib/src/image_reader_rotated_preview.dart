// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'camerax_library.dart';
import 'rotated_preview_utils.dart';

/// Widget that rotates the camera preview to be upright according to the
/// current user interface orientation for devices using the `ImageReader`
/// Impeller backend, which does not automatically handle the crop and
/// rotation of the camera preview correctly.
@internal
final class ImageReaderRotatedPreview extends StatefulWidget {
  /// Creates [ImageReaderRotatedPreview] that will correct the preview
  /// rotation assuming that the front camera is being used.
  const ImageReaderRotatedPreview.frontFacingCamera(
    this.initialDeviceOrientation,
    this.initialDefaultDisplayRotation,
    this.deviceOrientation,
    this.sensorOrientationDegrees,
    this.deviceOrientationManager, {
    this.initialSurfaceRequestTransformationInfo = const SurfaceRequestTransformationInfo(),
    this.surfaceRequestTransformationInfo,
    required this.child,
    super.key,
  }) : facingSign = 1;

  /// Creates [ImageReaderRotatedPreview] that will correct the preview
  /// rotation assuming that the back camera is being used.
  const ImageReaderRotatedPreview.backFacingCamera(
    this.initialDeviceOrientation,
    this.initialDefaultDisplayRotation,
    this.deviceOrientation,
    this.sensorOrientationDegrees,
    this.deviceOrientationManager, {
    this.initialSurfaceRequestTransformationInfo = const SurfaceRequestTransformationInfo(),
    this.surfaceRequestTransformationInfo,
    required this.child,
    super.key,
  }) : facingSign = -1;

  /// The initial orientation of the device when the camera is created.
  final DeviceOrientation initialDeviceOrientation;

  /// The initial rotation of the Android default display when the camera is created
  /// in terms of a Surface rotation constant.
  final int initialDefaultDisplayRotation;

  /// Stream of changes to the device orientation.
  final Stream<DeviceOrientation> deviceOrientation;

  /// The orientation of the camera sensor in degrees.
  final double sensorOrientationDegrees;

  /// The camera's device orientation manager.
  ///
  /// Instance required to check the current rotation of the default Android display.
  final DeviceOrientationManager deviceOrientationManager;

  /// The initial `SurfaceRequest.TransformationInfo` metadata for the camera
  /// preview.
  final SurfaceRequestTransformationInfo initialSurfaceRequestTransformationInfo;

  /// Stream of changes to the camera preview's
  /// `SurfaceRequest.TransformationInfo` metadata.
  final Stream<SurfaceRequestTransformationInfo>? surfaceRequestTransformationInfo;

  /// Value used to calculate the correct preview rotation.
  ///
  /// 1 if the camera is front facing; -1 if the camera is back facing.
  final int facingSign;

  /// The camera preview [Widget] to rotate.
  final Widget child;

  @override
  State<StatefulWidget> createState() => _ImageReaderRotatedPreviewState();
}

final class _ImageReaderRotatedPreviewState extends State<ImageReaderRotatedPreview> {
  late DeviceOrientation deviceOrientation;
  late int initialDefaultDisplayRotationDegrees;
  late Future<int> defaultDisplayRotationDegrees;
  late StreamSubscription<DeviceOrientation> deviceOrientationSubscription;
  late SurfaceRequestTransformationInfo transformationInfo;
  StreamSubscription<SurfaceRequestTransformationInfo>? transformationInfoSubscription;

  Future<int> _getCurrentDefaultDisplayRotationDegrees() async {
    final int currentDefaultDisplayRotationQuarterTurns = await widget.deviceOrientationManager
        .getDefaultDisplayRotation();
    return getQuarterTurnsFromSurfaceRotationConstant(currentDefaultDisplayRotationQuarterTurns) *
        90;
  }

  @override
  void initState() {
    deviceOrientation = widget.initialDeviceOrientation;
    initialDefaultDisplayRotationDegrees =
        getQuarterTurnsFromSurfaceRotationConstant(widget.initialDefaultDisplayRotation) * 90;
    defaultDisplayRotationDegrees = Future<int>.value(initialDefaultDisplayRotationDegrees);
    transformationInfo = widget.initialSurfaceRequestTransformationInfo;
    deviceOrientationSubscription = widget.deviceOrientation.listen((DeviceOrientation event) {
      // Ensure that we aren't updating the state if the widget is being destroyed.
      if (!mounted) {
        return;
      }

      setState(() {
        deviceOrientation = event;
        defaultDisplayRotationDegrees = _getCurrentDefaultDisplayRotationDegrees();
      });
    });
    transformationInfoSubscription = widget.surfaceRequestTransformationInfo?.listen((
      SurfaceRequestTransformationInfo event,
    ) {
      if (!mounted) {
        return;
      }

      setState(() {
        transformationInfo = event;
      });
    });
    super.initState();
  }

  double _computeRotationDegrees(
    DeviceOrientation orientation,
    int currentDefaultDisplayRotationDegrees, {
    required double sensorOrientationDegrees,
    required int sign,
    required SurfaceRequestTransformationInfo transformationInfo,
  }) {
    double rotationDegrees;
    if (transformationInfo.hasCameraTransform) {
      // Rotate the camera preview according to
      // https://developer.android.com/media/camera/camera2/camera-preview#orientation_calculation.
      rotationDegrees =
          (sensorOrientationDegrees - currentDefaultDisplayRotationDegrees * sign + 360) % 360;
    } else {
      // Per https://developer.android.com/reference/androidx/camera/core/SurfaceRequest.TransformationInfo#hasCameraTransform(),
      // when hasCameraTransform() is false, the Surface does not contain the
      // camera orientation value and the app must instead apply
      // TransformationInfo.getRotationDegrees() (which rotates the buffer to
      // Preview's targetRotation, initialDefaultDisplayRotationDegrees), plus
      // any subsequent change in display rotation.
      rotationDegrees =
          ((transformationInfo.rotationDegrees +
                      currentDefaultDisplayRotationDegrees -
                      initialDefaultDisplayRotationDegrees +
                      360) %
                  360)
              .toDouble();
    }

    // Then, subtract the rotation already applied in the CameraPreview widget
    // (see camera/camera/lib/src/camera_preview.dart) that is not correct
    // for this plugin.
    final double extraRotationDegrees =
        getPreAppliedQuarterTurnsRotationFromDeviceOrientation(orientation) * 90;
    rotationDegrees -= extraRotationDegrees;

    return rotationDegrees;
  }

  @override
  void dispose() {
    deviceOrientationSubscription.cancel();
    transformationInfoSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: defaultDisplayRotationDegrees,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final int currentDefaultDisplayRotation = snapshot.data!;
          final double rotationDegrees = _computeRotationDegrees(
            deviceOrientation,
            currentDefaultDisplayRotation,
            sensorOrientationDegrees: widget.sensorOrientationDegrees,
            sign: widget.facingSign,
            transformationInfo: transformationInfo,
          );

          // If the camera is front facing (widget.facingSign is 1 for front
          // cameras, -1 for back cameras) and the buffer still contains raw
          // unmirrored sensor frames (transformationInfo.hasCameraTransform is
          // true), mirror the camera preview according to the current device
          // orientation.
          Widget cameraPreview = widget.child;
          if (widget.facingSign == 1 && transformationInfo.hasCameraTransform) {
            if (deviceOrientation == DeviceOrientation.portraitDown ||
                deviceOrientation == DeviceOrientation.portraitUp) {
              cameraPreview = Transform.scale(scaleY: -1, child: cameraPreview);
            } else {
              cameraPreview = Transform.scale(scaleX: -1, child: cameraPreview);
            }
          }

          return RotatedBox(quarterTurns: rotationDegrees ~/ 90, child: cameraPreview);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
