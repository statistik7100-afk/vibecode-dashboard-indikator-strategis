import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../models/single_data.dart';

class SingleValueView extends StatelessWidget {
  final SingleData data;

  const SingleValueView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isUp = data.direction == 'up';
    final bool isDown = data.direction == 'down';
    final Color trendColor = isUp ? AppConstants.upTrendColor : (isDown ? AppConstants.downTrendColor : Colors.grey[400]!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              data.value.toString().replaceAll('.', ','),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(width: 4),
            Text(
              data.unit,
              style: TextStyle(fontSize: 12, color: Colors.grey[300]),
            ),
          ],
        ),
        if (data.changeValue != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isUp ? Icons.arrow_drop_up : (isDown ? Icons.arrow_drop_down : Icons.horizontal_rule),
                size: 24,
                color: trendColor,
              ),
              const SizedBox(width: 2),
              Text(
                '${data.changeValue} ${data.changeUnit ?? ''}',
                style: TextStyle(color: trendColor, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              if (data.changeType != null)
                Text(
                  ' (${data.changeType})',
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
            ],
          ),
        ],
        if (data.description != null) ...[
          const SizedBox(height: 4),
          Text(
            data.description!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey[400]),
          ),
        ],
        if (data.status != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: data.status == 'surplus' ? AppConstants.upTrendColor.withOpacity(0.2) : AppConstants.downTrendColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              data.status!.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: data.status == 'surplus' ? AppConstants.upTrendColor : AppConstants.downTrendColor,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
