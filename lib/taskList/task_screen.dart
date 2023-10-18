import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/Providers/app_config_provider.dart';
import 'package:todoapp/Providers/task_list_provider.dart';
import 'package:todoapp/mytheme.dart';
import 'package:todoapp/taskList/task_widget.dart';

import '../Providers/auth_provider.dart';

class TaskScreen extends StatefulWidget {
  static const String routename = 'TaskScreen';

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var listProvider = Provider.of<TaskListProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);

    /// listen 3shan el provider m3mool bra el build
    if (listProvider.taskList.isEmpty) {
      listProvider.getAllTasksFromFireStore(authProvider.currentUser?.id ?? "");
    }
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        CalendarTimeline(
          initialDate: listProvider.selectedDate,
          firstDate: DateTime.now().subtract(Duration(days: 365)),
          lastDate: DateTime.now().add(Duration(days: 365)),
          onDateSelected: (date) {
            listProvider.changeSelectedDate(
                date, authProvider.currentUser!.id!);
          },
          leftMargin: 20,
          monthColor:
              provider.isDark() ? MyTheme.whiteColor : MyTheme.blackColor,
          dayColor: MyTheme.primaryColor,
          activeDayColor: Colors.white,
          activeBackgroundDayColor: MyTheme.primaryColor,
          dotsColor: Color(0xFF333A47),
          selectableDayPredicate: (date) => true,
          locale: 'en_ISO',
        ),
        SizedBox(
          height: 15,
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return TaskWidget(
                task: listProvider.taskList[index],
              );
            },
            itemCount: listProvider.taskList.length,
          ),
        )
      ],
    );
  }
}
