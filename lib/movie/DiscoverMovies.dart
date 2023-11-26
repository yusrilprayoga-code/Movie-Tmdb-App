import 'package:flutter/material.dart';
import 'package:movie_app/Constants/movie_constants_repository.dart';
import 'package:movie_app/movie/Details_Movie.dart';

class DiscoverMovies extends StatelessWidget {
  const DiscoverMovies({Key? key, required this.snapshot});

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: snapshot.data!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = snapshot.data![index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsMovie(
                    movie: snapshot.data![index],
                  ),
                ),
              );
            },
            child: Container(
              width: 360,
              child: Card(
                elevation: 3,
                color: Colors.grey[300], // Set background color to gray
                child: Row(
                  children: [
                    ClipRRect(
                      child: Image.network(
                        '${MovieConstantsRepository.imagePath}${movie.posterPath}',
                        height: 150,
                        width: 100,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              movie.title?.toString() ?? 'No Title',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,

                                color: Colors.black, // Text color
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Rating: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black, // Text color
                                  ),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                ),
                                Text(
                                  '${movie.voteAverage.toStringAsFixed(1)}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              //textreleasedate
                              'Release Date: ${movie.releaseDate}',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black, // Text color
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
