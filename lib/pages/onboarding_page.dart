import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/pages/app_shell.dart';
import 'package:flux/onboard/onboard_step.dart';
import 'package:flux/onboard/steps/welcome_step.dart';
import 'package:flux/onboard/steps/quest_step.dart';
import 'package:flux/onboard/steps/areas_step.dart';
import 'package:flux/onboard/steps/lifestyle_step.dart';
import 'package:flux/onboard/steps/preferences_step.dart';
import 'package:flux/onboard/steps/starter_pack_step.dart';
import 'package:flux/onboard/steps/reminders_step.dart';
import 'package:flux/onboard/steps/complete_step.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  final VoidCallback? onComplete;

  const OnboardingPage({super.key, this.onComplete});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();

  late final List<OnboardStep> _stepsList;
  late AnimationController _headerAnimationController;

  @override
  void initState() {
    super.initState();
    _stepsList = [
      WelcomeStep(onSkip: _skipToEnd, onNext: _nextStep),
      QuestStep(),
      AreasStep(),
      // LifestyleStep(),
      PreferencesStep(),
      StarterPackStep(),
      // RemindersStep(),
      CompleteStep(),
    ];

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    final state = ref.read(onboardingProvider);
    if (state.currentStep < _stepsList.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    final state = ref.read(onboardingProvider);
    if (state.currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToEnd() {
    _completeOnboarding();
  }

  bool _canProceed() {
    final state = ref.read(onboardingProvider);
    if (state.currentStep < _stepsList.length) {
      return _stepsList[state.currentStep].canProceed(ref);
    }
    return true;
  }

  void _completeOnboarding() async {
    final notifier = ref.read(onboardingProvider.notifier);
    await notifier.saveAndComplete();

    if (widget.onComplete != null) {
      widget.onComplete!();
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AppShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final currentColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAnimatedHeader(currentColor, state.currentStep),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Prevent swipe to bypass validation
                onPageChanged: (index) {
                  ref.read(onboardingProvider.notifier).setStep(index);
                },
                children: _stepsList
                    .map(
                      (step) => _buildStepContainer(
                        title: step.title,
                        subtitle: step.subtitle,
                        child: step.buildContent(context, ref, currentColor),
                      ),
                    )
                    .toList(),
              ),
            ),
            _buildNavigationButtons(currentColor, state.currentStep),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(Color currentColor, int currentStep) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flux Setup',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(_stepsList.length, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index <= currentStep
                          ? currentColor
                          : Theme.of(context).dividerColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              '${currentStep + 1}/${_stepsList.length} - ${_stepsList[currentStep].stepName}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContainer({
    String? title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
          ],
          if (subtitle != null) ...[
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 14,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Expanded(child: SingleChildScrollView(child: child)),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(Color currentColor, int currentStep) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          if (currentStep > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: _canProceed() ? _nextStep : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: currentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                currentStep == _stepsList.length - 1 ? 'Complete' : 'Next',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
