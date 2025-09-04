import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task_bloc.dart';
import '../blocs/task_event.dart';
import '../blocs/task_state.dart';

class TaskScreen extends StatelessWidget {
  TaskScreen({super.key});

  // Text controller for the input field
  final TextEditingController titleInputField = TextEditingController();

  // Function to handle adding a new task
  void addNewTask(BuildContext context, TextEditingController controller) {
    // Check if input is empty -> show alert dialog
    if (controller.text.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Empty Task'),
          content: const Text('Please enter a task title before adding.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // If not empty -> dispatch AddTask event to BLoC
    context.read<TaskBloc>().add(AddTask(controller.text));
    controller.clear(); 

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task added')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task List')),

      body: Column(
        children: [
          // Input row (TextField + Add button)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Text field to type a new task
                Expanded(
                  child: TextField(
                    controller: titleInputField,
                    decoration: const InputDecoration(hintText: 'Enter task'),
                    // Pressing "Enter" to add the task
                    onSubmitted: (value) => addNewTask(context, titleInputField),
                  ),
                ),
                // Add button (same function as pressing Enter)
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => addNewTask(context, titleInputField),
                ),
              ],
            ),
          ),

          // Expanded section for displaying task list
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                // If no tasks -> show empty message
                if (state.tasks.isEmpty) {
                  return const Center(child: Text('No tasks yet'));
                }

                // Otherwise -> display tasks in a scrollable ListView
                return ListView.builder(
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) {
                    final task = state.tasks[index];

                    // Each task displayed as a ListTile
                    return ListTile(
                      // Task title (crossed out if completed)
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),

                      // Checkbox for marking task complete/incomplete
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) =>
                            context.read<TaskBloc>().add(ToggleTask(task.id)),
                      ),

                      // Delete button
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Show confirmation dialog before deleting
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Task'),
                              content: const Text('Are you sure you want to delete this task?'),
                              actions: [
                                // Cancel deletion
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('No'),
                                ),
                                // Confirm deletion
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    context.read<TaskBloc>().add(DeleteTask(task.id));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Task deleted')),
                                    );
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
