import 'package:bili_you/common/models/network/user_relations/user_realtion.dart';
import 'package:bili_you/common/widget/avatar.dart';
import 'package:bili_you/common/widget/simple_easy_refresher.dart';
import 'package:bili_you/pages/following/controller.dart';
import 'package:bili_you/pages/user_space/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key, this.mid});

  final int? mid;
  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  late FollowingController controller;
  @override
  void initState() {
    controller = Get.put(FollowingController(mid: widget.mid));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('关注列表')),
      body: SimpleEasyRefresher(
        onLoad: controller.onLoad,
        onRefresh: controller.onRefresh,
        easyRefreshController: controller.easyRefreshController,
        childBuilder: (context, physics) =>
            //SizedBox(),
            ListView.builder(
          padding: const EdgeInsets.all(12),
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          physics: physics,
          itemCount: controller.relationsItems.length,
          controller: controller.scrollController,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: RelationWidget(relation: controller.relationsItems[index]),
          ),
        ),
      ),
    );
  }
}

class RelationWidget extends StatelessWidget {
  RelationWidget({super.key, required this.relation});

  UserRelation relation;
  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: () {
        Navigator.of(context).push(GetPageRoute(
          page: () => UserSpacePage(
              key: ValueKey('UserSpacePage:${relation.mid}'),
              mid: this.relation.mid!),
        ));
      },
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: AvatarWidget(
                avatarUrl: relation.face!,
                radius: 20,
                cacheWidthHeight: 200,
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                relation.uname!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
