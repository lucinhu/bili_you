import 'package:bili_you/common/models/local/search/search_user_item.dart';
import 'package:bili_you/common/utils/index.dart';
import 'package:bili_you/common/widget/avatar.dart';
import 'package:bili_you/pages/user_space/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserTileItem extends StatelessWidget {
  const UserTileItem({super.key, required this.searchUserItem});
  final SearchUserItem searchUserItem;

  @override
  Widget build(BuildContext context) {
    var hintTextStyle =
        TextStyle(color: Theme.of(context).hintColor, fontSize: 12);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.of(context).push(GetPageRoute(
          page: () => UserSpacePage(mid: searchUserItem.mid),
        ));
      },
      child: SizedBox(
        height: 60,
        child: Row(children: [
          AvatarWidget(
            avatarUrl: searchUserItem.face,
            radius: 24,
            officialVerifyType: searchUserItem.officialVerify.type,
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        searchUserItem.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                      LayoutBuilder(
                        builder: (context, box) {
                          return Row(
                            children: [
                              SizedBox(
                                width: box.maxWidth / 3,
                                child: Text(
                                    '${StringFormatUtils.numFormat(searchUserItem.fansCount)}粉丝  ',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: hintTextStyle),
                              ),
                              SizedBox(
                                width: box.maxWidth / 3,
                                child: Text(
                                    '${StringFormatUtils.numFormat(searchUserItem.videoCount)}个视频',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: hintTextStyle),
                              ),
                            ],
                          );
                        },
                      ),
                      Text(
                        searchUserItem.sign,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: hintTextStyle,
                      )
                    ],
                  ))),
        ]),
      ),
    );
  }
}
