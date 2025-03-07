import 'dart:math';

import 'package:animations/finances/intro.dart';
import 'package:animations/finances/subscription.dart';
import 'package:animations/utils/hex_color.dart';
import 'package:animations/widgets/transformable_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _mainPageController = PageController();
  final PageController _cardsPageController = PageController(
    viewportFraction: 0.85,
  );
  double _mainPageValue = 0;
  double _cardsPageValue = 0;

  final GlobalKey<TransformableWidgetState> _redCardKey =
      GlobalKey<TransformableWidgetState>();

  final GlobalKey<TransformableWidgetState> _blueCardKey =
      GlobalKey<TransformableWidgetState>();

  @override
  void initState() {
    super.initState();
    _mainPageController.addListener(_onMainPageChanged);
    _cardsPageController.addListener(_onCardsPageChanged);
  }

  @override
  void dispose() {
    _mainPageController.removeListener(_onMainPageChanged);
    _cardsPageController.removeListener(_onCardsPageChanged);
    _mainPageController.dispose();
    _cardsPageController.dispose();
    super.dispose();
  }

  void _onMainPageChanged() {
    setState(() {
      _mainPageValue = _mainPageController.page ?? 0;
    });
  }

  void _onCardsPageChanged() {
    setState(() {
      _cardsPageValue = _cardsPageController.page ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final bool isFirstPage = _mainPageValue < 0.5;
    final bool isAnimationComplete = _mainPageValue >= 0.99;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Main page content (intro and second page)
        PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _mainPageController,
          onPageChanged: (index) {
            // If we've moved to the second page, initialize the cards PageView
            if (index == 1) {
              Future.delayed(Duration(milliseconds: 300), () {
                if (_cardsPageController.hasClients && _cardsPageValue == 0) {
                  _cardsPageController.jumpToPage(0);
                }
              });
            }
          },
          children: [
            IntroPage(
              onNext: () {
                _redCardKey.currentState?.animateTo(
                  newPosition: Offset(
                    screenWidth * 0.1,
                    screenWidth * 0.8 * 1.6 + 300,
                  ),
                  newRotation: 1.5 * pi,
                  newScale: (screenWidth * 0.8) / 200,
                );
                _blueCardKey.currentState?.animateTo(
                  newPosition: Offset(
                    screenWidth * 0.95,
                    screenWidth * 0.8 * 1.6 + 300,
                  ),
                  newRotation: 1.5 * pi,
                  newScale: (screenWidth * 0.8) / 200,
                );
                _mainPageController.animateToPage(
                  1,
                  duration: Duration(milliseconds: 1050),
                  curve: Curves.easeInOut,
                );
              },
            ),
            SubscriptionPage(
              cardsPageValue: _cardsPageValue,
              onPress: () {
                print(_redCardKey.currentState ?? "no");
                _redCardKey.currentState?.animateTo(
                  newPosition: Offset(30, 300),
                  newRotation: (2 * pi) / 360 * 350,
                  newScale: 1,
                );
                _blueCardKey.currentState?.animateTo(
                  newPosition: Offset(120, 100),
                  newRotation: (2 * pi) / 360 * 30,
                  newScale: 1,
                );
                _mainPageController.animateToPage(
                  0,
                  duration: Duration(milliseconds: 1050),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ],
        ),

        // Cards overlay
        Positioned.fill(
          child: Column(
            children: [
              Visibility(
                visible: isFirstPage || !isAnimationComplete,
                child: SizedBox(
                  height: 600,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      TransformableWidget(
                        borderRadius: 15,
                        key: _redCardKey,
                        initialPosition: Offset(30, 300),
                        initialOrientation: (2 * pi) / 360 * 350,
                        child: Container(
                          width: 200 * 1.6,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/business-rhubarb.png"),
                            ),
                          ),
                        ),
                      ),
                      TransformableWidget(
                        borderRadius: 15,
                        key: _blueCardKey,
                        initialPosition: Offset(120, 100),
                        initialOrientation: (2 * pi) / 360 * 30,
                        child: Container(
                          width: 200 * 1.6,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/business-petrol.png"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isFirstPage && isAnimationComplete)
                // Secondary PageView for cards after animation completes
                Column(
                  children: [
                    SizedBox(height: 300),
                    SizedBox(
                      height: screenWidth * 0.8 * 1.6,
                      child: PageView(
                        controller: _cardsPageController,
                        children: [
                          // Red card page
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: screenWidth * 0.8 * 1.6,
                              width: screenWidth * 0.8,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: Image.asset(
                                  "assets/business-rhubarb.png",
                                ),
                              ),
                            ),
                          ),
                          // Blue card page
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: screenWidth * 0.8 * 1.6,
                              width: screenWidth * 0.8,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: Image.asset(
                                  "assets/business-petrol.png",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
