import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class PasswordLoginPage extends GetView<PasswordLoginController> {
  const PasswordLoginPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView(context) {
    var outlineInputBorder = OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline));
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) {
              controller.account = value;
            },
            decoration:
                InputDecoration(labelText: "账号", border: outlineInputBorder),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) {
              controller.password = value;
            },
            decoration:
                InputDecoration(labelText: "密码", border: outlineInputBorder),
          ),
          const SizedBox(
            height: 20,
          ),
          OutlinedButton(
              onPressed: () {
                controller.startLogin();
              },
              child: const Text("登录"))
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PasswordLoginController>(
      init: PasswordLoginController(),
      id: "password_login",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("密码登录")),
          body: _buildView(context),
        );
      },
    );
  }
}
