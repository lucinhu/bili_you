class DynamicContent {
  DynamicContent({required this.description, required this.imageUrls});
  static DynamicContent get zero =>
      DynamicContent(description: "", imageUrls: []);
  String description;
  List<String> imageUrls = [];
}
