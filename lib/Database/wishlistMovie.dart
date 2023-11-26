import 'package:hive/hive.dart';

part 'wishlistMovie.g.dart';

@HiveType(typeId: 0)
class WishlistMovie extends HiveObject {
  @HiveField(0)
  String? title;

  @HiveField(1)
  String? overview;

  @HiveField(2)
  String? posterPath;

  @HiveField(3)
  String? backdropPath;

  @HiveField(4)
  String? voteAverage;

  @HiveField(5)
  double? price;

  @HiveField(6)
  bool? wishlist;

  @HiveField(7)
  String? imagePath;

  WishlistMovie({
    this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage,
    this.price,
    this.imagePath,
    this.wishlist = false,
  });
}
