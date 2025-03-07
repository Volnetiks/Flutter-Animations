import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({
    super.key,
    required this.cardsPageValue,
    required this.onPress,
  });

  final double cardsPageValue;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    int currentCardIndex = cardsPageValue.round();
    String title = "Basic";
    String description = "Your new favorite way to manage finances";
    double price = 8;

    if (currentCardIndex == 1) {
      title = "Premium";
      description = "Unlimited rewards and exclusive benefits for members";
      price = 12;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50),
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ElevatedButton(onPressed: onPress, child: Text("test")),
                    Text(
                      "Subscription",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "$title - ${price.toStringAsFixed(2)}\$",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          " per month",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
