import 'package:flutter/material.dart';
import 'package:movie_app/Constants/movie_constants_impl.dart';
import 'package:movie_app/Constants/movie_constants_repository.dart';
import 'package:movie_app/movie/Details_Movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllTrendingMoviesGrid extends StatefulWidget {
  @override
  _AllTrendingMoviesGridState createState() => _AllTrendingMoviesGridState();
}

class _AllTrendingMoviesGridState extends State<AllTrendingMoviesGrid> {
  List<MovieConstantsImpl> trendingMovies = [];
  List<MovieConstantsImpl> filteredMovies = [];
  int currentPage = 1;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAllTrendingMovies();
  }

  Future<void> loadAllTrendingMovies() async {
    final apiKey = 'cafc0f1b384e93eef15d267d6da132fa';
    bool hasMorePages = true;

    while (hasMorePages) {
      final url = Uri.parse(
          'https://api.themoviedb.org/3/trending/movie/week?api_key=$apiKey&page=$currentPage');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<MovieConstantsImpl> movies = (data['results'] as List)
            .map((movieData) => MovieConstantsImpl.fromJson(movieData))
            .toList();

        setState(() {
          trendingMovies.addAll(movies);
          filteredMovies.addAll(movies); // Initially, display all movies
          currentPage++;
        });

        hasMorePages = currentPage <= data['total_pages'];
      } else {
        throw Exception('Failed to load trending movies');
      }
    }
  }

  void filterMovies(String query) {
    setState(() {
      filteredMovies = trendingMovies
          .where((movie) =>
              movie.title?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            onChanged: (query) {
              filterMovies(query);
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffixIcon: searchController.text.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback(
                            (_) => searchController.clear());
                        filterMovies('');
                      },
                    ),
              labelText: 'Search Movies',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 7,
              mainAxisSpacing: 7,
            ),
            itemCount: filteredMovies.length,
            itemBuilder: (context, index) {
              final movie = filteredMovies[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsMovie(
                        movie: movie,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        ClipRRect(
                          child: Image.network(
                            '${MovieConstantsRepository.imagePath}${movie.posterPath}',
                            height: 150,
                            width: 130,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  movie.title?.toString() ?? 'No Title',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    movie.voteAverage?.toString() ??
                                        'No Rating',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
