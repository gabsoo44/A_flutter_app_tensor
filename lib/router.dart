import 'package:a_flutter_app_tensor/screens/auto_mode_screen.dart';
import 'package:a_flutter_app_tensor/screens/home_screen.dart';
import 'package:a_flutter_app_tensor/screens/manual_mode_screen.dart';
import 'package:a_flutter_app_tensor/services/thing_client.dart';
import 'package:go_router/go_router.dart';

/// Initializes a singleton ThingClient instance.
/// This client is shared across all screens and establishes a WebSocket connection to the server.
final thingClient = ThingClient()
  ..connectToWebSocket('ws://10.51.116.67:5001'); // Replace with your actual server IP if needed.

/// Main router configuration using GoRouter.
///
/// Defines all available routes in the app and injects the ThingClient
/// into each screen that requires server communication.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    /// Home screen route (main menu)
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => HomeScreen(thingClient: thingClient),
    ),

    /// Route for automatic telemetry mode
    GoRoute(
      path: '/auto',
      name: 'auto',
      builder: (context, state) => AutoModeScreen(thingClient: thingClient), 
    ),

    /// Route for manual data entry mode
    GoRoute(
      path: '/manual',
      name: 'manual',
      builder: (context, state) => ManualModeScreen(thingClient: thingClient), 
    ),
  ],
);
