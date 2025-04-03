import 'package:a_flutter_app_tensor/screens/auto_mode_screen.dart';
import 'package:a_flutter_app_tensor/screens/home_screen.dart';
import 'package:a_flutter_app_tensor/screens/manual_mode_screen.dart';
import 'package:go_router/go_router.dart';

/// Global router configuration using GoRouter.
/// Defines routes for navigating between Home, Auto, and Manual screens.
final GoRouter appRouter = GoRouter(
  initialLocation: '/', // Default route
  routes: [
    // Route to home screen
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    // Route to auto mode screen
    GoRoute(
      path: '/auto',
      name: 'auto',
      builder: (context, state) => const AutoModeScreen(),
    ),
    // Route to manual mode screen
    GoRoute(
      path: '/manual',
      name: 'manual',
      builder: (context, state) => const ManualModeScreen(),
    ),
  ],
);
