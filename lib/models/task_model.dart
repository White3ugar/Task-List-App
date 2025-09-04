import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isCompleted;
  
  @HiveField(3)
  final String? content;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.content,
  });

  Task updateWith({String? id, String? title, bool? isCompleted,String? content}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      content: content ?? this.content,
    );
  }
}