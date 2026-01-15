import 'package:aurora_take_home_paulo/core/theme.dart';
import 'package:aurora_take_home_paulo/view/app_ctrl.dart';
import 'package:aurora_take_home_paulo/view/widgets/background_layer.dart';
import 'package:aurora_take_home_paulo/view/widgets/another_button.dart';
import 'package:aurora_take_home_paulo/view/widgets/image_card.dart';
import 'package:aurora_take_home_paulo/view/widgets/theme_toggle_button.dart';
import 'package:ctrl/ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppView extends CtrlWidget<AppCtrl> {
  const AppView({super.key});

  @override
  void onInit(BuildContext context, ctrl) {
    ctrl.getNewImage();
    ctrl.isLoading.addListener(() {
      if (ctrl.isLoading.value) {
        SemanticsService.sendAnnouncement(
          View.of(context),
          "Loading new image from server",
          Directionality.of(context),
        );
      } else {
        SemanticsService.sendAnnouncement(
          View.of(context),
          "New Image loaded",
          Directionality.of(context),
        );
      }
    });

    super.onInit(context, ctrl);
  }

  @override
  Widget build(BuildContext context, ctrl) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          Watch(
            ctrl.colorScheme,
            builder: (context, scheme) {
              return ThemeToggleButton(
                colorScheme: scheme,
                onPressed: Locator().get<AppThemeCtrl>().toggleTheme,
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Watch(
            ctrl.colorScheme,
            builder: (context, scheme) {
              return BackgroundLayer(colorScheme: scheme);
            },
          ),
          Watch(
            ctrl.imageData,
            builder: (context, imageData) {
              return Watch(
                ctrl.isLoading,
                builder: (context, isLoading) {
                  return ImageCard(
                    imageData: imageData,
                    isLoading: isLoading,
                    colorScheme: ctrl.colorScheme.value,
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Watch(
        ctrl.isLoading,
        builder: (context, isLoading) {
          return Watch(
            ctrl.colorScheme,
            builder: (context, colorScheme) {
              return AnotherButton(
                isLoading: isLoading,
                colorScheme: colorScheme,
                onPressed: ctrl.getNewImage,
              );
            },
          );
        },
      ),
    );
  }
}
