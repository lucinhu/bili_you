import 'package:bili_you/pages/settings_page/pages/cache_management_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("设置")),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Text(
            "缓存",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ListTile(
          title: const Text(
            "缓存管理",
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CacheManagementPage(),
            ));
          },
        )
      ]),
    );
  }
}
