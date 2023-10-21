import 'package:flutter/material.dart';

void main() {
  runApp(PsychologicalTestApp());
}

class PsychologicalTestApp extends StatefulWidget {
  const PsychologicalTestApp();

  @override
  _PsychologicalTestAppState createState() => _PsychologicalTestAppState();
}

class _PsychologicalTestAppState extends State<PsychologicalTestApp> {
  int score = 0;
  String resultText = '';

  final List<String> questions = [
    '1. Як ви відчуваєте себе зараз?',
    '2. Як ви ставитеся до змін?',
    '3. Як ви багато часу проводите з друзями?',
    '4. Як ви реагуєте на стрес?',
    '5. Як ви вирішуєте конфлікти?',
    '6. Як ви ставитеся до нових викликів?',
    '7. Як ви виражаєте свої емоції?',
    '8. Як ви вирішуєте проблеми?',
    '9. Як ви впораєтеся з негативними думками?',
    '10. Як ви відноситесь до саморозвитку?'
  ];

  final List<List<String>> options = [
    ['Добре', 'Задовільно', 'Погано'],
    ['Позитивно', 'Байдуже', 'Негативно'],
    ['Часто', 'Іноді', 'Рідко'],
    ['Спокійно', 'Нервово', 'Агресивно'],
    ['Розв\'язую на місці', 'Вибираю компроміс', 'Уникаю'],
    ['З ентузіазмом', 'Спокійно', 'Не впевнений'],
    ['Вільно висловлюю', 'Стримую', 'Приховую'],
    ['Аналізую і шукаю рішення', 'Чекаю, поки само вирішиться', 'Звертаюсь до інших'],
    ['Шукаю позитивні моменти', 'Не звертаю увагу', 'Занурююсь в негатив'],
    ['Завжди розвиваюся', 'Іноді', 'Не цікавлюся']
  ];

  List<List<bool>> selectedAnswers =
      List.generate(10, (index) => List.generate(3, (index) => false));

  int currentQuestionIndex = 0;
  bool isTestCompleted = false;

  void answerQuestion(int questionIndex, int answerIndex) {
    setState(() {
      selectedAnswers[questionIndex] =
          List.generate(3, (index) => index == answerIndex);
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      }
    });
  }

  void submitAnswers() {
    int totalScore = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i][0]) {
        totalScore += 2;
      } else if (selectedAnswers[i][1]) {
        totalScore += 1;
      }
    }

    setState(() {
      score = totalScore;
      isTestCompleted = true;
      resultText = getResultText(score);
    });
  }

  void resetTest() {
    setState(() {
      score = 0;
      resultText = '';
      currentQuestionIndex = 0;
      selectedAnswers =
          List.generate(10, (index) => List.generate(3, (index) => false));
      isTestCompleted = false;
    });
  }

  String getResultText(int score) {
    if (score >= 15) {
      return 'Позитивний результат';
    } else if (score >= 10) {
      return 'Задовільний результат';
    } else {
      return 'Негативний результат';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Психологічний тест'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                questions[currentQuestionIndex],
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              for (var i = 0; i < options[currentQuestionIndex].length; i++)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: selectedAnswers[currentQuestionIndex][i],
                      onChanged: (value) {
                        answerQuestion(currentQuestionIndex, i);
                      },
                    ),
                    Text(options[currentQuestionIndex][i]),
                  ],
                ),
              ElevatedButton(
                onPressed: () {
                  currentQuestionIndex < questions.length - 1
                      ? nextQuestion()
                      : submitAnswers();
                },
                child: Text(
                  currentQuestionIndex < questions.length - 1
                      ? 'Наступне питання'
                      : 'Отримати результат',
                ),
              ),
              if (isTestCompleted)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ваш результат: $score',
                      style: const TextStyle(fontSize: 24),
                    ),
                    Text(
                      'Ваша оцінка: $resultText',
                      style: const TextStyle(fontSize: 24),
                    ),
                    ElevatedButton(
                      onPressed: resetTest,
                      child: const Text('Перезапустити тест'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
