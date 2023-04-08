import 'package:bili_you/common/api/search_api.dart';
import 'package:bili_you/pages/search_input/view.dart';

import 'package:bili_you/pages/search_tab_view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key? key, required this.keyWord}) : super(key: key);
  final String keyWord;
  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with AutomaticKeepAliveClientMixin {
  late SearchResultController controller;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    controller = Get.put(SearchResultController(keyWord: widget.keyWord));
    super.initState();
  }

  @override
  void dispose() {
    // controller.onClose();
    // controller.onDelete();
    controller.dispose();
    super.dispose();
  }

  AppBar _appBar(BuildContext context, SearchResultController controller) {
    return AppBar(
        shape: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).dividerColor)),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: TextEditingController(text: widget.keyWord),
                readOnly: true,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(GetPageRoute(
                      page: () => SearchInputPage(
                            defaultHintSearchWord: widget.keyWord,
                            defaultInputSearchWord: widget.keyWord,
                          )));
                },
              ),
            ),
            SizedBox(
              width: 70,
              child: IconButton(
                onPressed: () {
                  // controller.refreshController.callRefresh();
                },
                icon: const Icon(Icons.search_rounded),
              ),
            )
          ],
        ),
        bottom: TabBar(
            controller: controller.tabController,
            onTap: (value) {
              controller.tabController.animateTo(value);
            },
            tabs: const [
              Tab(
                text: "视频",
              ),
              Tab(
                text: "番剧",
              ),
              Tab(
                text: "直播",
              ),
              Tab(
                text: "影视",
              ),
              Tab(
                text: "用户",
              )
            ]));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: _appBar(context, controller),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          SearchTabViewPage(
            keyWord: widget.keyWord,
            searchType: SearchType.video,
          ),
          SearchTabViewPage(
            keyWord: widget.keyWord,
            searchType: SearchType.bangumi,
          ),
          SearchTabViewPage(
            keyWord: widget.keyWord,
            searchType: SearchType.liveRoom,
          ),
          SearchTabViewPage(
            keyWord: widget.keyWord,
            searchType: SearchType.movie,
          ),
          SearchTabViewPage(
            keyWord: widget.keyWord,
            searchType: SearchType.user,
          )
        ],
      ),
    );
  }
}
