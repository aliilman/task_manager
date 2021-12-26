import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:task_manager/models/task.dart';

class TaskController extends GetxController {
  final taskList = <Task>[
    Task(
        title: 'Gürev 1',
        note: 'Note something',
        isCompleted: 0,
        startTime: '8:19',
        endTime: '4:34',
        color: 2),
    Task(
        title: 'Gürev 1',
        note: 'Note something',
        isCompleted: 0,
        startTime: '8:19',
        endTime: '4:34',
        color: 2),
  ];
  getTasks() {}
}
