import 'package:flutter/material.dart';

class PremiumView extends StatelessWidget {
  const PremiumView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Premium',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF16251F),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF16251F)),
      ),
      body: const Center(
        child: Text(
          'Premium Subscription Screen',
          style: TextStyle(fontSize: 16, color: Color(0xFF6A7B73)),
        ),
      ),
    );
  }
}
