import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task_model.dart';
import 'package:hive/hive.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final Box<Task> taskBox = Hive.box<Task>('tasksBox');

  TaskBloc() : super(TaskState()) {
    // Load tasks from Hive when the bloc is created
    on<LoadTasks>((event, emit) {
      emit(TaskState(tasks: taskBox.values.toList()));
    });

    // Handle adding a new task
    on<AddTask>((event, emit) {
      final newTask = Task(id: DateTime.now().toString(), title: event.title);
      taskBox.add(newTask); // save to Hive

      // Get the current task list and define as updatedTasks
      final updatedTasks = List<Task>.from(state.tasks);

      // Add the new task into the updatedTasks
      updatedTasks.add(newTask);

      // Emit a new TaskState with the updatedTasks
      emit(TaskState(tasks: updatedTasks));
    });

    // Handle toggling task completion
    on<ToggleTask>((event, emit) {
      final taskIndex = taskBox.values.toList().indexWhere((task) => task.id == event.id);
      if (taskIndex != -1) {
        final task = taskBox.getAt(taskIndex)!;
        final updated = task.updateWith(isCompleted: !task.isCompleted);
        taskBox.putAt(taskIndex, updated); // update Hive
      }
      emit(TaskState(tasks: taskBox.values.toList()));
    });

    // Handle deleting a task
    on<DeleteTask>((event, emit) {
      final taskIndex = taskBox.values.toList().indexWhere((task) => task.id == event.id);
      if (taskIndex != -1) {
        taskBox.deleteAt(taskIndex); // delete from Hive
      }
      emit(TaskState(tasks: taskBox.values.toList()));
    });
  }
}
