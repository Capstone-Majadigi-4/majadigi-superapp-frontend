import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/router.dart';

void main() {
  runApp(const MajadigiAdminApp());
}

class MajadigiAdminApp extends StatelessWidget {
  const MajadigiAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Majadigi Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: appRouter,
    );
  }
}
