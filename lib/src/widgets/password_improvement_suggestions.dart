import 'package:flutter/material.dart';
import 'package:password_check/password_check.dart';

/// Smart password improvement suggestions with contextual advice.
class PasswordImprovementSuggestions extends StatelessWidget {
  final PasswordValidationResult result;
  final ValidationRules rules;
  final bool showIcons;
  final bool showPriority;
  final EdgeInsets padding;

  const PasswordImprovementSuggestions({
    super.key,
    required this.result,
    required this.rules,
    this.showIcons = true,
    this.showPriority = true,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    final suggestions = _getSuggestions();
    
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          ...suggestions.map((suggestion) => 
            _buildSuggestionItem(context, suggestion)
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.lightbulb_outline,
          size: 20,
          color: Colors.orange,
        ),
        const SizedBox(width: 8),
        Text(
          'Improvement Suggestions',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.orange[700],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionItem(BuildContext context, SuggestionItem suggestion) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcons) ...[
            Icon(
              suggestion.icon,
              size: 16,
              color: suggestion.priority == SuggestionPriority.high 
                  ? Colors.red 
                  : suggestion.priority == SuggestionPriority.medium 
                      ? Colors.orange 
                      : Colors.blue,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        suggestion.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: suggestion.priority == SuggestionPriority.high 
                              ? Colors.red[700] 
                              : suggestion.priority == SuggestionPriority.medium 
                                  ? Colors.orange[700] 
                                  : Colors.blue[700],
                        ),
                      ),
                    ),
                    if (showPriority) ...[
                      const SizedBox(width: 8),
                      _buildPriorityBadge(suggestion.priority),
                    ],
                  ],
                ),
                if (suggestion.description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    suggestion.description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                if (suggestion.examples != null) ...[
                  const SizedBox(height: 4),
                  _buildExamples(context, suggestion.examples!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(SuggestionPriority priority) {
    Color color;
    String text;
    
    switch (priority) {
      case SuggestionPriority.high:
        color = Colors.red;
        text = 'High';
        break;
      case SuggestionPriority.medium:
        color = Colors.orange;
        text = 'Medium';
        break;
      case SuggestionPriority.low:
        color = Colors.blue;
        text = 'Low';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildExamples(BuildContext context, List<String> examples) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: examples.map((example) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          example,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontFamily: 'monospace',
            color: Colors.grey[700],
          ),
        ),
      )).toList(),
    );
  }

  List<SuggestionItem> _getSuggestions() {
    final suggestions = <SuggestionItem>[];
    final checks = result.checks;

    // Length suggestions
    if (checks['minLength'] == false) {
      suggestions.add(SuggestionItem(
        title: 'Increase password length',
        description: 'Use at least ${rules.minLength} characters for better security',
        priority: SuggestionPriority.high,
        icon: Icons.straighten,
        examples: ['MyPassword123!', 'SecurePass2024!', 'StrongP@ssw0rd!'],
      ));
    }

    // Character variety suggestions
    if (checks['uppercase'] == false) {
      suggestions.add(SuggestionItem(
        title: 'Add uppercase letters',
        description: 'Include capital letters (A-Z) to increase complexity',
        priority: SuggestionPriority.high,
        icon: Icons.text_fields,
        examples: ['MyPassword', 'SecurePass', 'StrongPass'],
      ));
    }

    if (checks['lowercase'] == false) {
      suggestions.add(SuggestionItem(
        title: 'Add lowercase letters',
        description: 'Include small letters (a-z) for better variety',
        priority: SuggestionPriority.high,
        icon: Icons.text_fields,
        examples: ['mypassword', 'securepass', 'strongpass'],
      ));
    }

    if (checks['numbers'] == false) {
      suggestions.add(SuggestionItem(
        title: 'Include numbers',
        description: 'Add digits (0-9) to make your password harder to guess',
        priority: SuggestionPriority.medium,
        icon: Icons.numbers,
        examples: ['Password123', 'Secure2024', 'Strong99'],
      ));
    }

    if (checks['specialChars'] == false) {
      suggestions.add(SuggestionItem(
        title: 'Add special characters',
        description: 'Use symbols (!@#\$%^&*) for maximum security',
        priority: SuggestionPriority.medium,
        icon: Icons.tag,
        examples: ['Password!', 'Secure@2024', 'Strong#Pass'],
      ));
    }

    // Security suggestions
    if (checks['notCommon'] == false) {
      suggestions.add(SuggestionItem(
        title: 'Avoid common passwords',
        description: 'Don\'t use easily guessable passwords like "password" or "123456"',
        priority: SuggestionPriority.high,
        icon: Icons.warning,
        examples: ['MyUniquePass!', 'Secure2024!', 'StrongP@ss!'],
      ));
    }

    if (checks['noRepeatedChars'] == false) {
      suggestions.add(SuggestionItem(
        title: 'Reduce repeated characters',
        description: 'Avoid patterns like "aaa" or "111" which are easy to guess',
        priority: SuggestionPriority.medium,
        icon: Icons.repeat,
        examples: ['MyPassword!', 'SecurePass!', 'StrongPass!'],
      ));
    }

    if (checks['noSequentialChars'] == false) {
      suggestions.add(SuggestionItem(
        title: 'Avoid sequential characters',
        description: 'Don\'t use patterns like "abc" or "123" which are predictable',
        priority: SuggestionPriority.medium,
        icon: Icons.trending_up,
        examples: ['MyPassword!', 'SecurePass!', 'StrongPass!'],
      ));
    }

    // Space suggestions
    if (checks['noSpaces'] == false) {
      suggestions.add(SuggestionItem(
        title: 'Remove spaces',
        description: 'Spaces are not allowed in passwords',
        priority: SuggestionPriority.low,
        icon: Icons.space_bar,
        examples: ['MyPassword!', 'SecurePass!', 'StrongPass!'],
      ));
    }

    // Advanced suggestions based on strength
    if (result.strengthScore < 50) {
      suggestions.add(SuggestionItem(
        title: 'Use a passphrase',
        description: 'Consider using a memorable phrase with numbers and symbols',
        priority: SuggestionPriority.medium,
        icon: Icons.psychology,
        examples: ['MyDogLoves2024!', 'Coffee@Home!', 'SunnyDay#2024'],
      ));
    }

    if (result.strengthScore < 70) {
      suggestions.add(SuggestionItem(
        title: 'Mix different character types',
        description: 'Combine uppercase, lowercase, numbers, and symbols',
        priority: SuggestionPriority.medium,
        icon: Icons.shuffle,
        examples: ['MyP@ssw0rd!', 'Secure#2024!', 'Strong\$Pass!'],
      ));
    }

    // Sort by priority
    suggestions.sort((a, b) {
      if (a.priority == b.priority) return 0;
      if (a.priority == SuggestionPriority.high) return -1;
      if (b.priority == SuggestionPriority.high) return 1;
      if (a.priority == SuggestionPriority.medium) return -1;
      if (b.priority == SuggestionPriority.medium) return 1;
      return 0;
    });

    return suggestions;
  }
}

class SuggestionItem {
  final String title;
  final String? description;
  final SuggestionPriority priority;
  final IconData icon;
  final List<String>? examples;

  SuggestionItem({
    required this.title,
    this.description,
    required this.priority,
    required this.icon,
    this.examples,
  });
}

enum SuggestionPriority {
  high,
  medium,
  low,
}
