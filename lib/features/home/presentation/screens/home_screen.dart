import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiger_tap_quest/core/domain/bloc/music_cubit.dart';
import 'package:tiger_tap_quest/core/shared/widgets/dark_background.dart';
import 'package:tiger_tap_quest/features/home/presentation/widgets/home_header.dart';
import 'package:tiger_tap_quest/features/home/presentation/widgets/home_menu_column.dart';

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
