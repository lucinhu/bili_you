import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class LevelInfoModel {
  LevelInfoModel({
    this.currentLevel = 0,
    this.currentMin = 0,
    this.currentExp = 0,
    this.nextExp = 0,
  });

  @JsonProperty(name: 'current_level', defaultValue: 0)
  final int currentLevel;
  @JsonProperty(name: 'current_min', defaultValue: 0)
  final int currentMin;
  @JsonProperty(name: 'current_exp', defaultValue: 0)
  final int currentExp;
  @JsonProperty(name: 'next_exp', defaultValue: 0)
  final int nextExp;
}
