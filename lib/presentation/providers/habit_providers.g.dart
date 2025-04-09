// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$habitsHash() => r'6052d45adfe49c05af4284a8bf21be9e7ffbf3de';

/// See also [habits].
@ProviderFor(habits)
final habitsProvider = AutoDisposeStreamProvider<List<Habit>>.internal(
  habits,
  name: r'habitsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$habitsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HabitsRef = AutoDisposeStreamProviderRef<List<Habit>>;
String _$habitNotifierHash() => r'3bc232f61b190a49a5522a4a71870730875be304';

/// See also [HabitNotifier].
@ProviderFor(HabitNotifier)
final habitNotifierProvider =
    AutoDisposeNotifierProvider<HabitNotifier, Object?>.internal(
      HabitNotifier.new,
      name: r'habitNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$habitNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$HabitNotifier = AutoDisposeNotifier<Object?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
