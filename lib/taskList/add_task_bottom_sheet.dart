import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/Providers/app_config_provider.dart';
import 'package:todoapp/dialogUtils.dart';
import 'package:todoapp/firebase_utils.dart';
import 'package:todoapp/mytheme.dart';

import '../Providers/auth_provider.dart';
import '../Providers/task_list_provider.dart';
import '../data_classes/tasks.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  DateTime selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();
  String title = ' ';
  String description = ' ';
  late TaskListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<TaskListProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      color: provider.isDark() ? MyTheme.darkNavyColor : MyTheme.whiteColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 0, 0),
            child: Text(
              'Add New Task',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(45, 20, 45, 0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    onChanged: (text) {
                      title = text;
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please enter task title';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'enter your task',
                        hintStyle: TextStyle(
                            color: provider.isDark()
                                ? MyTheme.whiteColor
                                : MyTheme.blackColor)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: TextFormField(
                      onChanged: (text) {
                        description = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter task describtion';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'enter task describtion',
                          hintStyle: TextStyle(
                              color: provider.isDark()
                                  ? MyTheme.whiteColor
                                  : MyTheme.blackColor)),
                      maxLines: 3,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Selected date',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: provider.isDark()
                            ? MyTheme.whiteColor
                            : MyTheme.blackColor,
                        fontSize: 22),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      showCalendar();
                    },
                    child: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: MyTheme.primaryColor, fontSize: 22)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addTask();
                    },
                    child: Text(
                      'Add',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: MyTheme.whiteColor),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: MyTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void showCalendar() async {
    var chosendate = await showDatePicker(
      /// future
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (chosendate != null) {
      selectedDate = chosendate;
      setState(() {});
    }
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      /// add task to firebase
      Task task = Task(
        title: title,
        description: description,
        dateTime: selectedDate,
      );
      DialogUtils.showLoading(context, 'Loading...');
      var authProvider = Provider.of<AuthProvider>(context, listen: false);

      /// listen 3shan el provider m3mool bra el build
      FirebaseUtils.addTaskToFireStore(task, authProvider.currentUser!.id!)
          .then((value) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, 'Todo added succefully',
            posActionName: 'ok', posAction: () {
          Navigator.pop(context);
        });
      }).timeout(Duration(milliseconds: 500), onTimeout: () {
        // Fluttertoast.showToast(
        //     msg: "This is Center Short Toast",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0
        // );
        listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
        Navigator.pop(context);
      });
    }
  }
}
