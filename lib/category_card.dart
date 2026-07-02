import 'package:flutter/material.dart';
import 'package:mental_math_app/game_elements/math_questions.dart';
import 'package:mental_math_app/level_map_screen.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LevelMapScreen(
              courseTitle: "Mental Multiplication",
              levels: [
                {
                  'title': 'The Elevens Trick',
                  'generator': generateElevensQuestion,
                  'unlocked': true,
                  'questionCount': 10,
                  'gameMode': 'tutorial',
                },
                {
                  'title': 'Multiplying by Fives',
                  'generator': generateFivesQuestion,
                  'unlocked': false,
                  'questionCount': 10,
                  'gameMode': 'drill',
                },
                {
                  'title': 'Squares Mastery',
                  'generator': generateElevensQuestion,
                  'unlocked': false,
                  'questionCount': 10,
                  'gameMode': 'test',
                },
                {
                  'title': 'The Elevens Trick',
                  'generator': generateElevensQuestion,
                  'unlocked': false,
                  'questionCount': 10,
                  'gameMode': 'tutorial',
                },
                {
                  'title': 'Multiplying by Fives',
                  'generator': generateFivesQuestion,
                  'unlocked': false,
                  'questionCount': 10,
                  'gameMode': 'test',
                },
                {
                  'title': 'Squares Mastery',
                  'generator': generateElevensQuestion,
                  'unlocked': false,
                  'questionCount': 10,
                  'gameMode': 'drill',
                },
                {
                  'title': 'The Elevens Trick',
                  'generator': generateElevensQuestion,
                  'unlocked': false,
                  'questionCount': 10,
                  'gameMode': 'drill',
                },
                {
                  'title': 'Multiplying by Fives',
                  'generator': generateFivesQuestion,
                  'unlocked': false,
                  'questionCount': 10,
                  'gameMode': 'drill',
                },
                {
                  'title': 'Squares Mastery',
                  'generator': generateElevensQuestion,
                  'unlocked': false,
                  'questionCount': 10,
                  'gameMode': 'test',
                }
              ],
            ),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(isDarkMode ? 0xFF1E1E2C : 0xFFEDF9FF),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Color(0xFF0F4D92), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: const BoxDecoration(
                color: Color(0xFFE27411),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
