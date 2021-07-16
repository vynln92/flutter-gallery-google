// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_shared_albums_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListSharedAlbumsResponse _$ListSharedAlbumsResponseFromJson(
    Map<String, dynamic> json) {
  return ListSharedAlbumsResponse(
    json['sharedAlbums'] as List,
    json['nextPageToken'] as String,
  );
}

Map<String, dynamic> _$ListSharedAlbumsResponseToJson(
        ListSharedAlbumsResponse instance) =>
    <String, dynamic>{
      'sharedAlbums': instance.sharedAlbums,
      'nextPageToken': instance.nextPageToken,
    };
