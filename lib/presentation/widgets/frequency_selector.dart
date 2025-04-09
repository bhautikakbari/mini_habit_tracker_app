import 'package:flutter/material.dart';
import '../../domain/entities/habit.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import 'app_card.dart';

class FrequencySelector extends StatelessWidget {
  final HabitFrequency selectedFrequency;
  final Function(HabitFrequency) onFrequencyChanged;

  const FrequencySelector({
    super.key,
    required this.selectedFrequency,
    required this.onFrequencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.frequencyLabel,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          RadioListTile<HabitFrequency>(
            title: const Text(AppStrings.dailyFrequency),
            value: HabitFrequency.daily,
            groupValue: selectedFrequency,
            activeColor: AppColors.primary,
            onChanged: (value) {
              if (value != null) {
                onFrequencyChanged(value);
              }
            },
          ),
          RadioListTile<HabitFrequency>(
            title: const Text(AppStrings.weeklyFrequency),
            value: HabitFrequency.weekly,
            groupValue: selectedFrequency,
            activeColor: AppColors.primary,
            onChanged: (value) {
              if (value != null) {
                onFrequencyChanged(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
