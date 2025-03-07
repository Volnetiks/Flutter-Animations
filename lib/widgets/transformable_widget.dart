import 'dart:math';

import 'package:flutter/material.dart';

class TransformableWidget extends StatefulWidget {
  final Widget child;
  final Offset? initialPosition;
  final double? initialOrientation;
  final double? borderRadius;
  final double? initialScale;

  const TransformableWidget({
    super.key,
    required this.child,
    this.initialPosition,
    this.initialOrientation,
    this.borderRadius,
    this.initialScale,
  });

  @override
  TransformableWidgetState createState() => TransformableWidgetState();
}

class TransformableWidgetState extends State<TransformableWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  Offset _targetPosition = Offset(0, 0);
  double _targetRotation = 0.0;
  double _targetScale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _positionAnimation = Tween(
      begin: widget.initialPosition ?? Offset(0, 0),
      end: _targetPosition,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotationAnimation = Tween<double>(
      begin: widget.initialOrientation ?? 0.0,
      end: _targetRotation,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: _targetScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void animateTo({
    required Offset newPosition,
    required double newRotation,
    required double newScale,
  }) {
    _targetPosition = newPosition;
    _targetScale = newScale;

    // Ensure shortest rotation path
    double currentRotation = _rotationAnimation.value;
    double deltaRotation = (newRotation - currentRotation) % (2 * pi);
    if (deltaRotation > pi) {
      deltaRotation -= 2 * pi;
    } else if (deltaRotation < -pi) {
      deltaRotation += 2 * pi;
    }
    _targetRotation = currentRotation + deltaRotation;

    _positionAnimation = Tween(
      begin: _positionAnimation.value,
      end: _targetPosition,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotationAnimation = Tween<double>(
      begin: _rotationAnimation.value,
      end: _targetRotation,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: _scaleAnimation.value,
      end: _targetScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          transform:
              Matrix4.identity()
                ..translate(
                  _positionAnimation.value.dx,
                  _positionAnimation.value.dy,
                )
                ..rotateZ(_rotationAnimation.value)
                ..scale(_scaleAnimation.value),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              (widget.borderRadius ?? 0) / _scaleAnimation.value,
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}
