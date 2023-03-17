class DefaultSearchWord {
  DefaultSearchWord({required this.showName, required this.name});
  static DefaultSearchWord get zero =>
      DefaultSearchWord(showName: "", name: "");
  String showName;
  String name;
}
