import 'package:flutter/material.dart';

class ScanMode extends StatelessWidget {
  const ScanMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        "Scan",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
