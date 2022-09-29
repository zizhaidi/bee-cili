import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class TorrentsRes {
  TorrentsRes({
    required this.success,
    required this.torrents,
  });

  factory TorrentsRes.fromJson(Map<String, dynamic> jsonRes) {
    final List<Torrent>? torrents =
        jsonRes['torrents'] is List ? <Torrent>[] : null;
    if (torrents != null) {
      for (final dynamic item in jsonRes['torrents']!) {
        if (item != null) {
          torrents.add(Torrent.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return TorrentsRes(
      success: asT<int>(jsonRes['success'])!,
      torrents: torrents!,
    );
  }

  int success;
  List<Torrent> torrents;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'success': success,
        'torrents': torrents,
      };
}

class Torrent {
  Torrent({
    required this.name,
    required this.magnet,
    required this.length,
    required this.id,
  });

  factory Torrent.fromJson(Map<String, dynamic> jsonRes) => Torrent(
        name: asT<String>(jsonRes['name'])!,
        magnet: asT<String>(jsonRes['magnet'])!,
        length: asT<int>(jsonRes['length'])!,
        id: asT<String>(jsonRes['_id'])!,
      );

  String name;
  String magnet;
  int length;
  String id;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'magnet': magnet,
        'length': length,
        '_id': id,
      };
}
