import 'package:flutter/material.dart';
import 'package:movie_app/Constants/movie_constants_impl.dart';
import 'package:movie_app/providers/all_top_rated_movies.dart';

class TopratedMoviesContent extends StatelessWidget {
  const TopratedMoviesContent({
    super.key,
    required this.context,
    required this.topRatedMovies,
  });

  final BuildContext context;
  final Future<List<MovieConstantsImpl>> topRatedMovies;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Top Rated Movies',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          OutlinedButton(
            //styling border button
            style: OutlinedButton.styleFrom(
              primary: Colors.black,
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.black, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      //backbutton
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      title: Text(
                        'All Top Rated Movies',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    body: FutureBuilder(
                      future: topRatedMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return AllTopRatedMovies();
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
              );
            },
            child: Text("See All"),
          ),
        ],
      ),
    );
  }
}
