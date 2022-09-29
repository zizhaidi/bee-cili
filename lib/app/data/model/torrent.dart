import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class TorrentRes {
  TorrentRes({
    required this.success,
    this.torrent,
  });

  factory TorrentRes.fromJson(Map<String, dynamic> jsonRes) => TorrentRes(
        success: asT<int>(jsonRes['success'])!,
        torrent: jsonRes['torrent'] == null
            ? null
            : Torrent.fromJson(asT<Map<String, dynamic>>(jsonRes['torrent'])!),
      );

  int success;
  Torrent? torrent;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'success': success,
        'torrent': torrent,
      };
}

class Torrent {
  Torrent({
    this.meta,
    this.indexed,
    required this.id,
    required this.name,
    required this.infoHash,
    required this.magnet,
    required this.length,
    this.files,
    this.v,
  });

  factory Torrent.fromJson(Map<String, dynamic> jsonRes) {
    final List<Files>? files = jsonRes['files'] is List ? <Files>[] : null;
    if (files != null) {
      for (final dynamic item in jsonRes['files']!) {
        if (item != null) {
          files.add(Files.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Torrent(
      meta: jsonRes['meta'] == null
          ? null
          : Meta.fromJson(asT<Map<String, dynamic>>(jsonRes['meta'])!),
      indexed: asT<bool?>(jsonRes['indexed']),
      id: asT<String>(jsonRes['_id'])!,
      name: asT<String>(jsonRes['name'])!,
      infoHash: asT<String>(jsonRes['infoHash'])!,
      magnet: asT<String>(jsonRes['magnet'])!,
      length: asT<int>(jsonRes['length'])!,
      files: files,
      v: asT<int?>(jsonRes['__v']),
    );
  }

  Meta? meta;
  bool? indexed;
  String id;
  String name;
  String infoHash;
  String magnet;
  int length;
  List<Files>? files;
  int? v;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'meta': meta,
        'indexed': indexed,
        '_id': id,
        'name': name,
        'infoHash': infoHash,
        'magnet': magnet,
        'length': length,
        'files': files,
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

class Files {
  Files({
    required this.id,
    required this.path,
    required this.name,
    required this.length,
  });

  factory Files.fromJson(Map<String, dynamic> jsonRes) => Files(
        id: asT<String>(jsonRes['_id'])!,
        path: asT<String>(jsonRes['path'])!,
        name: asT<String>(jsonRes['name'])!,
        length: asT<int>(jsonRes['length'])!,
      );

  String id;
  String path;
  String name;
  int length;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': id,
        'path': path,
        'name': name,
        'length': length,
      };
}
