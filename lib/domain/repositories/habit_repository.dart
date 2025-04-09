import '../entities/habit.dart';

/// HabitRepository defines the contract for accessing and manipulating habit data.
/// This interface abstracts the data source, allowing the app to work with
abstract class HabitRepository {
  /// This allows the UI to reactively update when data changes.
  Stream<List<Habit>> getHabits();

  /// Adds a new habit to the repository.
  /// The implementation should generate a unique ID if the habit doesn't have one.
  Future<void> addHabit(Habit habit);

  /// Marks a habit as completed for the specified date.
  /// Should update the streak counts based on the habit's frequency.
  /// If the habit is already completed for that date, it should not create duplicates.
  Future<void> markHabitAsCompleted(String id, DateTime date);
}