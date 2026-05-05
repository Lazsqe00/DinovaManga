import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/manga_controller.dart';

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
              onChanged: (value) {
                if (Get.isDarkMode) {
                  Get.changeThemeMode(ThemeMode.light);
                } else
                  Get.changeThemeMode(ThemeMode.dark);
              },
            ),
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
