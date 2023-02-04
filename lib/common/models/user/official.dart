import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class OfficialModel {
  OfficialModel({
    this.role = 0,
    this.title = '',
    this.desc = '',
    this.type = 0,
  });
  @JsonProperty(defaultValue: 0)
  final int role;
  @JsonProperty(defaultValue: '')
  final String title;
  @JsonProperty(defaultValue: '')
  final String desc;
  @JsonProperty(defaultValue: 0)
  final int type;
}
