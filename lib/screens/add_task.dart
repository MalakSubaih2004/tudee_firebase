import 'package:flutter/material.dart';
import '../models/to_do.dart';
import '../utils/HiveService.dart';
import '../widgets/custom_text_field.dart';

class AddTaskScreen extends StatefulWidget {
  final ToDo? taskToEdit;
  final int? taskIndex;

  const AddTaskScreen({super.key, this.taskToEdit, this.taskIndex});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;

  bool get isEditing => widget.taskToEdit != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.taskToEdit?.title ?? '',
    );
    _descController = TextEditingController(
      text: widget.taskToEdit?.description ?? '',
    );
  }

  void _saveOrUpdateTask() async {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isNotEmpty) {
      if (isEditing) {
        final updatedTodo = ToDo(
          title: title,
          description: desc,
          isComplete: widget.taskToEdit!.isComplete,
        );
        await HiveService.updateTask(widget.taskIndex!, updatedTodo);
      } else {
        final newTodo = ToDo(title: title, description: desc);
        await HiveService.addTask(newTodo);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE8E8),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 38),
                    Text(
                      isEditing ? 'Edit Task' : 'Add Task',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hintText: 'What needs to be done?',
                      controller: _titleController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Description (optional)',
                      controller: _descController,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _saveOrUpdateTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF49BAF2),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          isEditing ? 'Update' : 'Save',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
