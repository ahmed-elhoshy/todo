import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/Home/homeScreen.dart';
import 'package:todoapp/Login/login_screen.dart';
import 'package:todoapp/Providers/app_config_provider.dart';
import 'package:todoapp/Providers/auth_provider.dart';
import 'package:todoapp/Providers/task_list_provider.dart';
import 'package:todoapp/Register/register_screen.dart';
import 'package:todoapp/Settings/SettingsScreen.dart';
import 'package:todoapp/mytheme.dart';
import 'package:todoapp/taskList/edit_task.dart';
import 'package:todoapp/taskList/task_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseFirestore.instance.disableNetwork();
  // FirebaseFirestore.instance.settings =
  //     Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AppConfigProvider()),
    ChangeNotifierProvider(create: (context) => TaskListProvider()),
    ChangeNotifierProvider(create: (context) => AuthProvider())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return MaterialApp(
      initialRoute: RegisterScreen.routename,
      routes: {
        LoginScreen.routename: (context) => LoginScreen(),
        RegisterScreen.routename: (context) => RegisterScreen(),
        HomeScreen.routename: (context) => HomeScreen(),
        TaskScreen.routename: (context) => TaskScreen(),
        SettingsScreen.routename: (context) => SettingsScreen(),
        EditTask.routename: (context) => EditTask(),
      },
      debugShowCheckedModeBanner: false,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: provider.appTheme,
      locale: Locale(provider.appLanguage),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
