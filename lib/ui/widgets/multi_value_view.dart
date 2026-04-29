import 'package:flutter/material.dart';
import '../../models/multi_data.dart';

class MultiValueView extends StatelessWidget {
  final List<MultiData> data;

  const MultiValueView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.map((item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.label,
              style: TextStyle(color: Colors.grey[300], fontSize: 12),
            ),
            Row(
              children: [
                Text(
                  item.value.toString().replaceAll('.', ','),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                ),
                const SizedBox(width: 4),
                Text(
                  item.unit,
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
              ],
            ),
          ],
        ),
      )).toList(),
    );
  }
}
