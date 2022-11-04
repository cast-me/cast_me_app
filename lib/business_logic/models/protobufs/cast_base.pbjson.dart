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
    const {'1': 'root_id', '3': 3, '4': 1, '5': 9, '10': 'rootId'},
    const {'1': 'author_username', '3': 4, '4': 1, '5': 9, '10': 'authorUsername'},
    const {'1': 'author_display_name', '3': 5, '4': 1, '5': 9, '10': 'authorDisplayName'},
    const {'1': 'image_url', '3': 6, '4': 1, '5': 9, '10': 'imageUrl'},
    const {'1': 'accent_color_base', '3': 7, '4': 1, '5': 9, '10': 'accentColorBase'},
    const {'1': 'view_count', '3': 8, '4': 1, '5': 13, '10': 'viewCount'},
    const {'1': 'has_viewed', '3': 9, '4': 1, '5': 8, '10': 'hasViewed'},
    const {'1': 'tree_has_new_casts', '3': 10, '4': 1, '5': 8, '10': 'treeHasNewCasts'},
    const {'1': 'likes', '3': 11, '4': 3, '5': 11, '6': '.cast_me_app.LikeBase', '10': 'likes'},
    const {'1': 'topic_names', '3': 12, '4': 3, '5': 9, '10': 'topicNames'},
    const {'1': 'tagged_usernames', '3': 13, '4': 3, '5': 9, '10': 'taggedUsernames'},
    const {'1': 'author_id', '3': 14, '4': 1, '5': 9, '10': 'authorId'},
    const {'1': 'title', '3': 15, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'topic', '3': 16, '4': 1, '5': 9, '10': 'topic'},
    const {'1': 'duration_ms', '3': 17, '4': 1, '5': 13, '10': 'durationMs'},
    const {'1': 'audio_url', '3': 18, '4': 1, '5': 9, '10': 'audioUrl'},
    const {'1': 'reply_to', '3': 19, '4': 1, '5': 9, '10': 'replyTo'},
    const {'1': 'external_url', '3': 20, '4': 1, '5': 9, '10': 'externalUrl'},
  ],
};

/// Descriptor for `CastBase`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List castBaseDescriptor = $convert.base64Decode('CghDYXN0QmFzZRIOCgJpZBgBIAEoCVICaWQSKgoRY3JlYXRlZF9hdF9zdHJpbmcYAiABKAlSD2NyZWF0ZWRBdFN0cmluZxIXCgdyb290X2lkGAMgASgJUgZyb290SWQSJwoPYXV0aG9yX3VzZXJuYW1lGAQgASgJUg5hdXRob3JVc2VybmFtZRIuChNhdXRob3JfZGlzcGxheV9uYW1lGAUgASgJUhFhdXRob3JEaXNwbGF5TmFtZRIbCglpbWFnZV91cmwYBiABKAlSCGltYWdlVXJsEioKEWFjY2VudF9jb2xvcl9iYXNlGAcgASgJUg9hY2NlbnRDb2xvckJhc2USHQoKdmlld19jb3VudBgIIAEoDVIJdmlld0NvdW50Eh0KCmhhc192aWV3ZWQYCSABKAhSCWhhc1ZpZXdlZBIrChJ0cmVlX2hhc19uZXdfY2FzdHMYCiABKAhSD3RyZWVIYXNOZXdDYXN0cxIrCgVsaWtlcxgLIAMoCzIVLmNhc3RfbWVfYXBwLkxpa2VCYXNlUgVsaWtlcxIfCgt0b3BpY19uYW1lcxgMIAMoCVIKdG9waWNOYW1lcxIpChB0YWdnZWRfdXNlcm5hbWVzGA0gAygJUg90YWdnZWRVc2VybmFtZXMSGwoJYXV0aG9yX2lkGA4gASgJUghhdXRob3JJZBIUCgV0aXRsZRgPIAEoCVIFdGl0bGUSFAoFdG9waWMYECABKAlSBXRvcGljEh8KC2R1cmF0aW9uX21zGBEgASgNUgpkdXJhdGlvbk1zEhsKCWF1ZGlvX3VybBgSIAEoCVIIYXVkaW9VcmwSGQoIcmVwbHlfdG8YEyABKAlSB3JlcGx5VG8SIQoMZXh0ZXJuYWxfdXJsGBQgASgJUgtleHRlcm5hbFVybA==');
