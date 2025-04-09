import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final FirebaseFirestore _firestore;

  HabitRepositoryImpl(this._firestore);

  @override
  Stream<List<Habit>> getHabits() {
    return _firestore.collection('habits').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        // Handle Firestore timestamp vs string date formats
        // This ensures our app works even if the data format changes
        DateTime startDate;
        if (data['startDate'] is Timestamp) {
          startDate = (data['startDate'] as Timestamp).toDate();
        } else {
          // Handle the case where startDate might be stored as a string
          try {
            startDate = DateTime.parse(data['startDate'] as String);
          } catch (e) {
            // Fallback to current date if parsing fails
            startDate = DateTime.now();
          }
        }

        // Safely convert completedDates
        List<DateTime> completedDates = [];
        if (data['completedDates'] != null) {
          if (data['completedDates'] is List) {
            completedDates = (data['completedDates'] as List).map((date) {
              if (date is Timestamp) {
                return date.toDate();
              } else if (date is String) {
                try {
                  return DateTime.parse(date);
                } catch (e) {
                  // Skip invalid dates
                  return null;
                }
              }
              return null;
            }).whereType<DateTime>().toList();
          }
        }

        // Convert frequency string to enum
        HabitFrequency frequency;
        try {
          frequency = HabitFrequency.values.firstWhere(
                (e) => e.toString().split('.').last == data['frequency'],
            orElse: () => HabitFrequency.daily,
          );
        } catch (e) {
          frequency = HabitFrequency.daily;
        }

        return Habit(
          id: doc.id,
          name: data['name'] as String? ?? 'Unnamed Habit',
          frequency: frequency,
          startDate: startDate,
          currentStreak: (data['currentStreak'] as num?)?.toInt() ?? 0,
          longestStreak: (data['longestStreak'] as num?)?.toInt() ?? 0,
          completedDates: completedDates,
        );
      }).toList();
    });
  }

  @override
  Future<void> addHabit(Habit habit) async {
    final docRef = await _firestore.collection('habits').add({
      'name': habit.name,
      'frequency': habit.frequency.toString().split('.').last,
      'startDate': Timestamp.fromDate(habit.startDate),
      'currentStreak': habit.currentStreak,
      'longestStreak': habit.longestStreak,
      'completedDates': habit.completedDates
          .map((date) => Timestamp.fromDate(date))
          .toList(),
    });

    // We need to update the document with its ID so we can reference it later
    await docRef.update({'id': docRef.id});
  }

  @override
  Future<void> markHabitAsCompleted(String id, DateTime date) async {
    final docSnapshot = await _firestore.collection('habits').doc(id).get();
    if (!docSnapshot.exists) {
      throw Exception('Habit not found');
    }

    final data = docSnapshot.data()!;

    List<DateTime> completedDates = [];
    if (data['completedDates'] != null) {
      if (data['completedDates'] is List) {
        completedDates = (data['completedDates'] as List).map((date) {
          if (date is Timestamp) {
            return date.toDate();
          } else if (date is String) {
            try {
              return DateTime.parse(date);
            } catch (e) {
              return null;
            }
          }
          return null;
        }).whereType<DateTime>().toList();
      }
    }

    HabitFrequency frequency;
    try {
      frequency = HabitFrequency.values.firstWhere(
            (e) => e.toString().split('.').last == data['frequency'],
        orElse: () => HabitFrequency.daily,
      );
    } catch (e) {
      frequency = HabitFrequency.daily;
    }

    // Normalize to start of day to avoid time-of-day issues when comparing dates
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Check if this date is already completed to avoid duplicates
    bool alreadyCompleted = false;
    for (final completedDate in completedDates) {
      final normalizedCompletedDate = DateTime(
          completedDate.year,
          completedDate.month,
          completedDate.day
      );
      if (normalizedCompletedDate.isAtSameMomentAs(normalizedDate)) {
        alreadyCompleted = true;
        break;
      }
    }

    // Only add the date if it's not already completed
    if (!alreadyCompleted) {
      completedDates.add(date);
    }

    // Calculate the updated streak based on the new completion
    final updatedStreak = _calculateStreak(frequency, completedDates);

    // Update longest streak if current streak is longer
    final currentLongestStreak = (data['longestStreak'] as num?)?.toInt() ?? 0;
    final newLongestStreak = updatedStreak > currentLongestStreak
        ? updatedStreak
        : currentLongestStreak;

    // Update the habit in Firestore
    await _firestore.collection('habits').doc(id).update({
      'completedDates': completedDates
          .map((date) => Timestamp.fromDate(date))
          .toList(),
      'currentStreak': updatedStreak,
      'longestStreak': newLongestStreak,
    });
  }

  // Main streak calculation logic that handles both daily and weekly habits
  int _calculateStreak(HabitFrequency frequency, List<DateTime> completedDates) {
    if (completedDates.isEmpty) return 0;

    // Step 1: Normalize dates to start of day and create a set of unique dates
    // This prevents duplicate dates from affecting the streak calculation
    final Set<String> uniqueDateStrings = {};
    final Map<String, DateTime> dateMap = {};

    for (final date in completedDates) {
      final normalized = DateTime(date.year, date.month, date.day);
      final dateString = '${normalized.year}-${normalized.month.toString().padLeft(2, '0')}-${normalized.day.toString().padLeft(2, '0')}';
      uniqueDateStrings.add(dateString);
      dateMap[dateString] = normalized;
    }

    // Step 2: Convert to list and sort in descending order (newest first)
    // This allows us to start from the most recent date and work backwards
    final List<String> sortedDateStrings = uniqueDateStrings.toList()..sort((a, b) => b.compareTo(a));
    final List<DateTime> sortedDates = sortedDateStrings.map((ds) => dateMap[ds]!).toList();

    // Step 3: Calculate streak based on frequency
    if (frequency == HabitFrequency.daily) {
      // For daily habits
      return _calculateDailyStreak(sortedDates);
    } else {
      // For weekly habits
      return _calculateWeeklyStreak(sortedDates);
    }
  }

  // Helper method to calculate streak for daily habits
  int _calculateDailyStreak(List<DateTime> sortedDates) {
    if (sortedDates.isEmpty) return 0;

    int streak = 1; // Start with 1 for the first date
    DateTime expectedPrevDate = sortedDates[0];

    // Debug print
    print('Starting daily streak calculation with ${sortedDates.length} dates');
    print('First date: ${sortedDates[0]}');

    // Check for consecutive days by walking backwards through the dates
    for (int i = 1; i < sortedDates.length; i++) {
      final currentDate = sortedDates[i];
      final expectedDate = expectedPrevDate.subtract(const Duration(days: 1));

      // Debug print
      print('Checking date $i: $currentDate, Expected: $expectedDate');

      if (currentDate.year == expectedDate.year &&
          currentDate.month == expectedDate.month &&
          currentDate.day == expectedDate.day) {
        // This is the expected previous day
        streak++;
        expectedPrevDate = currentDate;
        print('Streak increased to $streak');
      } else if (currentDate.isBefore(expectedDate)) {
        // This date is older than expected, skip it
        // This can happen if there are gaps in the streak but older completed dates
        print('Date is older than expected, skipping');
        continue;
      } else {
        // There's a gap, break the streak
        print('Gap detected, breaking streak');
        break;
      }
    }

    print('Final daily streak: $streak');
    return streak;
  }

  // Helper method to calculate streak for weekly habits
  int _calculateWeeklyStreak(List<DateTime> sortedDates) {
    if (sortedDates.isEmpty) return 0;

    // Group dates by week to handle multiple completions in the same week
    final Map<int, List<DateTime>> datesByWeek = {};

    for (final date in sortedDates) {
      final weekKey = _getWeekKey(date);
      if (!datesByWeek.containsKey(weekKey)) {
        datesByWeek[weekKey] = [];
      }
      datesByWeek[weekKey]!.add(date);
    }

    // Sort weeks in descending order (newest first)
    final List<int> sortedWeeks = datesByWeek.keys.toList()..sort((a, b) => b.compareTo(a));

    if (sortedWeeks.isEmpty) return 0;

    int streak = 1; // Start with 1 for the first week
    int expectedPrevWeek = sortedWeeks[0];

    // Debug print
    print('Starting weekly streak calculation with ${sortedWeeks.length} weeks');
    print('First week: $expectedPrevWeek');

    // Check for consecutive weeks
    for (int i = 1; i < sortedWeeks.length; i++) {
      final currentWeek = sortedWeeks[i];
      final expectedWeek = expectedPrevWeek - 1;

      // Debug print
      print('Checking week $i: $currentWeek, Expected: $expectedWeek');

      if (currentWeek == expectedWeek) {
        // This is the expected previous week
        streak++;
        expectedPrevWeek = currentWeek;
        print('Streak increased to $streak');
      } else {
        // There's a gap, break the streak
        print('Gap detected, breaking streak');
        break;
      }
    }

    print('Final weekly streak: $streak');
    return streak;
  }

  // Helper method to get a unique week identifier (year * 100 + week number)
  // This creates a sortable integer key that uniquely identifies each week
  int _getWeekKey(DateTime date) {
    // Get the first day of the year
    final firstDayOfYear = DateTime(date.year, 1, 1);

    // Calculate the offset to get the first day of the week
    int dayOffset = firstDayOfYear.weekday - 1;

    // Calculate the week number
    int weekNumber = ((date.difference(firstDayOfYear).inDays + dayOffset) / 7).floor();

    // Return a unique key for this week (year * 100 + week number)
    return date.year * 100 + weekNumber;
  }
}