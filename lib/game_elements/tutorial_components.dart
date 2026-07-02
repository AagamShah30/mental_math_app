import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

Widget buildDraggableDigit({
  required String digit,
  required bool isAlreadyUsed,
}) {
  if (isAlreadyUsed) {
    return Opacity(opacity: 0.2, child: _buildStaticBox(digit));
  }

  return Draggable<String>(
    data: digit,
    feedback: Material(
      color: Colors.transparent,
      child: _buildStaticBox(digit, isFloating: true),
    ),

    childWhenDragging: Opacity(opacity: 0.4, child: _buildStaticBox(digit)),
    child: _buildStaticBox(digit),
  );
}

Widget _buildStaticBox(String text, {bool isFloating = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: isFloating ? Colors.orange.withAlpha(0) : Colors.transparent,
      border: Border.all(color: Colors.orange, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 24,
        color: Colors.orange,
        decoration: TextDecoration.none,
      ),
    ),
  );
}

Widget buildTargetZone({
  required String currentDisplayValue,
  required String correctDigit,
  required String placeholder,
  required Function(String) onAccept,
}) {
  return DragTarget<String>(
    onWillAcceptWithDetails: (details) => details.data == correctDigit,

    onAcceptWithDetails: (details) {
      onAccept(details.data);
    },

    builder: (context, candidateData, rejectedData) {
      bool isHovering =
          candidateData.isNotEmpty && candidateData.first == correctDigit;

      if (currentDisplayValue.isNotEmpty) {
        return Container(
          width: 60,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.green, width: 3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              currentDisplayValue,
              style: const TextStyle(fontSize: 28, color: Colors.green),
            ),
          ),
        );
      }
      return DottedBorder(
        color: isHovering ? Colors.green : Colors.grey[600]!,
        strokeWidth: 2,
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        dashPattern: const [6, 4],
        child: Container(
          width: 60,
          height: 80,
          color: isHovering ? Colors.green.withAlpha(26) : Colors.transparent,
        ),
      );
    },
  );
}

Widget buildTutorialInputField({
  required TextEditingController controller,
  required String correctAnswer,
  required bool isEnabled,
  required ValueChanged<String> onChanged,
}) {
  return SizedBox(
    width: 60,
    height: 80,
    child: TextField(
      controller: controller,
      enabled: isEnabled,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      maxLength: 1,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
      decoration: InputDecoration(
        counterText: '',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[600]!, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 2.5),
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 3.0),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: onChanged,
    ),
  );
}
