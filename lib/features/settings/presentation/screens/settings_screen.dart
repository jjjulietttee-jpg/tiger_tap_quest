import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tiger_tap_quest/core/data/services/haptic_service.dart';
import 'package:tiger_tap_quest/core/domain/bloc/music_cubit.dart';
import 'package:tiger_tap_quest/core/domain/bloc/music_state.dart';
import 'package:tiger_tap_quest/core/domain/bloc/stats_bloc.dart';
import 'package:tiger_tap_quest/core/shared/widgets/dark_background.dart';
import 'package:tiger_tap_quest/core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late HapticService _hapticService;

  @override
  void initState() {
    super.initState();
    _hapticService = RepositoryProvider.of<HapticService>(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        children: [
          const DarkBackground(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    size.width * 0.02,
                    size.height * 0.02,
                    size.width * 0.04,
                    0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Back',
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/menu');
                          }
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Settings',
                          style: theme.textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.06,
                    ),
                    children: [
                      _SectionTitle(title: 'Audio', icon: Icons.music_note_rounded),
                      const SizedBox(height: 8),
                      _buildAudioSection(context),
                      SizedBox(height: size.height * 0.025),
                      _SectionTitle(title: 'Controls', icon: Icons.vibration_rounded),
                      const SizedBox(height: 8),
                      _buildHapticSection(context),
                      SizedBox(height: size.height * 0.025),
                      _SectionTitle(title: 'Data', icon: Icons.storage_rounded),
                      const SizedBox(height: 8),
                      _buildDataSection(context),
                      SizedBox(height: size.height * 0.025),
                      _SectionTitle(title: 'About', icon: Icons.info_outline_rounded),
                      const SizedBox(height: 8),
                      _GlassCard(
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.info_outline_rounded,
                                  color: Colors.white70, size: 20),
                              title: Text('About Tiger Tap Quest',
                                  style: theme.textTheme.bodyLarge),
                              trailing: const Icon(Icons.chevron_right,
                                  color: Colors.white54),
                              onTap: () => context.push('/about'),
                            ),
                            const Divider(height: 1, color: Colors.white12),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.shield_outlined,
                                  color: Colors.white70, size: 20),
                              title: Text('Privacy Policy',
                                  style: theme.textTheme.bodyLarge),
                              trailing: const Icon(Icons.open_in_new,
                                  color: Colors.white54, size: 18),
                              onTap: () async {
                                final uri = Uri.parse(
                                  'https://sergeypoznyko-tech.github.io/Tiger-Tap-Quest/privacy.html',
                                );
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri,
                                      mode: LaunchMode.inAppBrowserView);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioSection(BuildContext context) {
    final cubit = context.read<MusicCubit>();

    return BlocBuilder<MusicCubit, MusicState>(
      builder: (context, state) {
        return _GlassCard(
          child: Column(
            children: [
              _SettingsRow(
                label: 'Music',
                icon: Icons.music_note_rounded,
                trailing: Switch(
                  value: !state.isMuted,
                  onChanged: (v) => cubit.setMuted(!v),
                ),
              ),
              if (!state.isMuted) ...[
                Slider(
                  value: state.volume,
                  onChanged: (v) => cubit.setVolume(v),
                ),
                const SizedBox(height: 4),
              ],
              const Divider(height: 1, color: Colors.white12),
              const SizedBox(height: 4),
              _SettingsRow(
                label: 'Sound Effects',
                icon: Icons.volume_up_rounded,
                trailing: Switch(
                  value: !state.isEffectsMuted,
                  onChanged: (v) => cubit.setEffectsMuted(!v),
                ),
              ),
              if (!state.isEffectsMuted) ...[
                Slider(
                  value: state.effectsVolume,
                  onChanged: (v) => cubit.setEffectsVolume(v),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHapticSection(BuildContext context) {
    return _GlassCard(
      child: StatefulBuilder(
        builder: (context, setInnerState) {
          return _SettingsRow(
            label: 'Haptic Feedback',
            icon: Icons.vibration_rounded,
            trailing: Switch(
              value: _hapticService.enabled,
              onChanged: (v) {
                _hapticService.setEnabled(v);
                setInnerState(() {});
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDataSection(BuildContext context) {
    final theme = Theme.of(context);
    return _GlassCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.delete_outline_rounded, color: Colors.red.shade300),
        title: Text('Reset All Progress',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.red.shade300,
            )),
        onTap: () => _showResetDialog(context),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.deepGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Reset Progress?',
            style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
        content: Text(
          'This will erase all stats, achievements, and shop purchases. This cannot be undone.',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              context.read<StatsBloc>().add(const ResetAllStats());
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Progress reset'),
                  backgroundColor: AppTheme.deepGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: Text('Reset',
                style: TextStyle(color: Colors.red.shade300)),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.orange),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppTheme.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget trailing;

  const _SettingsRow({
    required this.label,
    required this.icon,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.white70),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: theme.textTheme.bodyLarge),
        ),
        trailing,
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withValues(alpha: 0.08),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: child,
        ),
      ),
    );
  }
}
