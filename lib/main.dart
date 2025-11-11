import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/project_model.dart';
import 'models/job_model.dart';
import 'models/work_type_model.dart';
import 'providers/project_provider.dart';
import 'providers/region_provider.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Hive
  await Hive.initFlutter();
  
  // Registrar adaptadores
  Hive.registerAdapter(WorkTypeAdapter());
  Hive.registerAdapter(JobAdapter());
  Hive.registerAdapter(ProjectAdapter());
  
  // Abrir boxes
  await Hive.openBox<Project>('projects');
  
  // Mantener splash screen visible por 3 segundos
  await Future.delayed(const Duration(seconds: 3));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProjectProvider()),
        ChangeNotifierProvider(create: (context) => RegionProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Mi Obra Fácil',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF6B35), // Naranja construcción
            primary: const Color(0xFFFF6B35),
            secondary: const Color(0xFF004E89),
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF6B35),
            brightness: Brightness.dark,
            primary: const Color(0xFFFF6B35),
            secondary: const Color(0xFF1A659E),
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
          ),
        ),
        themeMode: ThemeMode.system,
      ),
    );
  }
}
