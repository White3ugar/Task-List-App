import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task_bloc.dart';
import '../blocs/task_event.dart';
import '../blocs/task_state.dart';

// Enum to represent the current filter state
enum TaskFilter { all, completed, incomplete }

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController titleInputField = TextEditingController();
  final TextEditingController contentInputField = TextEditingController();

  // Default filter state
  TaskFilter currentFilter = TaskFilter.all;

  // Function to handle adding a new task
  void addNewTask(BuildContext context) {
    // Check if title is empty -> not allowed
    if (titleInputField.text.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.black, 
          title: const Text(
            'Empty Title',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Please enter a task title before adding.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
      return;
    }

    context.read<TaskBloc>().add(AddTask(titleInputField.text,content: contentInputField.text.isEmpty ? null : contentInputField.text,));

    titleInputField.clear();
    contentInputField.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task added')),
    );
  }

  // Function to build a filter chip
  Widget buildFilterChip(String label, TaskFilter filterType) {
    final isSelected = currentFilter == filterType;
    return FilterChip(
      label: Text(
        label,
        style: const TextStyle( color:  Colors.white),
      ),
      selected: isSelected,
      onSelected: (_) => setState(() => currentFilter = filterType),
      selectedColor: Colors.black,
      backgroundColor: Colors.black, 
      checkmarkColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task List',
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          // Input row (TextField + Add button)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Row(
                  children: [
                    Flexible(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 600, 
                        ),
                        child: TextField(
                          controller: titleInputField,
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            hintText: 'Enter title',
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          onSubmitted: (_) => addNewTask(context),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.black),
                      onPressed: () => addNewTask(context),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Content row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: contentInputField,
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          hintText: 'Enter content (optional)',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),

          // Filter buttons row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildFilterChip("All", TaskFilter.all),
                const SizedBox(width: 8),
                buildFilterChip("Completed", TaskFilter.completed),
                const SizedBox(width: 8),
                buildFilterChip("Incomplete", TaskFilter.incomplete),
              ],
            ),
          ),

          // Display task list
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                // Apply filter to the task list
                final filteredTasks = state.tasks.where((task) {
                  switch (currentFilter) {
                    case TaskFilter.completed: return task.isCompleted;
                    case TaskFilter.incomplete: return !task.isCompleted;
                    case TaskFilter.all:
                    default:
                      return true;
                  }
                }).toList();

                if (filteredTasks.isEmpty) {
                  return const Center(child: Text('No tasks found'));
                }

                // Task list (shows tasks based on selected filter)
                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];

                    return ListTile(
                      // Display task title (strikethrough if completed)
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),

                      subtitle: task.content != null && task.content!.isNotEmpty
                          ? Text(
                              task.content!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          : null,

                      // Checkbox for marking task complete/incomplete
                      leading: Checkbox(
                        value: task.isCompleted,
                        activeColor: Colors.black,
                        onChanged: (_) => context.read<TaskBloc>().add(ToggleTask(task.id))
                      ),

                      // Delete button
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Show confirmation dialog before deleting
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: Colors.black,
                              title: const Text(
                                'Delete Task',
                                style: TextStyle(color: Colors.white), 
                              ),
                              content: const Text(
                                'Are you sure you want to delete this task?',
                                style: TextStyle(color: Colors.white),
                              ),
                              actions: [
                                // Cancel button
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text(
                                    'No',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),

                                // Confirm delete button
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop(); 
                                    context.read<TaskBloc>().add(DeleteTask(task.id)); 

                                    // Show confirmation message
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
              }
            ),
          ),
        ],
      ),
    );
  }
}
