// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HabitImpl _$$HabitImplFromJson(Map<String, dynamic> json) => _$HabitImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  frequency: $enumDecode(_$HabitFrequencyEnumMap, json['frequency']),
  startDate: DateTime.parse(json['startDate'] as String),
  currentStreak: (json['currentStreak'] as num).toInt(),
  longestStreak: (json['longestStreak'] as num).toInt(),
  completedDates:
      (json['completedDates'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList(),
);

Map<String, dynamic> _$$HabitImplToJson(_$HabitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'frequency': _$HabitFrequencyEnumMap[instance.frequency]!,
      'startDate': instance.startDate.toIso8601String(),
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'completedDates':
          instance.completedDates.map((e) => e.toIso8601String()).toList(),
    };

const _$HabitFrequencyEnumMap = {
  HabitFrequency.daily: 'daily',
  HabitFrequency.weekly: 'weekly',
};
