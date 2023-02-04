import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class UserStatModel {
  @JsonProperty(defaultValue: 0)
  final int code;
  @JsonProperty(defaultValue: '')
  final String message;
  @JsonProperty(name: 'data/following', defaultValue: 0)
  final int followingCount;
  @JsonProperty(name: 'data/follower', defaultValue: 0)
  final int followerCount;
  @JsonProperty(name: 'data/dynamic_count', defaultValue: 0)
  final int dynamicCount;

  UserStatModel(
      {required this.code,
      required this.message,
      required this.followerCount,
      required this.dynamicCount,
      required this.followingCount});
}
