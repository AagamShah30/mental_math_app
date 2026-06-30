import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mental_math_app/game_elements/game_screen.dart';

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
  // We will store the exact computed centers of each orb to feed our line painter
  List<Offset> nodePositions = [];
  final double rowHeight = 130.0;
  final double orbSize = 80.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calculatePositions();
  }

  void _calculatePositions() {
    final random = Random(42); // Seeded random layout
    final screenWidth = MediaQuery.of(context).size.width;
    final centerX = screenWidth / 2;
    
    List<Offset> positions = [];
    
    for (int i = 0; i < widget.levels.length; i++) {
      // Create organic shifts left and right from center, exactly like the chess app map
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
    final totalHeight = 120.0 + (widget.levels.length * rowHeight);

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF070B19) : const Color(0xfff8f9fa), // Deep cosmic dark theme vs light background
      appBar: AppBar(
        title: Text(widget.courseTitle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: nodePositions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SizedBox(
                height: totalHeight,
                child: Stack(
                  children: [
                    // Layer 1: Perfect connecting vector line tracks
                    Positioned.fill(
                      child: CustomPaint(
                        painter: AbsolutePathPainter(
                          positions: nodePositions,
                          levels: widget.levels,
                          isDarkMode: isDarkMode, // Pass theme status down
                        ),
                      ),
                    ),
                    
                    // Layer 2: Vector neon interactive orbs
                    ...List.generate(widget.levels.length, (index) {
                      final level = widget.levels[index];
                      final isUnlocked = level['unlocked'] as bool;
                      final pos = nodePositions[index];

                      return Positioned(
                        left: pos.dx - (orbSize / 2),
                        top: pos.dy - (orbSize / 2),
                        child: GestureDetector(
                          onTap: () {
                            if (isUnlocked) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GameScreen(
                                    title: level['title'],
                                    questionGenerator: level['generator'],
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(
                                    child: Text(
                                      'Level Locked!',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight(500),
                                        color: isDarkMode ? const Color(0xfff8f9fa) : const Color(0xFF070B19),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  backgroundColor: isDarkMode ? const Color(0xFF070B19) : const Color(0xfff8f9fa),
                                  duration: Duration(seconds: 3),
                                  ),
                              );
                            }
                          },
                          child: Container(
                            width: orbSize,
                            height: orbSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // Multi-colored Neon Ring inspired by your second uploaded file
                              border: Border.all(
                                color: isUnlocked 
                                    ? _getThemeColors(index)[0] 
                                    : Colors.grey[800]!,
                                width: 4.0,
                              ),
                              boxShadow: isUnlocked ? [
                                BoxShadow(
                                  color: _getThemeColors(index)[0].withAlpha(140),
                                  blurRadius: 16,
                                  spreadRadius: 1,
                                )
                              ] : null,
                              gradient: SweepGradient(
                                colors: isUnlocked 
                                    ? _getThemeColors(index)
                                    : [Colors.grey[900]!, Colors.grey[850]!],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isUnlocked ? Colors.white : Colors.grey[600],
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

  List<Color> _getThemeColors(int index) {
    final themes = [
      [const Color.fromARGB(148, 226, 0, 117), const Color.fromARGB(179, 144, 0, 255), const Color.fromARGB(176, 226, 0, 117)], // Pink -> Violet
      [const Color.fromARGB(185, 0, 245, 212), const Color.fromARGB(187, 0, 187, 249), const Color.fromARGB(186, 0, 245, 212)], // Teal -> Blue
      [const Color.fromARGB(192, 255, 160, 28), const Color.fromARGB(181, 255, 0, 128), const Color.fromARGB(162, 255, 160, 28)], // Orange -> Hot Pink
    ];
    return themes[index % themes.length];
  }
}

// True coordinates path lines painter
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

    // Changes line track trace from white to black depending on system light/dark mode
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
        // High performance simple math dash rendering
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
      oldDelegate.positions != positions || oldDelegate.isDarkMode != isDarkMode;
}