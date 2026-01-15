import 'package:aurora_take_home_paulo/view/app_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ImageCard extends StatelessWidget {
  final ImageBundle imageData;
  final bool isLoading;
  final ColorScheme colorScheme;

  const ImageCard({
    super.key,
    required this.imageData,
    required this.isLoading,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300, maxHeight: 750),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              children: [
                Builder(
                  builder: (context) {
                    ImageProvider? image;
                    if (imageData.hasError) {
                      image = const AssetImage('assets/images/image_error.jpg');
                    } else if (imageData.image == null) {
                      image = null;
                    } else {
                      image = imageData.image!;
                    }

                    return Container(
                      width: double.infinity,
                      height: double.infinity,
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
                      child: image == null
                          ? ColoredBox(color: Colors.grey)
                                .animate(target: isLoading ? 1 : 0)
                                .blur(
                                  duration: const Duration(milliseconds: 500),
                                )
                          : AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  child: SizedBox(
                                    key: ValueKey(imageData.url),
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Image(
                                      image: image,
                                      fit: BoxFit.cover,
                                      semanticLabel: 'Image from server',
                                    ),
                                  ),
                                )
                                .animate(target: isLoading ? 1 : 0)
                                .blur(
                                  duration: const Duration(milliseconds: 500),
                                ),
                    );
                  },
                ),
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: imageData.image == null
                          ? Colors.white
                          : colorScheme.primary,
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
