import 'package:flutter/material.dart';
import 'package:password_check/password_check.dart';

/// Circular password strength meter with animated progress.
class PasswordStrengthMeter extends StatefulWidget {
  final PasswordValidationResult result;
  final double size;
  final bool animated;
  final bool showScore;
  final bool showLevel;
  final Color? backgroundColor;
  final EdgeInsets padding;

  const PasswordStrengthMeter({
    super.key,
    required this.result,
    this.size = 120.0,
    this.animated = true,
    this.showScore = true,
    this.showLevel = true,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  State<PasswordStrengthMeter> createState() => _PasswordStrengthMeterState();
}

class _PasswordStrengthMeterState extends State<PasswordStrengthMeter>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
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
  void didUpdateWidget(PasswordStrengthMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.result.strengthScore != oldWidget.result.strengthScore) {
      _updateAnimations();
    }
  }

  void _updateAnimations() {
    _progressAnimation = Tween<double>(
      begin: _progressAnimation.value,
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
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMeter(),
            if (widget.showScore || widget.showLevel) ...[
              const SizedBox(height: 16),
              _buildInfo(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMeter() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: StrengthMeterPainter(
            progress: _progressAnimation.value,
            color: _colorAnimation.value ?? Colors.grey,
            backgroundColor: widget.backgroundColor ?? Colors.grey[300]!,
            strokeWidth: 8.0,
          ),
        );
      },
    );
  }

  Widget _buildInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showScore) ...[
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Text(
                '${(_progressAnimation.value * 100).round()}/100',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getStrengthColor(widget.result.strengthScore),
                ),
              );
            },
          ),
        ],
        if (widget.showLevel) ...[
          const SizedBox(height: 4),
          Text(
            widget.result.strengthDisplay,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _getStrengthColor(widget.result.strengthScore),
            ),
          ),
        ],
      ],
    );
  }

  Color _getStrengthColor(int strengthScore) {
    if (strengthScore >= 80) return Colors.green;
    if (strengthScore >= 60) return Colors.yellow;
    if (strengthScore >= 40) return Colors.orange;
    return Colors.red;
  }
}

class StrengthMeterPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  StrengthMeterPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );

    // Draw center icon
    _drawCenterIcon(canvas, center, size);
  }

  void _drawCenterIcon(Canvas canvas, Offset center, Size size) {
    final iconSize = size.width * 0.3;
    final iconPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw strength icon based on progress
    if (progress < 0.2) {
      // Warning icon for very weak
      _drawWarningIcon(canvas, center, iconSize, iconPaint);
    } else if (progress < 0.4) {
      // Info icon for weak
      _drawInfoIcon(canvas, center, iconSize, iconPaint);
    } else if (progress < 0.6) {
      // Check icon for fair
      _drawCheckIcon(canvas, center, iconSize, iconPaint);
    } else if (progress < 0.8) {
      // Security icon for good
      _drawSecurityIcon(canvas, center, iconSize, iconPaint);
    } else {
      // Shield icon for strong
      _drawShieldIcon(canvas, center, iconSize, iconPaint);
    }
  }

  void _drawWarningIcon(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size / 2);
    path.lineTo(center.dx - size / 2, center.dy + size / 2);
    path.lineTo(center.dx + size / 2, center.dy + size / 2);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawInfoIcon(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawCircle(center, size / 4, paint);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + size / 4),
        width: size / 8,
        height: size / 4,
      ),
      paint,
    );
  }

  void _drawCheckIcon(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - size / 3, center.dy);
    path.lineTo(center.dx - size / 6, center.dy + size / 3);
    path.lineTo(center.dx + size / 3, center.dy - size / 3);
    canvas.drawPath(path, paint);
  }

  void _drawSecurityIcon(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size / 2);
    path.lineTo(center.dx - size / 2, center.dy - size / 4);
    path.lineTo(center.dx - size / 2, center.dy + size / 4);
    path.lineTo(center.dx, center.dy + size / 2);
    path.lineTo(center.dx + size / 2, center.dy + size / 4);
    path.lineTo(center.dx + size / 2, center.dy - size / 4);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawShieldIcon(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size / 2);
    path.quadraticBezierTo(
      center.dx - size / 2, center.dy - size / 4,
      center.dx - size / 2, center.dy + size / 4,
    );
    path.quadraticBezierTo(
      center.dx - size / 2, center.dy + size / 2,
      center.dx, center.dy + size / 2,
    );
    path.quadraticBezierTo(
      center.dx + size / 2, center.dy + size / 2,
      center.dx + size / 2, center.dy + size / 4,
    );
    path.quadraticBezierTo(
      center.dx + size / 2, center.dy - size / 4,
      center.dx, center.dy - size / 2,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(StrengthMeterPainter oldDelegate) {
    return progress != oldDelegate.progress ||
           color != oldDelegate.color ||
           backgroundColor != oldDelegate.backgroundColor ||
           strokeWidth != oldDelegate.strokeWidth;
  }
}
