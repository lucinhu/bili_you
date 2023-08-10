class ReportHistory {
  ReportHistory({
    this.code,
    this.message,
    this.ttl,
  });

  ReportHistory.fromJson(dynamic json) {
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
