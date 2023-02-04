import 'package:bili_you/common/models/video_info/video_info.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
@Json(valueDecorators: VideoPartsModel.valueDecorators)
class VideoPartsModel {
  static Map<Type, ValueDecoratorFunction> valueDecorators() => {
        typeOf<List<VideoPartModel>>(): (value) => value.cast<VideoPartModel>(),
      };
  VideoPartsModel({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });
  @JsonProperty(defaultValue: -1)
  final int code;
  @JsonProperty(defaultValue: 'VideoPartsModel')
  final String message;
  @JsonProperty(defaultValue: 0)
  final int ttl;
  @JsonProperty(defaultValue: [])
  final List<VideoPartModel> data;
}
