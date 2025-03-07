import 'package:animations/utils/hex_color.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex("#262d35"),
      body: Column(
        children: [
          SizedBox(height: 600),
          Text("Atlas.", style: TextStyle(color: Colors.white, fontSize: 50)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Text(
              "All seamlessly brought to you inside a card and app that's as intuitive, as it is powerful.",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: Text("Next", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
