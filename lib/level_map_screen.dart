import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mental_math_app/game_elements/game_screen.dart';
// 🌟 Added the missing import for your tutorial widget
import 'package:mental_math_app/game_elements/elevens_tutorial_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_gradients.dart'; // 🌟 Import your new gradient file!

class LevelMapScreen extends StatefulWidget {
  final String courseTitle;
  final List<Map<String, dynamic>> levels;

  const LevelMapScreen({
    super.key,
    required this.courseTitle,
    required this.levels,
  });

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  late List<Map<String, dynamic>> levelProgress;
  List<Offset> nodePositions = [];
  final double rowHeight = 130.0;
  final double orbSize = 80.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calculatePositions();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> unlockedIndexes = [];

    for (int i = 0; i < levelProgress.length; i++) {
      if (levelProgress[i]['unlocked'] == true) {
        unlockedIndexes.add(i.toString());
      }
    }

    await prefs.setStringList(
      'unlocked_levels_multiplication',
      unlockedIndexes,
    );
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedIndexes = prefs.getStringList(
      'unlocked_levels_multiplication',
    );

    if (savedIndexes != null) {
      setState(() {
        for (String indexStr in savedIndexes) {
          int index = int.parse(indexStr);
          if (index < levelProgress.length) {
            levelProgress[index]['unlocked'] = true;
          }
        }
      });
    }
  }

  Future<void> _resetAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('unlocked_levels_multiplication');

    setState(() {
      for (int i = 0; i < levelProgress.length; i++) {
        levelProgress[i]['unlocked'] = (i == 0);
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dev Mode: Progress Reset!'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    levelProgress = List<Map<String, dynamic>>.from(widget.levels);
    _loadProgress();
  }

  void _calculatePositions() {
    final random = Random(42);
    final screenWidth = MediaQuery.of(context).size.width;
    final centerX = screenWidth / 2;

    List<Offset> positions = [];

    for (int i = 0; i < levelProgress.length; i++) {
      double xOffset = (random.nextDouble() * 140) - 70;
      double x = centerX + xOffset;
      double y = 60.0 + (i * rowHeight) + (orbSize / 2);

      positions.add(Offset(x, y));
    }

    setState(() {
      nodePositions = positions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final totalHeight = 120.0 + (levelProgress.length * rowHeight);

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF070B19)
          : const Color(0xfff8f9fa),
      appBar: AppBar(
        title: Text(widget.courseTitle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.redAccent),
            tooltip: 'Reset Dev Progress',
            onPressed: _resetAllProgress,
          )
        ],
      ),
      body: nodePositions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SizedBox(
                height: totalHeight,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: AbsolutePathPainter(
                          positions: nodePositions,
                          levels: levelProgress,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                    ),

                    ...List.generate(levelProgress.length, (index) {
                      final level = levelProgress[index];
                      final isUnlocked = level['unlocked'] as bool;
                      final pos = nodePositions[index];

                      final currentColors = getLevelGradient(level['gameMode']);

                      return Positioned(
                        left: pos.dx - (orbSize / 2),
                        top: pos.dy - (orbSize / 2),
                        child: GestureDetector(
                          onTap: () async {
                            if (isUnlocked) {
                              // 🌟 Fix: Decide which widget to assign BEFORE entering Navigator parameters
                              Widget destinationScreen;

                              if (level['gameMode'] == 'tutorial') {
                                destinationScreen =
                                    ElevensTutorialWidget(
                                      onComplete: () {
                                        if (index + 1 < levelProgress.length) {
                                          levelProgress[index + 1]['unlocked'] = true;
                                          _saveProgress();
                                        }
                                      }
                                    );
                              } else {
                                destinationScreen = GameScreen(
                                  title: level['title'],
                                  questionGenerator: level['generator'],
                                  levelId: 001001 + index,
                                  questionCount: level['questionCount'],
                                  gameMode: level['gameMode'],
                                  onLevelComplete: (score) {
                                    if (index + 1 < levelProgress.length) {
                                      if (score >= level['questionCount']) {
                                        levelProgress[index + 1]['unlocked'] =
                                            true;
                                        _saveProgress();
                                      }
                                    }
                                  },
                                );
                              }

                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => destinationScreen,
                                ),
                              );

                              setState(() {});
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(
                                    child: Text(
                                      'Level Locked!',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: isDarkMode
                                            ? const Color(0xfff8f9fa)
                                            : const Color(0xFF070B19),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  backgroundColor: isDarkMode
                                      ? Colors.black54
                                      : Colors.white70,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: orbSize,
                            height: orbSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isUnlocked
                                    ? currentColors[0]
                                    : Colors.grey[800]!,
                                width: 4.0,
                              ),
                              boxShadow: isUnlocked
                                  ? [
                                      BoxShadow(
                                        color: currentColors[0].withAlpha(140),
                                        blurRadius: 16,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                              gradient: SweepGradient(
                                colors: isUnlocked
                                    ? currentColors
                                    : [Colors.grey[900]!, Colors.grey[850]!],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isUnlocked
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
    );
  }
}

class AbsolutePathPainter extends CustomPainter {
  final List<Offset> positions;
  final List<Map<String, dynamic>> levels;
  final bool isDarkMode;

  AbsolutePathPainter({
    required this.positions,
    required this.levels,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (positions.length < 2) return;

    final baseColor = isDarkMode ? Colors.white : Colors.black;

    final solidPaint = Paint()
      ..color = baseColor.withAlpha(50)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final dashedPaint = Paint()
      ..color = baseColor.withAlpha(20)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < positions.length - 1; i++) {
      Offset p1 = positions[i];
      Offset p2 = positions[i + 1];

      bool nextLevelUnlocked = levels[i + 1]['unlocked'] as bool;

      if (nextLevelUnlocked) {
        canvas.drawLine(p1, p2, solidPaint);
      } else {
        double dx = p2.dx - p1.dx;
        double dy = p2.dy - p1.dy;
        double distance = sqrt(dx * dx + dy * dy);
        double dashLength = 6.0;
        double spaceLength = 6.0;

        double currentDist = 0;
        while (currentDist < distance) {
          double x1 = p1.dx + (dx * currentDist / distance);
          double y1 = p1.dy + (dy * currentDist / distance);
          currentDist += dashLength;
          if (currentDist > distance) currentDist = distance;
          double x2 = p1.dx + (dx * currentDist / distance);
          double y2 = p1.dy + (dy * currentDist / distance);

          canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashedPaint);
          currentDist += spaceLength;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant AbsolutePathPainter oldDelegate) =>
      oldDelegate.positions != positions ||
      oldDelegate.isDarkMode != isDarkMode;
}
