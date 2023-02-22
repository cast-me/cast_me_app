// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

const bool isStaging = true;

final profilePicturesBucket = supabase.storage.from('profile_pictures');

final castAudioFileBucket = supabase.storage.from('cast-audio-files');

const String createdAtCol = 'created_at';

const String isPrivateCol = 'is_private';

const String visibleToCol = 'visible_to';

const String treeUpdatedAtCol = 'tree_updated_at';

const String promotedDateCol = 'promoted_date';

const String depthCol = 'depth';

const String treeHasNewCastsCol = 'tree_has_new_casts';

const String hasViewedCol = 'has_viewed';

const String authorIdCol = 'author_id';

const String userIdCol = 'user_id';

const String usernameCol = 'username';

const String displayNameCol = 'display_name';

const String profilePictureUrlCol = 'profile_picture_url';

const String accentColorBaseCol = 'accent_color_base';

const String authorDisplayNameCol = 'author_display_name';

const String authorUsernameCol = 'author_username';

const String idCol = 'id';

const String deletedCol = 'deleted';

const String rootIdCol = 'root_id';

const String castIdCol = 'cast_id';

const String reasonCol = 'reason';

const String titleCol = 'title';

const String topicIdCol = 'topic_id';

const String nameCol = 'name';

const String topicsCol = 'topics';

const String blockedUserIdCol = 'blocked_user_id';

const String allNewCol = 'all_new';

const String newCastCountCol = 'new_cast_count';

const String typeCol = 'type_id';

const String readCol = 'read';

typedef Row = Map<String, dynamic>;

typedef Rows = List<Map<String, dynamic>>;

SupabaseQueryBuilder get profilesQuery => supabase.from('profiles');

SupabaseQueryBuilder get blockedUsersQuery => supabase.from('blocked_users');

SupabaseQueryBuilder get reportedCastsQuery => supabase.from('reported_casts');

SupabaseQueryBuilder get fcmRegistrationTokensQuery =>
    supabase.from('fcm_registration_tokens');

SupabaseQueryBuilder get castsWriteQuery =>
    supabase.from(isStaging ? 'staging_casts' : 'casts');

SupabaseQueryBuilder get castsReadQuery =>
    supabase.from(isStaging ? 'staging_casts_view' : 'casts_view');

SupabaseQueryBuilder get conversationsReadQuery => supabase
    .from(isStaging ? 'staging_conversations_view' : 'conversations_view');

SupabaseQueryBuilder get listensQuery =>
    supabase.from(isStaging ? 'staging_views' : 'views');

SupabaseQueryBuilder get likesQuery =>
    supabase.from(isStaging ? 'staging_likes' : 'likes');

SupabaseQueryBuilder get topicsReadQuery =>
    supabase.from(isStaging ? 'staging_topics_agg_view' : 'topics_agg_view');

SupabaseQueryBuilder get castsToTopicWriteQuery =>
    supabase.from(isStaging ? 'staging_casts_to_topics' : 'casts_to_topics');

// TODO: This will return duplicative elements if casts were added between
//  requests.
// Consider client-side de-dup logic or migrating off `range` and onto
// `gt/lt`.
Stream<Row> paginated(
  PostgrestTransformBuilder query, {
  required int chunkSize,
  int? chunkLimit,
}) async* {
  int soFar = 0;
  while (chunkLimit == null || soFar < chunkLimit * chunkSize) {
    final int upper = soFar + chunkSize;
    // `upper - 1` because range is bad and should feel bad and is inclusive.
    // I mean seriously, what asshole decides a range should have an inclusive
    // upper bound?
    final Iterable<Map<String, dynamic>> rows =
        await query.range(soFar, upper - 1) as Iterable<Map<String, dynamic>>;
    soFar += chunkSize;
    if (rows.isEmpty) {
      // We've run out of casts.
      return;
    }
    for (final row in rows) {
      yield row;
    }
  }
}
