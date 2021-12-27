import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:task_manager/db/db_helper.dart';
import 'package:task_manager/models/task.dart';

class TaskController extends GetxController {
  // Görev listesi
  final RxList<Task> tasksList = <Task>[].obs;

// Görevi eklme fonksiyonu
  addTask({Task? task}) {
    debugPrint('addTask called');
    return DBHelper.insert(task);
  }

// tablodan Görevi alma fonksiyonu
  Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    tasksList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

// Görevi silme fonksiyonu
  void deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

// Görevin halini değiştirme fonksiyonu
  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
