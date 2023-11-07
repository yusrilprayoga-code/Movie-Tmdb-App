import 'package:flutter/material.dart';
import 'package:movie_app/Constants/movie_constants_impl.dart';
import 'package:movie_app/Constants/movie_constants_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsMovie extends StatelessWidget {
  const DetailsMovie({Key? key, required this.movie}) : super(key: key);

  final MovieConstantsImpl movie;

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
                  background: movie.backdropPath == null
                      ? Image.asset('assets/images/na.jpg', fit: BoxFit.cover)
                      : Image.network(
                          '${MovieConstantsRepository.imagePath}${movie.backdropPath ?? ""}',
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
                          // Judul film
                          Text(
                            movie.title ?? "Title not available",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Rating film
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                movie.voteAverage?.toString() ??
                                    "Rating not available",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              // Vote count
                              Row(
                                children: [
                                  const Icon(
                                    Icons.people,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    movie.voteCount?.toString() ??
                                        "Vote count not available",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              // Release date
                              Row(
                                children: [
                                  const Icon(
                                    Icons.date_range,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    movie.releaseDate ??
                                        "Release date not available",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //genre

                          const SizedBox(height: 10),
                          // Deskripsi film
                          Text(
                            movie.overview ?? "Overview not available",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Add other details from MovieDetailPage here
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
            '${MovieConstantsRepository.imagePath}${movie.backdropPath ?? ""}',
          );
        },
        child: const Icon(Icons.image_search),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Failed to open link: $_url');
    }
  }
}
