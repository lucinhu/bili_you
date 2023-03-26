import 'package:bili_you/common/models/local/dynamic/dynamic_item.dart';
import 'package:bili_you/common/widget/avatar.dart';
import 'package:bili_you/pages/user_space/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DynamicItemCard extends StatelessWidget {
  const DynamicItemCard({super.key, required this.dynamicItem});
  final DynamicItem dynamicItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AvatarWidget(
                  radius: 45 / 2,
                  avatarUrl: dynamicItem.author.avatarUrl,
                  onPressed: () {
                    // Get.to(() => UserSpacePage(
                    //     key:
                    //         ValueKey('UserSpacePage:${dynamicItem.author.mid}'),
                    //     mid: dynamicItem.author.mid));
                    Navigator.of(context).push(GetPageRoute(
                        page: () => UserSpacePage(
                            key: ValueKey(
                                'UserSpacePage:${dynamicItem.author.mid}'),
                            mid: dynamicItem.author.mid)));
                  },
                  cacheWidthHeight: 100,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    //发动态的作者名字
                    dynamicItem.author.name,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  //发布时间,动作
                  Text(
                    "${dynamicItem.author.pubTime} ${dynamicItem.author.pubAction}",
                    style: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 12),
                  )
                ],
              )
            ]),
            Padding(
              padding: const EdgeInsets.only(
                  top: 14.0, left: 8, right: 8, bottom: 8), //动态信息
              child: Text(
                dynamicItem.content.description,
                style: const TextStyle(fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
