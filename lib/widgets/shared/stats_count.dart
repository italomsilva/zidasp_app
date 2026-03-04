import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class StatItem {
  final String label;
  final Computed<int> value;
  final Color color;

  StatItem({
    required this.label,
    required this.value,
    required this.color,
  });
}

class StatsCount extends StatefulWidget {
  final List<StatItem> statsItems;

  const StatsCount({
    super.key,
    required this.statsItems,
  });

  @override
  State<StatsCount> createState() => _StatsCountState();
}

class _StatsCountState extends State<StatsCount> {
  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < widget.statsItems.length; i++) ...[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.statsItems[i].value.value.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: widget.statsItems[i].color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.statsItems[i].label,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (i < widget.statsItems.length - 1)
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.grey.withValues(alpha: 0.3),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                ),
            ],
          ],
        ),
      );
    });
  }
}