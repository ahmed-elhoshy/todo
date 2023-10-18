import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/Providers/app_config_provider.dart';
import 'package:todoapp/Settings/language_bottom_sheet.dart';
import 'package:todoapp/Settings/theme_bottom_sheet.dart';
import 'package:todoapp/mytheme.dart';

class SettingsScreen extends StatefulWidget {
  static const String routename = 'SettingsScreen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text(
              'Theming',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Mode',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                showThemeBottomSheet();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: provider.isDark()
                        ? MyTheme.darkNavyColor
                        : MyTheme.whiteColor,
                    border: Border.all(color: MyTheme.primaryColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      provider.isDark() ? 'Dark' : 'Light',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: provider.isDark()
                          ? MyTheme.primaryColor
                          : MyTheme.blackColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Language',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                showLangBottomSheet();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: provider.isDark()
                        ? MyTheme.darkNavyColor
                        : MyTheme.whiteColor,
                    border: Border.all(color: MyTheme.primaryColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'English',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: provider.isDark()
                          ? MyTheme.primaryColor
                          : MyTheme.blackColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showThemeBottomSheet() {
    showModalBottomSheet(
        context: context,

        /// to reed context make class stateful
        builder: ((context) => ThemeBottomSheet()));
  }

  void showLangBottomSheet() {
    showModalBottomSheet(
        context: context, builder: ((context) => LanguageBottomSheet()));
  }
}
