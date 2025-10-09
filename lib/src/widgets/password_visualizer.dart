import 'package:flutter/material.dart';
import 'package:password_check/password_check.dart';

/// Comprehensive password visualization widget combining all strength indicators.
class PasswordVisualizer extends StatefulWidget {
  final PasswordValidationResult result;
  final ValidationRules rules;
  final bool showMeter;
  final bool showIndicator;
  final bool showChecklist;
  final bool showSuggestions;
  final bool animated;
  final EdgeInsets padding;

  const PasswordVisualizer({
    super.key,
    required this.result,
    required this.rules,
    this.showMeter = true,
    this.showIndicator = true,
    this.showChecklist = true,
    this.showSuggestions = true,
    this.animated = true,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  State<PasswordVisualizer> createState() => _PasswordVisualizerState();
}

class _PasswordVisualizerState extends State<PasswordVisualizer>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.animated) {
      _fadeController.forward();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildTabBar(),
                const SizedBox(height: 16),
                _buildTabContent(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.security,
          size: 24,
          color: _getStrengthColor(widget.result.strengthScore),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password Analysis',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Comprehensive security assessment',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        _buildQuickScore(),
      ],
    );
  }

  Widget _buildQuickScore() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStrengthColor(widget.result.strengthScore).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStrengthColor(widget.result.strengthScore).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            '${widget.result.strengthScore}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: _getStrengthColor(widget.result.strengthScore),
            ),
          ),
          Text(
            'Score',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getStrengthColor(widget.result.strengthScore),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(6),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        tabs: [
          Tab(
            icon: Icon(Icons.speed, size: 18),
            text: 'Strength',
          ),
          Tab(
            icon: Icon(Icons.checklist, size: 18),
            text: 'Requirements',
          ),
          Tab(
            icon: Icon(Icons.analytics, size: 18),
            text: 'Breakdown',
          ),
          Tab(
            icon: Icon(Icons.lightbulb, size: 18),
            text: 'Suggestions',
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 400,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildStrengthTab(),
          _buildRequirementsTab(),
          _buildBreakdownTab(),
          _buildSuggestionsTab(),
        ],
      ),
    );
  }

  Widget _buildStrengthTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.showMeter) ...[
            PasswordStrengthMeter(
              result: widget.result,
              size: 150,
              animated: widget.animated,
            ),
            const SizedBox(height: 16),
          ],
          if (widget.showIndicator) ...[
            PasswordStrengthIndicator(
              result: widget.result,
              showBreakdown: false,
              showSuggestions: false,
              animated: widget.animated,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRequirementsTab() {
    return SingleChildScrollView(
      child: PasswordRequirementsChecklist(
        result: widget.result,
        rules: widget.rules,
        animated: widget.animated,
      ),
    );
  }

  Widget _buildBreakdownTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PasswordStrengthIndicator(
            result: widget.result,
            showBreakdown: true,
            showSuggestions: false,
            animated: widget.animated,
          ),
          const SizedBox(height: 16),
          _buildDetailedBreakdown(),
        ],
      ),
    );
  }

  Widget _buildSuggestionsTab() {
    return SingleChildScrollView(
      child: PasswordImprovementSuggestions(
        result: widget.result,
        rules: widget.rules,
        showIcons: true,
        showPriority: true,
      ),
    );
  }

  Widget _buildDetailedBreakdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Analysis',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildAnalysisItem('Length Score', _calculateLengthScore()),
            _buildAnalysisItem('Character Variety', _calculateVarietyScore()),
            _buildAnalysisItem('Pattern Security', _calculatePatternScore()),
            _buildAnalysisItem('Common Password Check', _calculateCommonScore()),
            _buildAnalysisItem('Overall Security', widget.result.strengthScore / 100),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisItem(String label, double score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(score * 100).round()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getScoreColor(score),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: score,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(score)),
          ),
        ],
      ),
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

  double _calculatePatternScore() {
    int score = 0;
    if (widget.result.checks['noRepeatedChars'] == true) score++;
    if (widget.result.checks['noSequentialChars'] == true) score++;
    return score / 2;
  }

  double _calculateCommonScore() {
    return widget.result.checks['notCommon'] == true ? 1.0 : 0.0;
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
}
