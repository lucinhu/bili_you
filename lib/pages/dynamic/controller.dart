import 'package:get/get.dart';

class DynamicController extends GetxController {
  DynamicController();

  _initData() {
    update(["dynamic"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

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
