import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class StatusRes {
  StatusRes({
    required this.success,
    required this.count,
  });

  factory StatusRes.fromJson(Map<String, dynamic> jsonRes) => StatusRes(
        success: asT<int>(jsonRes['success'])!,
        count: asT<int>(jsonRes['count'])!,
      );

  int success;
  int count;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'success': success,
        'count': count,
      };
}
