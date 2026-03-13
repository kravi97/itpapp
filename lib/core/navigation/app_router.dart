/// Navigation routes configuration using go_router
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'route_names.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/task/screens/tasks_screen.dart';
import '../../features/timesheet/screens/timesheet_screen.dart';
import '../../features/projects/screens/projects_screen.dart';
import '../../features/leave/screens/leave_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/auth/providers/auth_provider.dart';

/// Simple shell route for tab navigation
class TabNavigationShell extends StatefulWidget {
  final Widget child;
  final GoRouterState state;

  const TabNavigationShell({required this.child, required this.state, super.key});

  @override
  State<TabNavigationShell> createState() => _TabNavigationShellState();
}

class _TabNavigationShellState extends State<TabNavigationShell> {
  int _selectedIndex = 0;

  final List<String> _tabs = [
    RouteNames.dashboard,
    RouteNames.tasks,
    RouteNames.timesheet,
    RouteNames.projects,
    RouteNames.leave,
    RouteNames.settings,
  ];

  @override
  void didUpdateWidget(TabNavigationShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    final path = widget.state.matchedLocation;
    _selectedIndex = _getTabIndex(path);
  }

  int _getTabIndex(String path) {
    if (path.startsWith('/dashboard')) return 0;
    if (path.startsWith('/tasks')) return 1;
    if (path.startsWith('/timesheet')) return 2;
    if (path.startsWith('/projects')) return 3;
    if (path.startsWith('/leave')) return 4;
    if (path.startsWith('/settings')) return 5;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          context.go(_tabs[index]);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Timesheet'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.event_note), label: 'Leave'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

/// Create the GoRouter configuration
GoRouter createRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: RouteNames.login,
    redirect: (context, state) {
      final user = ref.watch(authProvider);
      final isLoggedIn = user != null;
      final isLoginRoute = state.matchedLocation == RouteNames.login;

      if (!isLoggedIn && !isLoginRoute) {
        return RouteNames.login;
      }
      if (isLoggedIn && isLoginRoute) {
        return RouteNames.dashboard;
      }
      return null;
    },
    routes: [
      GoRoute(path: RouteNames.login, builder: (context, state) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) {
          return TabNavigationShell(state: state, child: child);
        },
        routes: [
          GoRoute(path: RouteNames.dashboard, builder: (context, state) => const DashboardScreen()),
          GoRoute(path: RouteNames.tasks, builder: (context, state) => const TasksScreen()),
          GoRoute(path: RouteNames.timesheet, builder: (context, state) => const TimesheetScreen()),
          GoRoute(path: RouteNames.projects, builder: (context, state) => const ProjectsScreen()),
          GoRoute(path: RouteNames.leave, builder: (context, state) => const LeaveScreen()),
          GoRoute(path: RouteNames.settings, builder: (context, state) => const SettingsScreen()),
        ],
      ),
    ],
  );
}
