import 'package:flutter/material.dart';

import 'authscreen.dart';
import 'ingfokos_widgets.dart';

/// Layar 2: kartu "Welcome to Ingfokos!" dengan tombol panah.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = uiScale(context);
    final cardHeight = 248 * s;
    final buttonSize = 82 * s;
    final notchRadius = buttonSize / 2 + 11 * s;

    return GlowBackground(
      spots: const [
        GlowSpot(Alignment(-1.3, -1.1), kBlueGlow),
        GlowSpot(Alignment(1.4, -0.9), kOrangeGlow),
        GlowSpot(Alignment(-1.3, 1.1), kOrangeGlow),
      ],
      child: Column(
        children: [
          const Spacer(flex: 24),
          const IngfokosLogo(),
          const Spacer(flex: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 42 * s),
            child: SizedBox(
              height: cardHeight + buttonSize / 2,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Kartu dengan lekukan di tengah bawah
                  ClipPath(
                    clipper: _NotchedCardClipper(notchRadius, 50 * s),
                    child: Container(
                      height: cardHeight,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF7C7C7C), Color(0xFF2A2A2A)],
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(28 * s, 46 * s, 28 * s, 0),
                      child: Column(
                        children: [
                          Text(
                            'Welcome to\nIngfokos!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 27 * s,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 26 * s),
                          Text(
                            'Your smart companion for finding trusted boarding '
                            'houses, real reviews, and the perfect roommate',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12 * s,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Tombol panah
                  Positioned(
                    bottom: 0,
                    child: _ArrowButton(
                      size: buttonSize,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AuthScreen()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(flex: 16),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final double size;
  final VoidCallback onTap;

  const _ArrowButton({required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      child: Ink(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [kLimeDark, kLime]),
        ),
        child: InkWell(
          onTap: onTap,
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: size * 0.42,
          ),
        ),
      ),
    );
  }
}

/// Kartu sudut bulat dengan lekukan setengah lingkaran di tengah bawah.
class _NotchedCardClipper extends CustomClipper<Path> {
  final double notchRadius;
  final double cornerRadius;

  _NotchedCardClipper(this.notchRadius, this.cornerRadius);

  @override
  Path getClip(Size size) {
    final card = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(cornerRadius),
        ),
      );
    final notch = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height),
          radius: notchRadius,
        ),
      );
    return Path.combine(PathOperation.difference, card, notch);
  }

  @override
  bool shouldReclip(covariant _NotchedCardClipper old) =>
      old.notchRadius != notchRadius || old.cornerRadius != cornerRadius;
}
