abstract class TaskEvent {}

class AddTask extends TaskEvent {
  final String title;
  final String? content;

  AddTask(this.title, {this.content});
}

class ToggleTask extends TaskEvent {
  final String id;
  ToggleTask(this.id);
}

class DeleteTask extends TaskEvent {
  final String id;
  DeleteTask(this.id);
}

class LoadTasks extends TaskEvent {}