import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class OfficialVerifyModel {
  OfficialVerifyModel({
    this.type = 0,
    this.desc = '',
  });
  @JsonProperty(defaultValue: 0)
  final int type;
  @JsonProperty(defaultValue: '')
  final String desc;
}
