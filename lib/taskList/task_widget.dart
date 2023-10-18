import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/Providers/app_config_provider.dart';
import 'package:todoapp/Providers/task_list_provider.dart';
import 'package:todoapp/firebase_utils.dart';
import 'package:todoapp/mytheme.dart';
import 'package:todoapp/taskList/edit_task.dart';

import '../Providers/auth_provider.dart';
import '../data_classes/tasks.dart';

class TaskWidget extends StatefulWidget {
  Task task;

  TaskWidget({required this.task});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var listProvider = Provider.of<TaskListProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(12),
          child: Slidable(
            key: UniqueKey(),
            // The start action pane is the one at the left or the top side.
            startActionPane: ActionPane(
              ///fl shemal
              extentRatio: 0.25,
              // A motion is a widget used to control how the pane animates.
              motion: const ScrollMotion(),

              // A pane can dismiss the Slidable.
              dismissible: DismissiblePane(onDismissed: () {}),
              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: (context) {
                    FirebaseUtils.deleteTaskFromFireStore(
                            widget.task, authProvider.currentUser!.id!)
                        .then((_) {
                      print('dfgdfg');
                      listProvider.getAllTasksFromFireStore(
                          authProvider.currentUser!.id!);
                    });
                  },
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  backgroundColor: MyTheme.redColor,
                  foregroundColor: MyTheme.whiteColor,

                  ///icon color
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(EditTask.routename, arguments: widget.task);
              },
              child: Container(
                /// task container
                padding: EdgeInsets.all(10),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: provider.isDark()
                      ? MyTheme.darkNavyColor
                      : MyTheme.whiteColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: widget.task.isDone!
                          ? MyTheme.greenColor
                          : MyTheme.primaryColor,
                      height: 80,
                      width: 4,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.task.title ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: widget.task.isDone!
                                        ? MyTheme.greenColor
                                        : MyTheme.primaryColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time_outlined,
                                color: provider.isDark()
                                    ? MyTheme.whiteColor
                                    : MyTheme.blackColor,
                                size: 15,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.task.description ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: provider.isDark()
                                          ? MyTheme.whiteColor
                                          : MyTheme.blackColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                    InkWell(
                      onTap: () {
                        FirebaseUtils.editIsDone(
                            widget.task, authProvider.currentUser?.id ?? "");
                        widget.task.isDone = !widget.task.isDone!;
                        setState(() {});
                      },
                      child: widget.task.isDone!
                          ? Text(
                              'Done!',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: MyTheme.greenColor),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 7,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: MyTheme.primaryColor,
                              ),
                              child: Icon(
                                Icons.done,
                                color: MyTheme.whiteColor,
                                size: 28,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
