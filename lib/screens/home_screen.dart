import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../models/to_do.dart';
import '../utils/HiveService.dart';
import '../utils/pref_helper.dart';
import '../widgets/empty_tasks_widget.dart';
import '../widgets/stat_card.dart';
import 'add_task.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE8E8),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF49BAF2),
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: const Color(0xFF49BAF2),
              child: const Text(
                'Tudee',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CherryBomb',
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    FutureBuilder<String>(
                      future: PrefHelper.getUserName(),
                      builder: (context, snapshot) {
                        final userName = snapshot.data ?? 'User';
                        return Text(
                          'Welcome $userName',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: HiveService.box.listenable(),
                        builder: (context, Box box, _) {
                          final List<ToDo> allTasks = HiveService.getTasks();

                          final int toDoCount = allTasks
                              .where((t) => !t.isComplete)
                              .length;
                          final int doneCount = allTasks
                              .where((t) => t.isComplete)
                              .length;

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: StatCard(
                                      count: '$toDoCount',
                                      label: 'To do',
                                      backgroundColor: const Color(0xFF8AD1A6),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: StatCard(
                                      count: '$doneCount',
                                      label: 'Done',
                                      backgroundColor: const Color(0xFF9E8CDD),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              Expanded(
                                child: box.isEmpty
                                    ? const Center(child: EmptyTasksWidget())
                                    : ListView.builder(
                                        itemCount: allTasks.length,
                                        itemBuilder: (context, index) {
                                          final todo = allTasks[index];

                                          return Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 4,
                                                  ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddTaskScreen(
                                                          taskToEdit: todo,
                                                          taskIndex: index,
                                                        ),
                                                  ),
                                                );
                                              },
                                              leading: Checkbox(
                                                value: todo.isComplete,
                                                activeColor: const Color(
                                                  0xFF49BAF2,
                                                ),
                                                onChanged: (bool? value) {
                                                  todo.isComplete =
                                                      value ?? false;
                                                  HiveService.updateTask(
                                                    index,
                                                    todo,
                                                  );
                                                },
                                              ),
                                              title: Text(
                                                todo.title,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  decoration: todo.isComplete
                                                      ? TextDecoration
                                                            .lineThrough
                                                      : null,
                                                  color: todo.isComplete
                                                      ? Colors.grey
                                                      : Colors.black87,
                                                ),
                                              ),
                                              subtitle:
                                                  todo.description
                                                      .trim()
                                                      .isNotEmpty
                                                  ? Text(
                                                      todo.description,
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 13,
                                                      ),
                                                    )
                                                  : null,
                                              trailing: IconButton(
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.redAccent,
                                                ),
                                                onPressed: () =>
                                                    HiveService.deleteTask(
                                                      index,
                                                    ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
