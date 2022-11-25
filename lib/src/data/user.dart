// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class User {
  final String data_updated_at;
  final UserData data;
  User({
    required this.data_updated_at,
    required this.data,
  });

  User copyWith({
    String? data_updated_at,
    UserData? data,
  }) {
    return User(
      data_updated_at: data_updated_at ?? this.data_updated_at,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'data_updated_at': data_updated_at});
    result.addAll({'data': data.toMap()});

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      data_updated_at: map['data_updated_at'] ?? '',
      data: UserData.fromMap(map['data']),
    );
  }

  factory User.empty() {
    return User(data_updated_at: "", data: UserData.fromMap({}));
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(data_updated_at: $data_updated_at, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.data_updated_at == data_updated_at && other.data == data;
  }

  @override
  int get hashCode => data_updated_at.hashCode ^ data.hashCode;
}

class UserData {
  final String id;
  final String username;
  final int level;
  final String profile_url;
  final String started_at;
  final WaniKaniSubscription subscription;
  final WaniKaniPreferences preferences;

  UserData({
    required this.id,
    required this.username,
    required this.level,
    required this.profile_url,
    required this.started_at,
    required this.subscription,
    required this.preferences,
  });

  UserData copyWith({
    String? id,
    String? username,
    int? level,
    String? profile_url,
    String? started_at,
    WaniKaniSubscription? subscription,
    WaniKaniPreferences? preferences,
  }) {
    return UserData(
      id: id ?? this.id,
      username: username ?? this.username,
      level: level ?? this.level,
      profile_url: profile_url ?? this.profile_url,
      started_at: started_at ?? this.started_at,
      subscription: subscription ?? this.subscription,
      preferences: preferences ?? this.preferences,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'username': username});
    result.addAll({'level': level});
    result.addAll({'profile_url': profile_url});
    result.addAll({'started_at': started_at});
    result.addAll({'subscription': subscription.toMap()});
    result.addAll({'preferences': preferences.toMap()});

    return result;
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      level: map['level']?.toInt() ?? 0,
      profile_url: map['profile_url'] ?? '',
      started_at: map['started_at'] ?? '',
      subscription: WaniKaniSubscription.fromMap(map['subscription'] ?? {}),
      preferences: WaniKaniPreferences.fromMap(map['preferences'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) => UserData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Data(id: $id, username: $username, level: $level, profile_url: $profile_url, started_at: $started_at, subscription: $subscription, preferences: $preferences)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData &&
        other.id == id &&
        other.username == username &&
        other.level == level &&
        other.profile_url == profile_url &&
        other.started_at == started_at &&
        other.subscription == subscription &&
        other.preferences == preferences;
  }

  @override
  int get hashCode {
    return id.hashCode ^ username.hashCode ^ level.hashCode ^ profile_url.hashCode ^ started_at.hashCode ^ subscription.hashCode ^ preferences.hashCode;
  }
}

class WaniKaniSubscription {
  final bool active;
  final String type;
  final int max_level_granted;
  final String period_ends_at;

  WaniKaniSubscription({
    required this.active,
    required this.type,
    required this.max_level_granted,
    required this.period_ends_at,
  });

  WaniKaniSubscription copyWith({
    bool? active,
    String? type,
    int? max_level_granted,
    String? period_ends_at,
  }) {
    return WaniKaniSubscription(
      active: active ?? this.active,
      type: type ?? this.type,
      max_level_granted: max_level_granted ?? this.max_level_granted,
      period_ends_at: period_ends_at ?? this.period_ends_at,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'active': active});
    result.addAll({'type': type});
    result.addAll({'max_level_granted': max_level_granted});
    result.addAll({'period_ends_at': period_ends_at});

