import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class AdsRes {
  AdsRes({
    required this.success,
    required this.ads,
  });

  factory AdsRes.fromJson(Map<String, dynamic> jsonRes) {
    final List<Ad>? ads = jsonRes['ads'] is List ? <Ad>[] : null;
    if (ads != null) {
      for (final dynamic item in jsonRes['ads']!) {
        if (item != null) {
          ads.add(Ad.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return AdsRes(
      success: asT<int>(jsonRes['success'])!,
      ads: ads!,
    );
  }

  int success;
  List<Ad> ads;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'success': success,
        'ads': ads,
      };
}

class Ad {
  Ad({
    required this.meta,
    required this.id,
    required this.title,
    required this.content,
    required this.link,
    required this.v,
  });

  factory Ad.fromJson(Map<String, dynamic> jsonRes) => Ad(
        meta: Meta.fromJson(asT<Map<String, dynamic>>(jsonRes['meta'])!),
        id: asT<String>(jsonRes['_id'])!,
        title: asT<String>(jsonRes['title'])!,
        content: asT<String>(jsonRes['content'])!,
        link: asT<String>(jsonRes['link'])!,
        v: asT<int>(jsonRes['__v'])!,
      );

  Meta meta;
  String id;
  String title;
  String content;
  String link;
  int v;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'meta': meta,
        '_id': id,
        'title': title,
        'content': content,
        'link': link,
        '__v': v,
      };
}

class Meta {
  Meta({
    required this.updateAt,
    required this.createAt,
  });

  factory Meta.fromJson(Map<String, dynamic> jsonRes) => Meta(
        updateAt: asT<String>(jsonRes['updateAt'])!,
        createAt: asT<String>(jsonRes['createAt'])!,
      );

  String updateAt;
  String createAt;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'updateAt': updateAt,
        'createAt': createAt,
      };
}
