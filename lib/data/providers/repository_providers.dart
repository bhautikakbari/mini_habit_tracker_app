import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/habit_repository.dart';
import '../repositories/habit_repository_impl.dart';
import 'firebase_providers.dart';
part 'repository_providers.g.dart';

@riverpod
HabitRepository habitRepository(HabitRepositoryRef ref) {
  final firestore = ref.watch(firestoreProvider);
  return HabitRepositoryImpl(firestore);
}
