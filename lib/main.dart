import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movie_app/Database/wishlistMovie.dart';
import 'package:movie_app/screens/sign/login.dart';

String favoriteMovies = 'favoriteMovies';
String imagePicker = 'imagePicker';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<WishlistMovie>(WishlistMovieAdapter());
  await Hive.openBox<WishlistMovie>(favoriteMovies);
  await Hive.openBox<WishlistMovie>(imagePicker);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.palanquinTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          shadowColor: Colors.white70,
        ),
      ),
      home: MyLoginPage(),
    );
  }
}
