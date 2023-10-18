import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/data_classes/tasks.dart';
import 'package:todoapp/mytheme.dart';

import '../Providers/app_config_provider.dart';
import '../Providers/auth_provider.dart';
import '../Providers/task_list_provider.dart';
import '../dialogUtils.dart';
import '../firebase_utils.dart';

class EditTask extends StatefulWidget {
  const EditTask({super.key});

  static const String routename = 'EditTaskScreen';

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  var formKey = GlobalKey<FormState>();
  late TaskListProvider listProvider;
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  late DateTime selectedDate;
  Task? task;

  @override
  void initState() {
    // method bttnadah mra wahda bas abl el build
    super.initState();
  }

  Widget build(BuildContext context) {
    if (task == null) {
      task = ModalRoute.of(context)!.settings.arguments
          as Task; // lw el task info. b null hotly el values dih .... btt3ml mra wahda bs
      titleController.text = task!.title ?? '';
      descriptionController.text = task!.description ?? '';
      selectedDate = task!.dateTime ?? DateTime.now();
    }
    listProvider = Provider.of<TaskListProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: MyTheme.limeColor,
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 100,
            backgroundColor: MyTheme.primaryColor,
            title: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                'To Do List',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: MyTheme.whiteColor),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Center(
                    child: Container(
                  padding: EdgeInsets.all(20),
                  height: 550,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: provider.isDark()
                        ? MyTheme.darkNavyColor
                        : MyTheme.whiteColor,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 25, 0, 0),
                        child: Text(
                          'Edit Task',
                          textAlign: TextAlign.center,
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
                                controller: titleController,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Please enter task title';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Edit your task',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: TextFormField(
                                  controller: descriptionController,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please enter task describtion';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Edit task describtion',
                                  ),
                                  maxLines: 3,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Selected date',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: MyTheme.primaryColor,
                                            fontSize: 22)),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  addTask();
                                },
                                child: Text(
                                  'Save Changes',
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
                )
                    // Container(
                    //   padding: EdgeInsets.all(20),
                    //   height: 550,
                    //   width: 350,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(15),
                    //     color: MyTheme.whiteColor,
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         'Edit Task',
                    //         textAlign: TextAlign.center,
                    //         style: Theme.of(context).textTheme.titleMedium,
                    //       ),
                    //       Form(
                    //         key: formKey,
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.stretch,
                    //           children: [
                    //             SizedBox(
                    //               height: 30,
                    //             ),
                    //             TextFormField(
                    //               validator: (text) {
                    //                 if (text == null || text.isEmpty) {
                    //                   return 'Please enter task title';
                    //                 }
                    //                 return null;
                    //               },
                    //               decoration: InputDecoration(
                    //                 hintText: 'Edit title',
                    //               ),
                    //               // maxLines: 3,
                    //             ),
                    //             SizedBox(
                    //               height: 30,
                    //             ),
                    //             TextFormField(
                    //               validator: (text) {
                    //                 if (text == null || text.isEmpty) {
                    //                   return 'Please enter task describtion';
                    //                 }
                    //                 return null;
                    //               },
                    //               decoration: InputDecoration(
                    //                 hintText: 'Edit Task Details',
                    //               ),
                    //               maxLines: 2,
                    //             ),
                    //             SizedBox(
                    //               height: 30,
                    //             ),
                    //             Text(
                    //               'Seleted date',
                    //               style: Theme.of(context).textTheme.titleLarge,
                    //             ),
                    //             SizedBox(
                    //               height: 30,
                    //             ),
                    //             Text('20/9',
                    //                 textAlign: TextAlign.center,
                    //                 style: Theme.of(context)
                    //                     .textTheme
                    //                     .titleLarge!
                    //                     .copyWith(color: MyTheme.primaryColor)),
                    //             SizedBox(
                    //               height: 90,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       ElevatedButton(
                    //         onPressed: () {
                    //           addTask();
                    //         },
                    //         child: Text('Save Changes'),
                    //         style: ElevatedButton.styleFrom(
                    //           primary: MyTheme.primaryColor,
                    //           elevation: 0,
                    //           minimumSize: Size(250, 50),
                    //           shape: StadiumBorder(),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    )
              ],
            ),
          ),
        ),
      ],
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
      task!.title = titleController.text;
      task!.description = descriptionController.text;
      DialogUtils.showLoading(context, 'Loading...');
      var authProvider = Provider.of<AuthProvider>(context, listen: false);

      /// listen 3shan el provider m3mool bra el build
      FirebaseUtils.editTask(task!, authProvider.currentUser!.id!)
          .then((value) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, 'Task Editing succefully',
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
