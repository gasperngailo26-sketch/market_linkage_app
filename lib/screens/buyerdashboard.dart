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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Dashboard'),
        backgroundColor: Colors.orange.shade600,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome, $name',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text('Company Type: $companyType'),
              const SizedBox(height: 8),
              Text('Location: $location'),
              const SizedBox(height: 8),
              Text('Preferred Products: $preferredProducts'),
            ],
          ),
        ),
      ),
    );
  }
}
