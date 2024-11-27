// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v22.6.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

PlatformException _createConnectionError(String channelName) {
  return PlatformException(
    code: 'channel-error',
    message: 'Unable to establish connection on channel: "$channelName".',
  );
}

List<Object?> wrapResponse({Object? result, PlatformException? error, bool empty = false}) {
  if (empty) {
    return <Object?>[];
  }
  if (error == null) {
    return <Object?>[result];
  }
  return <Object?>[error.code, error.message, error.details];
}

enum SourceCamera {
  rear,
  front,
}

enum SourceType {
  camera,
  gallery,
}

enum CacheRetrievalType {
  image,
  video,
}

class GeneralOptions {
  GeneralOptions({
    required this.allowMultiple,
    required this.usePhotoPicker,
    this.limit,
  });

  bool allowMultiple;

  bool usePhotoPicker;

  int? limit;

  Object encode() {
    return <Object?>[
      allowMultiple,
      usePhotoPicker,
      limit,
    ];
  }

  static GeneralOptions decode(Object result) {
    result as List<Object?>;
    return GeneralOptions(
      allowMultiple: result[0]! as bool,
      usePhotoPicker: result[1]! as bool,
      limit: result[2] as int?,
    );
  }
}

/// Options for image selection and output.
class ImageSelectionOptions {
  ImageSelectionOptions({
    this.maxWidth,
    this.maxHeight,
    required this.quality,
  });

  /// If set, the max width that the image should be resized to fit in.
  double? maxWidth;

  /// If set, the max height that the image should be resized to fit in.
  double? maxHeight;

  /// The quality of the output image, from 0-100.
  ///
  /// 100 indicates original quality.
  int quality;

  Object encode() {
    return <Object?>[
      maxWidth,
      maxHeight,
      quality,
    ];
  }

  static ImageSelectionOptions decode(Object result) {
    result as List<Object?>;
    return ImageSelectionOptions(
      maxWidth: result[0] as double?,
      maxHeight: result[1] as double?,
      quality: result[2]! as int,
    );
  }
}

class MediaSelectionOptions {
  MediaSelectionOptions({
    required this.imageSelectionOptions,
  });

  ImageSelectionOptions imageSelectionOptions;

  Object encode() {
    return <Object?>[
      imageSelectionOptions,
    ];
  }

  static MediaSelectionOptions decode(Object result) {
    result as List<Object?>;
    return MediaSelectionOptions(
      imageSelectionOptions: result[0]! as ImageSelectionOptions,
    );
  }
}

/// Options for image selection and output.
class VideoSelectionOptions {
  VideoSelectionOptions({
    this.maxDurationSeconds,
  });

  /// The maximum desired length for the video, in seconds.
  int? maxDurationSeconds;

  Object encode() {
    return <Object?>[
      maxDurationSeconds,
    ];
  }

  static VideoSelectionOptions decode(Object result) {
    result as List<Object?>;
    return VideoSelectionOptions(
      maxDurationSeconds: result[0] as int?,
    );
  }
}

/// Specification for the source of an image or video selection.
class SourceSpecification {
  SourceSpecification({
    required this.type,
    this.camera,
  });

  SourceType type;

  SourceCamera? camera;

  Object encode() {
    return <Object?>[
      type,
      camera,
    ];
  }

  static SourceSpecification decode(Object result) {
    result as List<Object?>;
    return SourceSpecification(
      type: result[0]! as SourceType,
      camera: result[1] as SourceCamera?,
    );
  }
}

/// An error that occurred during lost result retrieval.
///
/// The data here maps to the `PlatformException` that will be created from it.
class CacheRetrievalError {
  CacheRetrievalError({
    required this.code,
    this.message,
  });

  String code;

  String? message;

  Object encode() {
    return <Object?>[
      code,
      message,
    ];
  }

  static CacheRetrievalError decode(Object result) {
    result as List<Object?>;
    return CacheRetrievalError(
      code: result[0]! as String,
      message: result[1] as String?,
    );
  }
}

/// The result of retrieving cached results from a previous run.
class CacheRetrievalResult {
  CacheRetrievalResult({
    required this.type,
    this.error,
    this.paths = const <String>[],
  });

  /// The type of the retrieved data.
  CacheRetrievalType type;

  /// The error from the last selection, if any.
  CacheRetrievalError? error;

  /// The results from the last selection, if any.
  List<String> paths;

