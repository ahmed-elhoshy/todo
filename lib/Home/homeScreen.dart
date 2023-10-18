import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/Login/login_screen.dart';
import 'package:todoapp/Providers/app_config_provider.dart';
import 'package:todoapp/Providers/task_list_provider.dart';
import 'package:todoapp/Settings/SettingsScreen.dart';
import 'package:todoapp/mytheme.dart';
import 'package:todoapp/taskList/add_task_bottom_sheet.dart';
import 'package:todoapp/taskList/task_screen.dart';

import '../Providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routename = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<Widget> tabs = [TaskScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    var listProvider = Provider.of<TaskListProvider>(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor:
              provider.isDark() ? MyTheme.darkBlackColor : MyTheme.limeColor,
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 80,
            backgroundColor: MyTheme.primaryColor,
            title: Text(
              '${AppLocalizations.of(context)!.app_title} ${authProvider.currentUser?.name ?? " .."}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 25),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    listProvider.taskList = [];
                    authProvider.currentUser = null;
                    Navigator.pushNamed(context, LoginScreen.routename);
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color:
                provider.isDark() ? MyTheme.darkNavyColor : MyTheme.whiteColor,
            shape: CircularNotchedRectangle(),
            notchMargin: 8,
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                selectedIndex = index;
                setState(() {});
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.list,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings_outlined,
                  ),
                  label: 'Settings',
                ),
              ],
              // backgroundColor: MyTheme.whiteColor,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showAddTaskBottomSheet();
            },
            elevation: 0,
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: tabs[selectedIndex],
        )
      ],
    );
  }

  void showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: ((context) => AddTaskBottomSheet()),
    );
  }
}
