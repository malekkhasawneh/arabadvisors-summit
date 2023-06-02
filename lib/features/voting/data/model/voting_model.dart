class VotingModel {
  int id;
  String title;
  bool active;
  List<Question> questions;

  VotingModel({
    required this.id,
    required this.title,
    required this.active,
    required this.questions,
  });

  factory VotingModel.fromJson(Map<String, dynamic> json) => VotingModel(
        id: json["id"] ?? 0,
        title: json["title"] ?? '',
        active: json["active"] ?? 0,
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "active": active,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}

class Question {
  int id;
  String question;
  List<Answer> answers;
  int selectedAnswer;

  Question({
    required this.id,
    required this.question,
    required this.answers,
    this.selectedAnswer = -1,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"] ?? 0,
        question: json["question"] ?? "",
        answers:
            List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
      };
}

class Answer {
  int id;
  String answer;
  int votes;

  Answer({
    required this.id,
    required this.answer,
    required this.votes,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json["id"] ?? 0,
        answer: json["answer"] ?? '',
        votes: json["votes"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "answer": answer,
        "votes": votes,
      };
}
