import 'captcha_data.dart';

class CaptchaResultModel {
  String validate;
  String seccode;

  CaptchaDataModel captchaData;
  CaptchaResultModel(
      {this.validate = "", this.seccode = "", required this.captchaData});
}
