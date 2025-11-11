import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/add_project_screen.dart';
import 'screens/project_detail_screen.dart';
import 'screens/select_item_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/edit_project_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'add_project',
          builder: (BuildContext context, GoRouterState state) {
            return const AddProjectScreen();
          },
        ),
        GoRoute(
          path: 'project/:id',
          builder: (BuildContext context, GoRouterState state) {
            final String id = state.pathParameters['id']!;
            return ProjectDetailScreen(projectId: id);
          },
          routes: [
            GoRoute(
              path: 'edit',
              builder: (BuildContext context, GoRouterState state) {
                final String id = state.pathParameters['id']!;
                return EditProjectScreen(projectId: id);
              },
            ),
            GoRoute(
              path: 'select_item',
              builder: (BuildContext context, GoRouterState state) {
                final String id = state.pathParameters['id']!;
                return SelectItemScreen(projectId: id);
              },
            ),
            GoRoute(
              path: 'calculate/:item_id',
              builder: (BuildContext context, GoRouterState state) {
                final String projectId = state.pathParameters['id']!;
                final String itemId = state.pathParameters['item_id']!;
                return CalculatorScreen(projectId: projectId, itemId: itemId);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
