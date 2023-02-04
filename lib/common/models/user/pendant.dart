import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class PendantModel {
  const PendantModel({
    this.pid = 0,
    this.name = '',
    this.image = '',
    this.expire = 0,
    this.imageEnhance = '',
  });

  @JsonProperty(defaultValue: 0)
  final int pid;
  @JsonProperty(defaultValue: '')
  final String name;
  @JsonProperty(defaultValue: '')
  final String image;
  @JsonProperty(defaultValue: 0)
  final int expire;
  @JsonProperty(name: 'image_enhance', defaultValue: '')
  final String imageEnhance;
}
