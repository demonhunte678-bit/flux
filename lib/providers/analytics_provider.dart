import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/index.dart';

final analyticsProvider = Provider<List<Habit>>((ref) {
  final habitsAsync = ref.watch(habitsProvider);
  return habitsAsync.maybeWhen(
    data: (habits) => habits,
    orElse: () => <Habit>[],
  );
});
