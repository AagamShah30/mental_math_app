import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mental_math_app/game_elements/dialog.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.title,
    required this.questionGenerator,
    required this.levelId,
    required this.onLevelComplete,
    required this.questionCount,
    required this.gameMode,
  });

  final String title;
  final int levelId;
  final Map<String, dynamic> Function() questionGenerator;
  final Function(int) onLevelComplete;
  final int questionCount;
  final String gameMode;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> questionStatuses = [];
  Timer? _loopTimer;
  String userAnswer = '';
  String correctAnswer = '';
  String questionText = '';
  int questionNumber = 1;

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
    questionStatuses = List.generate(
      widget.questionCount,
      (index) => 'pending',
    );
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Math.tex(
                    questionText, textStyle: const TextStyle(color: Colors.white, fontSize: 48)
                  ),
                  Container (
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: userAnswer.isEmpty ? Color.fromARGB(255, 128, 128, 128) : const Color(0xFFE27411),
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 100),
                        Math.tex(
                          userAnswer.isEmpty ? r'\Delta' : userAnswer,
                          textStyle: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                            color: userAnswer.isEmpty ? Color.fromARGB(100, 128, 128, 128) : Colors.white,
                          ),
                        ),
                      ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.questionCount, (index) {
                    bool isCompleted = index < questionNumber - 1;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? (questionStatuses[index] == 'correct'
                                  ? Colors.green
                                  : Colors.red)
                            : Colors.grey,
                      ),
                    );
                  }),
                ),
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
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: text == "X"
                      ? Colors.redAccent
                      : const Color(0xFF0F4D92),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 120,
                height: 60,
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              onTapDown: (details) {
                _loopTimer?.cancel();

                if (text == "X") {
                  _onBackspacePressed();
                } else if (text == "=") {
                  int currentIndex = questionNumber - 1;
                  if (userAnswer == correctAnswer) {
                    questionStatuses[currentIndex] = 'correct';
                    if (questionNumber < widget.questionCount) {
                      questionNumber++;
                      _generateNewQuestion();
                    } else {
                      showSuccessDialog(context, "Level Complete!");
                      questionNumber = 1;
                    }
                    widget.onLevelComplete(questionNumber);
                  } else {
                    questionStatuses[currentIndex] = 'incorrect';
                    if (questionNumber < widget.questionCount) {
                      questionNumber++;
                      _generateNewQuestion();
                    } else {
                      showSuccessDialog(context, "Level Complete!");
                      questionNumber = 1;
                    }
                    widget.onLevelComplete(questionNumber);
                  }
                } else {
                  _onNumberPressed(text);
                }

                _loopTimer = Timer(const Duration(milliseconds: 750), () {
                  _loopTimer = Timer.periodic(Duration(milliseconds: 100), (
                    timer,
                  ) {
                    if (text == 'X') {
                      _onBackspacePressed();
                    } else {
                      _onNumberPressed(text);
                    }
                  });
                });
              },
              onTapUp: (details) {
                _loopTimer?.cancel();
              },
              onTapCancel: () {
                _loopTimer?.cancel();
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
