import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/login_page.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/bapenda/bapenda_page.dart';
import '../features/harga_bahan_pokok/harga_bahan_pokok_page.dart';
import '../features/islamic_center/islamic_center_page.dart';
import '../features/rsud/rsud_page.dart';
import '../features/remaining_modules.dart';
import 'constants/app_constants.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (ctx, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (ctx, state) => const DashboardPage(),
    ),
    GoRoute(
      path: AppRoutes.bapenda,
      builder: (ctx, state) => const BapendaPage(),
    ),
    GoRoute(
      path: AppRoutes.hargaBahanPokok,
      builder: (ctx, state) => const HargaBahanPokokPage(),
    ),
    GoRoute(
      path: AppRoutes.islamicCenter,
      builder: (ctx, state) => const IslamicCenterPage(),
    ),
    GoRoute(
      path: AppRoutes.rsud,
      builder: (ctx, state) => const RsudPage(),
    ),
    GoRoute(
      path: AppRoutes.nomerDarurat,
      builder: (ctx, state) => const NomerDaruratPage(),
    ),
    GoRoute(
      path: AppRoutes.destinasiWisata,
      builder: (ctx, state) => const DestinasiWisataPage(),
    ),
    GoRoute(
      path: AppRoutes.infoBansos,
      builder: (ctx, state) => const InfoBansosPage(),
    ),
    GoRoute(
      path: AppRoutes.etibi,
      builder: (ctx, state) => const EtibiPage(),
    ),
    GoRoute(
      path: AppRoutes.sinaker,
      builder: (ctx, state) => const SinakerPage(),
    ),
    GoRoute(
      path: AppRoutes.transjatim,
      builder: (ctx, state) => const TransjatimPage(),
    ),
  ],
  errorBuilder: (ctx, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.uri}'),
    ),
  ),
);
