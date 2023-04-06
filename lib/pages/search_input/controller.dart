import 'dart:developer';

import 'package:bili_you/common/api/search_api.dart';
import 'package:bili_you/common/models/local/search/hot_word_item.dart';
import 'package:bili_you/common/models/local/search/search_suggest_item.dart';
import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:bili_you/pages/search_result/index.dart';
import 'package:bili_you/pages/search_result/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchInputPageController extends GetxController {
  SearchInputPageController();
  RxBool showSearchSuggest = false.obs;
  RxList<Widget> searchSuggestionItems = <Widget>[].obs;
  TextEditingController textEditingController = TextEditingController();
  final FocusNode textFeildFocusNode = FocusNode();
  late String defaultSearchWord;
  RxBool showEditDelete = false.obs;

  Rx<List<Widget>> historySearchedWords = Rx<List<Widget>>([]);

  //构造热搜按钮列表
  Future<List<Widget>> requestHotWordButtons() async {
    List<Widget> widgetList = [];
    late List<HotWordItem> wordList;
    try {
      wordList = await SearchApi.getHotWords();
    } catch (e) {
      log("requestHotWordButtons:$e");
      return widgetList;
    }
    for (var i in wordList) {
      widgetList.add(
        SizedBox(
            width: MediaQuery.of(Get.context!).size.width * 0.5,
            child: InkWell(
                onTap: () {
                  search(i.keyWord);
                  setTextFieldText(i.keyWord);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    i.showWord,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 14),
                  ),
                ))),
      );
    }
    return widgetList;
  }

//获取搜索建议并构造其控件
  Future<void> requestSearchSuggestions(String keyWord) async {
    late List<SearchSuggestItem> list;
    try {
      list = await SearchApi.getSearchSuggests(keyWord: keyWord);
    } catch (e) {
      log("requestSearchSuggestions:$e");
    }
    searchSuggestionItems.clear();
    for (var i in list) {
      searchSuggestionItems.add(InkWell(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            i.showWord,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        onTap: () {
          setTextFieldText(i.realWord);
          search(i.realWord);
        },
      ));
    }
  }

//搜索框内容改变
  onSearchWordChanged(String keyWord) {
    //搜索框不为空,且不为空字符,请求显示搜索提示
    if (keyWord.trim().isNotEmpty) {
      showSearchSuggest.value = true;
      requestSearchSuggestions(keyWord);
    } else {
      showSearchSuggest.value = false;
    }

    //搜索框不为空,显示删除按钮
    if (keyWord.isNotEmpty) {
      showEditDelete.value = true;
    } else {
      showEditDelete.value = false;
    }
  }

  //搜索某词
  search(String keyWord) {
    //不为空且不为空字符,保存历史并搜索
    if (keyWord.trim().isNotEmpty) {
      log("searching: $keyWord");
      _saveSearchedWord(keyWord.trim());
      // Get.to(() => SearchResultPage(
      //     key: ValueKey('SearchResultPage:$keyWord'), keyWord: keyWord));
      Navigator.of(Get.context!).pushReplacement(GetPageRoute(
          page: () => SearchResultPage(
              key: ValueKey('SearchResultPage:$keyWord'), keyWord: keyWord)));
    } else if (keyWord.isEmpty && defaultSearchWord.isNotEmpty) {
      setTextFieldText(defaultSearchWord);
      search(defaultSearchWord);
    }
  }

//获取/刷新历史搜索词控件
  _refreshHistoryWord() async {
    var box = BiliYouStorage.history;
    List<Widget> widgetList = [];
    List<dynamic> list = box.get("searchHistory", defaultValue: <String>[]);
    for (String i in list.reversed) {
      widgetList.add(
        GestureDetector(
          child: Chip(
            label: Text(i),
            onDeleted: () {
              //点击删除某条历史记录
              _deleteSearchedWord(i);
            },
          ),
          onTap: () {
            //点击某条历史记录
            search(i);
            setTextFieldText(i);
          },
        ),
      );
    }
    historySearchedWords.value = widgetList;
  }

//保存搜索词
  _saveSearchedWord(String keyWord) async {
    var box = BiliYouStorage.history;
    List<dynamic> list = box.get("searchHistory", defaultValue: <String>[]);
//不存在相同的词就放进去
    if (!list.contains(keyWord)) {
      list.add(keyWord);
      box.put("searchHistory", list);
    }
    _refreshHistoryWord(); //刷新历史记录控件
  }

//删除所有搜索历史
  clearAllSearchedWords() async {
    var box = BiliYouStorage.history;
    box.put("searchHistory", <String>[]);
    _refreshHistoryWord(); //刷新历史记录控件
  }

//删除历史记录某个词
  _deleteSearchedWord(String word) async {
    var box = BiliYouStorage.history;
    List<dynamic> list = box.get("searchHistory", defaultValue: <String>[]);
    list.remove(word);
    box.put("searchHistory", list);
    _refreshHistoryWord();
  }

  setTextFieldText(String text) {
    textEditingController.text = text;
    textEditingController.selection =
        TextSelection.fromPosition(TextPosition(offset: text.length));
  }

  _initData() async {
    // update(["search"]);
    _refreshHistoryWord();
    textFeildFocusNode.addListener(() {
      if (textFeildFocusNode.hasFocus &&
          textEditingController.text.isNotEmpty) {
        showEditDelete.value = true;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
