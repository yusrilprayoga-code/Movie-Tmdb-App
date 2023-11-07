import 'package:flutter/material.dart';
import 'package:movie_app/Api/api_source.dart';
import 'package:movie_app/Constants/movie_constants_impl.dart';
import 'package:movie_app/Constants/movie_constants_repository.dart';
import 'package:movie_app/movie/DiscoverMovies.dart';
import 'package:movie_app/movie/TopRatedMovies.dart';
import 'package:movie_app/movie/Trending_Movies.dart';
import 'package:movie_app/movie/UpComingMovies.dart';
import 'package:movie_app/screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/all_discover_movies.dart';
import '../providers/all_top_rated_movies.dart';
import '../providers/all_trending_movies_grid.dart';
import '../providers/all_up_coming_movies.dart';

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

  @override
  void initState() {
    super.initState();
    initial();
    trendingMovies = ApiSource().getTrendingMovies();
    topRatedMovies = ApiSource().getTopRatedMovies();
    discoverMovies = ApiSource().getDiscoverMovies();
    upComingMovies = ApiSource().getUpComingMovies();
    _pageController = PageController();
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
        actions: [
          // Add a search icon button
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(
                    searchResults: searchResults,
                    searchCallback: (query) {
                      searchMovie(query);
                    }),
              );
            },
            icon: const Icon(Icons.search),
            color: Colors.black,
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: [
            buildAllMovies(),
            Container(
              color: Colors.blue, // Placeholder color
              child: Center(
                child: Text("Favorite Movies"),
              ),
            ),
            MyProfile(),
            Container(
              color: Colors.green, // Placeholder color
              child: Center(
                child: Text("Profile"),
              ),
            ),
          ],
          onPageChanged: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blueAccent[700],
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;

            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Favorite',
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trending Movies',
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
                              'All Trending Movies',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          body: FutureBuilder(
                            future: trendingMovies,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return AllTrendingMoviesGrid();
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
          ),
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

          Padding(
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
          ),
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
          Padding(
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
          ),
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
          Padding(
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
          ),
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

class MovieSearchDelegate extends SearchDelegate<List<MovieConstantsImpl>> {
  final List<MovieConstantsImpl>? searchResults;
  final Function(String) searchCallback;

  MovieSearchDelegate({
    required this.searchResults,
    required this.searchCallback,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for the search bar (e.g., clear query)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showResults(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the search bar
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show search results based on the query
    return searchResults != null
        ? MovieSearchResults(searchResults: searchResults)
        : Center(
            child: Text('No results found'),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions while typing the query (e.g., recent searches)
    return Center(
      child: Text('Search for movies'),
    );
  }
}

class MovieSearchResults extends StatelessWidget {
  final List<MovieConstantsImpl>? searchResults;

  MovieSearchResults({required this.searchResults});

  @override
  Widget build(BuildContext context) {
    if (searchResults != null && searchResults!.isNotEmpty) {
      return ListView.builder(
        itemCount: searchResults!.length,
        itemBuilder: (context, index) {
          final movie = searchResults![index];
          return ListTile(
            title: Text(movie.title ?? 'No Title'),
            subtitle: Text(movie.overview ?? 'No overview'),
            leading: Image.network(
              '${MovieConstantsRepository.imagePath}${movie.posterPath}',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text('No results found'),
      );
    }
  }
}
