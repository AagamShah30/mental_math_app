
import 'package:flutter/material.dart';

List<Color> getLevelGradient(String? gameMode) {
  switch (gameMode) {
    case 'tutorial':
      return const [
        Color.fromARGB(185, 0, 245, 212),
        Color.fromARGB(187, 0, 187, 249),
        Color.fromARGB(186, 0, 245, 212),
      ];
    case 'drill':
      return const [
        Color.fromARGB(192, 255, 160, 28),
        Color.fromARGB(181, 255, 0, 128),
        Color.fromARGB(162, 255, 160, 28),
      ];
    case 'test':
    default:
      return const [
        Color.fromARGB(148, 226, 0, 117),
        Color.fromARGB(179, 144, 0, 255),
        Color.fromARGB(176, 226, 0, 117),
      ];
  }
}