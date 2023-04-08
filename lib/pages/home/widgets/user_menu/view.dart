import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:bili_you/pages/about/about_page.dart';
import 'package:bili_you/pages/history/history_page.dart';
import 'package:bili_you/pages/login/web_login/view.dart';
import 'package:bili_you/pages/settings_page/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'index.dart';

class UserMenuPage extends GetView<UserMenuController> {
  const UserMenuPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView(context) {
    return Dialog(
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 15, bottom: 10),
                  child: MaterialButton(
                    clipBehavior: Clip.antiAlias,
                    onPressed: () {},
                    shape: const CircleBorder(eccentricity: 0),
                    child: FutureBuilder(
                      future: controller.loadOldFace(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ValueListenableBuilder(
                            valueListenable: BiliYouStorage.user
                                .listenable(keys: [UserStorageKeys.userFace]),
                            builder: (context, value, child) {
                              return CachedNetworkImage(
                                cacheWidth: (80 *
                                        MediaQuery.of(context).devicePixelRatio)
                                    .toInt(),
                                cacheHeight: (80 *
                                        MediaQuery.of(context).devicePixelRatio)
                                    .toInt(),
                                //头像
                                cacheManager: controller.cacheManager,
                                width: 80,
                                height: 80,
                                imageUrl: value.get(UserStorageKeys.userFace,
                                    defaultValue: controller.faceUrl.value),
                                placeholder: () => const SizedBox(
                                  width: 80,
                                  height: 80,
                                ),
                              );
                            },
                          );
                        } else {
                          return Container(
                            color: Theme.of(context).colorScheme.primary,
                          );
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            controller.name.value,
                            style: const TextStyle(fontSize: 17),
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Obx(() => Text("LV${controller.level.value}",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface))),
                          const SizedBox(
                            width: 20,
                          ),
                          Obx(() => Text(
                                "${controller.currentExp}/${controller.level.value != 6 ? controller.nextExp : '--'}",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Theme.of(context).hintColor),
                              ))
                        ],
                      ),
                      SizedBox.fromSize(
                          size: const Size(100, 2),
                          child: Obx(
                            () => LinearProgressIndicator(
                              backgroundColor: Theme.of(context).highlightColor,
                              value: controller.nextExp.value > 0
                                  ? controller.currentExp.value /
                                      controller.nextExp.value
                                  : 0,
                            ),
                          )),
                    ],
                  ),
                )
              ]),
              Row(
                children: [
                  Expanded(
                      child: Center(
                    child: MaterialButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Obx(() => Text(
                                  controller.dynamicCount.value.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .color),
                                )),
                            Text(
                              "动态",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .color),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                      child: Center(
                    child: MaterialButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Obx(() => Text(
                                  controller.followingCount.value.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .color),
                                )),
                            Text(
                              "关注",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .color),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                      child: Center(
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Obx(() => Text(
                                  controller.followerCount.value.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .color),
                                )),
                            Text(
                              "粉丝",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .color),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              ),
              Divider(
                height: 10,
                color: Theme.of(context).dividerColor,
                indent: 25,
                endIndent: 25,
                thickness: 2,
              ),
              UserMenuListTile(
                icon: const Icon(Icons.history),
                title: '历史记录',
                onTap: () => Navigator.of(context)
                    .push(GetPageRoute(page: () => const HistoryPage())),
              ),
              UserMenuListTile(
                icon: const Icon(
                  Icons.settings,
                ),
                title: "设置",
                onTap: () {
                  Navigator.of(context).push(GetPageRoute(
                    page: () => const SettingsPage(),
                  ));
                },
              ),
              UserMenuListTile(
                icon: const Icon(Icons.info),
                title: "关于",
                onTap: () {
                  Navigator.of(context).push(GetPageRoute(
                    page: () => const AboutPage(),
                  ));
                },
              ),
              UserMenuListTile(
                icon: const Icon(Icons.logout_rounded),
                title: "退出登陆",
                onTap: () {
                  controller.onLogout();
                },
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
          Row(
            children: [
              IconButton(
                  padding: const EdgeInsets.all(8),
                  onPressed: () {
                    Get.close(1);
                  },
                  icon: const Icon(Icons.close_rounded)),
              const Spacer(
                flex: 1,
              ),
              FutureBuilder(
                  future: controller.hasLogin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Offstage(
                        offstage: snapshot.data ?? false,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: TextButton(
                            onPressed: () {
                              Get.off(() => const WebLoginPage());
                            },
                            child: const Text(
                              "登录",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Spacer();
                    }
                  })
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserMenuController>(
      init: UserMenuController(),
      id: "user_face",
      builder: (_) {
        return _buildView(context);
      },
    );
  }
}

class UserMenuListTile extends StatelessWidget {
  const UserMenuListTile(
      {super.key, required this.icon, required this.title, this.onTap});
  final Function()? onTap;
  final Icon icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 35, right: 35, top: 25, bottom: 25),
        child: Row(children: [
          icon,
          SizedBox(
            width: MediaQuery.of(context).size.width / 13,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 18),
          )
        ]),
      ),
    );
  }
}
