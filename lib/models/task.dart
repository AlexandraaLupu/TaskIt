import 'dart:io';

class Task {
  int? id;
  String name;
  String date;
  String location;
  String description;
  bool isCompleted;
  String priority;

  Task({
    this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.isCompleted,
    required this.priority
  });

  // Serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'location': location,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'priority': priority,
    };
  }

  // Deserialization
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      date: map['date'],
      location: map['location'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      priority: map['priority'],
    );
  }

  @override
  String toString() {
    return "Task :"
        "\nid: $id\n"
        "name: $name\n"
        "date: $date\n"
        "location: $location\n"
        "description: $description\n"
        "isCompleted: $isCompleted\n"
        "priority: $priority";
  }
}