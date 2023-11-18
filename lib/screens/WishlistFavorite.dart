import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart';
import 'package:movie_app/Constants/movie_constants_repository.dart';
import 'package:movie_app/Database/wishlistMovie.dart';
import 'package:movie_app/main.dart';

enum Currency { USD, EUR, JPY }

enum TimeZone { WIB, WITA, WIT }

class CurrencyConverter {
  static const Map<Currency, double> conversionRates = {
    Currency.USD: 1.0,
    Currency.EUR: 0.85,
    Currency.JPY: 110.0,
  };

  static String convertPrice(double price, Currency targetCurrency) {
    double convertedPrice = price /
        conversionRates[Currency.USD]! *
        conversionRates[targetCurrency]!;
    return convertedPrice.toStringAsFixed(2);
  }
}

class WishlistFavorite extends StatefulWidget {
  const WishlistFavorite({super.key});

  @override
  State<WishlistFavorite> createState() => _WishlistFavoriteState();
}

class _WishlistFavoriteState extends State<WishlistFavorite> {
  late Timer timer;
  Currency selectedCurrency = Currency.USD;
  TimeZone selectedTimeZone = TimeZone.WIB;
  late Box<WishlistMovie> wishlistBox;
  String? formattedTime;

  //make api call
  void getTime() async {
    Response response = await get(
        Uri.parse("https://worldtimeapi.org/api/timezone/Asia/Jakarta"));
    Map data = jsonDecode(response.body);
    if (mounted) {
      setState(() {
        formattedTime = data['datetime'];
      });
    }
    //get properties from data
    String datetime = data['datetime'];
    String offset = data['utc_offset'].substring(1, 3);
    //create DateTime object
    DateTime now = DateTime.parse(datetime);
    now = now.add(Duration(hours: int.parse(offset)));

    // Format the time based on the selected timezone
    switch (selectedTimeZone) {
      case TimeZone.WIB:
        formattedTime = '${now.hour}:${now.minute}:${now.second}';
        break;
      case TimeZone.WITA:
        formattedTime = '${now.hour}:${now.minute}:${now.second}';
        break;
      case TimeZone.WIT:
        formattedTime = '${now.hour + 1}:${now.minute}:${now.second}';
        break;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    wishlistBox = Hive.box<WishlistMovie>(favoriteMovies);
    Timer.periodic(Duration(seconds: 1), (timer) {
      getTime();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Wishlist',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                wishlistBox.isEmpty ? Container() : _buildTimezoneDropdown(),
              ],
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: wishlistBox.listenable(),
                builder: (context, Box<WishlistMovie> box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text("No data"),
                    );
                  }
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final movie = box.getAt(index);
                      return Dismissible(
                        key: Key(movie?.title ?? index.toString()),
                        onDismissed: (direction) {
                          setState(() {
                            wishlistBox.deleteAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${movie?.title ?? "Item"} dismissed',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 16.0),
                        ),
                        child: Card(
                          child: ListTile(
                            leading: movie?.posterPath == null
                                ? Image.asset('assets/images/na.jpg')
                                : Image.network(
                                    '${MovieConstantsRepository.imagePath}${movie?.posterPath ?? "na"}',
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                  ),
                            title: Text(
                              movie?.title ?? "Title not available",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      movie?.voteAverage?.toString() ??
                                          "Rating not available",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      'Price: ${CurrencyConverter.convertPrice(
                                        movie?.price ?? 0,
                                        selectedCurrency,
                                      )}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '(${selectedCurrency.toString().split('.').last})',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    _buildCurrencyDropdown(),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [_buildFormattedTime()],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormattedTime() {
    DateTime now = DateTime.now();
    String formattedTime = _getFormattedTime(now, selectedTimeZone);
    return Text(
      formattedTime,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTimezoneDropdown() {
    return DropdownButton<TimeZone>(
      value: selectedTimeZone,
      onChanged: (TimeZone? newValue) {
        setState(() {
          selectedTimeZone = newValue!;
          getTime(); // Update time when timezone changes
        });
      },
      items: TimeZone.values.map((TimeZone timezone) {
        return DropdownMenuItem<TimeZone>(
          value: timezone,
          child: Text("Convert to ${timezone.toString().split('.').last}"),
        );
      }).toList(),
    );
  }

  Widget _buildCurrencyDropdown() {
    return DropdownButton<Currency>(
      value: selectedCurrency,
      onChanged: (Currency? newValue) {
        setState(() {
          selectedCurrency = newValue!;
        });
      },
      items: Currency.values.map((Currency currency) {
        return DropdownMenuItem<Currency>(
          value: currency,
          child: Text(_getCurrencySymbol(currency)),
        );
      }).toList(),
    );
  }

  String _getCurrencySymbol(Currency currency) {
    switch (currency) {
      case Currency.USD:
        return '\$'; // Dollar symbol
      case Currency.EUR:
        return '€'; // Euro symbol
      case Currency.JPY:
        return '¥'; // Yen symbol
      default:
        return '';
    }
  }

  String _getFormattedTime(DateTime time, TimeZone timeZone) {
    switch (timeZone) {
      case TimeZone.WIB:
        return '${time.hour}:${time.minute}:${time.second} WIB';
      case TimeZone.WITA:
        return '${time.hour + 1}:${time.minute}:${time.second} WITA';
      case TimeZone.WIT:
        return '${time.hour + 2}:${time.minute}:${time.second} WIT';
      default:
        return '';
    }
  }
}
