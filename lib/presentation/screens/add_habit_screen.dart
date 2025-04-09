import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_strings.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../../domain/entities/habit.dart';
import '../providers/habit_providers.dart';
import '../widgets/date_selector.dart';
import '../widgets/frequency_selector.dart';

class AddHabitFormState {
  final String name;
  final HabitFrequency frequency;
  final DateTime startDate;

  const AddHabitFormState({
    required this.name,
    required this.frequency,
    required this.startDate,
  });

  // Daily frequency makes sense as a default and we start with today's date
  factory AddHabitFormState.initial() {
    return AddHabitFormState(
      name: '',
      frequency: HabitFrequency.daily,
      startDate: DateTime.now(),
    );
  }

  // This lets us update just one field at a time
  // Really handy when the user changes just one part of the form
  AddHabitFormState copyWith({
    String? name,
    HabitFrequency? frequency,
    DateTime? startDate,
  }) {
    return AddHabitFormState(
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
    );
  }
}

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  // Key for form validation
  final _formKey = GlobalKey<FormState>();
  // Controller for the text field
  final _nameController = TextEditingController();
  // Track if we're currently saving
  bool _isLoading = false;
  // Track if save was successful
  bool _isSuccess = false;

  // Start with default values for our form
  late AddHabitFormState _formState = AddHabitFormState.initial();

  @override
  void initState() {
    super.initState();
    // Update the form state whenever the user types in the name field
    _nameController.addListener(() {
      if (mounted) {
        setState(() {
          _formState = _formState.copyWith(name: _nameController.text);
        });
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller to avoid memory leaks
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addHabitTitle),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppTextField(
              controller: _nameController,
              label: AppStrings.habitNameLabel,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppStrings.habitNameValidationError;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            FrequencySelector(
              selectedFrequency: _formState.frequency,
              onFrequencyChanged: (frequency) {
                setState(() {
                  _formState = _formState.copyWith(frequency: frequency);
                });
              },
            ),
            const SizedBox(height: 16),
            DateSelector(
              selectedDate: _formState.startDate,
              onDateChanged: (date) {
                setState(() {
                  _formState = _formState.copyWith(startDate: date);
                });
              },
            ),
            const SizedBox(height: 24),
            Consumer(
                builder: (context, ref, child) {
                  return AppButton(
                    text: AppStrings.createHabitButton,
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : () => _saveHabit(ref),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }

  void _saveHabit(WidgetRef ref) {
    // Don't do anything if the form isn't valid or we're already processing
    if (!_formKey.currentState!.validate() || _isLoading || _isSuccess) {
      return;
    }
    // Show loading spinner
    setState(() {
      _isLoading = true;
    });

    final habit = Habit.create(
      name: _formState.name.trim(),
      frequency: _formState.frequency,
      startDate: _formState.startDate,
    );

    // This flag helps prevent multiple callbacks from running
    // (like if the timeout and the error both try to show messages)
    bool isHandled = false;

    // Helper function to handle completion (success or error)
    void handleCompletion(bool success, [String? errorMessage]) {
      if (isHandled || !mounted) return;
      isHandled = true;

      setState(() {
        _isLoading = false;
        _isSuccess = success;
      });

      if (success) {
        Navigator.of(context).pop();
      } else if (errorMessage != null) {
        // Show an error message if something went wrong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.errorPrefix}$errorMessage')),
        );
      }
    }

    // Try to save the habit with error handling
    try {
      // Set a timeout so we don't leave the user hanging forever
      Future.delayed(const Duration(seconds: 10), () {
        if (!isHandled && mounted) {
          handleCompletion(false, AppStrings.operationTimeout);
        }
      });

      // Actually save the habit
      ref.read(habitNotifierProvider.notifier).addHabit(habit).then((_) {
        handleCompletion(true);
      }).catchError((error) {
        handleCompletion(false, error.toString());
      });
    } catch (e) {
      handleCompletion(false, e.toString());
    }
  }
}