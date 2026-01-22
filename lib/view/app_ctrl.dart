import 'package:aurora_take_home_paulo/core/theme.dart';
import 'package:aurora_take_home_paulo/data/repositories/image_repository.dart';
import 'package:aurora_take_home_paulo/logic/actions/fetch_image_bundle.dart';
import 'package:ctrl/ctrl.dart';
import 'package:flutter/material.dart';

class AppCtrl with Ctrl {
  AppCtrl(this.imageRepository, this.fetchImageBundleAction);

  final ImageRepository imageRepository;

  final FetchImageBundleAction fetchImageBundleAction;
  late final _imageData = mutable<ImageBundle>(ImageBundle());
  late final Observable<ImageBundle> imageData = _imageData;

  ImageBundle? _nextImageBundle;
  bool _isFetchingNext = false;

  late final Observable<Brightness> brightness = Locator()
      .get<AppThemeCtrl>()
      .brightness;

  late final Observable<ColorScheme> colorScheme = scope.merge(
    [imageData, brightness],
    () {
      if (imageData.value.colorPalette.isEmpty) {
        return ColorScheme.fromSeed(
          seedColor: Colors.white,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        );
      }
      return ColorScheme.fromSeed(
        seedColor: imageData.value.colorPalette.first,
        dynamicSchemeVariant: DynamicSchemeVariant.content,
        brightness: brightness.value,
      );
    },
  );

  void getNewImage() async {
    if (_nextImageBundle != null) {
      _imageData.value = _nextImageBundle!;
      _nextImageBundle = null;
      _fetchNextImageBundle();
      return;
    }

    executeAsync(() async {
      final bundle = await fetchImageBundleAction();
      _fetchNextImageBundle();
      if (bundle != null) {
        _imageData.value = bundle;
      } else {
        _imageData.update((value) {
          value.hasError = true;
          value.image = null;
          value.colorPalette = [];
        });
      }
    });
  }

  void _fetchNextImageBundle() async {
    if (_isFetchingNext) return;
    _isFetchingNext = true;

    _nextImageBundle = await fetchImageBundleAction();
    _isFetchingNext = false;
  }
}
