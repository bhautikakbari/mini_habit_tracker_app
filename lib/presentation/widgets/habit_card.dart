import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/habit.dart';
import '../providers/habit_providers.dart';
import 'app_button.dart';
import 'app_card.dart';

/// Displays a card for a single habit with its details and completion status.
/// Shows the habit name, frequency, streaks, and a button to mark it as complete.
/// The button state changes based on whether the habit is started, completed, etc.
class HabitCard extends ConsumerWidget {
  final Habit habit;

  const HabitCard({
    super.key,
    required this.habit,
  });

  // Check if the habit has started yet by comparing with today's date
  // We normalize both dates to remove time components for accurate comparison
  bool _hasHabitStarted(DateTime startDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final normalizedStartDate = DateTime(startDate.year, startDate.month, startDate.day);

    // Return true if start date is today or in the past
    return !normalizedStartDate.isAfter(today);
  }

  // Get the most recent completion date from the list
  // Returns null if no completions yet
  DateTime? _getMostRecentCompletionDate(List<DateTime> completedDates) {
    if (completedDates.isEmpty) return null;

    // Normalize all dates to start of day
    final normalizedDates = completedDates.map((date) {
      return DateTime(date.year, date.month, date.day);
    }).toList();

    // Sort in descending order (newest first)
    normalizedDates.sort((a, b) => b.compareTo(a));

    return normalizedDates.first;
  }

  // Calculate when the habit will be available for completion next
  // For daily habits: tomorrow
  // For weekly habits: 7 days after the most recent completion
  DateTime _getNextAvailableDate(HabitFrequency frequency, List<DateTime> completedDates) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (frequency == HabitFrequency.daily) {
      // For daily habits, it's tomorrow
      return today.add(const Duration(days: 1));
    } else {
      // For weekly habits, it's exactly 7 days after the most recent completion
      final mostRecentCompletion = _getMostRecentCompletionDate(completedDates);
      if (mostRecentCompletion != null) {
        return mostRecentCompletion.add(const Duration(days: 7));
      } else {
        // If no completion yet, it's available today
        return today;
      }
    }
  }

  // Determines if the habit is already completed for the current period
  // Daily habits: check if completed today
  // Weekly habits: check if completed within the last 7 days
  bool _isCompletedForCurrentPeriod(List<DateTime> completedDates, HabitFrequency frequency) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (frequency == HabitFrequency.daily) {
      // For daily habits, check if completed today
      return completedDates.any((date) {
        final completedDate = DateTime(date.year, date.month, date.day);
        return completedDate.isAtSameMomentAs(today);
      });
    } else {
      // For weekly habits, check if completed within the last 7 days
      final mostRecentCompletion = _getMostRecentCompletionDate(completedDates);
      if (mostRecentCompletion == null) return false;

      // Calculate days since most recent completion
      final daysSinceCompletion = today.difference(mostRecentCompletion).inDays;

      // If completed today or within the last 6 days (total 7-day period)
      return daysSinceCompletion < 7;
    }
  }

  // Determines the text to show on the action button based on habit status
  // Three possible states:
  // 1. Not started yet - shows start date
  // 2. Completed for current period - shows when it will be available next
  // 3. Active but not completed - shows "Mark as complete"
  String _getButtonText(bool hasStarted, bool isCompleted, HabitFrequency frequency, List<DateTime> completedDates, DateTime startDate) {
    if (!hasStarted) {
      // Habit hasn't started yet
      final formattedDate = DateFormat('EEE, MMM d').format(startDate);
      return '${AppStrings.startsOn} $formattedDate';
    } else if (isCompleted) {
      // Habit is completed for the current period
      final nextDate = _getNextAvailableDate(frequency, completedDates);
      final formattedDate = DateFormat('EEE, MMM d').format(nextDate);

      if (frequency == HabitFrequency.daily) {
        return '${AppStrings.completedTodayButton} (${AppStrings.availableTomorrow})';
      } else {
        return '(${AppStrings.availableOn} $formattedDate)';
      }
    } else {
      // Habit is active and not completed
      return AppStrings.markAsCompleteButton;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasStarted = _hasHabitStarted(habit.startDate);
    final isCompletedForPeriod = hasStarted && _isCompletedForCurrentPeriod(habit.completedDates, habit.frequency);
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with habit name and frequency chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  habit.name,
                  style: theme.textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _FrequencyChip(frequency: habit.frequency),
            ],
          ),
          const SizedBox(height: 8),
          // Start date row
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 4),
              Text(
                '${AppStrings.startedOnPrefix}${DateFormat('MMM d, yyyy').format(habit.startDate)}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StreakIndicator(
                title: AppStrings.currentStreakLabel,
                value: habit.currentStreak.toString(),
                icon: Icons.local_fire_department,
                color: AppColors.streakCurrent,
              ),
              _StreakIndicator(
                title: AppStrings.longestStreakLabel,
                value: habit.longestStreak.toString(),
                icon: Icons.emoji_events,
                color: AppColors.streakLongest,
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppButton(
            text: _getButtonText(hasStarted, isCompletedForPeriod, habit.frequency, habit.completedDates, habit.startDate),
            onPressed: (!hasStarted || isCompletedForPeriod)
                ? null
                : () {
              ref.read(habitNotifierProvider.notifier).markHabitAsCompleted(
                habit.id,
                DateTime.now(),
              );
            },
            backgroundColor: !hasStarted
                ? Colors.orange
                : (isCompletedForPeriod ? Colors.grey : AppColors.success),
            textColor: Colors.white,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

/// A chip that displays the habit frequency (daily or weekly)
/// with appropriate colors for each type
class _FrequencyChip extends StatelessWidget {
  final HabitFrequency frequency;

  const _FrequencyChip({
    required this.frequency,
  });

  @override
  Widget build(BuildContext context) {
    final isDaily = frequency == HabitFrequency.daily;

    return Chip(
      label: Text(
        isDaily ? AppStrings.dailyFrequency : AppStrings.weeklyFrequency,
      ),
      backgroundColor: isDaily
          ? AppColors.daily
          : AppColors.weekly,
      labelStyle: TextStyle(
        color: isDaily ? AppColors.dailyText : AppColors.weeklyText,
        fontWeight: FontWeight.bold,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

/// Displays a streak indicator with an icon, title, and value
/// Used for both current streak and longest streak
class _StreakIndicator extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StreakIndicator({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 4),
            Text(
              title,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}