import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../providers/habit_providers.dart';
import '../widgets/habit_card.dart';

// This provider is used to force the UI to refresh when needed
// It's a simple counter that, when incremented, causes widgets to rebuild
final forceRefreshProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the force refresh provider to trigger rebuilds when its value changes
    // This ensures the UI updates when we manually refresh the habits
    ref.watch(forceRefreshProvider);

    // Get the stream of habits from our provider
    final habitsStream = ref.watch(habitsProvider);

    // Helper function to refresh the habits list
    // This is called when the user taps the refresh button or pulls to refresh
    void refreshHabits() {
      // Increment the counter to force UI components to rebuild
      ref.read(forceRefreshProvider.notifier).state++;
      // Tell Riverpod to fetch fresh data from the habits provider
      ref.invalidate(habitsProvider);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        centerTitle: true,
        actions: [
          // Refresh button in the app bar
          // Gives users a way to manually refresh the habits list
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: AppStrings.refreshTooltip,
            onPressed: refreshHabits,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: habitsStream.when(
        // When we successfully get the habits data
        data: (habits) {
          // If there are no habits, show an empty state with helpful message
          if (habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.track_changes,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.noHabitsTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.noHabitsSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          // If we have habits, create a sorted copy of the habits list
          // Sorting by start date puts the nearest date at the top
          final sortedHabits = [...habits];
          sortedHabits.sort((a, b) => a.startDate.compareTo(b.startDate));

          // Wrap the ListView in a RefreshIndicator to support pull-to-refresh
          return RefreshIndicator(
            onRefresh: () async {
              refreshHabits();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedHabits.length,
              itemBuilder: (context, index) {
                final habit = sortedHabits[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  // The key includes the forceRefreshProvider value to ensure
                  // the card rebuilds when we manually refresh the habits
                  child: HabitCard(
                    habit: habit,
                    key: ValueKey('${habit.id}-${ref.read(forceRefreshProvider)}'),
                  ),
                );
              },
            ),
          );
        },
        // Show a loading spinner while waiting for the habits data
        loading: () => const Center(child: CircularProgressIndicator()),
        // Show an error message if something goes wrong
        error: (error, stackTrace) => Center(
          child: Text('${AppStrings.errorPrefix}$error'),
        ),
      ),
      // Floating action button to add a new habit
      // Uses GoRouter to navigate to the add habit screen
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-habit'),
        child: const Icon(Icons.add),
      ),
    );
  }
}