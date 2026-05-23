import 'package:flutter/material.dart';

import '../../common/nakhlah_mascot.dart';

class NakhlahHome extends StatelessWidget {
  const NakhlahHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF4ECFF),
      body: Center(
        child: NakhlahMascot(size: 280),
      ),
    );
  }
}