    return result;
  }

  factory WaniKaniSubscription.fromMap(Map<String, dynamic> map) {
    return WaniKaniSubscription(
      active: map['active'] ?? false,
      type: map['type'] ?? '',
      max_level_granted: map['max_level_granted']?.toInt() ?? 0,
      period_ends_at: map['period_ends_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WaniKaniSubscription.fromJson(String source) => WaniKaniSubscription.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Subscription(active: $active, type: $type, max_level_granted: $max_level_granted, period_ends_at: $period_ends_at)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WaniKaniSubscription && other.active == active && other.type == type && other.max_level_granted == max_level_granted && other.period_ends_at == period_ends_at;
  }

  @override
  int get hashCode {
    return active.hashCode ^ type.hashCode ^ max_level_granted.hashCode ^ period_ends_at.hashCode;
  }
}

class WaniKaniPreferences {
  final int lessons_batch_size;
  final int default_voice_actor_id;
  final bool lessons_autoplay_audio;
  final bool reviews_autoplay_audio;
  final bool extra_study_autoplay_audio;
  final String lessons_presentation_order;
  final String reviews_presentation_order;
  final bool wanikani_compatibility_mode;
  final bool reviews_display_srs_indicator;

  WaniKaniPreferences({
    required this.lessons_batch_size,
    required this.default_voice_actor_id,
    required this.lessons_autoplay_audio,
    required this.reviews_autoplay_audio,
    required this.extra_study_autoplay_audio,
    required this.lessons_presentation_order,
    required this.reviews_presentation_order,
    required this.wanikani_compatibility_mode,
    required this.reviews_display_srs_indicator,
  });

  WaniKaniPreferences copyWith({
    int? lessons_batch_size,
    int? default_voice_actor_id,
    bool? lessons_autoplay_audio,
    bool? reviews_autoplay_audio,
    bool? extra_study_autoplay_audio,
    String? lessons_presentation_order,
    String? reviews_presentation_order,
    bool? wanikani_compatibility_mode,
    bool? reviews_display_srs_indicator,
  }) {
    return WaniKaniPreferences(
      lessons_batch_size: lessons_batch_size ?? this.lessons_batch_size,
      default_voice_actor_id: default_voice_actor_id ?? this.default_voice_actor_id,
      lessons_autoplay_audio: lessons_autoplay_audio ?? this.lessons_autoplay_audio,
      reviews_autoplay_audio: reviews_autoplay_audio ?? this.reviews_autoplay_audio,
      extra_study_autoplay_audio: extra_study_autoplay_audio ?? this.extra_study_autoplay_audio,
      lessons_presentation_order: lessons_presentation_order ?? this.lessons_presentation_order,
      reviews_presentation_order: reviews_presentation_order ?? this.reviews_presentation_order,
      wanikani_compatibility_mode: wanikani_compatibility_mode ?? this.wanikani_compatibility_mode,
      reviews_display_srs_indicator: reviews_display_srs_indicator ?? this.reviews_display_srs_indicator,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'lessons_batch_size': lessons_batch_size});
    result.addAll({'default_voice_actor_id': default_voice_actor_id});
    result.addAll({'lessons_autoplay_audio': lessons_autoplay_audio});
    result.addAll({'reviews_autoplay_audio': reviews_autoplay_audio});
    result.addAll({'extra_study_autoplay_audio': extra_study_autoplay_audio});
    result.addAll({'lessons_presentation_order': lessons_presentation_order});
    result.addAll({'reviews_presentation_order': reviews_presentation_order});
    result.addAll({'wanikani_compatibility_mode': wanikani_compatibility_mode});
    result.addAll({'reviews_display_srs_indicator': reviews_display_srs_indicator});

    return result;
  }

  factory WaniKaniPreferences.fromMap(Map<String, dynamic> map) {
    return WaniKaniPreferences(
      lessons_batch_size: map['lessons_batch_size']?.toInt() ?? 0,
      default_voice_actor_id: map['default_voice_actor_id']?.toInt() ?? 0,
      lessons_autoplay_audio: map['lessons_autoplay_audio'] ?? false,
      reviews_autoplay_audio: map['reviews_autoplay_audio'] ?? false,
      extra_study_autoplay_audio: map['extra_study_autoplay_audio'] ?? false,
      lessons_presentation_order: map['lessons_presentation_order'] ?? '',
      reviews_presentation_order: map['reviews_presentation_order'] ?? '',
      wanikani_compatibility_mode: map['wanikani_compatibility_mode'] ?? false,
      reviews_display_srs_indicator: map['reviews_display_srs_indicator'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory WaniKaniPreferences.fromJson(String source) => WaniKaniPreferences.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Preferences(lessons_batch_size: $lessons_batch_size, default_voice_actor_id: $default_voice_actor_id, lessons_autoplay_audio: $lessons_autoplay_audio, reviews_autoplay_audio: $reviews_autoplay_audio, extra_study_autoplay_audio: $extra_study_autoplay_audio, lessons_presentation_order: $lessons_presentation_order, reviews_presentation_order: $reviews_presentation_order, wanikani_compatibility_mode: $wanikani_compatibility_mode, reviews_display_srs_indicator: $reviews_display_srs_indicator)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WaniKaniPreferences &&
        other.lessons_batch_size == lessons_batch_size &&
        other.default_voice_actor_id == default_voice_actor_id &&
        other.lessons_autoplay_audio == lessons_autoplay_audio &&
        other.reviews_autoplay_audio == reviews_autoplay_audio &&
        other.extra_study_autoplay_audio == extra_study_autoplay_audio &&
        other.lessons_presentation_order == lessons_presentation_order &&
        other.reviews_presentation_order == reviews_presentation_order &&
        other.wanikani_compatibility_mode == wanikani_compatibility_mode &&
        other.reviews_display_srs_indicator == reviews_display_srs_indicator;
  }

  @override
  int get hashCode {
    return lessons_batch_size.hashCode ^
        default_voice_actor_id.hashCode ^
        lessons_autoplay_audio.hashCode ^
        reviews_autoplay_audio.hashCode ^
        extra_study_autoplay_audio.hashCode ^
        lessons_presentation_order.hashCode ^
        reviews_presentation_order.hashCode ^
        wanikani_compatibility_mode.hashCode ^
        reviews_display_srs_indicator.hashCode;
  }
}
