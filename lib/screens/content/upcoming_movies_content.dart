import 'package:flutter/material.dart';
import 'package:movie_app/Constants/movie_constants_impl.dart';
import 'package:movie_app/providers/all_up_coming_movies.dart';

class UpcomingMoviesContent extends StatelessWidget {
  const UpcomingMoviesContent({
    super.key,
    required this.context,
    required this.upComingMovies,
  });

  final BuildContext context;
  final Future<List<MovieConstantsImpl>> upComingMovies;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Upcoming Movies',
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
                        'All Upcoming Movies',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    body: FutureBuilder(
                      future: upComingMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return AllNowPlayingMovies();
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
