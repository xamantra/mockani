import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({super.key, this.color, this.size});

  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? 32,
        height: size ?? 32,
        child: CircularProgressIndicator(
          valueColor: color == null ? null : AlwaysStoppedAnimation(color),
        ),
      ),
    );
  }
}
