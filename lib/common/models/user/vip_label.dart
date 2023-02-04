import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class VipLabelModel {
  VipLabelModel({
    this.path = '',
    this.text = '',
    this.labelTheme = '',
  });

  @JsonProperty(defaultValue: '')
  final String path;
  @JsonProperty(defaultValue: '')
  final String text;
  @JsonProperty(name: 'label_theme', defaultValue: '')
  final String labelTheme;
}
