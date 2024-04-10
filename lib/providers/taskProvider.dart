import 'dart:io';
import 'package:flutter/material.dart';
import '../data_repository/dbHelper.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider() {
    //debugPrint("TP constructor");
    initDatabase();
  }

  late TextEditingController nameController = TextEditingController();
  late TextEditingController dateController = TextEditingController();
  late TextEditingController locationController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  late bool isCompleted = false;
  late String priority = "Low";

  List<Task> allTasks = [];

  Future<void> initDatabase() async {
    //debugPrint("TP initDatabase");
    await DBhelper.dbHelper.initDatabase();
    getTasks();
  }

  getTasks() async {
    //debugPrint("TP get");
    allTasks = await DBhelper.dbHelper.getAllTasks();
    notifyListeners();
  }

  insert() async {

    Task task = Task(
      name: nameController.text,
      date: dateController.text,
      location: locationController.text,
      description: descriptionController.text,
      isCompleted: isCompleted,
      priority: priority,
    );
   // debugPrint('${task.name} ${task.date} ${task.location} ${task.description} ${task.isCompleted} ${task.priority}');
    int taskId = await DBhelper.dbHelper.insert(task);
    task.id = taskId;
    allTasks.add(task);
    notifyListeners();
  }

  update(Task task) async {
    //debugPrint("TP update");
    await DBhelper.dbHelper.update(task);
    var index = allTasks.indexWhere((e) => e.id == task.id);
    if (index != -1) {
      allTasks[index] = task;
      notifyListeners();
    }
  }

  delete(int taskId) async {
    //debugPrint("TP delete");
    await DBhelper.dbHelper.delete(taskId);
    allTasks.removeWhere((e) => e.id == taskId);
    notifyListeners();
  }

  updateFlag(int taskId, bool isCompleted) async {
    //debugPrint("TP updateFlag");
    await DBhelper.dbHelper.updateFlag(taskId, isCompleted);
    var index = allTasks.indexWhere((element) => element.id == taskId);
    allTasks[index].isCompleted = isCompleted;
    notifyListeners();
  }


  void disposeControllers() {
    nameController.dispose();
    dateController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }
}