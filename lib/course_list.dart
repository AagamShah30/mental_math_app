import 'package:flutter/material.dart';
import 'package:mental_math_app/category_card.dart';
import 'package:flutter/cupertino.dart';

class CourseList extends StatelessWidget {
  const CourseList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        CategoryCard(
          title: 'Addition',
          subtitle: 'Learn the basics of mental math',
          icon: Icons.add,
        ),
        CategoryCard(
          title: 'Subtraction',
          subtitle: 'Expand upon your strong addition skills',
          icon: Icons.remove,
        ),
        CategoryCard(
          title: 'Multiplication',
          subtitle: 'Learn some of the coolest mental math tricks',
          icon: Icons.close,
        ),
        CategoryCard(
          title: 'Division',
          subtitle: 'Some of the most difficult techniques',
          icon: CupertinoIcons.divide, // Using horizontal_rule for division
        ),
      ],
    );
  }
}