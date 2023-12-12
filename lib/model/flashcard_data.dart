class FlashcardData {
  final String type;
  final int id;
  final String playlist;
  final String flashcardFront;
  final String flashcardBack;
  final String description;
  final UserData user;
  late List<bool> ratingSelection = [false, false, false, false, false];

  FlashcardData({
    required this.type,
    required this.id,
    required this.playlist,
    required this.flashcardFront,
    required this.flashcardBack,
    required this.description,
    required this.user,
  });

  factory FlashcardData.fromJson(Map<String, dynamic> json) {
    return FlashcardData(
      type: json['type'],
      id: json['id'],
      playlist: json['playlist'],
      flashcardFront: json['flashcard_front'],
      flashcardBack: json['flashcard_back'],
      description: json['description'],
      user: UserData.fromJson(json['user']),
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