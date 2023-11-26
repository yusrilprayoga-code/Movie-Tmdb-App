import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/Constants/movie_constants_impl.dart';
import 'package:movie_app/Constants/movie_constants_repository.dart';
import 'package:movie_app/Database/wishlistMovie.dart';
import 'package:movie_app/main.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsMovie extends StatefulWidget {
  const DetailsMovie({Key? key, required this.movie}) : super(key: key);

  final MovieConstantsImpl movie;

  @override
  State<DetailsMovie> createState() => _DetailsMovieState();
}

class _DetailsMovieState extends State<DetailsMovie> {
  late Box<WishlistMovie> wishlistBox;

  @override
  void initState() {
    super.initState();
    wishlistBox = Hive.box<WishlistMovie>(favoriteMovies);
  }

  Widget getIcon() {
    if (wishlistBox.values.toList().indexWhere((item) =>
            item.title == widget.movie.title &&
            item.overview == widget.movie.overview &&
            item.posterPath == widget.movie.posterPath &&
            item.backdropPath == widget.movie.backdropPath &&
            item.voteAverage == widget.movie.voteAverage.toString() &&
            item.price == widget.movie.price &&
            item.wishlist == widget.movie.wishlist) !=
        -1) {
      return Icon(
        Icons.bookmark,
      );
    } else {
      return Icon(
        Icons.bookmark_border,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 350,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: widget.movie.backdropPath == null
                      ? Image.asset('assets/images/na.jpg', fit: BoxFit.cover)
                      : Image.network(
                          '${MovieConstantsRepository.imagePath}${widget.movie.backdropPath ?? ""}',
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.movie.title ?? "Title not available",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Add this line to handle overflow
                                  maxLines:
                                      1, // Add this line to limit the number of lines to 1
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  wishlistBox =
                                      Hive.box<WishlistMovie>(favoriteMovies);
                                  setState(() {
                                    widget.movie.wishlist =
                                        !widget.movie.wishlist;

                                    if (widget.movie.wishlist) {
                                      wishlistBox.add(
                                        WishlistMovie(
                                          title: widget.movie.title,
                                          overview: widget.movie.overview,
                                          posterPath: widget.movie.posterPath,
                                          backdropPath:
                                              widget.movie.backdropPath,
                                          voteAverage: widget.movie.voteAverage
                                              .toString(),
                                          price: widget.movie.price,
                                          wishlist: widget.movie.wishlist,
                                        ),
                                      );
                                    } else {
                                      wishlistBox.deleteAt(wishlistBox.values
                                          .toList()
                                          .indexWhere((item) =>
                                              item.title ==
                                              widget.movie.title));
                                    }
                                  });
                                },
                                child: getIcon(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.movie.voteAverage?.toString() ??
                                    "Rating not available",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.people,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.movie.voteCount?.toString() ??
                                    "Vote count not available",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.date_range,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.movie.releaseDate ??
                                    "Release date not available",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          //price
                          Row(
                            children: [
                              const Icon(
                                Icons.monetization_on,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _formatCurrency(widget.movie.price),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Deskripsi film
                          Text(
                            widget.movie.overview ?? "Overview not available",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          //person
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _launchInBrowser(
            '${MovieConstantsRepository.imagePath}${widget.movie.backdropPath ?? ""}',
          );
        },
        child: const Icon(Icons.image_search),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  String _formatCurrency(double? price) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'USD ',
      decimalDigits: 0,
    ).format(price);
  }

  Future<void> _launchInBrowser(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Failed to open link: $_url');
    }
  }
}
