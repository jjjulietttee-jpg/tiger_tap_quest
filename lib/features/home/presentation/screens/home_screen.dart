import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiger_tap_quest/core/domain/bloc/music_cubit.dart';
import 'package:tiger_tap_quest/core/shared/widgets/dark_background.dart';
import 'package:tiger_tap_quest/features/home/presentation/widgets/home_header.dart';
import 'package:tiger_tap_quest/features/home/presentation/widgets/home_play_button.dart';
import 'package:tiger_tap_quest/features/home/presentation/widgets/home_stats_section.dart';
import 'package:tiger_tap_quest/features/home/presentation/widgets/home_nav_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MusicCubit>().onHomeReached();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final pad = size.width * 0.06;

    return Scaffold(
      body: Stack(
        children: [
          const DarkBackground(darkenOpacity: 0.72),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: pad),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.02),
                  const HomeHeader(),
                  SizedBox(height: size.height * 0.03),
                  const HomePlayButton(),
                  SizedBox(height: size.height * 0.025),
                  const HomeStatsSection(),
                  SizedBox(height: size.height * 0.02),
                  const Expanded(child: HomeNavButtons()),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
