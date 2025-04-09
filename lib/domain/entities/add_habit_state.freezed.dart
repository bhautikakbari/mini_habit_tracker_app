// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_habit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AddHabitState {
  String get name => throw _privateConstructorUsedError;
  HabitFrequency get frequency => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of AddHabitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddHabitStateCopyWith<AddHabitState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddHabitStateCopyWith<$Res> {
  factory $AddHabitStateCopyWith(
    AddHabitState value,
    $Res Function(AddHabitState) then,
  ) = _$AddHabitStateCopyWithImpl<$Res, AddHabitState>;
  @useResult
  $Res call({
    String name,
    HabitFrequency frequency,
    DateTime startDate,
    bool isLoading,
  });
}

/// @nodoc
class _$AddHabitStateCopyWithImpl<$Res, $Val extends AddHabitState>
    implements $AddHabitStateCopyWith<$Res> {
  _$AddHabitStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddHabitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? frequency = null,
    Object? startDate = null,
    Object? isLoading = null,
  }) {
    return _then(
      _value.copyWith(
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            frequency:
                null == frequency
                    ? _value.frequency
                    : frequency // ignore: cast_nullable_to_non_nullable
                        as HabitFrequency,
            startDate:
                null == startDate
                    ? _value.startDate
                    : startDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddHabitStateImplCopyWith<$Res>
    implements $AddHabitStateCopyWith<$Res> {
  factory _$$AddHabitStateImplCopyWith(
    _$AddHabitStateImpl value,
    $Res Function(_$AddHabitStateImpl) then,
  ) = __$$AddHabitStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    HabitFrequency frequency,
    DateTime startDate,
    bool isLoading,
  });
}

/// @nodoc
class __$$AddHabitStateImplCopyWithImpl<$Res>
    extends _$AddHabitStateCopyWithImpl<$Res, _$AddHabitStateImpl>
    implements _$$AddHabitStateImplCopyWith<$Res> {
  __$$AddHabitStateImplCopyWithImpl(
    _$AddHabitStateImpl _value,
    $Res Function(_$AddHabitStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddHabitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? frequency = null,
    Object? startDate = null,
    Object? isLoading = null,
  }) {
    return _then(
      _$AddHabitStateImpl(
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        frequency:
            null == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                    as HabitFrequency,
        startDate:
            null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$AddHabitStateImpl implements _AddHabitState {
  const _$AddHabitStateImpl({
    required this.name,
    required this.frequency,
    required this.startDate,
    required this.isLoading,
  });

  @override
  final String name;
  @override
  final HabitFrequency frequency;
  @override
  final DateTime startDate;
  @override
  final bool isLoading;

  @override
  String toString() {
    return 'AddHabitState(name: $name, frequency: $frequency, startDate: $startDate, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddHabitStateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, name, frequency, startDate, isLoading);

  /// Create a copy of AddHabitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddHabitStateImplCopyWith<_$AddHabitStateImpl> get copyWith =>
      __$$AddHabitStateImplCopyWithImpl<_$AddHabitStateImpl>(this, _$identity);
}

abstract class _AddHabitState implements AddHabitState {
  const factory _AddHabitState({
    required final String name,
    required final HabitFrequency frequency,
    required final DateTime startDate,
    required final bool isLoading,
  }) = _$AddHabitStateImpl;

  @override
  String get name;
  @override
  HabitFrequency get frequency;
  @override
  DateTime get startDate;
  @override
  bool get isLoading;

  /// Create a copy of AddHabitState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddHabitStateImplCopyWith<_$AddHabitStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
