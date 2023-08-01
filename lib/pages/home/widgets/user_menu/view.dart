import 'dart:io';

import 'package:bili_you/common/models/network/user_relations/user_relation_types.dart';
import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:bili_you/pages/about/about_page.dart';
import 'package:bili_you/pages/history/history_page.dart';
import 'package:bili_you/pages/login/qrcode_login/view.dart';
import 'package:bili_you/pages/login/web_login/view.dart';
import 'package:bili_you/pages/settings_page/settings_page.dart';
import 'package:bili_you/pages/relation/view.dart';
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
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
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
                                cacheWidth: (45 *
                                        MediaQuery.of(context).devicePixelRatio)
                                    .toInt(),
                                cacheHeight: (45 *
                                        MediaQuery.of(context).devicePixelRatio)
                                    .toInt(),
                                //头像
                                cacheManager: controller.cacheManager,
                                width: 45,
                                height: 45,
                                imageUrl: value.get(UserStorageKeys.userFace,
                                    defaultValue: controller.faceUrl.value),
                                placeholder: () => const SizedBox(
                                  width: 45,
                                  height: 45,
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
                  padding: const EdgeInsets.only(top: 45),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            controller.name.value,
                            style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(
                        height: 2,
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
                            width: 35,
                          ),
                          Obx(() => Text(
                                "${controller.currentExp}/${controller.level.value != 6 ? controller.nextExp : '--'}",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Theme.of(context).highlightColor), //TODO 颜色名称不符，但hightlight用作分割线更自然。此处UI待优化或重构
                              ))
                        ],
                      ),
                      SizedBox.fromSize(
                          size: const Size(100, 2),
                          child: Obx(
                            () => LinearProgressIndicator(
                              backgroundColor: Theme.of(context).highlightColor, //TODO 颜色名称不符，但hightlight用作文字色更自然。此处UI待优化或重构
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
                      onPressed: () async {
                        if(await controller.hasLogin())
                          Navigator.of(context)
                              .push(GetPageRoute(page: () => RelationPage(mid:controller.userInfo.mid,type: UserRelationType.following,)));
                      },
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
                      onPressed: () async {
                        if(await controller.hasLogin())
                          Navigator.of(context)
                              .push(GetPageRoute(page: () => RelationPage(mid:controller.userInfo.mid,type: UserRelationType.follower,)));
                      },
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
                color: Theme.of(context).highlightColor,
                indent: 25,
                endIndent: 25,
                thickness: 1,
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
                title: "退出登录",
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
              Padding(
                  padding: EdgeInsets.only(left: 8, top: 8),
                  child: IconButton(
                      padding: const EdgeInsets.all(8),
                      onPressed: () {
                        Get.close(1);
                      },
                      icon: const Icon(Icons.close_rounded))),
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
                              if (Platform.isAndroid || Platform.isIOS) {
                                Get.off(() => const WebLoginPage());
                              } else {
                                Get.off(() => const QrcodeLogin());
                              }
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
