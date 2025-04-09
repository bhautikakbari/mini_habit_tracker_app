import 'package:freezed_annotation/freezed_annotation.dart';
import 'habit.dart';
part 'add_habit_state.freezed.dart';

@freezed
class AddHabitState with _$AddHabitState {
  const factory AddHabitState({
    required String name,
    required HabitFrequency frequency,
    required DateTime startDate,
    required bool isLoading,
  }) = _AddHabitState;

  factory AddHabitState.initial() => AddHabitState(
    name: '',
    frequency: HabitFrequency.daily,
    startDate: DateTime.now(),
    isLoading: false,
  );
}
