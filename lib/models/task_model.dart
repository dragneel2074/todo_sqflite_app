import 'dart:convert';

class Task {
  final int? id;
  final String? title;
  final DateTime? date;
   int? status;
  Task({
     this.id,
    required this.title,
    required this.date,
    this.status,
  });
  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date!.millisecondsSinceEpoch,
      'status': status,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}
