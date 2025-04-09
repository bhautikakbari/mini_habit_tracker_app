// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_habit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addHabitFormNotifierHash() =>
    r'e1b831faa200c8e614c470ff28cd3ae98097f4a1';

/// See also [AddHabitFormNotifier].
@ProviderFor(AddHabitFormNotifier)
final addHabitFormNotifierProvider =
    AutoDisposeNotifierProvider<AddHabitFormNotifier, AddHabitState>.internal(
      AddHabitFormNotifier.new,
      name: r'addHabitFormNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$addHabitFormNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AddHabitFormNotifier = AutoDisposeNotifier<AddHabitState>;
String _$nameControllerHash() => r'71200c4768f953aa80087d50ae2d48ae94a986a6';

/// See also [NameController].
@ProviderFor(NameController)
final nameControllerProvider =
    NotifierProvider<NameController, TextEditingController>.internal(
      NameController.new,
      name: r'nameControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$nameControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NameController = Notifier<TextEditingController>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
