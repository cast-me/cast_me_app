///
//  Generated code. Do not modify.
//  source: business_logic/models/protobufs/cast_base.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use castBaseDescriptor instead')
const CastBase$json = const {
  '1': 'CastBase',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'created_at_string', '3': 2, '4': 1, '5': 9, '10': 'createdAtString'},
    const {'1': 'author_username', '3': 3, '4': 1, '5': 9, '10': 'authorUsername'},
    const {'1': 'author_display_name', '3': 4, '4': 1, '5': 9, '10': 'authorDisplayName'},
    const {'1': 'image_url', '3': 5, '4': 1, '5': 9, '10': 'imageUrl'},
    const {'1': 'accent_color_base', '3': 6, '4': 1, '5': 9, '10': 'accentColorBase'},
    const {'1': 'view_count', '3': 7, '4': 1, '5': 13, '10': 'viewCount'},
    const {'1': 'has_viewed', '3': 8, '4': 1, '5': 8, '10': 'hasViewed'},
    const {'1': 'likes', '3': 9, '4': 3, '5': 11, '6': '.cast_me_app.LikeBase', '10': 'likes'},
    const {'1': 'tagged_usernames', '3': 10, '4': 3, '5': 9, '10': 'taggedUsernames'},
    const {'1': 'author_id', '3': 11, '4': 1, '5': 9, '10': 'authorId'},
    const {'1': 'title', '3': 12, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'topic', '3': 13, '4': 1, '5': 9, '10': 'topic'},
    const {'1': 'duration_ms', '3': 14, '4': 1, '5': 13, '10': 'durationMs'},
    const {'1': 'audio_url', '3': 15, '4': 1, '5': 9, '10': 'audioUrl'},
    const {'1': 'reply_to', '3': 16, '4': 1, '5': 9, '10': 'replyTo'},
  ],
};

/// Descriptor for `CastBase`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List castBaseDescriptor = $convert.base64Decode('CghDYXN0QmFzZRIOCgJpZBgBIAEoCVICaWQSKgoRY3JlYXRlZF9hdF9zdHJpbmcYAiABKAlSD2NyZWF0ZWRBdFN0cmluZxInCg9hdXRob3JfdXNlcm5hbWUYAyABKAlSDmF1dGhvclVzZXJuYW1lEi4KE2F1dGhvcl9kaXNwbGF5X25hbWUYBCABKAlSEWF1dGhvckRpc3BsYXlOYW1lEhsKCWltYWdlX3VybBgFIAEoCVIIaW1hZ2VVcmwSKgoRYWNjZW50X2NvbG9yX2Jhc2UYBiABKAlSD2FjY2VudENvbG9yQmFzZRIdCgp2aWV3X2NvdW50GAcgASgNUgl2aWV3Q291bnQSHQoKaGFzX3ZpZXdlZBgIIAEoCFIJaGFzVmlld2VkEisKBWxpa2VzGAkgAygLMhUuY2FzdF9tZV9hcHAuTGlrZUJhc2VSBWxpa2VzEikKEHRhZ2dlZF91c2VybmFtZXMYCiADKAlSD3RhZ2dlZFVzZXJuYW1lcxIbCglhdXRob3JfaWQYCyABKAlSCGF1dGhvcklkEhQKBXRpdGxlGAwgASgJUgV0aXRsZRIUCgV0b3BpYxgNIAEoCVIFdG9waWMSHwoLZHVyYXRpb25fbXMYDiABKA1SCmR1cmF0aW9uTXMSGwoJYXVkaW9fdXJsGA8gASgJUghhdWRpb1VybBIZCghyZXBseV90bxgQIAEoCVIHcmVwbHlUbw==');
