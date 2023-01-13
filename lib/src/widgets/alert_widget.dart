import 'package:flutter/material.dart';
import 'package:mockani/src/utils/array_slice.dart';

class AlertWidget extends StatelessWidget {
  const AlertWidget({
    super.key,
    required this.color,
    required this.alerts,
  });

  final Color color;
  final List<String> alerts;

  @override
  Widget build(BuildContext context) {
    if (alerts.length == 1) {
      return BadgeWidget(color: color, text: alerts.first);
    } else if (alerts.length > 1) {
      final rows = sliceList(source: alerts, itemsPerSet: 3);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: rows
            .map(
              (row) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: row
                    .map(
                      (alert) => BadgeWidget(color: color, text: alert),
                    )
                    .toList(),
              ),
            )
            .toList(),
      );
    } else {
      return const SizedBox();
    }
  }
}

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({
    super.key,
    required this.color,
    required this.text,
    this.textColor,
    this.padding,
    this.onTap,
  });

  final Color color;
  final String text;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final void Function(String value)? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(text);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: textColor ?? Colors.white,
              ),
        ),
      ),
    );
  }
}
