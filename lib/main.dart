import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadb_tech/classes/theme_class.dart';
import 'package:quadb_tech/classes/theme_provider_class.dart';
import 'package:quadb_tech/screens/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (ctx, __, ___) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Provider.of<ThemeProvider>(ctx).isSelectedData
              ? CustomTheme.darkTheme
              : CustomTheme.lightTheme,
          title: 'Flutter Demo',
          home: const SplashScreen(),
        );
      },
    );
  }
}
