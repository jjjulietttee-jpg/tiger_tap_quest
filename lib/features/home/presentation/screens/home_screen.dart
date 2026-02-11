import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/dark_background.dart';
import 'package:tiger_tap_quest/features/home/presentation/widgets/home_header.dart';
import 'package:tiger_tap_quest/features/home/presentation/widgets/home_menu_column.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const DarkBackground(),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              HomeHeader(),
              HomeMenuColumn(),
            ],
          ),
        ],
      ),
    );
  }
}
