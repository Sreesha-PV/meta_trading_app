import 'package:flutter/material.dart';

class MarketstatisticsPage extends StatelessWidget {
  const MarketstatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              children: [
                Icon(Icons.arrow_back),
              ],
            )
          ],
        ),
      ),
    );
  }
}


