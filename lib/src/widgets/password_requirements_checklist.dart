import 'package:flutter/material.dart';
import 'package:password_checker_pro/password_checker_pro.dart';

/// Interactive password requirements checklist with progress tracking.
class PasswordRequirementsChecklist extends StatefulWidget {
  final PasswordValidationResult result;
  final ValidationRules rules;
  final bool showProgress;
  final bool animated;
  final EdgeInsets padding;

  const PasswordRequirementsChecklist({
    super.key,
    required this.result,
    required this.rules,
    this.showProgress = true,
    this.animated = true,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
  });

  @override
  State<PasswordRequirementsChecklist> createState() => _PasswordRequirementsChecklistState();
}

class _PasswordRequirementsChecklistState extends State<PasswordRequirementsChecklist>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: _calculateProgress(),
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.animated) {
      _progressController.forward();
    }
  }

  @override
  void didUpdateWidget(PasswordRequirementsChecklist oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.result.checks != oldWidget.result.checks) {
      _updateProgress();
    }
  }

  void _updateProgress() {
    _progressAnimation = Tween<double>(
      begin: _progressAnimation.value,
      end: _calculateProgress(),
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.animated) {
      _progressController.reset();
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  double _calculateProgress() {
    final checks = widget.result.checks;
    int passedChecks = 0;
    int totalChecks = 0;

    // Count relevant checks
    if (widget.rules.minLength > 0) {
      totalChecks++;
      if (checks['minLength'] == true) passedChecks++;
    }
    if (widget.rules.maxLength < 128) {
      totalChecks++;
      if (checks['maxLength'] == true) passedChecks++;
    }
    if (widget.rules.requireUppercase) {
      totalChecks++;
      if (checks['uppercase'] == true) passedChecks++;
    }
    if (widget.rules.requireLowercase) {
      totalChecks++;
      if (checks['lowercase'] == true) passedChecks++;
    }
    if (widget.rules.requireNumbers) {
      totalChecks++;
      if (checks['numbers'] == true) passedChecks++;
    }
    if (widget.rules.requireSpecialChars) {
      totalChecks++;
      if (checks['specialChars'] == true) passedChecks++;
    }
    if (!widget.rules.allowSpaces) {
      totalChecks++;
      if (checks['noSpaces'] == true) passedChecks++;
    }
    if (widget.rules.checkCommonPasswords) {
      totalChecks++;
      if (checks['notCommon'] == true) passedChecks++;
    }
    if (widget.rules.checkRepeatedChars) {
      totalChecks++;
      if (checks['noRepeatedChars'] == true) passedChecks++;
    }
    if (widget.rules.checkSequentialChars) {
      totalChecks++;
      if (checks['noSequentialChars'] == true) passedChecks++;
    }

    return totalChecks > 0 ? passedChecks / totalChecks : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showProgress) ...[
            _buildProgressHeader(),
            const SizedBox(height: 12),
          ],
          _buildRequirementsList(),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password Requirements',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Text(
                  '${(_progressAnimation.value * 100).round()}% Complete',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getProgressColor(_progressAnimation.value),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: _progressAnimation.value,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(_progressAnimation.value),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRequirementsList() {
    final requirements = _getRequirements();
    
    return Column(
      children: requirements.map((requirement) => 
        _buildRequirementItem(requirement)
      ).toList(),
    );
  }

  Widget _buildRequirementItem(RequirementItem requirement) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: requirement.isMet 
                  ? Colors.green 
                  : Colors.grey[300],
            ),
            child: Icon(
              requirement.isMet ? Icons.check : Icons.close,
              size: 12,
              color: requirement.isMet ? Colors.white : Colors.grey[600],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  requirement.title,
                  style: TextStyle(
                    fontWeight: requirement.isMet 
                        ? FontWeight.bold 
                        : FontWeight.normal,
                    color: requirement.isMet 
                        ? Colors.green[700] 
                        : Colors.grey[700],
                  ),
                ),
                if (requirement.description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    requirement.description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<RequirementItem> _getRequirements() {
    final checks = widget.result.checks;
    final requirements = <RequirementItem>[];

    // Length requirements
    if (widget.rules.minLength > 0) {
      requirements.add(RequirementItem(
        title: 'At least ${widget.rules.minLength} characters',
        description: 'Longer passwords are more secure',
        isMet: checks['minLength'] == true,
      ));
    }

    if (widget.rules.maxLength < 128) {
      requirements.add(RequirementItem(
        title: 'No more than ${widget.rules.maxLength} characters',
        description: 'Keep passwords manageable',
        isMet: checks['maxLength'] == true,
      ));
    }

    // Character type requirements
    if (widget.rules.requireUppercase) {
      requirements.add(RequirementItem(
        title: 'Uppercase letters (A-Z)',
        description: 'Add capital letters for better security',
        isMet: checks['uppercase'] == true,
      ));
    }

    if (widget.rules.requireLowercase) {
      requirements.add(RequirementItem(
        title: 'Lowercase letters (a-z)',
        description: 'Include small letters',
        isMet: checks['lowercase'] == true,
      ));
    }

    if (widget.rules.requireNumbers) {
      requirements.add(RequirementItem(
        title: 'Numbers (0-9)',
        description: 'Add digits to increase complexity',
        isMet: checks['numbers'] == true,
      ));
    }

    if (widget.rules.requireSpecialChars) {
      requirements.add(RequirementItem(
        title: 'Special characters (!@#\$%^&*)',
        description: 'Use symbols for maximum security',
        isMet: checks['specialChars'] == true,
      ));
    }

    // Space requirements
    if (!widget.rules.allowSpaces) {
      requirements.add(RequirementItem(
        title: 'No spaces',
        description: 'Spaces are not allowed',
        isMet: checks['noSpaces'] == true,
      ));
    }

    // Security requirements
    if (widget.rules.checkCommonPasswords) {
      requirements.add(RequirementItem(
        title: 'Not a common password',
        description: 'Avoid easily guessable passwords',
        isMet: checks['notCommon'] == true,
      ));
    }

    if (widget.rules.checkRepeatedChars) {
      requirements.add(RequirementItem(
        title: 'No repeated characters',
        description: 'Avoid patterns like "aaa" or "111"',
        isMet: checks['noRepeatedChars'] == true,
      ));
    }

    if (widget.rules.checkSequentialChars) {
      requirements.add(RequirementItem(
        title: 'No sequential characters',
        description: 'Avoid patterns like "abc" or "123"',
        isMet: checks['noSequentialChars'] == true,
      ));
    }

    return requirements;
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red;
    if (progress < 0.6) return Colors.orange;
    if (progress < 0.8) return Colors.yellow;
    return Colors.green;
  }
}

class RequirementItem {
  final String title;
  final String? description;
  final bool isMet;

  RequirementItem({
    required this.title,
    this.description,
    required this.isMet,
  });
}
