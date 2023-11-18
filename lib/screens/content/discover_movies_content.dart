import 'package:flutter/material.dart';
import 'package:movie_app/Constants/movie_constants_impl.dart';
import 'package:movie_app/providers/all_discover_movies.dart';

class DiscoverMoviesContent extends StatelessWidget {
  const DiscoverMoviesContent({
    super.key,
    required this.context,
    required this.discoverMovies,
  });

  final BuildContext context;
  final Future<List<MovieConstantsImpl>> discoverMovies;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Discover Movies',
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
                        'All Discover Movies',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    body: FutureBuilder(
                      future: discoverMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return AllDiscoverMovies();
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
