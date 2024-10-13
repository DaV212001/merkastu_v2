import 'package:flutter/material.dart';
import 'package:merkastu_v2/constants/constants.dart';

class AnimatedUndoButton extends TextButton {
  final String buttonText;
  final double width;
  final double height;
  final double borderRadius;
  final Color buttonColor;
  final Color progressColor;
  @override
  final Function() onPressed;

  const AnimatedUndoButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.width = 200,
    this.height = 50,
    this.borderRadius = 12.0,
    this.buttonColor = Colors.indigo,
    this.progressColor = Colors.white,
    required super.child,
  }) : super(onPressed: onPressed);

  @override
  _LoadingTextButtonState createState() => _LoadingTextButtonState();
}

class _LoadingTextButtonState extends State<AnimatedUndoButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {}); // Trigger a rebuild to animate progress
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onPressed();
        _animationController.stop();
      },
      splashFactory: InkRipple.splashFactory,
      child: CustomPaint(
        painter: RectangularProgressPainter(
          animation: _animationController,
          progressColor: widget.progressColor,
          borderRadius: widget.borderRadius,
        ),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.buttonColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Center(
            child: Text(
              widget.buttonText,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RectangularProgressPainter extends CustomPainter {
  final Animation<double> animation;
  final Color progressColor;
  final double borderRadius;

  RectangularProgressPainter({
    required this.animation,
    required this.progressColor,
    required this.borderRadius,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));

    // Calculate the total length of the border path
    final pathMetrics = path.computeMetrics().toList();
    final totalLength =
        pathMetrics.fold(0.0, (sum, metric) => sum + metric.length);

    // Calculate the length of the progress based on the animation value
    final progressLength = totalLength * animation.value;

    // Paint for the full background border (light)
    final backgroundPaint = Paint()
      ..color = maincolor.withOpacity(0.2)
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke;

    // Paint for the progress indicator (active)
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw the full background border
    canvas.drawPath(path, backgroundPaint);

    // Draw progress along the path
    var currentLength = 0.0;
    for (var metric in pathMetrics) {
      final remainingLength = progressLength - currentLength;
      if (remainingLength <= 0) break;

      final segmentLength = metric.length;
      if (currentLength + segmentLength > progressLength) {
        final partialPath = metric.extractPath(0, remainingLength);
        canvas.drawPath(partialPath, progressPaint);
        break;
      } else {
        canvas.drawPath(metric.extractPath(0, segmentLength), progressPaint);
        currentLength += segmentLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
