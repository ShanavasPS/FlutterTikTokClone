class AnswerData {
  final int id;
  final List<OptionData> correctOptions;

  AnswerData({
    required this.id,
    required this.correctOptions,
  });

  factory AnswerData.fromJson(Map<String, dynamic> json) {
    return AnswerData(
      id: json['id'],
      correctOptions: List<OptionData>.from(json['correct_options']
          .map((optionJson) => OptionData.fromJson(optionJson))),
    );
  }
}

class OptionData {
  final String id;
  final String answer;

  OptionData({
    required this.id,
    required this.answer,
  });

  factory OptionData.fromJson(Map<String, dynamic> json) {
    return OptionData(
      id: json['id'],
      answer: json['answer'],
    );
  }
}
