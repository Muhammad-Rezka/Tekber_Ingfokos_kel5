import 'package:flutter/material.dart';

import 'ingfokos_widgets.dart';

/// Layar 3: pilihan Log in / Sign Up.
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  void _belumTersedia(BuildContext context, String fitur) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$fitur belum tersedia')));
  }

  @override
  Widget build(BuildContext context) {
    final s = uiScale(context);
    return GlowBackground(
      showBack: true,
      spots: const [GlowSpot(Alignment(1.4, 1.1), kBlueGlow)],
      child: Column(
        children: [
          const Spacer(flex: 24),
          const IngfokosLogo(),
          SizedBox(height: 74 * s),
          OutlinedLimeButton(
            label: 'Log in',
            onPressed: () => _belumTersedia(context, 'Log in'),
          ),
          SizedBox(height: 26 * s),
          OutlinedLimeButton(
            label: 'Sign Up',
            onPressed: () => _belumTersedia(context, 'Sign Up'),
          ),
          const Spacer(flex: 30),
        ],
      ),
    );
  }
}
