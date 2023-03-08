import 'package:flutter/material.dart';

import 'cache_management_page.dart';

class OthersSettingsPage extends StatelessWidget {
  const OthersSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("其他设置"),
      ),
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
