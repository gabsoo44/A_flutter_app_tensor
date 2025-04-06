import 'package:a_flutter_app_tensor/screens/auto_mode_screen.dart';
import 'package:a_flutter_app_tensor/screens/home_screen.dart';
import 'package:a_flutter_app_tensor/screens/manual_mode_screen.dart';
import 'package:a_flutter_app_tensor/services/thing_client.dart';
import 'package:go_router/go_router.dart';

final thingClient = ThingClient()..connectToWebSocket('ws://10.51.116.67:5001');

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => HomeScreen(thingClient: thingClient),
    ),
    GoRoute(
      path: '/auto',
      name: 'auto',
      builder: (context, state) => AutoModeScreen(thingClient: thingClient), // ✅
    ),
    GoRoute(
      path: '/manual',
      name: 'manual',
      builder: (context, state) => ManualModeScreen(thingClient: thingClient), // ✅
    ),
  ],
);