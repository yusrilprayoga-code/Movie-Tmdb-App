import 'package:movie_app/Constants/movie_constants_impl.dart';
import 'package:movie_app/Constants/movie_constants_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiSource {
  //search movie
  static String movieSearchUrl(String query) {
    return 'https://api.themoviedb.org/3/search/movie?api_key=${MovieConstantsRepository.api_key}&query=$query';
  }

  static const _discover =
      'https://api.themoviedb.org/3/discover/movie?api_key=${MovieConstantsRepository.api_key}';

  static const _trendingUrl =
      'https://api.themoviedb.org/3/trending/all/day?api_key=${MovieConstantsRepository.api_key}';

  static const _topRatedUrl =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=${MovieConstantsRepository.api_key}';

  static const _upComingUrl =
      'https://api.themoviedb.org/3/movie/upcoming?api_key=${MovieConstantsRepository.api_key}';

  Future<List<MovieConstantsImpl>> getTrendingMovies() async {
    final response = await http.get(Uri.parse(_trendingUrl));

    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['results'] as List;
      print(decodeData);
      return decodeData
          .map((movie) => MovieConstantsImpl.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<MovieConstantsImpl>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(_topRatedUrl));

    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['results'] as List;
      print(decodeData);
      return decodeData
          .map((movie) => MovieConstantsImpl.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<MovieConstantsImpl>> getDiscoverMovies() async {
    final response = await http.get(Uri.parse(_discover));

    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['results'] as List;
      print(decodeData);
      return decodeData
          .map((movie) => MovieConstantsImpl.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  //upcoming
  Future<List<MovieConstantsImpl>> getUpComingMovies() async {
    final response = await http.get(Uri.parse(_upComingUrl));

    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['results'] as List;
      print(decodeData);
      return decodeData
          .map((movie) => MovieConstantsImpl.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  //get searchmovie
  Future<List<MovieConstantsImpl>> getMovieSearch(String query) async {
    final response = await http.get(Uri.parse(movieSearchUrl(query)));

    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['results'] as List;
      print(decodeData); // Print the response data for debugging
      return decodeData
          .map((movie) => MovieConstantsImpl.fromJson(movie))
          .toList();
    } else {
      print(
          'Failed to load movies: ${response.statusCode} - ${response.body}'); // Print the error response for debugging
      throw Exception('Failed to load movies');
    }
  }
}
