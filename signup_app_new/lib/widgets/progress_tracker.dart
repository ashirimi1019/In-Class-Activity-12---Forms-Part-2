import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class ProgressTracker extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final Function(int)? onMilestoneReached;
  final List<String> milestoneMessages;

  const ProgressTracker({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onMilestoneReached,
    this.milestoneMessages = const [
      'Great start!',
      'Halfway there!',
      'Almost done!',
      'Ready for adventure!',
    ],
  });

  @override
  State<ProgressTracker> createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Track which milestones have been triggered
  final Set<int> _triggeredMilestones = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _checkMilestones();
  }

  @override
  void didUpdateWidget(ProgressTracker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _checkMilestones();
    }
  }

  void _checkMilestones() {
    final progress = widget.currentStep / widget.totalSteps;
    final milestone = (progress * 4).floor();

    // Only trigger if we haven't already triggered this milestone
    if (milestone > 0 && !_triggeredMilestones.contains(milestone)) {
      _triggeredMilestones.add(milestone);
      _celebrateMilestone(milestone);

      if (widget.onMilestoneReached != null) {
        widget.onMilestoneReached!(milestone);
      }
    }

    // Animate the progress bar
    _animationController.reset();
    _animationController.forward();
  }

  Future<void> _celebrateMilestone(int milestone) async {
    // Haptic feedback
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 100);
    }

    // Sound effect
    try {
      await _audioPlayer.play(AssetSource('sounds/ding.mp3'));
    } catch (e) {
      // Sound file not found or other error - ignore
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _getMilestoneMessage() {
    final progress = widget.currentStep / widget.totalSteps;
    final milestone = (progress * 4).floor();

    if (milestone <= 0 || milestone > widget.milestoneMessages.length) {
      return '';
    }

    return widget.milestoneMessages[milestone - 1];
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.currentStep / widget.totalSteps;
    final message = _getMilestoneMessage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress text
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Adventure Progress',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Progress bar
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: Tween<double>(
                begin: _animationController.value * progress,
                end: progress,
              ).evaluate(_animation),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            );
          },
        ),

        // Milestone message with animation
        if (message.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                message,
                key: ValueKey<String>(message),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
