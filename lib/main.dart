import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiger_tap_quest/core/appsflyer/appsflyer_service.dart';
import 'package:tiger_tap_quest/core/appsflyer/startup_offer_screen.dart';
import 'package:tiger_tap_quest/core/theme/app_theme.dart';
import 'package:tiger_tap_quest/routes.dart';
import 'package:tiger_tap_quest/core/domain/bloc/stats_bloc.dart';
import 'package:tiger_tap_quest/core/data/services/stats_service.dart';
import 'package:tiger_tap_quest/core/data/services/haptic_service.dart';
import 'package:tiger_tap_quest/features/shop/domain/bloc/shop_bloc.dart';
import 'package:tiger_tap_quest/core/domain/bloc/music_cubit.dart';

class MusicLifecycleHandler extends StatefulWidget {
  final Widget child;

  const MusicLifecycleHandler({
    super.key,
    required this.child,
  });

  @override
  State<MusicLifecycleHandler> createState() => _MusicLifecycleHandlerState();
}

class _MusicLifecycleHandlerState extends State<MusicLifecycleHandler>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final musicCubit = context.read<MusicCubit>();
    final isActive = state == AppLifecycleState.resumed;
    musicCubit.setAppLifecycleState(isActive);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppsFlyerService.instance.init();
  runApp(const TapApp());
}

class TapApp extends StatefulWidget {
  const TapApp({super.key});

  @override
  State<TapApp> createState() => _TapAppState();
}

class _TapAppState extends State<TapApp> {
  bool _showOffer = true;

  void _dismissOffer() {
    if (!mounted) return;
    setState(() => _showOffer = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_showOffer) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: IntroPanelScreen(onDismiss: _dismissOffer),
      );
    }

    final statsService = StatsService();
    final hapticService = HapticService()..initialize();

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
        BlocProvider(
          create: (context) => MusicCubit()..initialize(),
        ),
      ],
      child: RepositoryProvider<HapticService>.value(
        value: hapticService,
        child: MusicLifecycleHandler(
          child: MaterialApp.router(
            title: 'Tiger Tap Quest',
            theme: AppTheme.theme,
            routerConfig: createRouter(),
          ),
        ),
      ),
    );
  }
}
