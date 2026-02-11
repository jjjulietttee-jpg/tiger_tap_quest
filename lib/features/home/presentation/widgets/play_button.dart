import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_elevated_button.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.12,
          vertical: size.height * 0.04,
        ),
        child: AspectRatio(
          aspectRatio: 2.5,
          child: CustomElevatedButton(
            onPressed: () => context.push('/game'),
            child: const Text('Play'),
          ),
        ),
      ),
    );
  }
}
