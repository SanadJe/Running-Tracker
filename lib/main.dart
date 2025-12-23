import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gano/core/theme/features/runs/provider/runs_provider.dart';
import 'package:gano/core/theme/features/runs/ui/runs_screen.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  try {
    await FirebaseAuth.instance.signInAnonymously();
    debugPrint('✅ Firebase Auth connected successfully');
  } catch (e) {
    debugPrint('❌ Firebase Auth error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = RunProvider();
            provider.listenToRuns();
            return provider;
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.mode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const RunsScreen(),
          );
        },
      ),
    );
  }
}
