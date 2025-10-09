import 'package:flutter/material.dart';
import '../history/password_history.dart';

/// Widget for displaying password history information
class PasswordHistoryWidget extends StatelessWidget {
  final PasswordHistory? history;
  final PasswordHistoryResult? historyResult;
  final bool showDetails;
  final bool showSuggestions;
  final VoidCallback? onClearHistory;

  const PasswordHistoryWidget({
    super.key,
    this.history,
    this.historyResult,
    this.showDetails = true,
    this.showSuggestions = true,
    this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    if (history == null && historyResult == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            if (historyResult != null) _buildHistoryResult(context),
            if (showDetails && history != null) _buildHistoryDetails(context),
            if (showSuggestions &&
                historyResult?.suggestions.isNotEmpty == true)
              _buildSuggestions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Password History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onClearHistory != null)
          TextButton.icon(
            onPressed: onClearHistory,
            icon: const Icon(Icons.clear_all, size: 16),
            label: const Text('Clear'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
      ],
    );
  }

  Widget _buildHistoryResult(BuildContext context) {
    if (historyResult!.isRejected) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red[50],
          border: Border.all(color: Colors.red[200]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.red[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Password Rejected',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              historyResult!.reason ?? 'Password rejected by history check',
              style: TextStyle(color: Colors.red[600]),
            ),
            if (historyResult!.similarityScore != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Similarity: '),
                  Text(
                    '${(historyResult!.similarityScore! * 100).toInt()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
            if (historyResult!.lastUsed != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('Last used: '),
                  Text(
                    _formatDate(historyResult!.lastUsed!),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[50],
          border: Border.all(color: Colors.green[200]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[600], size: 20),
            const SizedBox(width: 8),
            Text(
              'Password accepted - not in history',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildHistoryDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'History Details:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Passwords in history: '),
            Text(
              '${history!.length}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: [
            const Text('Max history length: '),
            Text(
              '${history!.config.maxLength}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: [
            const Text('Similarity threshold: '),
            Text(
              '${(history!.config.similarityThreshold * 100).toInt()}%',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: [
            const Text('Comparison method: '),
            Text(
              _formatComparisonMethod(history!.config.method),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Suggestions:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...historyResult!.suggestions.map((suggestion) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline,
                      size: 16, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      suggestion,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  String _formatComparisonMethod(ComparisonMethod method) {
    switch (method) {
      case ComparisonMethod.exactHash:
        return 'Exact Hash';
      case ComparisonMethod.similarity:
        return 'Similarity';
      case ComparisonMethod.fuzzyMatch:
        return 'Fuzzy Match';
    }
  }
}

/// Compact widget for showing history status
class PasswordHistoryStatusWidget extends StatelessWidget {
  final PasswordHistoryResult? historyResult;
  final bool showIcon;

  const PasswordHistoryStatusWidget({
    super.key,
    this.historyResult,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    if (historyResult == null) {
      return const SizedBox.shrink();
    }

    if (historyResult!.isRejected) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(Icons.warning, color: Colors.red[600], size: 16),
            const SizedBox(width: 4),
          ],
          Text(
            'History: Rejected',
            style: TextStyle(
              color: Colors.red[600],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(Icons.check_circle, color: Colors.green[600], size: 16),
            const SizedBox(width: 4),
          ],
          Text(
            'History: OK',
            style: TextStyle(
              color: Colors.green[600],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      );
    }
  }
}
