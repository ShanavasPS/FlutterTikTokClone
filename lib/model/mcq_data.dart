class McqData {
  final String type;
  final int id;
  final String playlist;
  final String description;
  final String image;
  final String question;
  final List<McqOption> options;
  final UserData user;

  McqData({
    required this.type,
    required this.id,
    required this.playlist,
    required this.description,
    required this.image,
    required this.question,
    required this.options,
    required this.user,
  });

  factory McqData.fromJson(Map<String, dynamic> json) {
    return McqData(
      type: json['type'],
      id: json['id'],
      playlist: json['playlist'],
      description: json['description'],
      image: json['image'],
      question: json['question'],
      options: List<McqOption>.from(json['options'].map((option) => McqOption.fromJson(option))),
      user: UserData.fromJson(json['user']),
    );
  }
}

class McqOption {
  final String id;
  final String answer;

  McqOption({
    required this.id,
    required this.answer,
  });

  factory McqOption.fromJson(Map<String, dynamic> json) {
    return McqOption(
      id: json['id'],
      answer: json['answer'],
    );
  }
}

class UserData {
  final String name;
  final String avatar;

  UserData({
    required this.name,
    required this.avatar,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}