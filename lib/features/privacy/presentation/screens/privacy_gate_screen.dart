import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tiger_tap_quest/core/data/services/stats_service.dart';
import 'package:tiger_tap_quest/core/shared/widgets/dark_background.dart';
import 'package:tiger_tap_quest/core/theme/app_theme.dart';

class PrivacyGateScreen extends StatefulWidget {
  const PrivacyGateScreen({super.key});

  @override
  State<PrivacyGateScreen> createState() => _PrivacyGateScreenState();
}

class _PrivacyGateScreenState extends State<PrivacyGateScreen>
    with SingleTickerProviderStateMixin {
  bool _accepted = false;
  bool _saving = false;
  bool _policyOpened = false;
  late AnimationController _fadeController;
  late Animation<double> _fade;

  static const _privacyUrl =
      'https://sergeypoznyko-tech.github.io/Tiger-Tap-Quest/privacy.html';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _openPrivacyPolicy() async {
    final uri = Uri.parse(_privacyUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      if (mounted && !_policyOpened) {
        setState(() => _policyOpened = true);
      }
    }
  }

  Future<void> _onContinue() async {
    if (!_accepted || _saving) return;
    setState(() => _saving = true);
    await StatsService().setPrivacyAccepted();
    if (!mounted) return;
    context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final pad = size.width * 0.08;

    return Scaffold(
      body: Stack(
        children: [
          const DarkBackground(darkenOpacity: 0.82),
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: pad),
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.04),
                          const Text('🐯', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text(
                            'Welcome to\nTiger Tap Quest',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Before we start, please review our\nprivacy policy',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          _buildPrivacyCard(theme, size),
                          const SizedBox(height: 20),
                          _buildCheckbox(theme),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(pad, 0, pad, size.height * 0.04),
                    child: _buildContinueButton(theme, size),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard(ThemeData theme, Size size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withValues(alpha: 0.08),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Icon(Icons.shield_outlined,
                  color: AppTheme.jungleGreen, size: 40),
              const SizedBox(height: 12),
              Text(
                'Your Privacy',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '• No personal data collected\n'
                '• No tracking or analytics\n'
                '• No ads or third-party SDKs\n'
                '• All data stored locally on device',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _openPrivacyPolicy,
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: const Text('Read Full Privacy Policy'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.orange,
                    side: BorderSide(
                        color: AppTheme.orange.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(ThemeData theme) {
    final enabled = _policyOpened;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: enabled ? 1.0 : 0.45,
      child: GestureDetector(
        onTap: enabled
            ? () => setState(() => _accepted = !_accepted)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _accepted,
                    onChanged: enabled
                        ? (v) => setState(() => _accepted = v ?? false)
                        : null,
                    activeColor: AppTheme.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: enabled ? 0.5 : 0.25),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: enabled ? 0.85 : 0.5),
                        height: 1.3,
                      ),
                      children: [
                        const TextSpan(text: 'I have read and agree to the '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: AppTheme.orange,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                AppTheme.orange.withValues(alpha: 0.5),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _openPrivacyPolicy,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (!enabled)
              Padding(
                padding: const EdgeInsets.only(left: 36, top: 6),
                child: Text(
                  'Please read the Privacy Policy first',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.orange.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(ThemeData theme, Size size) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: _accepted ? 1.0 : 0.4,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _accepted ? _onContinue : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.orange,
            disabledBackgroundColor: AppTheme.orange.withValues(alpha: 0.3),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: _accepted ? 8 : 0,
            shadowColor: AppTheme.orange.withValues(alpha: 0.5),
          ),
          child: _saving
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  'Continue',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    );
  }
}
