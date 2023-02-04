import 'dart:developer';

import 'package:bili_you/common/api/search_api.dart';
import 'package:bili_you/common/models/search/hot_words.dart';
import 'package:bili_you/pages/search_result/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchInputPageController extends GetxController {
  SearchInputPageController();
  RxBool showSearchSuggest = false.obs;
  RxList<Widget> searchSuggestionItems = <Widget>[].obs;
  TextEditingController textEditingController = TextEditingController();
  late String defaultSearchWord;
  RxBool showEditDelete = false.obs;

  Rx<List<Widget>> historySearchedWords = Rx<List<Widget>>([]);

  //构造热搜按钮列表
  Future<List<Widget>> requestHotWordButtons() async {
    try {
      HotWordsModel hotWordsModel = await SearchApi.requestHotWorlds();
      List<Widget> list = [];
      if (hotWordsModel.code == 0) {
        for (var i in hotWordsModel.list) {
          list.add(
            SizedBox(
                width: MediaQuery.of(Get.context!).size.width * 0.5,
                child: InkWell(
                    onTap: () {
                      search(i.keyword);
                      setTextFieldText(i.keyword);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        i.showName,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ))),
          );
        }
      }
      return list;
    } catch (e) {
      log("获取热搜失败,网络错误?");
      return [];
    }
  }

//获取搜索建议并构造其控件
  requestSearchSuggestions(String keyWord) async {
    var result = await SearchApi.requestSearchSuggests(keyWord);
    List<Widget> list = [];
    for (var i in result.items) {
      list.add(InkWell(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            i.name,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        onTap: () {
          setTextFieldText(i.value);
          search(i.value);
        },
      ));
    }
    searchSuggestionItems.value = list;
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
      Get.to(() => SearchResultPage(keyword: keyWord));
    } else if (keyWord.isEmpty && defaultSearchWord.isNotEmpty) {
      setTextFieldText(defaultSearchWord);
      search(defaultSearchWord);
    }
  }

//获取/刷新历史搜索词控件
  _refreshHistoryWord() async {
    var pref = await SharedPreferences.getInstance();
    List<Widget> widgetList = [];
    List<String> list = pref.getStringList("searchHistory") ?? [];
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
    var pref = await SharedPreferences.getInstance();
    List<String> list = pref.getStringList("searchHistory") ?? [];
//不存在相同的词就放进去
    if (!list.contains(keyWord)) {
      list.add(keyWord);
    }
    pref.setStringList("searchHistory", list);
    _refreshHistoryWord(); //刷新历史记录控件
  }

//删除所有搜索历史
  clearAllSearchedWords() async {
    var pref = await SharedPreferences.getInstance();
    pref.setStringList("searchHistory", []);
    _refreshHistoryWord(); //刷新历史记录控件
  }

//删除历史记录某个词
  _deleteSearchedWord(String word) async {
    var pref = await SharedPreferences.getInstance();
    List<String> list = pref.getStringList("searchHistory") ?? [];
    list.remove(word);
    pref.setStringList("searchHistory", list);
    _refreshHistoryWord();
  }

  setTextFieldText(String text) {
    textEditingController.text = text;
    textEditingController.selection =
        TextSelection.fromPosition(TextPosition(offset: text.length));
  }

  _initData() async {
    update(["search"]);
    _refreshHistoryWord();
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
