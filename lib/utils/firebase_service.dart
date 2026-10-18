import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/to_do.dart';

class FirestoreService {
  final tasks = FirebaseFirestore.instance.collection('tasks');

  void addTask(ToDo todo) {
    tasks.add({
      'title': todo.title,
      'description': todo.description,
      'isComplete': todo.isComplete,
    });
  }

  Stream<List<ToDo>> getTasks() {
    return tasks.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ToDo(
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          isComplete: data['isComplete'] ?? false,
        );
      }).toList();
    });
  }

  Future<void> updateTask(int index, ToDo todo) async {
    final snapshot = await tasks.get();
    if (index < snapshot.docs.length) {
      final docId = snapshot.docs[index].id;
      await tasks.doc(docId).update({
        'title': todo.title,
        'description': todo.description,
        'isComplete': todo.isComplete,
      });
    }
  }

  Future<void> deleteTask(int index) async {
    final snapshot = await tasks.get();
    if (index < snapshot.docs.length) {
      final docId = snapshot.docs[index].id;
      await tasks.doc(docId).delete();
    }
  }
}
