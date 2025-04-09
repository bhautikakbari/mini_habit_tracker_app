# Flutter Habit Tracker

A modern habit tracking application built with Flutter, Firebase, and Riverpod, designed to help users build and maintain habits by tracking their daily and weekly activities.

## Features

- **Habit Creation**: Create habits with customizable names and start dates
- **Multiple Frequencies**: Support for both daily and weekly habits
- **Streak Tracking**: Track current and longest streaks for each habit
- **Smart Completion Logic**:
    - Daily habits reset every day
    - Weekly habits use a rolling 7-day period
- **Future Start Dates**: Support for habits that start in the future
- **Real-time Updates**: Firebase integration for real-time data synchronization
- **Pull-to-Refresh**: Easy data refreshing with pull gesture

## Architecture

The application follows **Clean Architecture** principles with a clear separation of concerns:

### Layers

1. **Domain Layer**: Contains business logic and entities
    - Entities (Habit)
    - Repository interfaces

2. **Data Layer**: Handles data operations
    - Repository implementations
    - Providers

3. **Presentation Layer**: Manages UI and user interactions
    - Screens
    - Widgets
    - State management (Riverpod)

## Technologies Used

- **Flutter**: UI framework (latest stable version)
- **Firebase Firestore**: Real-time NoSQL database
- **Riverpod**: State management
- **Go Router**: Navigation
- **Freezed**: Immutable models
- **Intl**: Internationalization and date formatting
- **Shared Preferences**: Local storage for theme preferences

## Project Structure

```plaintext
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   ├── theme/
│   │   ├── app_theme.dart
├── data/
│   ├── providers/
│   │   ├── firebase_providers.dart
│   │   ├── repository_providers.dart
│   ├── repositories/
│   │   ├── habit_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── habit.dart
│   │   ├── add_habit_state.dart
│   ├── repositories/
│   │   ├── habit_repository.dart
├── presentation/
│   ├── app_router.dart
│   ├── providers/
│   │   ├── habit_providers.dart
│   │   ├── add_habit_provider.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── add_habit_screen.dart
│   ├── widgets/
│   │   ├── app_button.dart
│   │   ├── app_card.dart
│   │   ├── app_text.dart
│   │   ├── app_text_field.dart
│   │   ├── date_selector.dart
│   │   ├── frequency_selector.dart
│   │   ├── habit_card.dart
├── firebase_options.dart
├── main.dart

```

Reusable widgets for consistent UI:
- `AppButton`: Customizable button with loading state
- `AppCard`: Styled card container
- `AppText`: Text
- `AppTextField`: Text input with validation
- `FrequencySelector`: Radio buttons for frequency selection
- `DateSelector`: Date picker with formatting
- `HabitCard`: Comprehensive habit display with completion status
