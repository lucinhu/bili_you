class SearchSuggestItem {
  SearchSuggestItem({required this.showWord, required this.realWord});
  static SearchSuggestItem get zero =>
      SearchSuggestItem(showWord: "", realWord: "");
  String showWord;
  String realWord;
}
