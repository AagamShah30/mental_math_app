import 'package:flutter/material.dart';
// Make sure this path exactly matches where your components file is located!
import 'package:mental_math_app/game_elements/tutorial_components.dart';

class ElevensTutorialWidget extends StatefulWidget {
  final VoidCallback onComplete;
  const ElevensTutorialWidget({super.key, required this.onComplete});

  @override
  State<ElevensTutorialWidget> createState() => _ElevensTutorialWidgetState();
}

class _ElevensTutorialWidgetState extends State<ElevensTutorialWidget> {
  String hundredsValue = '';
  String tensValue = '';
  String onesValue = '';

  final TextEditingController _tensController = TextEditingController();

  @override
  void dispose() {
    _tensController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF070B19)
          : Colors.white, // Matching your dark cosmic theme
      appBar: AppBar(
        title: const Text("11s Trick Tutorial"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Multiply ",
                  style: TextStyle(
                    fontSize: 24,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                buildDraggableDigit(
                  digit: "4",
                  isAlreadyUsed: hundredsValue == "4",
                ),
                const SizedBox(width: 6),
                buildDraggableDigit(
                  digit: "2",
                  isAlreadyUsed: onesValue == "2",
                ),
                Text(
                  " by 11",
                  style: TextStyle(
                    fontSize: 24,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTargetZone(
                  currentDisplayValue: hundredsValue,
                  correctDigit: "4",
                  placeholder: " ",
                  onAccept: (value) {
                    setState(() {
                      hundredsValue = value;
                    });
                  },
                ),
                const SizedBox(width: 12),
                buildTutorialInputField(
                  controller: _tensController,
                  isEnabled:
                      hundredsValue.isNotEmpty &&
                      onesValue.isNotEmpty &&
                      tensValue != "6",
                  correctAnswer: "6",
                  onChanged: (value) {
                    setState(() {
                      if (value == "6") {
                        setState(() {
                          tensValue = value;
                        });
                      }
                    });
                  },
                ),
                const SizedBox(width: 12),

                buildTargetZone(
                  currentDisplayValue: onesValue,
                  correctDigit: "2",
                  placeholder: " ",
                  onAccept: (value) {
                    setState(() {
                      onesValue = value;
                    });
                  },
                ),
              ],
            ),

            if (hundredsValue.isNotEmpty && onesValue.isNotEmpty) ...[
              const SizedBox(height: 40),
              if (tensValue.isEmpty) ...[
                Text(
                  "Now, add the two digits together \nto get the middle digit.\n",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 30),
                Text(
                  "Great! The final answer is 462.\n",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    widget.onComplete();
                    Navigator.pop(context);
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Tutorial Complete!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ] else ...[
              const SizedBox(height: 40),
              if (tensValue.isEmpty) ...[
                Text(
                  "Drag the digits into the correct\n positions. The first digit goes in\n the hundreds place, and the second \ndigit goes in the ones place.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
