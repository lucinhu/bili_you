import 'package:bili_you/pages/login/password_login/index.dart';
import 'package:bili_you/pages/login/web_login/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'index.dart';

class PhoneLoginPage extends GetView<PhoneLoginController> {
  const PhoneLoginPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView(context) {
    var outlineInputBorder = OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline));
    return Center(
        child: ListView(
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            children: [
          Card(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 10,
                  left: 10,
                  right: 10,
                  bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      IntrinsicWidth(
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              labelText: "地区/国家代码",
                              enabledBorder: outlineInputBorder,
                              focusedBorder: outlineInputBorder),
                          hint: const Text("+86 中国大陆"),
                          items: controller.countryItems,
                          onChanged: (value) {
                            controller.countryId = int.tryParse((value
                                        as Map<String, dynamic>)['country_id']
                                    as String) ??
                                0;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                            onChanged: (String value) {
                              controller.tel = int.tryParse(value) ?? 0;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: "手机号",
                                enabledBorder: outlineInputBorder,
                                focusedBorder: outlineInputBorder),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ]),
                      ),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                    height: 30,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                            onChanged: (value) {
                              controller.messageCode = int.tryParse(value) ?? 0;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: "验证码",
                                enabledBorder: outlineInputBorder,
                                focusedBorder: outlineInputBorder),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ]),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            controller.startLogin();
                          },
                          child: const Text("获取验证码")),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  )
                ],
              )),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  controller.startSmsLogin();
                },
                child: const Text(
                  "   登录   ",
                  style: TextStyle(fontSize: 16),
                )),
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhoneLoginController>(
      init: PhoneLoginController(),
      id: "phone_login",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("短信登录"),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.off(() => const PasswordLoginPage());
                  },
                  child: const Text("密码登录")),
              TextButton(
                  onPressed: () {
                    Get.off(() => const WebLoginPage());
                  },
                  child: const Text("网站登录"))
            ],
          ),
          body: _buildView(context),
        );
      },
    );
  }
}
