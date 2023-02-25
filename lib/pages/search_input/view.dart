import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class SearchInputPage extends GetView<SearchInputPageController> {
  const SearchInputPage({Key? key, required this.defaultSearchWord})
      : super(key: key);
  final String defaultSearchWord;

  Widget _defaultHintView() {
    return ListView(children: [
      const Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "热搜",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      FutureBuilder(
        future: controller.requestHotWordButtons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.length >= 10) {
              return Wrap(
                children: snapshot.data!.sublist(0, 10),
              );
            } else {
              return Wrap(
                children: snapshot.data!,
              );
            }
          } else {
            return Container();
          }
        },
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              const Text(
                "历史",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: controller.clearAllSearchedWords,
                  icon: const Icon(Icons.delete_rounded))
            ],
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Obx(() => Wrap(
              spacing: 8,
              children: controller.historySearchedWords.value,
            )),
      )
    ]);
  }

  Widget _searchHintView() {
    return Obx(() => ListView(
          children: controller.searchSuggestionItems,
        ));
  }

  Widget _viewSelecter() {
    return Obx(
      () {
        if (controller.showSearchSuggest.value) {
          return _searchHintView();
        } else {
          return _defaultHintView();
        }
      },
    );
  }

  _init() {
    controller.defaultSearchWord = defaultSearchWord;
  }

  // 主视图
  Widget _buildView() {
    _init();
    return Container(
      child: _viewSelecter(),
    );
  }

  AppBar _appBar(context) {
    return AppBar(
        shape: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).dividerColor)),
        // titleSpacing: 0,
        title: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: controller.textFeildFocusNode,
                      controller: controller.textEditingController,
                      onChanged: controller.onSearchWordChanged,
                      autofocus: true,
                      onEditingComplete: () {
                        controller
                            .search(controller.textEditingController.text);
                      },
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                          //删除键
                          suffixIcon: Obx(() => Offstage(
                                offstage: controller.showEditDelete.isFalse,
                                child: IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () {
                                    controller.textEditingController.clear();
                                    controller.showEditDelete.value = false;
                                    controller.showSearchSuggest.value = false;
                                  },
                                ),
                              )),
                          border: InputBorder.none,
                          hintText: defaultSearchWord),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 70,
              child: IconButton(
                onPressed: () {
                  controller.search(controller.textEditingController.text);
                },
                icon: const Icon(Icons.search_rounded),
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchInputPageController>(
      init: SearchInputPageController(),
      id: "search",
      builder: (_) {
        return Scaffold(
          appBar: _appBar(context),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
