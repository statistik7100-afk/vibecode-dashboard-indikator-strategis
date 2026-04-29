import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../models/indicator_card.dart';
import '../../models/multi_data.dart';
import '../screens/detail_screen.dart';
import 'single_value_view.dart';
import 'multi_value_view.dart';

class IndicatorCardWidget extends StatelessWidget {
  final IndicatorCard card;

  const IndicatorCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppConstants.primaryColor,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(indicatorId: card.id, title: card.title),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              if (card.type == 'single')
                SingleValueView(data: card.data)
              else if (card.type == 'multi')
                MultiValueView(data: card.data as List<MultiData>),
              const SizedBox(height: 16),
              Text(
                card.periodLabel,
                style: TextStyle(fontSize: 12, color: Colors.grey[300]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
