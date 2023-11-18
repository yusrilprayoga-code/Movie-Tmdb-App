import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movie_app/Database/wishlistMovie.dart';
import 'package:movie_app/screens/sign/login.dart';

String favoriteMovies = 'favoriteMovies';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<WishlistMovie>(WishlistMovieAdapter());
  await Hive.openBox<WishlistMovie>(favoriteMovies);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      //theme white
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //google font POPPINS
        textTheme: GoogleFonts.palanquinTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Colors.white,
        //make arrow back rounded button
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
