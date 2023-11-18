class CreditCast {
  final String? creditType;
  final String? department;
  final String? job;
  final Media? media;
  final String? mediaType;
  final String? id;
  final Person? person;

  CreditCast({
    this.creditType,
    this.department,
    this.job,
    this.media,
    this.mediaType,
    this.id,
    this.person,
  });

  CreditCast.fromJson(Map<String, dynamic> json)
      : creditType = json['credit_type'] as String?,
        department = json['department'] as String?,
        job = json['job'] as String?,
        media = (json['media'] as Map<String, dynamic>?) != null
            ? Media.fromJson(json['media'] as Map<String, dynamic>)
            : null,
        mediaType = json['media_type'] as String?,
        id = json['id'] as String?,
        person = (json['person'] as Map<String, dynamic>?) != null
            ? Person.fromJson(json['person'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'credit_type': creditType,
        'department': department,
        'job': job,
        'media': media?.toJson(),
        'media_type': mediaType,
        'id': id,
        'person': person?.toJson()
      };
}

class Media {
  final bool? adult;
  final String? backdropPath;
  final int? id;
  final String? name;
  final String? originalLanguage;
  final String? originalName;
  final String? overview;
  final String? posterPath;
  final String? mediaType;
  final List<int>? genreIds;
  final double? popularity;
  final String? firstAirDate;
  final double? voteAverage;
  final int? voteCount;
  final List<String>? originCountry;
  final String? character;
  final List<dynamic>? episodes;
  final List<Seasons>? seasons;

  Media({
    this.adult,
    this.backdropPath,
    this.id,
    this.name,
    this.originalLanguage,
    this.originalName,
    this.overview,
    this.posterPath,
    this.mediaType,
    this.genreIds,
    this.popularity,
    this.firstAirDate,
    this.voteAverage,
    this.voteCount,
    this.originCountry,
    this.character,
    this.episodes,
    this.seasons,
  });

  Media.fromJson(Map<String, dynamic> json)
      : adult = json['adult'] as bool?,
        backdropPath = json['backdrop_path'] as String?,
        id = json['id'] as int?,
        name = json['name'] as String?,
        originalLanguage = json['original_language'] as String?,
        originalName = json['original_name'] as String?,
        overview = json['overview'] as String?,
        posterPath = json['poster_path'] as String?,
        mediaType = json['media_type'] as String?,
        genreIds =
            (json['genre_ids'] as List?)?.map((dynamic e) => e as int).toList(),
        popularity = json['popularity'] as double?,
        firstAirDate = json['first_air_date'] as String?,
        voteAverage = json['vote_average'] as double?,
        voteCount = json['vote_count'] as int?,
        originCountry = (json['origin_country'] as List?)
            ?.map((dynamic e) => e as String)
            .toList(),
        character = json['character'] as String?,
        episodes = json['episodes'] as List?,
        seasons = (json['seasons'] as List?)
            ?.map((dynamic e) => Seasons.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'adult': adult,
        'backdrop_path': backdropPath,
        'id': id,
        'name': name,
        'original_language': originalLanguage,
        'original_name': originalName,
        'overview': overview,
        'poster_path': posterPath,
        'media_type': mediaType,
        'genre_ids': genreIds,
        'popularity': popularity,
        'first_air_date': firstAirDate,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'origin_country': originCountry,
        'character': character,
        'episodes': episodes,
        'seasons': seasons?.map((e) => e.toJson()).toList()
      };
}

class Seasons {
  final String? airDate;
  final int? episodeCount;
  final int? id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final int? seasonNumber;
  final int? showId;

  Seasons({
    this.airDate,
    this.episodeCount,
    this.id,
    this.name,
    this.overview,
    this.posterPath,
    this.seasonNumber,
    this.showId,
  });

  Seasons.fromJson(Map<String, dynamic> json)
      : airDate = json['air_date'] as String?,
        episodeCount = json['episode_count'] as int?,
        id = json['id'] as int?,
        name = json['name'] as String?,
        overview = json['overview'] as String?,
        posterPath = json['poster_path'] as String?,
        seasonNumber = json['season_number'] as int?,
        showId = json['show_id'] as int?;

  Map<String, dynamic> toJson() => {
        'air_date': airDate,
        'episode_count': episodeCount,
        'id': id,
        'name': name,
        'overview': overview,
        'poster_path': posterPath,
        'season_number': seasonNumber,
        'show_id': showId
      };
}

class Person {
  final bool? adult;
  final int? id;
  final String? name;
  final String? originalName;
  final String? mediaType;
  final double? popularity;
  final int? gender;
  final String? knownForDepartment;
  final String? profilePath;

  Person({
    this.adult,
    this.id,
    this.name,
    this.originalName,
    this.mediaType,
    this.popularity,
    this.gender,
    this.knownForDepartment,
    this.profilePath,
  });

  Person.fromJson(Map<String, dynamic> json)
      : adult = json['adult'] as bool?,
        id = json['id'] as int?,
        name = json['name'] as String?,
        originalName = json['original_name'] as String?,
        mediaType = json['media_type'] as String?,
        popularity = json['popularity'] as double?,
        gender = json['gender'] as int?,
        knownForDepartment = json['known_for_department'] as String?,
        profilePath = json['profile_path'] as String?;

  Map<String, dynamic> toJson() => {
        'adult': adult,
        'id': id,
        'name': name,
        'original_name': originalName,
        'media_type': mediaType,
        'popularity': popularity,
        'gender': gender,
        'known_for_department': knownForDepartment,
        'profile_path': profilePath
      };
}
