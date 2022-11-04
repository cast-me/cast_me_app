// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

const bool isStaging = false;

final profilePicturesBucket = supabase.storage.from('profile_pictures');

final castAudioFileBucket = supabase.storage.from('cast-audio-files');

const String createdAtCol = 'created_at';

const String treeUpdatedAtCol = 'tree_updated_at';

const String hasViewedCol = 'has_viewed';

const String authorIdCol = 'author_id';

const String userIdCol = 'user_id';

const String usernameCol = 'username';

const String displayNameCol = 'display_name';

const String authorDisplayNameCol = 'author_display_name';

const String authorUsernameCol = 'author_username';

const String idCol = 'id';

const String rootIdCol = 'root_id';

const String castIdCol = 'cast_id';

const String titleCol = 'title';

const String topicIdCol = 'topic_id';

const String nameCol = 'name';

const String topicsCol = 'topics';

SupabaseQueryBuilder get profilesQuery => supabase.from('profiles');

SupabaseQueryBuilder get fcmRegistrationTokensQuery =>
    supabase.from('fcm_registration_tokens');

SupabaseQueryBuilder get castsWriteQuery =>
    supabase.from(isStaging ? 'staging_casts' : 'casts');

SupabaseQueryBuilder get castsReadQuery =>
    supabase.from(isStaging ? 'staging_casts_view' : 'casts_view');

SupabaseQueryBuilder get listensQuery =>
    supabase.from(isStaging ? 'staging_views' : 'views');

SupabaseQueryBuilder get likesQuery =>
    supabase.from(isStaging ? 'staging_likes' : 'likes');

SupabaseQueryBuilder get topicsReadQuery =>
    supabase.from(isStaging ? 'staging_topics_agg_view' : 'topics_agg_view');

SupabaseQueryBuilder get castsToTopicWriteQuery =>
    supabase.from(isStaging ? 'staging_casts_to_topics' : 'casts_to_topics');

