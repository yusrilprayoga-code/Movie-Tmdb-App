import 'package:flutter/material.dart';
import 'package:movie_app/Constants/movie_constants_repository.dart';
import 'package:movie_app/movie/Details_Movie.dart';

class TopRatedMovies extends StatelessWidget {
  const TopRatedMovies({
    super.key,
    required this.snapshot,
  });

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: snapshot.data!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsMovie(
                              movie: snapshot.data![index],
                            )));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                    height: 220,
                    width: 150,
                    child: Image.network(
                      '${MovieConstantsRepository.imagePath}${snapshot.data![index].posterPath}',
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }
}
