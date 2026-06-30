import 'package:flutter/material.dart';
import 'package:mental_math_app/game_elements/dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.title,
    required this.questionGenerator,
  });

  final String title;
  final Map<String, dynamic> Function() questionGenerator;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String userAnswer = '';
  String correctAnswer = '';
  String questionText = '';

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }

  void _onNumberPressed(String number) {
    setState(() {
      userAnswer += number;
    });
  }

  void _onBackspacePressed() {
    setState(() {
      if (userAnswer.isNotEmpty) {
        userAnswer = userAnswer.substring(0, userAnswer.length - 1);
      }
    });
  }

  void _generateNewQuestion() {
    final questionData = widget.questionGenerator();

    setState(() {
      questionText = questionData['question'];
      correctAnswer = questionData['answer'];
      userAnswer = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF1E1E2C)
          : const Color(0xFFEDF9FF),
      appBar: AppBar(
        title: const Text('Game Screen'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    questionText,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userAnswer.isEmpty ? '?' : userAnswer,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE27411),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildKeyboardRow(['1', '2', '3']),
                _buildKeyboardRow(['4', '5', '6']),
                _buildKeyboardRow(['7', '8', '9']),
                _buildKeyboardRow(['X', '0', '=']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((text) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 80,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: text == "X"
                    ? Colors.redAccent
                    : const Color(0xFF0F4D92),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (text == "X") {
                  _onBackspacePressed();
                } else if (text == "=") {
                  if (userAnswer == correctAnswer) {
                    showSuccessDialog(context, "Correct!");
                  } else {
                    showSuccessDialog(context, "Try again!");
                  }
                } else {
                  _onNumberPressed(text);
                }
              },
              child: Text(
                text,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
