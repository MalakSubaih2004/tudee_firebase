
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../models/to_do.dart';

class HiveService {
  static const String boxName = 'task';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static Box get box => Hive.box(boxName);

  static Future<void> addTask(ToDo todo) async {
    await box.add({
      'title': todo.title,
      'description': todo.description,
      'isComplete': todo.isComplete,
    });
  }

  static List<ToDo> getTasks() {
    List<ToDo> tasks = [];
    for (int i = 0; i < box.length; i++) {
      final data = box.getAt(i);
      if (data != null) {
        tasks.add(
          ToDo(
            title: data['title'] ?? '',
            description: data['description'] ?? '',
            isComplete: data['isComplete'] ?? false,
          ),
        );
      }
    }
    return tasks;
  }

  static Future<void> updateTask(int index, ToDo todo) async {
    await box.putAt(index, {
      'title': todo.title,
      'description': todo.description,
      'isComplete': todo.isComplete,
    });
  }

  static Future<void> deleteTask(int index) async {
    await box.deleteAt(index);
  }
}