import 'dart:convert';

class SearchSuggestResponse {
  SearchSuggestResponse({
    this.expStr,
    this.code,
    this.cost,
    this.result,
    this.pageCaches,
    this.sengine,
    this.stoken,
  });

  String? expStr;
  int? code;
  Cost? cost;
  Result? result;
  PageCaches? pageCaches;
  Sengine? sengine;
  String? stoken;

  factory SearchSuggestResponse.fromRawJson(String str) =>
      SearchSuggestResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchSuggestResponse.fromJson(Map<String, dynamic> json) =>
      SearchSuggestResponse(
        expStr: json["exp_str"],
        code: json["code"],
        cost: json["cost"] == null ? null : Cost.fromJson(json["cost"]),
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
        pageCaches: json["page caches"] == null
            ? null
            : PageCaches.fromJson(json["page caches"]),
        sengine:
            json["sengine"] == null ? null : Sengine.fromJson(json["sengine"]),
        stoken: json["stoken"],
      );

  Map<String, dynamic> toJson() => {
        "exp_str": expStr,
        "code": code,
        "cost": cost?.toJson(),
        "result": result?.toJson(),
        "page caches": pageCaches?.toJson(),
        "sengine": sengine?.toJson(),
        "stoken": stoken,
      };
}

class Cost {
  Cost({
    this.about,
  });

  About? about;

  factory Cost.fromRawJson(String str) => Cost.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cost.fromJson(Map<String, dynamic> json) => Cost(
        about: json["about"] == null ? null : About.fromJson(json["about"]),
      );

  Map<String, dynamic> toJson() => {
        "about": about?.toJson(),
      };
}

class About {
  About({
    this.paramsCheck,
    this.total,
    this.mainHandler,
  });

  String? paramsCheck;
  String? total;
  String? mainHandler;

  factory About.fromRawJson(String str) => About.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory About.fromJson(Map<String, dynamic> json) => About(
        paramsCheck: json["params_check"],
        total: json["total"],
        mainHandler: json["main_handler"],
      );

  Map<String, dynamic> toJson() => {
        "params_check": paramsCheck,
        "total": total,
        "main_handler": mainHandler,
      };
}

class PageCaches {
  PageCaches({
    this.saveCache,
  });

  String? saveCache;

  factory PageCaches.fromRawJson(String str) =>
      PageCaches.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PageCaches.fromJson(Map<String, dynamic> json) => PageCaches(
        saveCache: json["save cache"],
      );

  Map<String, dynamic> toJson() => {
        "save cache": saveCache,
      };
}

class Result {
  Result({
    this.tag,
  });

  List<Tag>? tag;

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        tag: json["tag"] == null
            ? []
            : List<Tag>.from(json["tag"]!.map((x) => Tag.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tag":
            tag == null ? [] : List<dynamic>.from(tag!.map((x) => x.toJson())),
      };
}

class Tag {
  Tag({
    this.value,
    this.term,
    this.ref,
    this.name,
    this.spid,
  });

  String? value;
  String? term;
  int? ref;
  String? name;
  int? spid;

  factory Tag.fromRawJson(String str) => Tag.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        value: json["value"],
        term: json["term"],
        ref: json["ref"],
        name: json["name"],
        spid: json["spid"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "term": term,
        "ref": ref,
        "name": name,
        "spid": spid,
      };
}

class Sengine {
  Sengine({
    this.usage,
  });

  int? usage;

  factory Sengine.fromRawJson(String str) => Sengine.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sengine.fromJson(Map<String, dynamic> json) => Sengine(
        usage: json["usage"],
      );

  Map<String, dynamic> toJson() => {
        "usage": usage,
      };
}
