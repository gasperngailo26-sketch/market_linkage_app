import 'package:flutter/material.dart';
import 'package:market_linkage_application/screens/buyerloginpage.dart'
    show BuyerLoginPage;
import 'package:market_linkage_application/screens/farmerloginpage.dart'
    show FarmerLoginPage, loadRegisteredUsers;

import 'screens/welcome page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadRegisteredUsers();
  runApp(const MarketLinkageApp());
}

class MarketLinkageApp extends StatelessWidget {
  const MarketLinkageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}

class FarmerRoleAuthPage extends StatelessWidget {
  const FarmerRoleAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: null, backgroundColor: Colors.green),
      body: const FarmerLoginPage(),
    );
  }
}

class BuyerRoleAuthPage extends StatelessWidget {
  const BuyerRoleAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: null, backgroundColor: Colors.orange.shade600),
      body: const BuyerLoginPage(),
    );
  }
}