  Object encode() {
    return <Object?>[
      type,
      error,
      paths,
    ];
  }

  static CacheRetrievalResult decode(Object result) {
    result as List<Object?>;
    return CacheRetrievalResult(
      type: result[0]! as CacheRetrievalType,
      error: result[1] as CacheRetrievalError?,
      paths: (result[2] as List<Object?>?)!.cast<String>(),
    );
  }
}


class _PigeonCodec extends StandardMessageCodec {
  const _PigeonCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is int) {
      buffer.putUint8(4);
      buffer.putInt64(value);
    }    else if (value is SourceCamera) {
      buffer.putUint8(129);
      writeValue(buffer, value.index);
    }    else if (value is SourceType) {
      buffer.putUint8(130);
      writeValue(buffer, value.index);
    }    else if (value is CacheRetrievalType) {
      buffer.putUint8(131);
      writeValue(buffer, value.index);
    }    else if (value is GeneralOptions) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    }    else if (value is ImageSelectionOptions) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    }    else if (value is MediaSelectionOptions) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    }    else if (value is VideoSelectionOptions) {
      buffer.putUint8(135);
      writeValue(buffer, value.encode());
    }    else if (value is SourceSpecification) {
      buffer.putUint8(136);
      writeValue(buffer, value.encode());
    }    else if (value is CacheRetrievalError) {
      buffer.putUint8(137);
      writeValue(buffer, value.encode());
    }    else if (value is CacheRetrievalResult) {
      buffer.putUint8(138);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 129: 
        final int? value = readValue(buffer) as int?;
        return value == null ? null : SourceCamera.values[value];
      case 130: 
        final int? value = readValue(buffer) as int?;
        return value == null ? null : SourceType.values[value];
      case 131: 
        final int? value = readValue(buffer) as int?;
        return value == null ? null : CacheRetrievalType.values[value];
      case 132: 
        return GeneralOptions.decode(readValue(buffer)!);
      case 133: 
        return ImageSelectionOptions.decode(readValue(buffer)!);
      case 134: 
        return MediaSelectionOptions.decode(readValue(buffer)!);
      case 135: 
        return VideoSelectionOptions.decode(readValue(buffer)!);
      case 136: 
        return SourceSpecification.decode(readValue(buffer)!);
      case 137: 
        return CacheRetrievalError.decode(readValue(buffer)!);
      case 138: 
        return CacheRetrievalResult.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class ImagePickerApi {
  /// Constructor for [ImagePickerApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  ImagePickerApi({BinaryMessenger? binaryMessenger, String messageChannelSuffix = ''})
      : pigeonVar_binaryMessenger = binaryMessenger,
        pigeonVar_messageChannelSuffix = messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
  final BinaryMessenger? pigeonVar_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = _PigeonCodec();

  final String pigeonVar_messageChannelSuffix;

  /// Selects images and returns their paths.
  Future<List<String>> pickImages(SourceSpecification source, ImageSelectionOptions options, GeneralOptions generalOptions) async {
    final String pigeonVar_channelName = 'dev.flutter.pigeon.image_picker_android.ImagePickerApi.pickImages$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(<Object?>[source, options, generalOptions]) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as List<Object?>?)!.cast<String>();
    }
  }

  /// Selects video and returns their paths.
  Future<List<String>> pickVideos(SourceSpecification source, VideoSelectionOptions options, GeneralOptions generalOptions) async {
    final String pigeonVar_channelName = 'dev.flutter.pigeon.image_picker_android.ImagePickerApi.pickVideos$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(<Object?>[source, options, generalOptions]) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as List<Object?>?)!.cast<String>();
    }
  }

  /// Selects images and videos and returns their paths.
  Future<List<String>> pickMedia(MediaSelectionOptions mediaSelectionOptions, GeneralOptions generalOptions) async {
    final String pigeonVar_channelName = 'dev.flutter.pigeon.image_picker_android.ImagePickerApi.pickMedia$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(<Object?>[mediaSelectionOptions, generalOptions]) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as List<Object?>?)!.cast<String>();
    }
  }

  /// Returns results from a previous app session, if any.
  Future<CacheRetrievalResult?> retrieveLostResults() async {
    final String pigeonVar_channelName = 'dev.flutter.pigeon.image_picker_android.ImagePickerApi.retrieveLostResults$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(null) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return (pigeonVar_replyList[0] as CacheRetrievalResult?);
    }
  }
}
