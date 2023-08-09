import 'package:bili_you/common/models/network/user_relations/user_realtion.dart';
import 'package:bili_you/common/models/network/user_relations/user_relation_types.dart';
import 'package:bili_you/common/widget/avatar.dart';
import 'package:bili_you/common/widget/simple_easy_refresher.dart';
import 'package:bili_you/pages/relation/controller.dart';
import 'package:bili_you/pages/user_space/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RelationPage extends StatefulWidget {
  const RelationPage({super.key, required this.mid, required this.type});

  final UserRelationType type; //指示页面是关注还是粉丝
  final int mid;
  @override
  State<RelationPage> createState() => _RelationPageState();
}

class _RelationPageState extends State<RelationPage> {
  late RealtionController controller;
  @override
  void initState() {
    controller =
        Get.put(RealtionController(mid: widget.mid, type: widget.type));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var titleText = "";
    switch (widget.type) {
      case UserRelationType.following:
        titleText = "关注列表";
        break;
      case UserRelationType.follower:
        titleText = "粉丝列表";
    }
    return Scaffold(
      appBar: AppBar(title: Text(titleText)),
      body: SimpleEasyRefresher(
        onLoad: controller.onLoad,
        onRefresh: controller.onRefresh,
        easyRefreshController: controller.easyRefreshController,
        childBuilder: (context, physics) => ListView.builder(
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
  const RelationWidget({super.key, required this.relation});

  final UserRelation relation;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(GetPageRoute(
          page: () => UserSpacePage(
              key: ValueKey('UserSpacePage:${relation.mid}'),
              mid: relation.mid!),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
