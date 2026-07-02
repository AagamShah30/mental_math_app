import 'dart:math';

Map<String, String> generateElevensQuestion() {
  final random = Random();
  int num = random.nextInt(90) + 10;
  return {
    'question': num.toString() + r'\times 11',
    'answer': (num * 11).toString(),
  };
}


Map<String, String> generateFivesQuestion() {
  final random = Random();
  int num = (random.nextInt(45) + 6) * 2;
  return {
    'question': num.toString() + r' \times 5',
    'answer': (num * 5).toString(),
  };
}