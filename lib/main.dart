import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiger_tap_quest/core/theme/app_theme.dart';
import 'package:tiger_tap_quest/routes.dart';
import 'package:tiger_tap_quest/core/domain/bloc/stats_bloc.dart';
import 'package:tiger_tap_quest/core/data/services/stats_service.dart';
import 'package:tiger_tap_quest/features/shop/domain/bloc/shop_bloc.dart';

void main() {
  runApp(const TapApp());
}

class TapApp extends StatelessWidget {
  const TapApp({super.key});

  @override
  Widget build(BuildContext context) {
    final statsService = StatsService();
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StatsBloc(statsService)..add(const LoadStats()),
        ),
        BlocProvider(
          create: (context) => ShopBloc(
            statsService: statsService,
            statsBloc: context.read<StatsBloc>(),
          )..add(const LoadShopItems()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Tiger Tap Quest',
        theme: AppTheme.theme,
        routerConfig: createRouter(),
      ),
    );
  }
}
