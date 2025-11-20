import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:job_platform/core/utils/AuthProvider.dart';
import 'package:job_platform/core/utils/providers/ThemeProvider.dart';
import 'package:job_platform/core/utils/providers/setting_provider.dart';
import 'package:job_platform/routes/router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY_DEV']!,
      authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN_DEV']!,
      projectId: dotenv.env['FIREBASE_PROJECT_ID_DEV']!,
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET_DEV']!,
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID_DEV']!,
      appId: dotenv.env['FIREBASE_APP_ID_DEV']!,
      measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID_DEV']!,
    ),
  );
  usePathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('id')],
        path: 'assets/lang',
        fallbackLocale: const Locale('id'),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingProvider = Provider.of<SettingProvider>(context);
    return MaterialApp.router(
      title: 'Skillen',
      theme: ThemeData(
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: settingProvider.fontSizeHead?.toDouble(),
          ),
          headlineMedium: TextStyle(
            fontSize: settingProvider.fontSizeSubHead?.toDouble(),
          ),
          bodyMedium: TextStyle(
            fontSize: settingProvider.fontSizeBody?.toDouble(),
          ),
          labelMedium: TextStyle(
            fontSize: settingProvider.fontSizeIcon?.toDouble(),
          ),
        ),
        colorScheme: ColorScheme.light(
          primary: Colors.white,
          secondary: Colors.blue,
        ),
        scaffoldBackgroundColor: Colors.grey.shade100,
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.grey.shade300,
          secondary: Colors.blue,
        ),
        scaffoldBackgroundColor: Colors.grey.shade900,
        cardColor: Colors.grey.shade800,
      ),
      themeMode: themeProvider.currentTheme,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 600, name: MOBILE),
          const Breakpoint(start: 601, end: 1024, name: TABLET),
          const Breakpoint(start: 1025, end: double.infinity, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      routerConfig: router,
    );
  }
}
