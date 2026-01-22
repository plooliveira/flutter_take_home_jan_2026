import 'dart:async';
import 'dart:typed_data';

import 'package:aurora_take_home_paulo/core/image_palette.dart';
import 'package:aurora_take_home_paulo/core/result.dart';
import 'package:aurora_take_home_paulo/data/models/image_data.dart';
import 'package:aurora_take_home_paulo/data/repositories/image_repository.dart';
import 'package:flutter/painting.dart';

class ImageBundle {
  String url = '';
  ImageProvider? image;
  List<Color> colorPalette = [];
  bool hasError = false;
}

class FetchImageBundleAction {
  FetchImageBundleAction(this.imageRepository);
  final ImageRepository imageRepository;

  Future<ImageBundle?> call() async {
    final result = await imageRepository.get();
    if (result is Success<ImageData>) {
      final bytes = await imageRepository.download(result.data.url);
      if (bytes is Success<Uint8List>) {
        final ImageProvider imageProvider = ResizeImage(
          MemoryImage(bytes.data),
          width: 600,
          policy: ResizeImagePolicy.fit,
        );

        final colorResult = await getColorsFromImage(imageProvider);
        if (colorResult is Success<List<Color>>) {
          await _preDecodeImage(imageProvider);
          return ImageBundle()
            ..url = result.data.url
            ..image = imageProvider
            ..hasError = false
            ..colorPalette = colorResult.data;
        }
      }
    }
    return null;
  }

  Future<void> _preDecodeImage(ImageProvider provider) async {
    final completer = Completer<void>();
    final stream = provider.resolve(const ImageConfiguration());
    late ImageStreamListener listener;

    listener = ImageStreamListener(
      (info, synchronousCall) {
        stream.removeListener(listener);
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
      onError: (error, stackTrace) {
        stream.removeListener(listener);
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );

    stream.addListener(listener);
    return completer.future;
  }
}
