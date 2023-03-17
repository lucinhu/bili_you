class PartInfo {
  PartInfo({required this.title, required this.cid});
  static PartInfo get zero => PartInfo(title: "", cid: 0);
  String title;
  int cid;
}
