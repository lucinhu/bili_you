import 'package:bili_you/common/models/home/recommend_item.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class RecommendItemsModel {
  RecommendItemsModel({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });
  @JsonProperty(defaultValue: -1)
  final int code;
  @JsonProperty(defaultValue: '')
  final String message;
  @JsonProperty(defaultValue: 0)
  final int ttl;
  @JsonProperty(defaultValue: {})
  final RecommendItemsData data;
}

@jsonSerializable
@Json(valueDecorators: RecommendItemsData.valueDecorators)
class RecommendItemsData {
  static Map<Type, ValueDecoratorFunction> valueDecorators() => {
        typeOf<List<RecommendItemModel>>(): (value) =>
            value.cast<RecommendItemModel>(),
      };
  RecommendItemsData({
    required this.item,
    // required this.businessCard,
    // required this.floorInfo,
    // required this.userFeature,
    // required this.preloadExposePct,
    // required this.preloadFloorExposePct,
    required this.mid,
  });
  @JsonProperty(defaultValue: [])
  final List<RecommendItemModel> item;
  // @JsonProperty(name: 'business_card')
  // final dynamic businessCard;
  // final dynamic floorInfo;
  // final dynamic userFeature;
  // final double preloadExposePct;
  // final double preloadFloorExposePct;
  @JsonProperty(defaultValue: 0)
  final int mid;
}
