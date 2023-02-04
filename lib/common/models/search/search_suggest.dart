import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
@Json(valueDecorators: SearchSuggestModel.valueDecorators)
class SearchSuggestModel {
  static Map<Type, ValueDecoratorFunction> valueDecorators() => {
        typeOf<List<SearchSuggestItemModel>>(): (value) =>
            value.cast<SearchSuggestItemModel>(),
      };
  SearchSuggestModel({
    required this.code,
    required this.items,
  });
  @JsonProperty(defaultValue: 0)
  final int code;
  @JsonProperty(name: 'result/tag', defaultValue: [])
  final List<SearchSuggestItemModel> items;
}

@jsonSerializable
class SearchSuggestItemModel {
  SearchSuggestItemModel({
    required this.value,
    required this.name,
  });
  @JsonProperty(defaultValue: '')
  final String value;
  @JsonProperty(defaultValue: '')
  final String name;
}
