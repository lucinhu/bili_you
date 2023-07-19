class report_history {
  report_history({
    this.code,
    this.message,
    this.ttl,});

  report_history.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    ttl = json['ttl'];
  }
  int? code;
  String? message;
  int? ttl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    map['ttl'] = ttl;
    return map;
  }

}
