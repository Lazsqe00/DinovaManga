import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/manga_controller.dart';
import 'page_history.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MangaController controller = Get.find<MangaController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(
              Get.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            title: Text(Get.isDarkMode ? "Dark Theme" : "Light Theme"),
            trailing: Switch(
              value: Get.isDarkMode,
              onChanged: (value) async {
                final prefs = await SharedPreferences.getInstance();
                if (Get.isDarkMode) {
                  Get.changeThemeMode(ThemeMode.light);
                  await prefs.setBool('isDark', false);
                } else {
                  Get.changeThemeMode(ThemeMode.dark);
                  await prefs.setBool('isDark', true);
                }
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.history),
            title: Text("History"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Get.to(() => PageHistory());
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("About"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
