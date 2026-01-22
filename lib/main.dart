import 'package:aurora_take_home_paulo/core/theme.dart';
import 'package:aurora_take_home_paulo/data/repositories/image_repository.dart';
import 'package:aurora_take_home_paulo/logic/actions/fetch_image_bundle.dart';
import 'package:aurora_take_home_paulo/view/app_view.dart';
import 'package:aurora_take_home_paulo/view/app_ctrl.dart';
import 'package:ctrl/ctrl.dart';
import 'package:flutter/material.dart';

void main() {
  Locator().registerFactory<ImageRepository>((i) => ImageRepositoryImpl());
  Locator().registerFactory((i) => FetchImageBundleAction(i()));
  Locator().registerFactory<AppCtrl>((i) => AppCtrl(i(), i()));
  Locator().registerLazySingleton((_) => AppThemeCtrl());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch(
      Locator().get<AppThemeCtrl>().brightness,
      builder: (context, value) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(brightness: value),
          home: const AppView(),
        );
      },
    );
  }
}
