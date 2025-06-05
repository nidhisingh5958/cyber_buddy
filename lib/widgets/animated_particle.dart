import 'package:flutter/material.dart';

class AnimatedParticle extends StatefulWidget {
  final int index;

  AnimatedParticle({required this.index});

  @override
  _AnimatedParticleState createState() => _AnimatedParticleState();
}

class _AnimatedParticleState extends State<AnimatedParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3 + widget.index),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue.withOpacity(0.3),
      Colors.purple.withOpacity(0.3),
      Colors.pink.withOpacity(0.3),
      Colors.orange.withOpacity(0.3),
      Colors.green.withOpacity(0.3),
      Colors.red.withOpacity(0.3),
    ];

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: 50.0 + widget.index * 200.0 + _animation.value * 100,
          top: 100.0 + widget.index * 150.0 + _animation.value * 200,
          child: Container(
            width: 60 + widget.index * 20.0,
            height: 60 + widget.index * 20.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors[widget.index % colors.length],
              boxShadow: [
                BoxShadow(
                  color: colors[widget.index % colors.length],
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
