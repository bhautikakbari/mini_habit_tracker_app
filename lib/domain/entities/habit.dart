import 'package:freezed_annotation/freezed_annotation.dart';
part 'habit.freezed.dart';
part 'habit.g.dart';

enum HabitFrequency {
  daily,
  weekly,
}

@freezed
class Habit with _$Habit {
  const factory Habit({
    required String id,
    required String name,
    required HabitFrequency frequency,
    required DateTime startDate,
    required int currentStreak,
    required int longestStreak,
    required List<DateTime> completedDates,
  }) = _Habit;

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

  factory Habit.create({
    required String name,
    required HabitFrequency frequency,
    required DateTime startDate,
  }) =>
      Habit(
        id: '',
        name: name,
        frequency: frequency,
        startDate: startDate,
        currentStreak: 0,
        longestStreak: 0,
        completedDates: [],
      );
}
