import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/providers/repository_providers.dart';
import '../../domain/entities/habit.dart';
part 'habit_providers.g.dart';

@riverpod
Stream<List<Habit>> habits(HabitsRef ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getHabits();
}

@riverpod
class HabitNotifier extends _$HabitNotifier {
  @override
  build() {
  }

  Future<void> addHabit(Habit habit) async {
    await ref.read(habitRepositoryProvider).addHabit(habit);
  }

  Future<void> markHabitAsCompleted(String id, DateTime date) async {
    await ref.read(habitRepositoryProvider).markHabitAsCompleted(id, date);
    ref.invalidate(habitsProvider);
  }
}
