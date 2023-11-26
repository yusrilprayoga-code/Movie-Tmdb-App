import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/Api/api_source.dart';
import 'package:movie_app/Constants/movie_constants_impl.dart';
import 'package:movie_app/Database/wishlistMovie.dart';
import 'package:movie_app/main.dart';
import 'package:movie_app/movie/DiscoverMovies.dart';
import 'package:movie_app/movie/TopRatedMovies.dart';
import 'package:movie_app/movie/Trending_Movies.dart';
import 'package:movie_app/movie/UpComingMovies.dart';
import 'package:movie_app/screens/WishlistFavorite.dart';
import 'package:movie_app/screens/profile.dart';
import 'package:movie_app/screens/saranKesan.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'content/discover_movies_content.dart';
import 'content/toprated_movies_content.dart';
import 'content/trending_movies_content.dart';
import 'content/upcoming_movies_content.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences loginData;
  late String username;
  late Future<List<MovieConstantsImpl>> trendingMovies;
  late Future<List<MovieConstantsImpl>> topRatedMovies;
  late Future<List<MovieConstantsImpl>> discoverMovies;
  late Future<List<MovieConstantsImpl>> upComingMovies;
  int _selectedIndex = 0;
  late PageController _pageController;
  List<MovieConstantsImpl>? searchResults;
  late Box<WishlistMovie> wishlistBox;

  @override
  void initState() {
    super.initState();
    initial();
    trendingMovies = ApiSource().getTrendingMovies();
    topRatedMovies = ApiSource().getTopRatedMovies();
    discoverMovies = ApiSource().getDiscoverMovies();
    upComingMovies = ApiSource().getUpComingMovies();
    _pageController = PageController();
    wishlistBox = Hive.box<WishlistMovie>(favoriteMovies);
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      username = loginData.getString('username')!;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Handle the search functionality
  void searchMovie(String query) async {
    if (query.isEmpty) {
      // Clear search results when query is empty
      setState(() {
        searchResults = null;
      });
      return;
    }

    // Perform the search and update the state with the results
    final results = await ApiSource().getMovieSearch(query);
    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Movie App',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: [
            buildAllMovies(),
            WishlistFavorite(),
            SaranKesan(),
            MyProfile(),
          ],
          onPageChanged: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(Colors.grey[200]!.value),
        color: Color.fromARGB(255, 88, 221, 192),
        buttonBackgroundColor: Colors.black,
        height: 50,
        items: <Widget>[
          Icon(Icons.movie_creation_outlined, size: 20, color: Colors.white),
          Icon(Icons.bookmark, size: 20, color: Colors.white),
          Icon(Icons.add_reaction, size: 20, color: Colors.white),
          Icon(Icons.person, size: 20, color: Colors.white),
        ],
        index: _selectedIndex,
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.bounceInOut,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
          });
        },
      ),
    );
  }

  Widget buildAllMovies() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          // Trending Movies content
          TrendingMoviesContent(
              context: context, trendingMovies: trendingMovies),
          FutureBuilder(
            future: trendingMovies,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TrendingMovies(
                  snapshot: snapshot,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
          SizedBox(
            height: 20,
          ),
          //Top Rated Movies content
          TopratedMoviesContent(
              context: context, topRatedMovies: topRatedMovies),
          SizedBox(
            child: FutureBuilder(
                future: topRatedMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return TopRatedMovies(
                      snapshot: snapshot,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                }),
          ),
          SizedBox(
            height: 20,
          ),
          // Upcoming Movies content
          UpcomingMoviesContent(
              context: context, upComingMovies: upComingMovies),
          SizedBox(
            child: FutureBuilder(
                future: upComingMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return UpComingMovies(
                      snapshot: snapshot,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                }),
          ),
          SizedBox(
            height: 20,
          ),
          // Discover Movies content
          DiscoverMoviesContent(
              context: context, discoverMovies: discoverMovies),
          SizedBox(
            child: FutureBuilder(
                future: discoverMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DiscoverMovies(
                      snapshot: snapshot,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                }),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
