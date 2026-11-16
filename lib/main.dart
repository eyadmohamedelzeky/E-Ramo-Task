import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/app_theme.dart';
import 'features/home/data/home_content.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/home/state/favorites_controller.dart';

export 'features/home/presentation/home_screen.dart' show HomeScreen;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Draw behind the system navigation bar so the floating nav card reaches
  // the screen edge with the gesture handle inside it, as in the design.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const ERamoApp());
}

class ERamoApp extends StatefulWidget {
  const ERamoApp({super.key});

  @override
  State<ERamoApp> createState() => _ERamoAppState();
}

class _ERamoAppState extends State<ERamoApp> {
  final _favorites = FavoritesController(
    initial: HomeContent.initialFavoriteIds,
  );

  @override
  void dispose() {
    _favorites.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App name shown by the OS (recent apps); matches the launcher label.
      title: 'امتلك',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Installed above the navigator so bottom sheets inherit RTL layout,
      // favourites and the clamped text scale.
      builder: (context, child) => FavoritesScope(
        controller: _favorites,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: 1.15,
            child: child!,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
