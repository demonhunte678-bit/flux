import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flux/providers/index.dart';
import 'package:flux/pages/app_shell.dart';
import 'package:flux/onboard/onboard_step.dart';
import 'package:flux/onboard/steps/welcome_step.dart';
import 'package:flux/onboard/steps/quest_step.dart';
import 'package:flux/onboard/steps/areas_step.dart';
import 'package:flux/onboard/steps/goals_step.dart';
import 'package:flux/onboard/steps/lifestyle_step.dart';
import 'package:flux/onboard/steps/preferences_step.dart';
import 'package:flux/onboard/steps/starter_pack_step.dart';
import 'package:flux/onboard/steps/reminders_step.dart';
import 'package:flux/onboard/steps/theme_step.dart';
import 'package:flux/onboard/steps/complete_step.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  final Function(String?)? onComplete;

  const OnboardingPage({super.key, this.onComplete});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();

  late final List<OnboardStep> _stepsList;
  late AnimationController _headerAnimationController;
  late Animation<Color?> _headerColorAnimation;

  final List<Color> _stepColors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.pink,
    Colors.indigo,
    Colors.cyan,
    Colors.deepPurple,
  ];

  @override
  void initState() {
    super.initState();
    _stepsList = [
      WelcomeStep(onSkip: _skipToEnd, onNext: _nextStep),
      QuestStep(),
      AreasStep(),
      GoalsStep(),
      LifestyleStep(),
      PreferencesStep(),
      StarterPackStep(),
      RemindersStep(),
      ThemeStep(),
      CompleteStep(),
    ];

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _headerColorAnimation = ColorTween(
      begin: _stepColors[0],
      end: _stepColors[0],
    ).animate(_headerAnimationController);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  void _animateHeaderColor() {
    final state = ref.read(onboardingProvider);
    final previousColor = _headerColorAnimation.value ?? _stepColors[0];
    final nextColor = _stepColors[state.currentStep];

    _headerColorAnimation = ColorTween(
      begin: previousColor,
      end: nextColor,
    ).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _headerAnimationController.forward(from: 0.0);
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AppShell(),
      ),
    );
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

    final state = ref.read(onboardingProvider);
    if (widget.onComplete != null) {
      widget.onComplete!(state.selectedTheme?.value);
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AppShell()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final currentColor = _headerColorAnimation.value ?? _stepColors[state.currentStep];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAnimatedHeader(currentColor, state.currentStep),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Prevent swipe to bypass validation
                onPageChanged: (index) {
                  ref.read(onboardingProvider.notifier).setStep(index);
                  _animateHeaderColor();
                },
                children: _stepsList
                    .map((step) => _buildStepContainer(
                          title: step.title,
                          subtitle: step.subtitle,
                          child: step.buildContent(
                            context,
                            ref,
                            _stepColors[state.currentStep],
                          ),
                        ))
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
    return AnimatedBuilder(
      animation: _headerAnimationController,
      builder: (context, child) {
        final animatedColor = _headerColorAnimation.value ?? currentColor;
        return Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                animatedColor,
                animatedColor.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: animatedColor.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Flux Setup',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: List.generate(_stepsList.length, (index) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: index <= currentStep
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.3),
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
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (subtitle != null) ...[
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
          ],
          Expanded(child: SingleChildScrollView(child: child)),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(Color currentColor, int currentStep) {
    // Hide navigation buttons on the Welcome step (it has custom buttons)
    if (currentStep == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: ElevatedButton(
                onPressed: _previousStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  elevation: 0,
                ),
                child: const Text('Back'),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _canProceed() ? _nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: currentColor,
                foregroundColor: Colors.white,
              ),
              child: Text(
                currentStep == _stepsList.length - 1 ? 'Complete' : 'Next',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
