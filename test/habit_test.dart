import 'package:flutter_test/flutter_test.dart';
import 'package:flux/data/models/habit.dart';
import 'package:flux/data/models/habit_entry.dart';
import 'package:flux/index.dart';

void main() {
  group('Habit Model Tests', () {
    // Helper to create dates (weekday: 1 = Monday, 7 = Sunday)
    DateTime getSpecificWeekday(int weekday) {
      final now = DateTime.now();
      final diff = weekday - now.weekday;
      return now.add(Duration(days: diff));
    }

    group('Schedule Logic - isDueOnDate', () {
      test('Daily frequency is always due', () {
        final habit = Habit(
          name: 'Daily Test',
          frequency: HabitFrequency.Daily,
        );

        for (int d = 1; d <= 7; d++) {
          final date = getSpecificWeekday(d);
          expect(habit.isDueOnDate(date), isTrue);
        }
      });

      test('Weekdays frequency - Saturday & Sunday Weekend (Default)', () {
        final habit = Habit(
          name: 'Weekdays Default',
          frequency: HabitFrequency.Weekdays,
          weekendDays: 'Saturday & Sunday',
        );

        // Monday to Friday
        for (int d = 1; d <= 5; d++) {
          expect(habit.isDueOnDate(getSpecificWeekday(d)), isTrue);
        }
        // Saturday and Sunday
        for (int d = 6; d <= 7; d++) {
          expect(habit.isDueOnDate(getSpecificWeekday(d)), isFalse);
        }
      });

      test('Weekdays frequency - Friday & Saturday Weekend', () {
        final habit = Habit(
          name: 'Weekdays Fri-Sat',
          frequency: HabitFrequency.Weekdays,
          weekendDays: 'Friday & Saturday',
        );

        // Sun-Thu are weekdays (due)
        expect(habit.isDueOnDate(getSpecificWeekday(7)), isTrue); // Sunday
        for (int d = 1; d <= 4; d++) {
          expect(habit.isDueOnDate(getSpecificWeekday(d)), isTrue); // Mon-Thu
        }
        // Fri-Sat are weekends (not due)
        expect(habit.isDueOnDate(getSpecificWeekday(5)), isFalse); // Friday
        expect(habit.isDueOnDate(getSpecificWeekday(6)), isFalse); // Saturday
      });

      test('Weekdays frequency - Thursday & Friday Weekend', () {
        final habit = Habit(
          name: 'Weekdays Thu-Fri',
          frequency: HabitFrequency.Weekdays,
          weekendDays: 'Thursday & Friday',
        );

        // Sat-Wed are weekdays (due)
        expect(habit.isDueOnDate(getSpecificWeekday(6)), isTrue); // Saturday
        expect(habit.isDueOnDate(getSpecificWeekday(7)), isTrue); // Sunday
        for (int d = 1; d <= 3; d++) {
          expect(habit.isDueOnDate(getSpecificWeekday(d)), isTrue); // Mon-Wed
        }
        // Thu-Fri are weekends (not due)
        expect(habit.isDueOnDate(getSpecificWeekday(4)), isFalse); // Thursday
        expect(habit.isDueOnDate(getSpecificWeekday(5)), isFalse); // Friday
      });

      test('Weekends frequency - Saturday & Sunday Weekend (Default)', () {
        final habit = Habit(
          name: 'Weekends Default',
          frequency: HabitFrequency.Weekends,
          weekendDays: 'Saturday & Sunday',
        );

        // Mon-Fri (not due)
        for (int d = 1; d <= 5; d++) {
          expect(habit.isDueOnDate(getSpecificWeekday(d)), isFalse);
        }
        // Sat-Sun (due)
        for (int d = 6; d <= 7; d++) {
          expect(habit.isDueOnDate(getSpecificWeekday(d)), isTrue);
        }
      });

      test('Weekends frequency - Friday & Saturday Weekend', () {
        final habit = Habit(
          name: 'Weekends Fri-Sat',
          frequency: HabitFrequency.Weekends,
          weekendDays: 'Friday & Saturday',
        );

        // Sun-Thu (not due)
        expect(habit.isDueOnDate(getSpecificWeekday(7)), isFalse);
        for (int d = 1; d <= 4; d++) {
          expect(habit.isDueOnDate(getSpecificWeekday(d)), isFalse);
        }
        // Fri-Sat (due)
        expect(habit.isDueOnDate(getSpecificWeekday(5)), isTrue);
        expect(habit.isDueOnDate(getSpecificWeekday(6)), isTrue);
      });

      test('CustomDays frequency - Specific Days chosen', () {
        final habit = Habit(
          name: 'Custom Days Test',
          frequency: HabitFrequency.CustomDays,
          customDays: [1, 3, 5], // Mon, Wed, Fri
        );

        expect(habit.isDueOnDate(getSpecificWeekday(1)), isTrue); // Monday
        expect(habit.isDueOnDate(getSpecificWeekday(2)), isFalse); // Tuesday
        expect(habit.isDueOnDate(getSpecificWeekday(3)), isTrue); // Wednesday
        expect(habit.isDueOnDate(getSpecificWeekday(4)), isFalse); // Thursday
        expect(habit.isDueOnDate(getSpecificWeekday(5)), isTrue); // Friday
        expect(habit.isDueOnDate(getSpecificWeekday(6)), isFalse); // Saturday
        expect(habit.isDueOnDate(getSpecificWeekday(7)), isFalse); // Sunday
      });
    });

    group('Evaluation Logic - isPositiveDay', () {
      test('Avoid Habit (FailBased)', () {
        final habit = Habit(
          name: 'Avoid Smoking',
          type: HabitType.FailBased,
          targetValue: 0, // 0 failures allowed
        );

        final positiveEntry = HabitEntry(date: DateTime.now(), value: 0.0);
        final negativeEntry = HabitEntry(date: DateTime.now(), value: 1.0);

        expect(habit.isPositiveDay(positiveEntry), isTrue);
        expect(habit.isPositiveDay(negativeEntry), isFalse);
      });

      test('Avoid Habit (FailBased) with limit > 0', () {
        final habit = Habit(
          name: 'Avoid Caffeine Coffee limit',
          type: HabitType.FailBased,
          targetValue: 2, // Up to 2 failures allowed
        );

        expect(habit.isPositiveDay(HabitEntry(date: DateTime.now(), value: 1.0)), isTrue);
        expect(habit.isPositiveDay(HabitEntry(date: DateTime.now(), value: 2.0)), isTrue);
        expect(habit.isPositiveDay(HabitEntry(date: DateTime.now(), value: 3.0)), isFalse);
      });

      test('Achieve Habit (SuccessBased)', () {
        final habit = Habit(
          name: 'Read Pages',
          type: HabitType.SuccessBased,
          targetValue: 10,
        );

        final positiveEntry = HabitEntry(date: DateTime.now(), value: 10.0);
        final negativeEntry = HabitEntry(date: DateTime.now(), value: 5.0);

        expect(habit.isPositiveDay(positiveEntry), isTrue);
        expect(habit.isPositiveDay(negativeEntry), isFalse);
      });

      test('Check Habit (DoneBased)', () {
        final habit = Habit(
          name: 'Drink Water',
          type: HabitType.DoneBased,
        );

        final positiveEntry = HabitEntry(date: DateTime.now(), value: 1.0);
        final negativeEntry = HabitEntry(date: DateTime.now(), value: 0.0);

        expect(habit.isPositiveDay(positiveEntry), isTrue);
        expect(habit.isPositiveDay(negativeEntry), isFalse);
      });
    });

    group('Success Rate & Penalization', () {
      test('Empty entries returns 0 success rate', () {
        final habit = Habit(name: 'Empty Habit');
        expect(habit.successRate, 0.0);
      });

      test('Skipped entry counts as full success point', () {
        final habit = Habit(
          name: 'Skipped Habit Test',
          type: HabitType.SuccessBased,
          targetValue: 10,
          entries: [
            HabitEntry(date: DateTime.now(), value: 5.0, isSkipped: true),
          ],
        );

        expect(habit.successRate, 100.0);
      });

      test('Avoid habit success rate with penalty logic', () {
        // Limit of 2 failures
        final habit = Habit(
          name: 'Smoking Limit',
          type: HabitType.FailBased,
          targetValue: 2,
        );

        // Day 1: 2 failures (limit met, score 1.0)
        // Day 2: 3 failures (1 excess, penalty -0.25, score -0.25)
        // Day 3: 4 failures (2 excess, penalty -0.50, score -0.50)
        // Day 4: 8 failures (6 excess, penalty -1.50 -> clamped to -1.0, score -1.0)
        habit.entries = [
          HabitEntry(date: DateTime.now().subtract(const Duration(days: 3)), value: 2.0),
          HabitEntry(date: DateTime.now().subtract(const Duration(days: 2)), value: 3.0),
          HabitEntry(date: DateTime.now().subtract(const Duration(days: 1)), value: 4.0),
          HabitEntry(date: DateTime.now(), value: 8.0),
        ];

        // totalPoints = 1.0 + (-0.25) + (-0.50) + (-1.0) = -0.75
        // Clamped successRate = raw success rate of -0.75 / 4 = -18.75% -> clamped to 0.0%
        expect(habit.successRate, 0.0);

        // Test with positive rate: Day 1 (1.0) + Day 2 (-0.25) = 0.75 points
        // successRate = (0.75 / 2) * 100 = 37.5%
        final positiveHabit = Habit(
          name: 'Sweets Limit',
          type: HabitType.FailBased,
          targetValue: 1,
          entries: [
            HabitEntry(date: DateTime.now().subtract(const Duration(days: 1)), value: 1.0),
            HabitEntry(date: DateTime.now(), value: 2.0),
          ],
        );
        expect(positiveHabit.successRate, 37.5);
      });
    });

    group('Streaks - currentStreak and bestStreak', () {
      test('Streak calculation chronologically sorts entries', () {
        final habit = Habit(
          name: 'Daily Running',
          frequency: HabitFrequency.Daily,
          type: HabitType.DoneBased,
          targetValue: 1,
        );

        // Entries out of chronological order
        habit.entries = [
          HabitEntry(date: DateTime.now(), value: 1.0), // Today (positive)
          HabitEntry(date: DateTime.now().subtract(const Duration(days: 2)), value: 1.0), // 2 days ago (positive)
          HabitEntry(date: DateTime.now().subtract(const Duration(days: 1)), value: 0.0), // Yesterday (negative)
        ];

        // Should sort to: Today (pos), Yesterday (neg), 2 days ago (pos)
        // Current streak should stop at yesterday (neg) -> currentStreak = 1
        expect(habit.currentStreak, 1);
        // Best streak overall is 1
        expect(habit.bestStreak, 1);
      });

      test('Consecutive positive days build streak', () {
        final habit = Habit(
          name: 'Reading Books',
          frequency: HabitFrequency.Daily,
          type: HabitType.DoneBased,
          targetValue: 1,
          entries: [
            HabitEntry(date: DateTime.now().subtract(const Duration(days: 2)), value: 1.0),
            HabitEntry(date: DateTime.now().subtract(const Duration(days: 1)), value: 1.0),
            HabitEntry(date: DateTime.now(), value: 1.0),
          ],
        );

        expect(habit.currentStreak, 3);
        expect(habit.bestStreak, 3);
      });
    });
  });
}
