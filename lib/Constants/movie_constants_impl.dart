import 'dart:math';

class MovieResponseModel {
  MovieResponseModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int page;
  final List<MovieConstantsImpl> results;
  final int totalPages;
  final int totalResults;

  factory MovieResponseModel.fromMap(Map<String, dynamic> json) =>
      MovieResponseModel(
        page: json["page"],
        results: List<MovieConstantsImpl>.from(
            json["results"].map((x) => MovieConstantsImpl.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

class MovieConstantsImpl {
  int? id;
  String? title;
  List<int>? genreIds;
  String? backdropPath;
  String? originalTitle;
  String? overview;
  String? posterPath;
  String? releaseDate;
  double? voteAverage;
  bool? video;
  int? voteCount;
  bool wishlist = false;
  double? price;

  MovieConstantsImpl({
    required this.id,
    required this.title,
    required this.genreIds,
    required this.backdropPath,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.video,
    required this.voteCount,
    required this.price,
  }) {
    final random = Random();
    price = random.nextInt(100).toDouble();
  }

  factory MovieConstantsImpl.fromJson(Map<String, dynamic> json) {
    return MovieConstantsImpl(
      price: json['price']?.toDouble(),
      id: json['id'] as int?,
      title: json['title'] as String?,
      genreIds: json['genre_ids'] != null
          ? List<int>.from(json['genre_ids'] as List<dynamic>)
          : null,
      backdropPath: json['backdrop_path'] as String?,
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      voteAverage: json['vote_average']?.toDouble(),
      video: json['video'] as bool?,
      voteCount: json['vote_count'] as int?,
    );
  }

  //map tojson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'genre_ids': genreIds,
      'backdrop_path': backdropPath,
      'original_title': originalTitle,
      'overview': overview,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'video': video,
      'vote_count': voteCount,
      'price': price,
    };
  }
}

class Genre {
  int? id;
  String? name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  //map tojson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
