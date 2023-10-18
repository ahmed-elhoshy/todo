import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data_classes/tasks.dart';
import '../firebase_utils.dart';

class TaskListProvider extends ChangeNotifier {
  // data
  List<Task> taskList = [];
  DateTime selectedDate = DateTime.now();

  void getAllTasksFromFireStore(String uId) async {
    ///ana hena gbt list el tasks ml firebase w 7atetha f list 3adeya mn noo3 task
    QuerySnapshot<Task> querySnapshot =
        await FirebaseUtils.getTasksCollection(uId).get();

    /// List<QueryDocumentSnapshot<Task>  3ayzha tb2a List<Task>  fa h3ml map
    taskList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    // filtering date
    taskList = taskList.where((task) {
      if (task.dateTime?.day == selectedDate.day &&
          task.dateTime?.month == selectedDate.month &&
          task.dateTime?.year == selectedDate.year) {
        return true;
      }
      return false;
    }).toList();
    taskList.sort((Task task1, Task task2) {
      return task1.dateTime!.compareTo(task2.dateTime!);
    });
    notifyListeners();
  }

  void changeSelectedDate(DateTime newDate, String uId) {
    selectedDate = newDate;
    getAllTasksFromFireStore(uId);

    /// mesh mehtag notify listeners 3shan getall task feha n.l
  }
}
