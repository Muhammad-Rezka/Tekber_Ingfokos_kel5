import 'dart:math' as math;

import 'package:flutter/material.dart';

// ---------- Palet warna Ingfokos ----------
const Color kBackground = Color(0xFF1E1E1E);
const Color kLime = Color(0xFFB0FF00);
const Color kLimeDark = Color(0xFF5E9E00);
const Color kBlueGlow = Color(0xFF4A6AB0);
const Color kOrangeGlow = Color(0xFFA63A0C);
const Color kButtonFill = Color(0xFF444444);

// Ukuran frame desain di Figma (iPhone 16 Pro Max).
const double kDesignWidth = 440;
const double kDesignHeight = 956;
// Lebar maksimal konten (supaya di layar laptop tetap seperti HP).
const double kMaxContentWidth = 480;

/// Faktor skala: 1.0 = ukuran persis seperti di Figma.
/// Semua ukuran di UI dikali nilai ini supaya proporsional di semua layar.
double uiScale(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  final w = math.min(size.width, kMaxContentWidth);
  final s = math.min(w / kDesignWidth, size.height / kDesignHeight);
  return s.clamp(0.6, 1.2).toDouble();
}

/// Satu "cahaya" blur berwarna di background (radial gradient).
class GlowSpot {
  final Alignment alignment;
  final Color color;
  final double size; // relatif terhadap lebar layar

  const GlowSpot(this.alignment, this.color, {this.size = 1.5});
}

/// Background gelap dengan cahaya gradien + (opsional) tombol kembali.
class GlowBackground extends StatelessWidget {
  final List<GlowSpot> spots;
  final Widget child;
  final bool showBack;

  const GlowBackground({
    super.key,
    required this.spots,
    required this.child,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = uiScale(context);
    return Scaffold(
      backgroundColor: kBackground,
      body: LayoutBuilder(
        builder: (context, c) {
          final glowBase = math.min(c.maxWidth, kMaxContentWidth * 1.5);
          return Stack(
            children: [
              for (final g in spots)
                Align(
                  alignment: g.alignment,
                  child: OverflowBox(
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                    child: Container(
                      width: glowBase * g.size,
                      height: glowBase * g.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            g.color.withValues(alpha: 0.8),
                            g.color.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: kMaxContentWidth,
                    ),
                    child: child,
                  ),
                ),
              ),
              if (showBack)
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(8 * s),
                    child: IconButton(
                      tooltip: 'Kembali',
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                      ),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 22 * s,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Logo Ingfokos (ikon + tulisan), ukurannya ikut skala layar.
class IngfokosLogo extends StatelessWidget {
  const IngfokosLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final s = uiScale(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 135 * s,
          height: 130 * s,
          child: const CustomPaint(painter: _LogoPainter()),
        ),
        SizedBox(height: 4 * s),
        Text(
          'Ingfokos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 54 * s,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

/// Menggambar ikon: kepala (oval) + badan huruf "A" dengan klip kertas.
class _LogoPainter extends CustomPainter {
  const _LogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width / 100;
    final h = size.height / 100;

    final lime = Paint()
      ..color = kLime
      ..isAntiAlias = true;

    // Kepala
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(50 * w, 11 * h),
        width: 26 * w,
        height: 21 * h,
      ),
      lime,
    );

    // Badan "A" (stroke tebal dengan ujung bulat)
    final body = Paint()
      ..color = kLime
      ..style = PaintingStyle.stroke
      ..strokeWidth = 26 * w
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      Path()
        ..moveTo(20 * w, 82 * h)
        ..lineTo(50 * w, 42 * h)
        ..lineTo(80 * w, 82 * h),
      body,
    );

    // Klip kertas (potongan gelap di dalam "A")
    final clip = Paint()
      ..color = kBackground
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.5 * w
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      Path()
        ..moveTo(27 * w, 86 * h)
        ..lineTo(46 * w, 59 * h)
        ..quadraticBezierTo(53 * w, 49 * h, 60 * w, 59 * h)
        ..lineTo(67 * w, 70 * h),
      clip,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Tombol abu-abu dengan border gradien hijau lime.
class OutlinedLimeButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const OutlinedLimeButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final s = uiScale(context);
    final radius = BorderRadius.circular(22 * s);
    return Container(
      width: 244 * s,
      height: 70 * s,
      padding: EdgeInsets.all(2 * s),
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [kLimeDark, kLime],
        ),
      ),
      child: Material(
        color: kButtonFill,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26 * s,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
