import 'package:aurora_take_home_paulo/core/image_palette.dart';
import 'package:aurora_take_home_paulo/core/result.dart';
import 'package:aurora_take_home_paulo/core/theme.dart';
import 'package:aurora_take_home_paulo/data/models/image_data.dart';
import 'package:aurora_take_home_paulo/data/repositories/image_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ctrl/ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageBundle {
  String url = '';
  ImageProvider? image;
  List<Color> colorPallete = [];
  bool hasError = false;
}

class AppCtrl with Ctrl {
  final ImageRepository imageRepository;
  late final _imageData = mutable<ImageBundle>(ImageBundle());
  late final Observable<ImageBundle> imageData = _imageData;
  late final Observable<Brightness> brightness = Locator()
      .get<AppThemeCtrl>()
      .brightness;
  late final Observable<ColorScheme> colorScheme = scope.merge(
    [imageData, brightness],
    () {
      if (imageData.value.colorPallete.isEmpty) {
        return ColorScheme.fromSeed(
          seedColor: Colors.white,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        );
      }
      return ColorScheme.fromSeed(
        seedColor: imageData.value.colorPallete.first,
        dynamicSchemeVariant: DynamicSchemeVariant.content,
        brightness: brightness.value,
      );
    },
  );

  AppCtrl(this.imageRepository);

  void getNewImage() async {
    beginLoading();
    imageRepository.get().then((response) async {
      switch (response) {
        case Success<ImageData>():
          _imageData.update((value) {
            value.url = response.data.url;
            value.hasError = false;
          });

          await getColorsFromImage(
            CachedNetworkImageProvider(
              response.data.url,
              errorListener: (value) {
                _imageData.update((value) {
                  value.colorPallete = [Colors.white];
                  value.hasError = true;
                });
                completeLoading();
              },
            ),
          ).then((colorsResult) {
            switch (colorsResult) {
              case Success<List<Color>>():
                if (colorsResult.data.isNotEmpty) {
                  _imageData.update((value) {
                    value.colorPallete = colorsResult.data;
                    value.hasError = false;
                  });
                }
                completeLoading();
                break;
              case Failure<List<Color>>():
                completeLoading();
                break;
            }
          });
          break;
        case Failure<ImageData>():
          completeLoading();
          break;
      }
    });
  }
}
