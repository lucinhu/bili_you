class HotWordItem {
  HotWordItem({required this.keyWord, required this.showWord});
  static HotWordItem get zero => HotWordItem(keyWord: "", showWord: "");
  String keyWord;
  String showWord;
}
