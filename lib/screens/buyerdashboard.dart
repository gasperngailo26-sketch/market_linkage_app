import 'package:flutter/material.dart';

class BuyerDashboard extends StatelessWidget {
  final String name;
  final String companyType;
  final String location;
  final String preferredProducts;

  const BuyerDashboard({
    super.key,
    required this.name,
    required this.companyType,
    required this.location,
    required this.preferredProducts,
  });

  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Dashboard'),
        backgroundColor: Colors.orange.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Type: $companyType', style: const TextStyle(fontSize: 16)),
            Text('Location: $location', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              'Preferred Products: $preferredProducts',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Buyer dashboard content goes here.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              'Browse available crops, connect with farmers, and place orders.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
