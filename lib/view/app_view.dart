import 'dart:ui';

import 'package:aurora_take_home_paulo/core/theme.dart';
import 'package:aurora_take_home_paulo/view/app_ctrl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ctrl/ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppView extends CtrlWidget<AppCtrl> {
  const AppView({super.key});

  @override
  void onInit(BuildContext context, ctrl) {
    ctrl.getNewImage();
    super.onInit(context, ctrl);
  }

  @override
  Widget build(BuildContext context, ctrl) {
    return Watch(
      ctrl.colorScheme,
      builder: (context, scheme) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: scheme.onPrimary,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(Icons.brightness_4),
                onPressed: Locator().get<AppThemeCtrl>().toggleTheme,
              ),
            ],
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Container(color: scheme.primary),
              Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    children: [
                      Watch(
                        ctrl.imageData,
                        builder: (context, imageData) {
                          if (imageData.url.isEmpty) return const SizedBox();
                          return Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(50),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              key: ValueKey(imageData.hasError),
                              imageUrl: imageData.url,
                              useOldImageOnUrlChange: true,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/image_error.jpg',
                                fit: BoxFit.cover,
                              ),
                              placeholder: (context, url) {
                                if (imageData.hasError) {
                                  return Image.asset(
                                    'assets/images/image_error.jpg',
                                    fit: BoxFit.cover,
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          );
                        },
                      ),
                      Watch(
                        ctrl.isLoading,
                        builder: (context, value) {
                          if (value) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Watch(
            ctrl.isLoading,
            builder: (context, isLoading) {
              final widget = Watch(
                ctrl.colorScheme,
                builder: (context, colorScheme) {
                  return Theme(
                    data: Theme.of(context).copyWith(colorScheme: colorScheme),
                    child: ElevatedButton(
                      onPressed: ctrl.getNewImage,
                      child: const Text('Another'),
                    ),
                  );
                },
              );
              // Visible when NOT loading (target=1), invisible when loading (target=0)
              return widget
                  .animate(target: ctrl.isLoading.value ? 0 : 1)
                  .fade(duration: 200.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: 200.ms,
                  );
            },
          ),
        );
      },
    );
  }
}
