import 'package:flutter/material.dart';

void main() {
  runApp(const MarketLinkageApp());
}

class MarketLinkageApp extends StatelessWidget {
  const MarketLinkageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Market Linkage TZ')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Select Your Role', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    ("DEBUG: Farmer Button Clicked!");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FarmerDashboard()),
                    );
                  },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                child: const Text('FARMER /CO-OPERATIVE UNION'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BuyerDashboard()),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                child: const Text('BUYER'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class FarmerDashboard extends StatelessWidget {
  const FarmerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Farmer Dashboard"), backgroundColor: Colors.green),
      body: const Center(child: Text("Welcome, Farmer. Post your crops here.")),
    );
  }
}

class BuyerDashboard extends StatelessWidget {
  const BuyerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buyer Dashboard"), backgroundColor: Colors.blue),
      body: const Center(child: Text("Welcome, Buyer. Search for crops here.")),
    );
  }
}