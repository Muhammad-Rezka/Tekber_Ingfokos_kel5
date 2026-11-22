import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // === TES KONEKSI (hapus kalau sudah) ===
  try {
    await supabase.from('tes_koneksi').select();
    print('✅ TERHUBUNG');
  } on PostgrestException catch (e) {
    print('✅ TERHUBUNG ke Supabase (server membalas: ${e.message})');
  } catch (e) {
    print('❌ GAGAL KONEK: $e');
  }
  // ======================================

  runApp(const MainApp());
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}