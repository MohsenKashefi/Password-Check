import 'package:flutter/material.dart';
import 'package:password_check/password_check.dart';

/// Advanced password strength indicator with animations and breakdown.
class PasswordStrengthIndicator extends StatefulWidget {
  final PasswordValidationResult result;
  final bool showBreakdown;
  final bool showSuggestions;
  final bool animated;
  final double height;
  final EdgeInsets padding;

  const PasswordStrengthIndicator({
    super.key,
    required this.result,
    this.showBreakdown = true,
    this.showSuggestions = true,
    this.animated = true,
    this.height = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
  });

  @override
  State<PasswordStrengthIndicator> createState() => _PasswordStrengthIndicatorState();
}

class _PasswordStrengthIndicatorState extends State<PasswordStrengthIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _strengthAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _strengthAnimation = Tween<double>(
      begin: 0.0,
      end: widget.result.strengthScore / 100,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _colorAnimation = ColorTween(
      begin: Colors.grey,
      end: _getStrengthColor(widget.result.strengthScore),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.animated) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(PasswordStrengthIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.result.strengthScore != oldWidget.result.strengthScore) {
      _updateAnimations();
    }
  }

  void _updateAnimations() {
    _strengthAnimation = Tween<double>(
      begin: _strengthAnimation.value,
      end: widget.result.strengthScore / 100,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _colorAnimation = ColorTween(
      begin: _colorAnimation.value,
      end: _getStrengthColor(widget.result.strengthScore),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.animated) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStrengthBar(),
          const SizedBox(height: 8),
          _buildStrengthInfo(),
          if (widget.showBreakdown) ...[
            const SizedBox(height: 12),
            _buildBreakdown(),
          ],
          if (widget.showSuggestions) ...[
            const SizedBox(height: 12),
            _buildSuggestions(),
          ],
        ],
      ),
    );
  }

  Widget _buildStrengthBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password Strength',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${widget.result.strengthScore}/100',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getStrengthColor(widget.result.strengthScore),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.height / 2),
                color: Colors.grey[300],
              ),
              child: Stack(
                children: [
                  Container(
                    height: widget.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.height / 2),
                      color: Colors.grey[300],
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _strengthAnimation,
                    builder: (context, child) {
                      return Container(
                        height: widget.height,
                        width: MediaQuery.of(context).size.width * _strengthAnimation.value,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(widget.height / 2),
                          gradient: LinearGradient(
                            colors: [
                              _colorAnimation.value ?? Colors.grey,
                              _colorAnimation.value?.withOpacity(0.7) ?? Colors.grey,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStrengthInfo() {
    return Row(
      children: [
        Icon(
          _getStrengthIcon(widget.result.strengthScore),
          size: 16,
          color: _getStrengthColor(widget.result.strengthScore),
        ),
        const SizedBox(width: 8),
        Text(
          widget.result.strengthDisplay,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _getStrengthColor(widget.result.strengthScore),
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Strength Breakdown',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildBreakdownItem('Length', _calculateLengthScore()),
        _buildBreakdownItem('Character Variety', _calculateVarietyScore()),
        _buildBreakdownItem('Complexity', _calculateComplexityScore()),
        _buildBreakdownItem('Pattern Analysis', _calculatePatternScore()),
      ],
    );
  }

  Widget _buildBreakdownItem(String label, double score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.grey[300],
              ),
              child: Stack(
                children: [
                  Container(
                    height: 4,
                    width: MediaQuery.of(context).size.width * score,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: _getScoreColor(score),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(score * 100).round()}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    final suggestions = _getImprovementSuggestions();
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Improvement Suggestions',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...suggestions.map((suggestion) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 16,
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  suggestion,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  double _calculateLengthScore() {
    final length = widget.result.checks['minLength'] == true ? 1.0 : 0.0;
    final maxLength = widget.result.checks['maxLength'] == true ? 1.0 : 0.0;
    return (length + maxLength) / 2;
  }

  double _calculateVarietyScore() {
    int score = 0;
    if (widget.result.checks['uppercase'] == true) score++;
    if (widget.result.checks['lowercase'] == true) score++;
    if (widget.result.checks['numbers'] == true) score++;
    if (widget.result.checks['specialChars'] == true) score++;
    return score / 4;
  }

  double _calculateComplexityScore() {
    int score = 0;
    if (widget.result.checks['notCommon'] == true) score++;
    if (widget.result.checks['noRepeatedChars'] == true) score++;
    if (widget.result.checks['noSequentialChars'] == true) score++;
    return score / 3;
  }

  double _calculatePatternScore() {
    // This would be calculated based on actual pattern analysis
    return widget.result.strengthScore / 100;
  }

  List<String> _getImprovementSuggestions() {
    final suggestions = <String>[];
    
    if (widget.result.checks['minLength'] == false) {
      suggestions.add('Use at least 8 characters');
    }
    if (widget.result.checks['uppercase'] == false) {
      suggestions.add('Add uppercase letters (A-Z)');
    }
    if (widget.result.checks['lowercase'] == false) {
      suggestions.add('Add lowercase letters (a-z)');
    }
    if (widget.result.checks['numbers'] == false) {
      suggestions.add('Include numbers (0-9)');
    }
    if (widget.result.checks['specialChars'] == false) {
      suggestions.add('Add special characters (!@#\$%^&*)');
    }
    if (widget.result.checks['notCommon'] == false) {
      suggestions.add('Avoid common passwords');
    }
    if (widget.result.checks['noRepeatedChars'] == false) {
      suggestions.add('Reduce repeated characters');
    }
    if (widget.result.checks['noSequentialChars'] == false) {
      suggestions.add('Avoid sequential characters (abc, 123)');
    }
    
    return suggestions;
  }

  Color _getStrengthColor(int strengthScore) {
    if (strengthScore >= 80) return Colors.green;
    if (strengthScore >= 60) return Colors.yellow;
    if (strengthScore >= 40) return Colors.orange;
    return Colors.red;
  }

  Color _getScoreColor(double score) {
    if (score < 0.3) return Colors.red;
    if (score < 0.6) return Colors.orange;
    if (score < 0.8) return Colors.yellow;
    return Colors.green;
  }

  IconData _getStrengthIcon(int strengthScore) {
    if (strengthScore >= 80) return Icons.verified_user;
    if (strengthScore >= 60) return Icons.security;
    if (strengthScore >= 40) return Icons.check_circle_outline;
    if (strengthScore >= 20) return Icons.info;
    return Icons.warning;
  }
}
