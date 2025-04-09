import 'package:go_router/go_router.dart';
import 'package:mini_habit_tracker_app/presentation/screens/add_habit_screen.dart';
import 'package:mini_habit_tracker_app/presentation/screens/home_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add-habit',
        builder: (context, state) => const AddHabitScreen(),
      ),
    ],
  );
}
