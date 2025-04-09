import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/add_habit_state.dart';
import '../../domain/entities/habit.dart';

part 'add_habit_provider.g.dart';

@riverpod
class AddHabitFormNotifier extends _$AddHabitFormNotifier {
  @override
  AddHabitState build() {
    return AddHabitState.initial();
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateFrequency(HabitFrequency frequency) {
    state = state.copyWith(frequency: frequency);
  }

  void updateStartDate(DateTime startDate) {
    state = state.copyWith(startDate: startDate);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void resetForm() {
    state = AddHabitState.initial();
  }
}

@Riverpod(keepAlive: true)
class NameController extends _$NameController {
  @override
  TextEditingController build() {
    final controller = TextEditingController();

    ref.onDispose(() {
      controller.dispose();
    });

    return controller;
  }

  void updateText(String text) {
    state.text = text;
  }
}
