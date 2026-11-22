import 'dart:async';

import 'package:flutter/material.dart';

import 'ingfokos_widgets.dart';
import 'welcomescreen.dart';

/// Layar 1: splash, otomatis pindah ke Welcome setelah 2 detik.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, _, _) => const WelcomeScreen(),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const GlowBackground(
      spots: [
        GlowSpot(Alignment(-1.2, -1.1), kBlueGlow),
        GlowSpot(Alignment(1.0, 1.2), kOrangeGlow),
      ],
      child: Center(child: IngfokosLogo()),
    );
  }
}
