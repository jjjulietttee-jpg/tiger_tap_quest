import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/dark_background.dart';
import 'package:tiger_tap_quest/features/about/presentation/widgets/about_content_block.dart';
import 'package:tiger_tap_quest/features/about/presentation/widgets/about_header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const DarkBackground(),
          CustomScrollView(
            slivers: [
              AboutHeader(),
              AboutContentBlock(),
            ],
          ),
        ],
      ),
    );
  }
}
