abstract class TaskEvent {}

class AddTask extends TaskEvent {
  final String title;
  AddTask(this.title);
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