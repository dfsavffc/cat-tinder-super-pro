import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/main_screen.dart';
import 'domain/cat_controller.dart';
import 'presentation/themes/app_theme.dart';
import 'di/service_locator.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  setupLocator();

  runApp(
    ChangeNotifierProvider<CatController>(
      create: (_) {
        final controller = CatController();
        controller.initialize();
        return controller;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _dark = true;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Cat Tinder',
    theme: _dark ? AppTheme.dark : AppTheme.light,
    home: MainScreen(onToggleTheme: () => setState(() => _dark = !_dark)),
  );
}
