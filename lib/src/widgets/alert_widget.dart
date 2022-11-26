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
      return _AlertBadge(color: color, alert: alerts.first);
    } else if (alerts.length > 1) {
      final rows = sliceListToRows(source: alerts, columnCount: 3);
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
                      (alert) => _AlertBadge(color: color, alert: alert),
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

class _AlertBadge extends StatelessWidget {
  const _AlertBadge({
    required this.color,
    required this.alert,
  });

  final Color color;
  final String alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        alert,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}
